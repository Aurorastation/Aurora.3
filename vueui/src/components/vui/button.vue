<template>
  <div @click="senddata()" class="button" :disabled="$root.$data.status < 2 || this.disabled">
    <div v-if="icon" class="uiIcon16" :class="'ic-' + icon"/>
    <span><slot/></span>
  </div>
</template>

<script>
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
      if(this.unsafeParams) {
        this.$rtc(this.unsafeParams)
      }
      if(!this.params) {
        return
      }
      this.$atc(this.params)
    }
  }
}
</script>

<style lang="scss" scoped>
.uiIcon16 {
  margin-right: 4px;
}
</style>