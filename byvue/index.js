import styles from './styles/global.scss'
import components from './components'
import Vue from 'vue'
import Store from './store.js'

var state = JSON.parse(document.getElementById('initialstate').innerHTML)

Store.loadState(state)

var app = new Vue({
    el: '#app',
    data: Store.state,
    components,
    render (createElement) {
        return createElement("ui-" + this.$root.$data.active)
    }
})