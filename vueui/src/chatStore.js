import Cookies from 'js-cookie'

export default {
  state: {
    ref: "",
    roundId: "",
    fontSize: 14,
    messages: []
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
  }
}