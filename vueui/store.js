export default {
    debug: true,
    state: {
        assets: [],
        state: {},
        active: '',
        uiref: '',
        status: 2,
    },
    loadState (loadedState) {
        this.isUpdating = true
        if (this.debug) console.log('Loaded state with', loadedState)
        this.state.assets = loadedState.assets
        this.state.state = loadedState.state
        this.state.active = loadedState.active
        this.state.uiref = loadedState.uiref
        this.state.status = loadedState.status
        this.isUpdating = false
    },
    isUpdating: false
}