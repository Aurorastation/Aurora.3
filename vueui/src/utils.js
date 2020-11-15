import Store from './store.js'
import store from './store.js';

const randomId = () => Math.random().toString(36).substring(13)

export default {
  sendRaw(path, data) {
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
    var url = path + '?' + sendparams.join("&")

    if(url.indexOf('byond://') >= 0) {
      window.location.href = url
      return
    }

    var r = new XMLHttpRequest()
    r.open("GET", url, true);
    r.send()
  },
  sendRawWithCallback(path, data, callback) {
    var functionCallbackId = '__bycallback' + randomId()
    window[functionCallbackId] = callback
    this.sendRaw(path, Object.assign({}, data, {
      callback: functionCallbackId,
    }))
  },
  sendToTopicRaw(data) {
    this.sendRaw('?', data)
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