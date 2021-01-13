const config = require('../../config')
const processPromisify = require('../../src/processPromisify')
const path = require('path')
const vueuiPath = path.resolve(config.vueui)
module.exports = async function (signale) {
  try {
    const { stdout, stderr } = await processPromisify.exec('npm install --colors', {
      cwd: vueuiPath,
    })
    signale.debug("Install done. Building...")
    const build = await processPromisify.exec('npm run build-dev --colors',
      {
        cwd: vueuiPath,
      }
    )
    signale.debug("Build done.")
    return {
      install: stdout,
      build
    }
  } catch (error) {
    return {fail: error}
  }
}
