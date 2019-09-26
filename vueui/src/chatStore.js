export default {
  state: {
    ref: "",
    roundId: "",
    messages: []
  },
  loadInitialState(encodedData) {
    var newState = JSON.parse(encodedData)
    this.state.ref = newState.ref
    this.state.roundId = newState.roundid
    if (window.localStorage) {
      var rid = window.localStorage.getItem("roundID")
      if(rid != this.state.roundId) {
        window.localStorage.clear()
        window.localStorage.setItem("roundID", this.state.roundId)
      }
      var messages = window.localStorage.getItem("messages")
      messages = JSON.parse(messages)
      if(typeof messages == Array) {
        this.state.messages = messages
      }
    }
  },
  AddMessages(messages) {
    this.state.messages = this.state.messages.concat(messages)
    if (window.localStorage) {
      window.localStorage.setItem("messages", JSON.stringify(this.state.messages))
    }
  }
}