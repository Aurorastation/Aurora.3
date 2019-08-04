import Store from './store.js'
import store from './store.js';
export default {
  sendToTopicRaw(data) {
    var sendparams = []
    for(var val in data) {
      sendparams.push(encodeURIComponent(val) + "=" + encodeURIComponent(data[val]))
    }
    var r = new XMLHttpRequest()
    var sendUrl = "?" + sendparams.join("&")
    r.open("GET", sendUrl, true);
    r.send()
  },
  sendToTopic(data, pushState = false) {
    var pushData = {
      src: Store.state.uiref,
      vueuihrefjson: JSON.stringify(data)
    }
    if(pushState) {
      pushData["vueuistateupdate"] = store.getStatePushDataString()
    }
    this.sendToTopicRaw(pushData)
  },
  dotNotationRead(object, key) {
    return key.split('.').reduce((a, b) => a[b], object);
  }
}