import Utils from './utils'
export default {
  install(Vue) {
    // Map Advanced topic call and regular topic call to instances
    Vue.prototype.$toTopic = Utils.sendToTopic
    Vue.prototype.$toTopicRaw = Utils.sendToTopicRaw
  },
}