<template>
  <div>
    <vui-group v-if="read">
      <vui-group-item label="Pressure:">
        {{ press.toFixed(1) }}
      </vui-group-item>
      <vui-group-item label="Temperature:">
        {{ temp.toFixed(1) }} K ({{ tempC.toFixed(1) }}&deg;C)
      </vui-group-item>
      <vui-group-item label="Gases:">
        <span class="complist" v-if="gas.oxygen">{{ gas.oxygen.toFixed(2) }} O<sub>2</sub></span>
        <span class="complist" v-if="gas.nitrogen">{{ gas.nitrogen.toFixed(2) }} N</span>
        <span class="complist" v-if="gas.carbon_dioxide">{{ gas.carbon_dioxide.toFixed(2) }} CO<sub>2<sub/></sub></span>
        <span class="complist" v-if="gas.phoron">{{ gas.phoron.toFixed(2) }} PH</span>
        <span class="complist" v-if="gas.sleeping_agent">{{ gas.sleeping_agent.toFixed(2) }} SA</span>
      </vui-group-item>
    </vui-group>
    <span v-else class="bad">Unable to obtain air reading!</span>
  </div>
</template>

<script>
export default {
  data() {
    return this.$root.$data.state;
  }
}
</script>

<style lang="scss" scoped>
.complist {
  margin-right: 1em;
}
</style>