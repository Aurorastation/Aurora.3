/*
 * Vue.js based ui framework for SS13
 * Made for Aurora, by Karolis K.
 */
import "core-js/stable"
import Vue from 'vue'
import upperFirst from 'lodash/upperFirst'
import camelCase from 'lodash/camelCase'

import Plugin from './plugin'
import Store from './store.js'
import './assets/global.scss'
import ByWin from './byWin'

const requireComponent = require.context(
  './components', // The relative path of the components folder
  true, // Whether or not to look in subfolders
  /[A-Za-z]\w+\.vue$/ // The regular expression used to match base component filenames
)

requireComponent.keys().forEach(fileName => {
  const componentConfig = requireComponent(fileName)
  const componentName = upperFirst(
      camelCase(
          // Strip the leading `'./` and extension from the filename
          fileName.replace(/^\.\/(.*)\.\w+$/, '$1')
      )
  )
  Vue.component(
      componentName,
      componentConfig.default || componentConfig
  )
})

Vue.use(Plugin)
Vue.config.productionTip = false
global.Vue = Vue

global.receiveUIState = (jsonState) => {
  Store.loadState(JSON.parse(jsonState))
}
if (document.getElementById("app")) {
  var state = JSON.parse(document.getElementById('initialstate').innerHTML)

  Store.loadState(state)

  window.__wtimetimer = window.setInterval(() => {
    Store.state.wtime += 2
  }, 200)

  ByWin.setWindowKey(window.document.getElementById('vueui:windowId').getAttribute('content'))
  ByWin.setupDrag()

  new Vue({
    data: Store.state,
    template: "<div id='content' tabindex='-1'><p class='csserror'>Javascript loaded, stylesheets has failed to load. <a href='javascript:void(0)'><vui-button :params='{ vueuiforceresource: 1}'>Click here to load.</vui-button></a></p><component v-if='componentName' :is='componentName'/><component v-if='templateString' :is='{template:templateString}'/></div>",
    computed: {
      componentName() {
        if(this.$root.$data.active.charAt(0) != "?") {
          return 'view-' + this.$root.$data.active
        }
        return null
      },
      templateString() {
        if(this.$root.$data.active.charAt(0) == "?") {
          return "<div>" + this.$root.$data.active.substr(1) + "</div>"
        }
        return null
      }
    },
    watch: {
      state: {
        handler() {
          Store.pushState()
        },
        deep: true
      }
    },
    mounted() {
      this.$el.focus()
    }
  }).$mount('#app')
}

if (document.getElementById("header")) {
  new Vue({
    data: Store.state
  }).$mount('#header')
}

if (document.getElementById("dapp")) {
  new Vue({
    data: Store.state,
    template: '<div id="debug"><h2>Debug this UI with inspector by opening URL in your browser:</h2><pre>{{url}}</pre><h2>Current data of UI:</h2><pre>{{ JSON.stringify(this.$root.$data, null, \'    \') }}</pre><button @click="stop()">STOP WTIME TRACKING</button></div>',
    methods: {
      stop() {
        window.clearInterval(window.__wtimetimer)
      }
    },
    computed: {
      url() {
        return window.location.href + '?ext'
      }
    }
  }).$mount('#dapp')
}
