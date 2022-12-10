const config = require('../../config')
const path = require('path')
const fs = require('fs-extra')
const vueuiTestsPath = path.resolve(config.vueui, './uitests')
const vueuiDistPath = path.resolve(config.vueui, './dist')
const klaw = require('klaw')
const express = require('express')
const puppeteer = require('puppeteer')
const app = express()

app.use(express.static(vueuiDistPath))

app.use('/tmpl', async (req, res) => {
  const file = req.query.test
  const theme = req.query.theme
  const { data } = await fs.readJson(file)
  res.send(config.template(theme, data))
})

module.exports = async function (signale) {
  let tests = []
  for await (const file of klaw(vueuiTestsPath)) {
    if (!file.stats.isDirectory()) {
      tests.push(file.path)
    }
  }

  var server = app.listen(5221, () => {
    signale.info(`Puppeteer web server listening at http://localhost:5221`)
  })

  // C:\Projektai\Aurora.3\vueui\tests\manifest.json

  // http://localhost:5221/tmpl?test=C:\Projektai\Aurora.3\vueui\tests\manifest.json&theme=vueui%20theme-nano%20dark-theme
  const options = {
    headless: process.env.CI ? true : false,
    args: [process.env.CI ? '--no-sandbox' : ''],
  }

  const browser = await puppeteer.launch(options)
  const page = await browser.newPage()

  let results = {}

  for (const testFile of tests) {
    const { size } = await fs.readJson(testFile)
    results[testFile] = {}
    for (const theme of config.themes) {
      results[testFile][theme] = { errors: [] }

      const ConsoleHandler = (message) => {
        const type = message.type().substr(0, 3).toUpperCase()
        if (type == 'ERR') {
          results[testFile][theme].errors.push(`${message._text}`)
        }
      }
      const PageErrorHandler = ({ message }) => {
        results[testFile][theme].errors.push(`${message}`)
      }

      page.on('console', ConsoleHandler)
      page.on('pageerror', PageErrorHandler)

      await page.goto(`http://localhost:5221/tmpl?test=${encodeURI(testFile)}&theme=${encodeURI(theme)}`)
      await page.setViewport({
        width: size[0],
        height: size[1],
        deviceScaleFactor: 1,
      })
      const screen = await page.screenshot({ encoding: 'base64' })
      results[testFile][theme].image = screen

      // await new Promise((resolve, reject) => {
      //   setTimeout(() => {
      //     resolve()
      //   }, 3000)
      // })

      page.off('console', ConsoleHandler)
      page.off('pageerror', PageErrorHandler)
    }
  }

  // await new Promise((resolve, reject) => {
  //   setTimeout(() => {
  //     resolve()
  //   }, 1000 * 60)
  // })

  await browser.close()
  server.close()
  return { results }
}
