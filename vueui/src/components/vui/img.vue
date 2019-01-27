<template>
  <img :src="source" @error="failedToLoad()">
</template>

<script>
export default {
  props: {
    name: {
      type: String,
      default: ""
    },
    maxTries: {
      type: Number,
      default: 10
    }
  },
  computed: {
    sourceBuster() {
      if(this.failsToLoad && this.failsToLoad < this.maxTries) {
        return "?t=" + failsToLoad
      } else {
        return ""
      }
    },
    source() {
      return "vueuiimg_" + this.$root.$data.assets[this.name].ref + this.sourceBuster +".png"
    }
  },
  data() {
    return {
      failsToLoad: 0
    }
  },
  methods: {
    failedToLoad() {
      setTimeout(() => {
        this.failsToLoad++
        if(this.failsToLoad < this.maxTries) {
          console.error(`Image ${this.name} failed to load ${this.failsToLoad} times. Please double check have you actually sent it to the client.`)
        }
      }, 300)
    }
  }
}
</script>