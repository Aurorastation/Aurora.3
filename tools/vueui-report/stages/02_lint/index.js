const run = require('./run')
const component = require('./component')
module.exports = {
  name: () => 'Lint',
  run,
  component,
  ci: false,
}
