module.exports = {
  presets: [
    ['@babel/preset-env', 
      { 
        useBuiltIns: 'usage',
        corejs: 3,
        targets: {
          ie: 9
        }
      }
    ]
  ]
}