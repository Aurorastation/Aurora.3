<template>
  <div>
    <h1>Access Control</h1>
    <vui-button icon="cog" :params="{ page: 'controlmode' }">Control Mode</vui-button>
  </div>
</template>

<script>
export default {
  data() {
    return this.$root.$data.state;
  }
};
</script>

<style lang="scss" scoped>
  div {
    display: flex;
    align-items: center;
    flex-direction: column;
  }
</style>