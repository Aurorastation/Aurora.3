import Convert from 'ansi-to-html'
const convert = new Convert()
export default function (state) {
  return {
    template: `<div>
      <pre v-html="lintOut"></pre>
    </div>`,
    data() {
      return state
    },
    computed: {
      lintOut() {
        if (this.lint) {
          return convert.toHtml(this.lint)
        }
        return ''
      },
    },
  }
}
