/*
 * Vue.js based ui framework for SS13
 * Made for Aurora, by Karolis K.
 */
import "core-js/stable"
import Vue from "vue"
import upperFirst from "lodash/upperFirst"
import camelCase from "lodash/camelCase"

import Plugin from "./plugin"
import Store from "./store.js"
import "./assets/global.scss"
import ByWin from "./byWin"
import Main from "./Main.vue"
import Debug from "./Debug.vue"

const requireComponent = require.context(
  "./components", // The relative path of the components folder
  true, // Whether or not to look in subfolders
  /[A-Za-z]\w+\.vue$/ // The regular expression used to match base component filenames
)

requireComponent.keys().forEach(fileName => {
  const componentConfig = requireComponent(fileName)
  const componentName = upperFirst(
    camelCase(
      // Strip the leading `'./` and extension from the filename
      fileName.replace(/^\.\/(.*)\.\w+$/, "$1")
    )
  )
  Vue.component(componentName, componentConfig.default || componentConfig)
})

Vue.use(Plugin)
Vue.config.productionTip = false
global.Vue = Vue

global.receiveUIState = jsonState => {
  Store.loadState(JSON.parse(jsonState))
}
if (document.getElementById("app")) {
  var state = JSON.parse(document.getElementById("initialstate").innerHTML)

  Store.loadState(state)

  window.__wtimetimer = window.setInterval(() => {
    Store.state.wtime += 2
  }, 200)

  ByWin.setWindowKey(
    window.document.getElementById("vueui:windowId").getAttribute("content")
  )
  ByWin.setupDrag()

  new Vue({
    components: {
      Main,
    },
    data: Store.state,
    template: "<Main />",
    mounted() {
      this.$el.focus()
    },
  }).$mount("#app")
}

if (document.getElementById("header")) {
  new Vue({
    data: Store.state,
  }).$mount("#header")
}

if (document.getElementById("dapp")) {
  new Vue({
    components: {
      Debug,
    },
    data: Store.state,
    template: "<Debug />",
  }).$mount("#dapp")
}
