<template>
  <div>
    <div class="titleBar">
      <div class="uiTitleText" unselectable="on">{{ d.title }}</div>
    </div>
    <slot/>
  </div>
</template>

<script>

export default {
  data () {
    return {
      d: this.$root.$data,
    }
  },
}
</script>
