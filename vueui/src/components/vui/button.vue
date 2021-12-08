<template>
  <a
    @click="senddata()"
    class="btn"
    :class="'btn-' + type + (isDisabled ? ' disabled' : '')"
    :disabled="isDisabled"
  >
    <div
      v-if="icon"
      class="fa"
      :class="[
        `ic-${this.icon}`,
        { 'mr-1': !this.iconOnly },
        getRotateClass,
        getFlipClass,
      ]"
    />
    <span><slot /></span>
  </a>
</template>

<script>
import Utils from "@/utils"
export default {
  props: {
    icon: {
      type: String,
      default: "",
    },
    rotate: {
      type: Number,
      default: 0,
    },
    flip: {
      type: String,
      default: "",
    },
    params: {
      type: Object,
      default: null,
    },
    unsafeParams: {
      type: Object,
      default: null,
    },
    disabled: {
      type: Boolean,
      default: false,
    },
    type: {
      type: String,
      default: "primary",
    },
  },
  methods: {
    senddata() {
      if (this.$root.$data.status < 2 || this.disabled) {
        return
      }
      this.$emit("click")
      if (this.unsafeParams) {
        Utils.sendToTopicRaw(this.unsafeParams)
      }
      if (!this.params) {
        return
      }
      Utils.sendToTopic(this.params)
    },
  },
  computed: {
    getRotateClass() {
      switch (this.rotate % 360) {
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
      if (!this.flip) return
      return `ic-flip-${this.flip}`
    },
    isDisabled() {
      return this.$root.$data.status < 2 || this.disabled
    },
  },
}
</script>
