import Vue from 'vue'
import upperFirst from 'lodash/upperFirst'
import camelCase from 'lodash/camelCase'

import Store from './store.js'
import styles from './styles/global.scss'

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

var state = JSON.parse(document.getElementById('initialstate').innerHTML)

Store.loadState(state)

global.receveUIState = (jsonState) => {
    Store.loadState(JSON.parse(jsonState))
}

var app = new Vue({
    el: '#app',
    data: Store.state,
    render (createElement) {
        return createElement('view-' + this.$root.$data.active)
    },
    watch: {
        state: {
            handler(val) {
                if (Store.isUpdating) return
                var r = new XMLHttpRequest()
                r.open("GET", "?src=" + Store.state.uiref + "&vueuistateupdate=" + encodeURIComponent(JSON.stringify(Store.state)), true);
                r.send()
            },
            deep: true
        }
    }
})

var header = new Vue({
    el: '#header',
    data: Store.state
})

if (document.getElementById("dapp")) {
    var dapp = new Vue({
        el: '#dapp',
        data: Store.state,
        template: '<div><h1>Current data of UI:</h1><pre>{{ JSON.stringify(this.$root.$data, null, \'    \') }}</pre></div>'
    })
}
