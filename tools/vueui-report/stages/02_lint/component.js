var Convert = require('ansi-to-html');
var convert = new Convert();
module.exports = function (state) {
  return ({
    template: `<div>
      <pre v-html="lintOut"></pre>
    </div>`,
    data() {
      return state
    },
    computed: {
      lintOut() {
        if(this.lint)
        {
          return convert.toHtml(this.lint)
        }
        return ''
      }
    }
  })
}