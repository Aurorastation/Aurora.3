<template>
  <div>
    <div v-for="(price, name) in items" :key="name">
      <span v-if="selection[name] && selection[name] > 0">
        {{ name }} ({{price}}x{{selection[name] }}): {{ price * selection[name] }}
      </span>
    </div>
    <vui-button :params="{ return: 1 }" width="3em">Return to order menu</vui-button>
    <h2> Total: {{ priceSum }}</h2>

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
      return Object.keys(this.selection).reduce((sum, name) => {
  if(isNaN(sum)){
    return (this.items[name] * this.selection[name])
}
return sum + (this.items[name] * this.selection[name])
      })
    }
  }
};
</script>