export default {
    debug: true,
    state: {
        assets: [],
        state: {},
        active: ""
    },
    loadState (loadedState) {
        if (this.debug) console.log('Loaded state with', loadedState)
        this.state.assets = loadedState.assets
        this.state.state = loadedState.state
        this.state.active = loadedState.active
    }
}