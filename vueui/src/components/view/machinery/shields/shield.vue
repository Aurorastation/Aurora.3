<template>
  <div>
    <div v-if="multi_unlocked == 1">
      <vui-button :params="{ ztoggle: 1 }" width="3em">Toggle Lock</vui-button>
    </div>
    <div style="clear: both;">
      <div v-if="time_since_fail >= 2">
        {{ "Field Status" }}: {{ price }} Credits
        Field Status: Stable
      </div>
      <div v-if="time_since_fail < 2">
        Field Status: Unstable
      </div>
    </div>


    <vui-group-item label="Coverage Radius (restart required):">
        <vui-progress style="width: 100%;" :value="coverageRadius" :min="mincoverageRadius" :max="maxcoverageRadius"/>
        <div style="clear: both; padding-top: 4px;">
          <vui-input-numeric width="5em" v-model="coverageRadius" :button-count="4" :min="minRcoverageRadius" :max="maxcoverageRadius" @input="$toTopic({pressure_set : coverageRadius})">{{coverageRadius}} </vui-input-numeric>
        </div>
    </vui-group-item>

    <vui-group-item label="Charge Rate">
        <vui-progress style="width: 100%;" :value="coverageRadius" :min="mincoverageRadius" :max="maxcoverageRadius"/>
        <div style="clear: both; padding-top: 4px;">
          <vui-input-numeric width="5em" v-model="coverageRadius" :button-count="4" :min="minRcoverageRadius" :max="maxcoverageRadius" @input="$toTopic({pressure_set : coverageRadius})">{{coverageRadius}} </vui-input-numeric>
        </div>
    </vui-group-item>
    <vui-input-numeric v-model="strengthen_rate" width="3em" :button-count="1" :min="0.1" :max="max_strengthen_rate"/>

    <div v-for="(price, name) in items" :key="name" style="clear: both;">
      {{ name }}: {{ price }} Credits
      <div style="float: right;">
        <vui-button :params="{ buy: {name: name, price: price, amount: 1 } }" width="2em">Buy</vui-button>
        <vui-button v-if="editmode == 1" :params="{ remove: name }" width="3em">Delete</vui-button>
      </div>
    </div>

    
    <vui-button :params="{ locking: 1 }" width="3em">Toggle Lock</vui-button>
    <vui-button :params="{ confirm: buying }">Confirm Selection</vui-button>
    <vui-button :params="{ clear: 1 }">Clear selection</vui-button>

    <h4> Selected Products:</h4>
    <div v-for="(price, name) in buying" :key="name" style="clear: both;">
      <span v-if="buying[name] && buying[name] >= 0">
        {{buying[name] }}x  {{ name }}: at {{ price * items[name] }} Credits
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
    return this.$root.$data.state;
  }
}
</script>