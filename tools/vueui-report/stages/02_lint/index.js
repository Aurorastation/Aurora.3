const run = require('./run')
const format = require('./format')
module.exports = {
  name: () => 'Lint',
  run,
  format
}