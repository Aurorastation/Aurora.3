/*
 * HTML chat styles and tools.
 * Made for Aurora, by Karolis K.
 */
import './assets/chat.scss'
import Utils from './utils.js'
import Store from './chatStore.js'
import UrlParse from 'url-parse'
import linkifyHtml from 'linkifyjs/html';

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

global.chatPong = Store.getPongHandler((speed) => {
  document.getElementById("latency").innerText = speed
})

global.dbg = () => {
  let div = document.createElement('div')
  div.innerText = global.messageTarget.innerHTML
  div.innerText += "<hr>" + window.location
  global.messageTarget.appendChild(div)

}

var pingTimer = setInterval(Store.getPingHandlier(
  () => Utils.sendToTopicRaw({
      src: Store.state.ref,
      ping: 1
    }),
  (time) => {
    addMessages([`Server didn't respond in ${time} seconds. You might have lost connection.`])
    clearInterval(pingTimer);
  }
), 2000)

function getLinkClickHandler(el) {
  return (event) => {
    event.preventDefault()
    var url = UrlParse(el.getAttribute('href'), 'byond://')
    if(url.hostname) {
      Utils.sendToTopicRaw({
        _openurl: url.href
      })
    } else {
      Utils.AJAX(url.query)
    }
    return false
  }
}

function addMessages(messages) {
  // Save current parameters for later
  var offset = document.documentElement.scrollTop;
  var height = document.documentElement.scrollHeight - document.documentElement.clientHeight;
  messages.forEach(message => {
    let div = document.createElement('div')
    div.innerHTML = linkifyHtml(message)
    div.className = 'message'
    global.messageTarget.appendChild(div)
    div.getElementsByTagName('A').forEach(el => el.addEventListener('click', getLinkClickHandler(el)))
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

  document.addEventListener("onclick", (event) => {
    addMessages([JSON.stringify(event)])
    if(event.target.tagName == "A") {
      event.preventDefault()
    }
  })

  var tst = document.createElement('div')
  tst.className = "vuchat-controls"
  tst.innerHTML = "<span id=\"latency\"></span><a href=\"javascript:void(0);\" onmousedown=\"changeFontSize(1)\">[+]</a><a href=\"javascript:void(0);\" onmousedown=\"changeFontSize(-1)\">[-]</a><a href=\"javascript:void(0);\" onmousedown=\"dbg()\">[D]</a>"
  document.body.insertBefore(tst, document.body.firstChild)
  
})