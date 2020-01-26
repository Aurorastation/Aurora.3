#!/usr/bin/env node

const express = require('express')
const chalk = require('chalk');
const util = require('util');
const app = express()
const port = 3000

app.use(express.static('dist'))

app.get('/topic', function (req, res) {
  var extra = 0
  res.send('Server does not handle Topic calls. Please handle them in cypress.')
  console.log(chalk`Received topic call from client to {yellow ${req.query.src}}- it was received by CI server.`)
  if(req.query.vueuistateupdate) {
    console.log(chalk`{magenta JSON state data}: \n${util.inspect(JSON.parse(req.query.vueuistateupdate), { colors: true, depth: 6 })}`)
    extra++
  }
  if(req.query.vueuihrefjson) {
    console.log(chalk`{magenta JSON href data}: \n${util.inspect(JSON.parse(req.query.vueuihrefjson), { colors: true, depth: 3 })}`)
    extra++
  } 
  if (!extra) {
    console.log(chalk`{magenta RAW topic call}: \n${req.originalUrl}`)
  }
})

app.get('/', function (req, res) {
  if(req.query.src) {
    res.send('Server does not handle Topic calls. Please handle them in cypress.')
    return
  }
  var theme = req.query.theme || 'theme-nano dark-theme'
  var header = req.query.header || 'minimal'
  var defaultState = {
    "state": {
      "choices": [],
      "mode": null,
      "voted": null,
      "endtime": 1957.25,
      "allow_vote_restart": 1,
      "allow_vote_mode": 0,
      "allow_extra_antags": 0,
      "question": "",
      "isstaff": 8192,
      "is_code_red": 0
    },
    "assets": [],
    "active": "misc-voting",
    "uiref": "[0x00000009]",
    "status": 2,
    "title": "Voting panel",
    "wtime": 0
  }
  var initialState = req.query.state || JSON.stringify(defaultState)
  res.set('Content-Type', 'text/html')
  res.send(`
<!DOCTYPE html>
  <html>
    <head>
      <meta http-equiv="X-UA-Compatible" content="IE=edge">
      <meta charset="UTF-8">
      <link rel="stylesheet" type="text/css" href="app.css">
      <script>window.ci = true</script>
    </head>
    <body class="${theme}">
      <div id="header">
        <header-${header}/>
      </div>
      <div id="app">
        Javascript file has failed to load.
      </div>
      <div id="dapp"></div>
      <noscript>
        <div id='uiNoScript'>
          <h2>JAVASCRIPT REQUIRED</h2>
          <p>Your Internet Explorer's Javascript is disabled (or broken).<br/>
          Enable Javascript and then open this UI again.</p>
        </div>
      </noscript>
    </body>
    <script type="application/json" id="initialstate">
      ${initialState}
    </script>
    <script type="text/javascript" src="app.js"></script>
  </html>
  `)
})

app.listen(port, () => {
  console.log(chalk`{green VueUI} emulation CI server is live on {blueBright http://localhost:${port}}`)
})
