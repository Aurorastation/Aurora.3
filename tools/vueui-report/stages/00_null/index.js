module.exports = {
  name: () => 'null',
  run: (signale) => ({result: 'fail'}),
  component: (state) => ({template: '<div>{{ $data }}</div>'}),
  ci: true,
}