const config = require('../../config')
const processPromisify = require('../../src/processPromisify')
const path = require('path')
const vueuiPath = path.resolve(config.vueui)
module.exports = async function (signale) {
  try {
    const { stdout, stderr } = await processPromisify.exec('npm install', {
      cwd: vueuiPath,
    })
    signale.debug("Install done. Building...")
    const { stdout2, stderr2 } = await processPromisify.exec(
      'npm run build-dev',
      {
        cwd: vueuiPath,
      }
    )
    signale.debug("Build done.")
    return {
      install: stdout,
      build: stdout2
    }
  } catch (error) {
    return {fail: error}
  }
}
