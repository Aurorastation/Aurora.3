import config from '../../config'
import path from 'path'
import fs from 'fs-extra'
const vueuiTestsPath = path.resolve(config.vueui, './uitests')
const vueuiDistPath = path.resolve(config.vueui, './dist')
import klaw from 'klaw'
import express from 'express'
import puppeteer from 'puppeteer'
import runners from './runners'
const app = express()

app.use(express.static(vueuiDistPath))

app.use('/blank', async (req, res) => {
  res.send('<html><head><meta charset="UTF-8"/></head><body><h1>Loading</h1></body></html>')
})

interface Screenshot {
  image: string
  name?: string
}

interface LogMessage {
  message: string
  type: 'Error' | 'Info'
}

interface TestResult {
  log: LogMessage[]
  screenshots: Screenshot[]
  testFile: string
}

export default async function (signale) {
  const tests = []
  for await (const file of klaw(vueuiTestsPath)) {
    if (!file.stats.isDirectory()) {
      tests.push(file.path)
    }
  }

  // C:\Projektai\Aurora.3\vueui\tests\manifest.json

  // http://localhost:5221/tmpl?test=C:\Projektai\Aurora.3\vueui\tests\manifest.json&theme=vueui%20theme-nano%20dark-theme

  const browser = await puppeteer.launch({ headless: false })
  const page = await browser.newPage()

  const results: TestResult[] = []

  const extToMime = (ext: string): string => {
    switch (ext.toLowerCase()) {
      case '.css':
        return 'text/css'
      case '.js':
        return 'text/javascript'
      case '.html':
        return 'text/html'
      default:
        return 'text/plain'
    }
  }

  const assetDataUri = async (asset: string): Promise<string> => {
    const file = await fs.promises.readFile(path.resolve(vueuiDistPath, asset))
    return `data:${extToMime(path.extname(asset))};base64,${file.toString('base64')}`
  }

  const dataUriAssets = Object.fromEntries(
    await Promise.all(
      Object.entries(config.assets).map(async ([type, assetName]) => [type, await assetDataUri(assetName)])
    )
  ) as typeof config.assets

  const renderTemplate = (data: any): string => config.template(data, config.assets)

  const server = app.listen(5221, () => {
    signale.info('Puppeteer web server listening at http://localhost:5221')
  })

  for (const testFile of tests) {
    const extension = path.extname(testFile).substr(1)
    const runner = runners[extension.toLowerCase()]

    const log: LogMessage[] = []
    const logInfo = (message: string) => log.push({ message, type: 'Info' })
    const logError = (message: string) => log.push({ message, type: 'Error' })

    const screenshots: Screenshot[] = []

    const ConsoleHandler = (message) => {
      const type = message.type().substr(0, 3).toUpperCase()
      if (type == 'ERR') {
        logError(`${message._text}`)
      }
    }
    const PageErrorHandler = ({ message }) => {
      logError(`${message}`)
    }

    page.on('console', ConsoleHandler)
    page.on('pageerror', PageErrorHandler)

    await runner(page, testFile, {
      async loadInitial(data) {
        const html = renderTemplate(data)
        await page.goto('http://localhost:5221/blank')
        await page.setContent(html)
      },
      async setSize(w, h) {
        await page.setViewport({
          width: w,
          height: h,
          deviceScaleFactor: 1,
        })
      },
      async log(message) {
        logInfo(message)
      },
      async screenshot(name) {
        const screen = await page.screenshot({ encoding: 'base64' })
        if (name) {
          logInfo(`Screenshot '${name}' taken`)
        }
        screenshots.push({
          name,
          image: screen,
        })
      },
    })

    page.off('console', ConsoleHandler)
    page.off('pageerror', PageErrorHandler)

    results.push({
      log,
      testFile,
      screenshots,
    })
  }

  // await new Promise((resolve, reject) => {
  //   setTimeout(() => {
  //     resolve()
  //   }, 3000)
  // })

  await browser.close()
  server.close()
  return { results }
}
