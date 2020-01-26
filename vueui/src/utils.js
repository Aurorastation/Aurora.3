import Store from './store.js'
export default {
  sendToTopicRaw(data) {
    var sendparams = []
    for (var val in data) {
      sendparams.push(encodeURIComponent(val) + "=" + encodeURIComponent(data[val]))
    }
    var r = new XMLHttpRequest()
    var sendUrl = "?" + sendparams.join("&")
    if(window.ci)
      sendUrl = "topic" + sendUrl
    r.open("GET", sendUrl, true);
    r.send()
  },
  sendToTopic(data, pushState = false) {
    var pushData = {
      src: Store.state.uiref,
      vueuihrefjson: JSON.stringify(data)
    }
    if (pushState) {
      pushData["vueuistateupdate"] = Store.getStatePushDataString()
    }
    this.sendToTopicRaw(pushData)
  },
  dotNotationRead(object, key) {
    return key.split('.').reduce((a, b) => a[b], object);
  },
  pushState() {
    if (Store.isUpdating || (Date.now() - Store.lastUpdateTime) < 100) {
      return
    }
    var pushData = {
      src: Store.state.uiref,
      vueuipushonly: 1,
      vueuistateupdate: Store.getStatePushDataString()
    }
    this.sendToTopicRaw()
  }
}
