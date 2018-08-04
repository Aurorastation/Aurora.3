<template>
  <div>
    <h3>Sensor Data:</h3>
    <span v-if="state.sensors.length <= 0">No sensors connected.</span>
    <div v-else v-for="(sdata, key) in state.sensors" :key="key">
      <b>{{ sdata.name }}</b><br>
      <vui-item v-if="sdata.pressure" label="Pressure:">{{ sdata.pressure }} kPa</vui-item>
      <vui-item v-if="sdata.temperature" label="Temperature:">{{ sdata.temperature }} K</vui-item>
      <vui-item v-if="sdata.oxygen || sdata.phoron || sdata.nitrogen || sdata.carbon_dioxide" label="Gas Composition:">
        <span class="complist" v-if="sdata.oxygen">{{ sdata.oxygen }} O<sub>2</sub></span>
        <span class="complist" v-if="sdata.nitrogen">{{ sdata.nitrogen }} N</span>
        <span class="complist" v-if="sdata.carbon_dioxide">{{ sdata.carbon_dioxide }} CO<sub>2<sub/></sub></span>
        <span class="complist" v-if="sdata.phoron">{{ sdata.phoron }} PH</span>
      </vui-item>
    </div>
    <component v-if="state.control" :is="&quot;view-console-atmocontrol-&quot; + state.control"/>
  </div>
</template>


<script>
export default {
  data() {
    return this.$root.$data;
  }
};
</script>

<style lang="scss" scoped>
.complist {
  margin-right: 1em;
}
</style>