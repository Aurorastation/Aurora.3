import run from './run'
import component from './component'
import { Stage } from '../stage'
const stage: Stage = {
  name: () => 'Puppeteer',
  run,
  component,
  ci: true,
}
export default stage
