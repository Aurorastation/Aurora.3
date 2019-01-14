<template>
  <div>
    <div v-for="(price, name) in items" :key="name">
      <span v-if="selection[name] && selection[name] > 0">
        {{ name }} ({{price}}x{{selection[name] }}): {{ price * selection[name] }}
      </span>
    </div>
    <h3>Please swipe your ID to pay.</h3>
  </div>
</template>

<script>
export default {
  data() {
    return this.$root.$data.state;
  },
  computed: {
    priceSum() {
      return Object.keys(selection).reduce((sum, name) => {
        return sum + (items[name] * selection[name])
      })
    }
  }
};
</script>