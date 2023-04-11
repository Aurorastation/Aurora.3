import { Signale } from 'signale'
import { createSSRApp } from 'vue'
import { renderToString } from '@vue/server-renderer'
import fs from 'fs-extra'

import Stages from './stages'
import App from './app'
import { Stage } from './stages/stage'

// run
const mainLogger = new Signale({ scope: 'main' })
const states = {}
async function runStages(runnableStages: Stage[]) {
  mainLogger.time('All Stages')
  for (let i = 0; i < runnableStages.length; i++) {
    const stage = runnableStages[i]
    const name = stage.name()
    const subLogger = mainLogger.scope('stage', name)
    mainLogger.time(name)
    const result = await Promise.resolve(stage.run(subLogger))
    mainLogger.timeEnd(name)
    states[i] = result
  }
  mainLogger.timeEnd('All Stages')
}

// Build HTML

async function generateHTML(stages: Stage[]) {
  const app = createSSRApp(App(states, stages))

  await fs.outputFile('report.htm', await renderToString(app))
}

async function main() {
  const runnableStages = Stages.filter((stage) => stage.ci || !process.env.CI)
  await runStages(runnableStages)
  await generateHTML(runnableStages)
}

main()
