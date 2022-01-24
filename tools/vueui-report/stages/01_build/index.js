const run = require('./run')
const component = require('./component')
module.exports = {
  name: () => 'Build',
  run,
  component,
  ci: false,
}
