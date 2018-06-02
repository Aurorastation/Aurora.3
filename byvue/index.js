import styles from './styles/global.scss'
import components from './components'
import Vue from 'vue'

var state = JSON.parse(document.getElementById('initialstate').innerHTML)

var app = new Vue({
    el: '#app',
    data: state,
    components
})