<template>
  <tr class="item">
    <td class="itemLabel">{{ label }}</td>
    <td class="itemContent"><slot/></td>
  </tr>
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
.itemContent {
  width: 10%;
}

.itemLabel {
  padding-right: 8px;
  width: 4%;
}
</style>
