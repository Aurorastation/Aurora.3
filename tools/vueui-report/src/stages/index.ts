import build from './01_build'
import lint from './02_lint'
import puppeteer from './03_puppeteer'
import { Stage } from './stage'
const stages: Stage[] = [build, lint, puppeteer]
export default stages
