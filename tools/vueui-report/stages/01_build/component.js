var Convert = require('ansi-to-html');
var convert = new Convert();
module.exports = function (state) {
  return ({
    template: `<div>
      <h3>npm install</h3>
      <pre v-html="installOut"></pre>
      <h3>npm run build-dev</h3>
      <pre v-html="buildOut"></pre>
    </div>`,
    data() {
      return state
    },
    computed: {
      installOut() {
        if(this.install)
        {
          return convert.toHtml(this.install)
        }
        return ''
      },
      buildOut() {
        if(this.build)
        {
          return convert.toHtml(this.build.stdout)
        }
        return ''
      }
    }
  })
}