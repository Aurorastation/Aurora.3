<template>
  <div class="uiTitleWrapper" unselectable="on">
    <slot/>
    <div class="uiTitleText" unselectable="on">{{ title }}</div>
  </div>
</template>

<script>
export default {
  data () {
    return this.$root.$data
  }
}
</script>
