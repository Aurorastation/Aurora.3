/*
 * HTML chat styles and tools.
 * Made for Aurora, by Karolis K.
 */
import './assets/chat.scss'
import Utils from './utils.js'
import Store from './chatStore.js'

global.receiveQueue = function (encoded) {
  let decoded = JSON.parse(encoded)
  Store.AddMessages(decoded)
  addMessages(decoded)
}

function addMessages(messages) {
  var offset = document.documentElement.scrollTop;
  var height = document.documentElement.scrollHeight - document.documentElement.clientHeight;
  messages.forEach(message => {
    let div = document.createElement('div')
    div.innerHTML = message
    div.className = "message"
    global.messageTarget.appendChild(div)
  })
  if(offset + 20 >= height) {
    window.scrollTo(0, document.documentElement.scrollHeight);
  }
}

Utils.onReady(() => {
  global.messageTarget = document.getElementById('chattarget')
  global.messageTarget.innerHTML = ""
  Store.loadInitialState(document.getElementById('initialstate').innerHTML)
  addMessages(Store.state.messages)
  Utils.sendToTopicRaw({
    src: Store.state.ref,
    ready: 1
  })
})