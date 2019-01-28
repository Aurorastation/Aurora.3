<template>
  <div>
    <div v-for="(price, name) in items" :key="name" style="clear: both;">
      {{ name }}: {{ price }}
      <div style="float: right;">
        <vui-input-numeric v-model="selection[name]" width="2em"/>
        <vui-button v-if="editmode == 1" :params="{ remove: name }" width="3em">Delete</vui-button>
      </div>
    </div>

    <div v-if="editmode == 1">
      <input v-model="tmp_name">
      <vui-input-numeric v-model="tmp_price" width="3em" :button-count="2"/>
      <vui-button :params="{ add: {name: tmp_name, price: tmp_price }}">Add</vui-button>
    </div>

    <vui-button :params="{ confirm: selection }">Confirm Selection</vui-button>
  </div>
</template>

<script>
export default {
  data() {
    return this.$root.$data.state;
  }
};
</script>