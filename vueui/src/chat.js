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

global.changeFontSize = function (delta) {
  // Save current parameters for later
  var offset = document.documentElement.scrollTop + document.documentElement.clientHeight;
  var height = document.documentElement.scrollHeight;
  // Make font increase faster with bigger font
  if(Store.state.fontSize > 40) {
    delta *= 2
  }
  // Do font size updating
  Store.UpdateFontSize(Store.state.fontSize + delta)
  applyFontSize(Store.state.fontSize)
  // Gather new parameters
  var height2 = document.documentElement.scrollHeight;
  var newOffset = offset/height * height2 - document.documentElement.clientHeight
  // If we were close to the end, then let's scroll to it.
  if(offset + 20 >= height) {
    newOffset = height2
  }
  window.scrollTo(0, newOffset);
}

function addMessages(messages) {
  // Save current parameters for later
  var offset = document.documentElement.scrollTop;
  var height = document.documentElement.scrollHeight - document.documentElement.clientHeight;
  messages.forEach(message => {
    let div = document.createElement('div')
    div.innerHTML = message
    div.className = "message"
    global.messageTarget.appendChild(div)
  })
  // If we were at the end of document, then auto scroll to it.
  if(offset + 20 >= height) {
    window.scrollTo(0, document.documentElement.scrollHeight);
  }
}

function applyFontSize(newSize) {
  document.body.style.fontSize = `${newSize}px`
}

Utils.onReady(() => {
  global.messageTarget = document.getElementById('chattarget')
  global.messageTarget.innerHTML = ""
  Store.loadInitialState(document.getElementById('initialstate').innerHTML)
  addMessages(Store.state.messages)
  global.changeFontSize(0)
  Utils.sendToTopicRaw({
    src: Store.state.ref,
    ready: 1
  })

  var tst = document.createElement('div')
  tst.className = "vuchat-controls"
  tst.innerHTML = "<a href=\"javascript:void(0);\" onmousedown=\"changeFontSize(1)\">[+]</a><a href=\"javascript:void(0);\" onmousedown=\"changeFontSize(-1)\">[-]</a>"
  document.body.insertBefore(tst, document.body.firstChild)
  
})