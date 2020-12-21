const run = require('./run')
const format = require('./format')
module.exports = {
  name: () => 'Build',
  run,
  format
}