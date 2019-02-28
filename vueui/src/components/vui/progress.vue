<template>
  <div class="displayBar">
    <div class="displayBarFill" :style="{ width: percentage + '%'}"/>
  </div>
</template>

<script>
export default {
  name: 'vui-progress',
  props: {
    value: {
      type: Number,
      default: 50
    },
    max: {
      type: Number,
      default: 100
    },
    min: {
      type: Number,
      default: 0
    }
  },
  computed: {
    percentage() {
      return (this.value - this.min) / (this.max - this.min) * 100
    }
  }
}
</script>