<template>
  <div>
    <h1>Control Mode</h1>
    <vui-button icon="cog" :params="{ page: 'elevatorstates' }">Elevator States</vui-button><br>
    <vui-button icon="cog" :params="{ page: 'cabincontrol' }">Cabin Control</vui-button><br>
    <vui-button icon="cog" :params="{ page: 'floorlockout' }">Floor Lockout</vui-button><br>
    <vui-button icon="cog" :params="{ page: 'safetysystem' }">Safety System</vui-button><br>
    <vui-button icon="cog" :params="{ page: 'accesscontrol' }">Access Control</vui-button>
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