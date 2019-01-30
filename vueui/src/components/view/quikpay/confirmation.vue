<template>
  <div>
    <h3> Selected Products:</h3>
    <div v-for="(price, name) in items" :key="name">
      <span v-if="selection[name] && selection[name] > 0">
        {{selection[name] }}x  {{ name }}: at {{ price * selection[name] }} Credits
      </span>
    </div>
    <h3> Total: {{ priceSum }}</h3>
    <h4>Destination Account: {{ destinationact }}</h4>
    <h3>Please swipe your ID to pay.</h3>
    <vui-button :params="{ return: 1 }" width="3em">Return to order menu</vui-button>
  </div>
</template>

<script>
export default {
  data() {
    return this.$root.$data.state;
  },
  computed: {
    priceSum()  {
      return Object.keys(this.selection).reduce((sum, name) => {
        if(isNaN(sum)) {
          return (this.items[name] * this.selection[name])
        }
        return sum + (this.items[name] * this.selection[name])
      })
    }
  }
};
</script>