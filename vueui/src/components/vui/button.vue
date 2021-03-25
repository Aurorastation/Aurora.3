<template>
  <div @click="senddata()" class="button" :disabled="$root.$data.status < 2 || this.disabled">
    <div v-if="icon" class="uiIcon16" :class="[`ic-${this.icon}`, {'mr-1': !this.iconOnly}, getRotateClass, getFlipClass]"/>
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
    rotate: {
      type: Number,
      default: 0
    },
    flip: {
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
  },
  computed: {
    getRotateClass() {
      switch(this.rotate % 360) {
        case 90:
          return "ic-rotate-90"
        case 180:
          return "ic-rotate-180"
        case 270:
          return "ic-rotate-270"
        default:
          return ""
      }
    },
    getFlipClass() {
      if(!this.flip) return
      return `ic-flip-${this.flip}`
    }
  }
}
</script>
