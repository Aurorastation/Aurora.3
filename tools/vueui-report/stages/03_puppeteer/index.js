const run = require('./run')
const component = require('./component')
module.exports = {
  name: () => 'Puppeteer',
  run,
  component,
  ci: true,
}
