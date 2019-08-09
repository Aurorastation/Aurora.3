<template>
  <div class="item">
    <div class="itemLabel" :style="{ width: (1 - balance) * 100 + '%' }">{{ label }}</div>
    <div class="itemContent" :style="{ width: balance * 100 + '%' }"><slot/></div>
  </div>
</template>

<script>
export default {
  name: "vui-item",
  props: {
    label: {
      type: String,
      default: ""
    },
    balance: {
      type: Number,
      default: 0.6
    }
  }
}
</script>

<style lang="scss" scoped>
.item {
    width: 100%;
}

.itemLabel, .itemContent {
    display: inline-block
}

.itemLabel {
    width: 30%;
    vertical-align: top;
}
</style>
