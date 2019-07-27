import Store from './store.js'
export default {
  sendToTopic(data, pushState = false) {
    var r = new XMLHttpRequest()
    var sendUrl = "?src=" + Store.state.uiref + "&vueuihrefjson=" + encodeURIComponent(JSON.stringify(data))
    if (pushState) {
      sendUrl += "&" + Store.getStatePushString()
    }
    r.open("GET", sendUrl, true);
    r.send()
  },
  dotNotationRead(object, key) {
    return key.split('.').reduce((a, b) => a[b], object);
  }
}