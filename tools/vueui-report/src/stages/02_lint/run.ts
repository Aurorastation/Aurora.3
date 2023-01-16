import config from '../../config'
import processPromisify from '../../processPromisify'
import path from 'path'
const vueuiPath = path.resolve(config.vueui)
export default async function (signale) {
  try {
    const { stdout } = await processPromisify.exec('npm run lint --colors', {
      cwd: vueuiPath,
    })
    return {
      lint: stdout,
    }
  } catch (error) {
    return { lint_error: error }
  }
}
