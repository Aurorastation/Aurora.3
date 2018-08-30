<template>
  <div @click="senddata()" class="button" :disabled="$root.$data.status < 2 || this.disabled">
    <div v-if="icon" class="uiIcon16" :class="'ic-' + icon"/>
    <span><slot/></span>
  </div>
</template>

<script>
import Store from '../../store.js'

export default {
  props: {
    icon: {
      type: String,
      default: ""
    },
    params: {
      type: Object,
      default() {
        return {}
      }
    },
    pushState: {
      type: Boolean,
      default: false
    },
    disabled: {
      type: Boolean,
      default: false
    }
  },
  methods: {
    senddata() {
      if(this.$root.$data.status < 2 || this.disabled) {
        return
      }
      this.$emit('click')
      if(!this.params) {
        if (this.pushState) {
          Store.pushState()
        }
        return
      }
      var r = new XMLHttpRequest()
      var sendUrl = "?src=" + Store.state.uiref + "&vueuihrefjson=" + encodeURIComponent(JSON.stringify(this.params))
      if (this.pushState) {
        sendUrl += "&" + Store.getStatePushString()
      }
      r.open("GET", sendUrl, true);
      r.send()
    }
  }
}
</script>

<style lang="scss" scoped>
.uiIcon16 {
  margin-right: 4px;
}
</style>