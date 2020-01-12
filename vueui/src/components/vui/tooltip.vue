<template>
  <span class="tooltip label">
    <slot name="label">{{label}}</slot><div class="tooltip content"><slot/></div>
  </span>
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
span {
  &:hover {
    div {
      display: inline-block;
    }
  }
  div {
    margin-top: -5px;
    margin-left: 4px;
    padding: 3px;
    display: none;
    position: absolute;
  }
}
</style>
