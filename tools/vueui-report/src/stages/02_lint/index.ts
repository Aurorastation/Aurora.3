import run from './run'
import component from './component'
import { Stage } from '../stage'
const stage: Stage = {
  name: () => 'Lint',
  run,
  component,
  ci: false,
}
export default stage
