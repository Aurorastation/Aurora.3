import Store from './store.js'
export default {
  sendToTopicRaw(data) {
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
  },
  // ATC call.
  sendToTopic(data) {
    var callData = {
      src: Store.state.uiref,
      vueuihrefjson: JSON.stringify(data)
    }
    this.sendToTopicRaw(callData)
  },
  dotNotationRead(object, key) {
    return key.split('.').reduce((a, b) => a[b], object);
  }
}