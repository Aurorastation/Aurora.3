<template>
  <div>
    <div v-for="(price, name) in s.items" :key="name" style="clear: both;">
      {{ name }}: {{ price }} Credits
      <div style="float: right;">
        <vui-input-numeric @input="setSelection(name, $event)" :value="getSelection(name)" width="2em"/>
        <vui-button v-if="s.editmode == 1" :params="{ remove: name }" width="3em">Delete</vui-button>
      </div>
    </div>

    <div v-if="s.editmode == 1">
      <input v-model="tmp_name">
      <vui-input-numeric v-model="tmp_price" width="3em" :button-count="2"/>
      <vui-button :params="{ add: {name: tmp_name, price: tmp_price }}">Add</vui-button>
      <vui-button :params="{ accountselect: 1 }" width="3em">Select Destination Account</vui-button>
    </div>
    <vui-button :params="{ locking: 1 }" width="3em">Toggle Lock</vui-button>
    <vui-button :params="{ confirm: selection }">Confirm Selection</vui-button>

  </div>
</template>

<script>
export default {
  data() {
    return {
      s: this.$root.$data.state,
      selection: {},
      tmp_name: '',
      tmp_price: 0,
    }
  },
  methods: {
    getSelection(name) {
      return this.selection[name] || 0
    },
    setSelection(name, value) {
      this.$set(this.selection, name, value)
    },
  }
}
</script>
