export default {
  debug: false,
  state: {
    assets: [],
    state: {},
    active: '',
    uiref: '',
    status: 2,
    size: [400, 600],
    debug: 0,
    debug_view: false,
    wtime: 0,
    roundstart_hour: 0
  },
  loadState (loadedState) {
    this.isUpdating = true
    this.lastUpdateTime = Date.now()
    if (this.debug) console.log('Loaded state with', loadedState)
    this.state.assets = loadedState.assets
    Object.keys(loadedState.state).forEach((key) => {
        this.state.state[key] = loadedState.state[key]
    })
    this.state.active = loadedState.active
    this.state.uiref = loadedState.uiref
    this.state.status = loadedState.status
    this.state.size = loadedState.size
    this.state.title = loadedState.title
    this.state.wtime = loadedState.wtime
    this.state.debug = loadedState.debug
    this.state.roundstart_hour = loadedState.roundstart_hour
    this.isUpdating = false
  },
  isUpdating: false,
  lastUpdateTime: null,
  getStatePushString () {
    return "vueuistateupdate=" + encodeURIComponent(this.getStatePushDataString())
  },
  getStatePushDataString () {
    return JSON.stringify(this.state)
  },
  pushState() {
    if (this.isUpdating || (Date.now() - this.lastUpdateTime) < 100 ) {
      return
    }
    var r = new XMLHttpRequest()
    r.open("GET", "?src=" + this.state.uiref + "&vueuipushonly=1&" + this.getStatePushString(), true);
    r.send()
  }
}
