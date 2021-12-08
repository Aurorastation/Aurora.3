<template>
  <div class="progress">
    <div
      class="progress-bar"
      role="progressbar"
      :style="{ width: percentage + '%' }"
    >
      <span><slot /></span>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    value: {
      type: Number,
      default: 50,
    },
    max: {
      type: Number,
      default: 100,
    },
    min: {
      type: Number,
      default: 0,
    },
  },
  computed: {
    percentage() {
      return (
        ((Math.min(this.max, Math.max(this.value, this.min)) - this.min) /
          (this.max - this.min)) *
        100
      )
    },
  },
}
</script>
