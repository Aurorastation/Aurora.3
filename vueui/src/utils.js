import Store from './store.js'

export function sendToTopicRaw(data) {
  var sendparams = []
  for(var val in data) {
    if (Array.isArray(data[val])) {
      for (const value in data[val]) {
        sendparams.push(encodeURIComponent(val) + "=" + encodeURIComponent(value))
      }
    } else {
      sendparams.push(encodeURIComponent(val) + "=" + encodeURIComponent(data[val]))
    }
  }
  var r = new XMLHttpRequest()
  var sendUrl = "?" + sendparams.join("&")
  r.open("GET", sendUrl, true);
  r.send()
}

export function sendToTopic(data, pushState = false) {
  var pushData = {
    src: Store.state.uiref,
    vueuihrefjson: JSON.stringify(data)
  }
  if(pushState) {
    pushData["vueuistateupdate"] = Store.getStatePushDataString()
  }
  sendToTopicRaw(pushData)
}

export function dotNotationRead(object, key) {
  return key.split('.').reduce((a, b) => a[b], object);
}

const HOUR = 36000
const MINUTE = 600

export function worldtime2text(time, timeshift = true) {
  const offset = timeshift ? Store.state.roundstart_hour + 2 : 0
  const hour = Math.floor((time / HOUR + offset) % 24)
  const minute = Math.floor(time % HOUR / MINUTE)
  return `${('0' + hour).slice(-2)}:${('0' + minute).slice(-2)}`
}

export default {
  sendToTopicRaw,
  sendToTopic,
  dotNotationRead,
  worldtime2text
}