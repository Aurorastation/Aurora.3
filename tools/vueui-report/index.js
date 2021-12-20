const { Signale } = require('signale')
const Vue = require('vue')
const fs = require('fs-extra')

const stages = (() => {
  if (process.env.CI) return require('./stages').filter((stage) => stage.ci)
  return require('./stages')
})()

// run
const mainLogger = new Signale({ scope: 'main' })
var states = {}
async function runStages() {
  mainLogger.time('All Stages')
  for (const [i, stage] of stages.entries()) {
    const name = stage.name()
    const subLogger = mainLogger.scope('stage', name)
    mainLogger.time(name)
    let result = await Promise.resolve(stage.run(subLogger))
    mainLogger.timeEnd(name)
    states[i] = result
  }
  mainLogger.timeEnd('All Stages')
}

// Build HTML

async function generateHTML() {
  const app = new Vue(require('./src/app')(states, stages))
  const renderer = require('vue-server-renderer').createRenderer()

  await fs.outputFile('report.htm', await renderer.renderToString(app))
}

async function main() {
  await runStages()
  await generateHTML()
}

main()
