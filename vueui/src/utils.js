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
  dotNotationRead(object, key) {
    return key.split('.').reduce((a, b) => a[b], object);
  },
  onReady(callback) {
    if (document.readyState != 'loading'){
      callback()
    } else if (document.addEventListener) {
      document.addEventListener('DOMContentLoaded', callback)
    } else {
      document.attachEvent('onreadystatechange', function() {
        if (document.readyState != 'loading') {
          callback()
        }
      });
    }
  }
}