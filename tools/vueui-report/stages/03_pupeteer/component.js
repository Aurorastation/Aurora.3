module.exports = function (state) {
  return ({
    template: `<div>
      DO PuPETEERING
      {{ $data }}
    </div>`,
    data() {
      return state
    }
  })
}