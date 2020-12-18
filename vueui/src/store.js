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
  },
}
