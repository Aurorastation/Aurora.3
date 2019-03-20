<template>
  <div @click="senddata()" class="button" :disabled="$root.$data.status < 2 || this.disabled">
    <div v-if="icon" class="uiIcon16" :class="'ic-' + icon"/>
    <span><slot/></span>
  </div>
</template>

<script>
import Store from '../../store.js'
import Utils from '../../utils.js'
export default {
  props: {
    icon: {
      type: String,
      default: ""
    },
    params: {
      type: Object,
      default: null
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
      Utils.sendToTopic(this.params, this.pushState)
    }
  }
}
</script>

<style lang="scss" scoped>
.uiIcon16 {
  margin-right: 4px;
}
</style>