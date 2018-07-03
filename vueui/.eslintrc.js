module.exports = {
  root: true,
  env: {
    node: true
  },
  'extends': [
    'plugin:vue/essential',
    'eslint:recommended'
  ],
  rules: {
    'no-console': 'off',
    'no-debugger': 'off',
    'vue/html-indent': [
      'error',
      2
    ],
    'vue/require-default-prop': 'error',
    'vue/require-prop-types': 'error'
  },
  parserOptions: {
    parser: 'babel-eslint'
  }
}