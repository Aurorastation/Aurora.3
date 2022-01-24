module.exports = {
  vueui: '../../vueui',
  themes: ['vueui theme-nano dark-theme', 'vueui theme-nano-light', 'vueui theme-basic', 'vueui theme-basic-dark dark-theme'],
  template: (theme, data) => `<!DOCTYPE html>
  <html>
    <head>
      <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
      <meta charset="UTF-8"/>
      <meta id="vueui:windowId" content="TEST"/>
      <link rel="stylesheet" type="text/css" href="app.css"/>
    </head>
    <body class="${theme}">
      <div id="header">
        <header-default></header-default>
        <header-handles></header-handles>
      </div>
      <div id="app">
        Javascript file has failed to load. <a href="?src=\ref&vueuiforceresource=1">Click here to force load resources</a>
      </div>
      <div id="dapp">
      </div>
      <noscript>
        <div id='uiNoScript'>
          <h2>JAVASCRIPT REQUIRED</h2>
          <p>Your Internet Explorer's Javascript is disabled (or broken).<br/>
          Enable Javascript and then open this UI again.</p>
        </div>
      </noscript>
    </body>
    <script type="application/json" id="initialstate">
      ${JSON.stringify(data)}
    </script>
    <script type="text/javascript" src="app.js"></script>
  </html>`
}
