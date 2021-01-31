const config = require('../../config')
const processPromisify = require('../../src/processPromisify')
const path = require('path')
const vueuiPath = path.resolve(config.vueui)
module.exports = async function (signale) {
  try {
    const { stdout, stderr } = await processPromisify.exec('npm run lint --colors', {
      cwd: vueuiPath,
    })
    return {
      lint: stdout,
    }
  } catch (error) {
    return {lint_error: error}
  }
}
