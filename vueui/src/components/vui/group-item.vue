<template>
  <div class="item">
    <div class="itemLabel">{{ label }}</div>
    <div class="itemContent"><slot/></div>
  </div>
</template>

<script>
export default {
  props: {
    label: {
      type: String,
      default: ""
    }
  }
}
</script>

<style lang="scss" scoped>
div.item {
  display: table-row;
}

.itemLabel, .itemContent {
  display: table-cell;
}

.itemLabel {
  padding-right: 8px;
}
</style>
