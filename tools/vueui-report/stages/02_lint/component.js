module.exports = function (state) {
  return ({
    template: '<div>{{ $data }}</div>',
    data() {
      return state
    }
  })
}