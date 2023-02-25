<template>
  <div>
    <div v-for="(price, name) in s.items" :key="name" style="clear: both;">
      {{ name }}: {{ price }} Credits
      <div style="float: right;">
        <vui-button :params="{ buy: {name: name, price: price, amount: 1 } }" width="2em">Buy</vui-button>
        <vui-button v-if="s.editmode == 1" :params="{ remove: name }" width="3em">Delete</vui-button>
      </div>
    </div>

    <div v-if="s.editmode == 1">
      <input v-model="tmp_name">
      <vui-input-numeric v-model="tmp_price" width="3em" :button-count="2"/>
      <vui-button :params="{ add: {name: tmp_name, price: tmp_price }}">Add</vui-button>
    </div>
    <vui-button :params="{ locking: 1 }" width="3em">Toggle Lock</vui-button>
    <vui-button :params="{ confirm: buying }">Confirm Selection</vui-button>
    <vui-button :params="{ clear: 1 }">Clear selection</vui-button>

    <h4> Selected Products:</h4>
    <div v-for="(price, name) in s.buying" :key="name" style="clear: both;">
      <span v-if="s.buying[name] && s.buying[name] >= 0">
        {{s.buying[name] }}x  {{ name }}: at {{ price * s.items[name] }} Credits
        <div style="float: right;">
          <vui-button :params="{ removal: {name: name, price: price, amount: 1 }}" width="2em">Remove</vui-button>
        </div>
      </span>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      s: this.$root.$data.state,
      tmp_name: '',
      tmp_price: 0,
    }
  },
}
</script>
