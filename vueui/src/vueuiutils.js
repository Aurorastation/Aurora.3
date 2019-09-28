import Utils from './utils.js'
import Store from './store.js'
export default {
  sendToTopic(data, pushState = false) {
    var pushData = {
      src: Store.state.uiref,
      vueuihrefjson: JSON.stringify(data)
    }
    if(pushState) {
      pushData.vueuistateupdate = Store.getStatePushDataString()
    }
    Utils.sendToTopicRaw(pushData)
  },
  ...Utils
}