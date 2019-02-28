<template>
  <img :src="source">
</template>

<script>
export default {
  props: {
    name: {
      type: String,
      default: ""
    }
  },
  computed: {
    source() {
      return "vueuiimg_" + this.$root.$data.assets[this.name].ref + ".png"
    }
  }
}
</script>