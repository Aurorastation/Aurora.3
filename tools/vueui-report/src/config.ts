export default {
  vueui: '../../vueui',
  assets: {
    css: 'app.css',
    js: 'app.js',
  },
  template: (initialData, { css, js }) => `<html>
    <head>
      <meta charset="UTF-8"/>
      <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
      <meta id="vueui:windowId" content="TEST"/>
      <link rel="stylesheet" type="text/css" href="${css}"/>
    </head>
    <body class="vueui theme-nano dark-theme">
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
      ${JSON.stringify(initialData)}
    </script>
    <script type="text/javascript" src="${js}"></script>
  </html>`,
}
