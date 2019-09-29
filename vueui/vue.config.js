module.exports = {
  lintOnSave: false,
  publicPath: '',
  outputDir: undefined,
  assetsDir: undefined,
  runtimeCompiler: true,
  productionSourceMap: undefined,
  parallel: undefined,
  css: {
    extract: true
  },
  pages: {
    app: "src/main.js",
    chat: "src/chat.js"
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
      .delete("html-app")
      .delete("preload-app")
      .delete("prefetch-app")
      .delete("html-chat")
      .delete("preload-chat")
      .delete("prefetch-chat")
      .delete("hmr")

    config.plugin('extract-css')
      .tap(args => {
        args[0].filename = '[name].css'
      })
  }
}