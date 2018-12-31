<template>
  <div>
    <p>{{ data }}</p>
    <vui-button :params="{ action: 'test', data: 'This is from ui.' }">Call topic</vui-button>
    <vui-button @click="data++">Increase Charge Ammount</vui-button>
    <vui-button @click="data--">Decrease Charge Ammount</vui-button>
  </div>
</template>

<script>
export default {
  data() {
    return this.$root.$data.state; // Make data more easily accessible
  }
};
</script>

<style lang="scss" scoped>
p {
  font-size: 3em;
}
</style>