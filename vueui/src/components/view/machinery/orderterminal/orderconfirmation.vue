<template>
  <div>
    <h3> Selected Products:</h3>
    <div v-for="(price, name) in items" :key="name">
      <span v-if="buying[name] && buying[name] >= 0">
        {{buying[name] }}x  {{ name }}: at {{ price * buying[name] }} Credits
      </span>
    </div>
    <h3> Total: {{ sum }}</h3>
    <h3>Please swipe your ID to pay.</h3>
    <vui-button :params="{ return: 1 }" width="3em">Return to order menu</vui-button>
  </div>
</template>

<script>
export default {
  data() {
    return this.$root.$data.state;
  },
};
</script>