module.exports = {
  name: () => 'null',
  run: (signale) => ({result: 'fail'}),
  format: (state) => `<div class="alert alert-danger" role="alert">${state.result}</div>`
}