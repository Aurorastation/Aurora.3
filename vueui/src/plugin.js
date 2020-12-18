import Utils from './utils'
export default {
  install(Vue) {
    // Map Advanced topic call and regular topic call to instances
    Vue.prototype.$atc = Utils.sendToTopic
    Vue.prototype.$rtc = Utils.sendToTopicRaw
  },
}
