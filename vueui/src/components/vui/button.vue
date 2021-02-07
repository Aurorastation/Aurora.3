<template>
  <div @click="senddata()" class="button" :disabled="$root.$data.status < 2 || this.disabled">
    <div v-if="icon" class="uiIcon16" :class="[this.iconOnly ? '' : 'mr-1', 'ic-' + icon]"/>
    <span><slot/></span>
  </div>
</template>

<script>
import Store from "@/store"
import Utils from "@/utils"
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
    unsafeParams: {
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
    },
    iconOnly: {
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
      if(this.unsafeParams) {
        Utils.sendToTopicRaw(this.unsafeParams)
      }
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
