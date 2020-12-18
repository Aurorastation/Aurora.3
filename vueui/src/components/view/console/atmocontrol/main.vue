<template>
  <div>
    <h3>Sensor Data:</h3>
    <vui-group>
      <vui-group-row v-if="state.sensors.length <= 0">No sensors connected.</vui-group-row>
      <template v-else v-for="(sdata, key) in state.sensors">
        <vui-group-row :key="key"><b>{{ sdata.name }}</b></vui-group-row>
        <vui-group-item :key="key" v-if="sdata.pressure" label="Pressure:">{{ sdata.pressure }} kPa</vui-group-item>
        <vui-group-item :key="key" v-if="sdata.temperature" label="Temperature:">{{ sdata.temperature }} K</vui-group-item>
        <vui-group-item :key="key" v-if="sdata.oxygen || sdata.hydrogen || sdata.phoron || sdata.nitrogen || sdata.carbon_dioxide" label="Gas Composition:">
          <span class="complist" v-if="sdata.oxygen">{{ sdata.oxygen }} O<sub>2</sub></span>
          <span class="complist" v-if="sdata.nitrogen">{{ sdata.nitrogen }} N</span>
          <span class="complist" v-if="sdata.carbon_dioxide">{{ sdata.carbon_dioxide }} CO<sub>2<sub/></sub></span>
          <span class="complist" v-if="sdata.phoron">{{ sdata.phoron }} PH</span>
          <span class="complist" v-if="sdata.hydrogen">{{ sdata.hydrogen }} H<sub>2</sub></span>
        </vui-group-item>
      </template>
    </vui-group>
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