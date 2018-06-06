import styles from './styles/global.scss'
import components from './components'
import Vue from 'vue'
import Store from './store.js'

var state = JSON.parse(document.getElementById('initialstate').innerHTML)

Store.loadState(state)

global.receveUIState = (jsonState) => {

}

var app = new Vue({
    el: '#app',
    data: Store.state,
    components,
    render (createElement) {
        return createElement('ui-' + this.$root.$data.active)
    }
})

var dapp = new Vue({
    el: '#dapp',
    data: Store.state,
    template: '<p>{{ JSON.stringify(this.$root.$data) }}</p>'
})
