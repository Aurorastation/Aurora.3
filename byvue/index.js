import Vue from 'vue'

import Store from './store.js'
import styles from './styles/global.scss'
import components from './components'

var state = JSON.parse(document.getElementById('initialstate').innerHTML)

Store.loadState(state)

global.receveUIState = (jsonState) => {
    Store.loadState(JSON.parse(jsonState))
}

var app = new Vue({
    el: '#app',
    data: Store.state,
    components,
    render (createElement) {
        return createElement('ui-' + this.$root.$data.active)
    },
    watch: {
        state: {
            handler(val) {
                if (Store.isUpdating) return
                var r = new XMLHttpRequest()
                r.open("GET", "?src=" + Store.state.uiref + "&byvuestateupdate=" + encodeURIComponent(JSON.stringify(Store.state)), true);
                r.send()
            },
            deep: true
        }
    }
})

var dapp = new Vue({
    el: '#dapp',
    data: Store.state,
    template: '<p>{{ JSON.stringify(this.$root.$data) }}</p>'
})
