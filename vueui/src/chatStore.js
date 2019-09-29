import Cookies from 'js-cookie'

export default {
  state: {
    ref: "",
    roundId: "",
    fontSize: 14,
    messages: [],
    lastPing: null,
    lastPong: null,
  },
  loadInitialState(encodedData) {
    var newState = JSON.parse(encodedData)
    this.state.ref = newState.ref
    this.state.roundId = newState.roundid
    var fs = Cookies.getJSON('fontSize')
    if(fs) {
      this.state.fontSize = fs;
    }
  },
  AddMessages(messages) {
    this.state.messages = this.state.messages.concat(messages)
  },
  UpdateFontSize(newSize) {
    this.state.fontSize = newSize
    Cookies.set('fontSize', newSize);
  },
  getPingHandlier(send, onFailure) {
    return () => {
      if(!this.state.lastPing) {
        this.state.lastPing = Date.now()
        send()
      } else {
        var diff = Date.now() - this.state.lastPing
        if(diff > 15000) {
          onFailure(diff / 1000);
          send()
        }
      }
    }
  },
  getPongHandler(callback) {
    return () => {
      if(!this.state.lastPing) {
        return;
      }
      this.state.lastPong = Date.now()
      callback(this.state.lastPong - this.state.lastPing)
      this.state.lastPong = null;
      this.state.lastPing = null;
    }
  }
}