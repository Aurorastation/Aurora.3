<template>
  <div class="item">
    <!-- DEPRECATED PLEASE USE VUI-GROUP AND VUI-GROUP-ITEM -->
    <div v-if="label" class="itemLabel" :style="{ width: (1 - balance) * 100 + '%' }">{{ label }}</div>
    <div class="itemContent" :style="{ width: (label ? balance : 1) * 100 + '%' }"><slot/></div>
  </div>
</template>

<script>
// DEPRICATE PLEASE USE VUI-GROUP AND VUI-GROUP-ITEM
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
