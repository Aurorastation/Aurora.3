import { Runner } from './runner'
import fs from 'fs-extra'

const runner: Runner = async function json(page, testFile, utils) {
  const { data, size } = await fs.readJSON(testFile)
  await utils.loadInitial(data)
  await utils.setSize(size[0], size[1])
  await utils.screenshot()
}

export default runner
