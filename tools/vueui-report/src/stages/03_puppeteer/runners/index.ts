import json from './json'
import { Runner } from './runner'
const runners: { [extension: string]: Runner } = {
  json,
}
export default runners
