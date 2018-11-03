module.exports = {
  lintOnSave: false,
  baseUrl: '',
  outputDir: undefined,
  assetsDir: undefined,
  runtimeCompiler: true,
  productionSourceMap: undefined,
  parallel: undefined,
  css: {
    extract: true
  },
  chainWebpack: config => {
    config
      .performance
        .hints(false)
        .end()
      .output
        .filename("[name].js")
        .end()
      .optimization
        .delete('splitChunks')
        .end()
      .module
        .rule('images')
          .use('url-loader')
            .options({})
            .end()
          .delete("file-loader")
          .end()
        .rule('svg')
          .use('file-loader')
            .loader('url-loader')
            .options({})
            .end()
          .delete("file-loader")
          .end()
        .rule('fonts')
          .use('url-loader')
            .options({})
            .end()
          .end()
        .end()
        
    config.plugins
      .delete("html")
      .delete("preload")
      .delete("prefetch")
      .delete("hmr")

    config.plugin('extract-css')
      .tap(args => {
        args[0].filename = '[name].css'
      })
  }
}