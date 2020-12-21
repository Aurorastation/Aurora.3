const { Signale } = require('signale')


const stages = require('./stages')


// run
const mainLogger = new Signale({scope: 'main'})
var states = {}
async function runStages () {
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





runStages()




