<template>
  <div>
    <h3>Sensor Data:</h3>
    <span v-if="state.sensors.length <= 0">No sensors connected.</span>
    <div v-else v-for="(sdata, key) in state.sensors" :key="key">
      <b>{{ sdata.name }}</b><br>
      <vui-item v-if="sdata.pressure" label="Pressure:">{{ sdata.pressure }} kPa</vui-item>
      <vui-item v-if="sdata.temperature" label="Temperature:">{{ sdata.temperature }} K</vui-item>
      <vui-item v-if="sdata.oxygen || sdata.hydrogen || sdata.phoron || sdata.nitrogen || sdata.carbon_dioxide" label="Gas Composition:">
        <span class="complist" v-if="sdata.oxygen">{{ sdata.oxygen }}% O<sub>2</sub></span>
        <span class="complist" v-if="sdata.nitrogen">{{ sdata.nitrogen }}% N</span>
        <span class="complist" v-if="sdata.carbon_dioxide">{{ sdata.carbon_dioxide }}% CO<sub>2<sub/></sub></span>
        <span class="complist" v-if="sdata.phoron">{{ sdata.phoron }}% PH</span>
        <span class="complist" v-if="sdata.hydrogen">{{ sdata.hydrogen }}% H<sub>2</sub></span>
      </vui-item>
    </div>
    <component v-if="state.control" :is="&quot;view-console-atmocontrol-&quot; + state.control"/>
    <div v-if="state['input']">
      <vui-item :balance="0.65" label="Input:">
        <span v-if="state['input'].power">Injecting</span>
        <span v-else>On Hold</span>&nbsp;
        <vui-button :params="{ in_toggle_injector: 1 }" icon="power-off">Toggle Power</vui-button>
      </vui-item>
      <vui-item :balance="0.65" label="Flow Rate Limit:">{{ state['input'].rate }} L/s</vui-item>
      <vui-item :balance="0.65" label="Command:">
        <vui-input-numeric
          @keypress.enter="$toTopic({ in_set_flowrate: state['input'].setrate })"
          width="3em"
          :button-count="3"
          v-model="state['input'].setrate"
          :max="state.maxrate"
        />
        <br >
        <vui-button push-state :params="{ in_set_flowrate: state['input'].setrate }">Set Flow Rate</vui-button>
      </vui-item>
    </div>
    <vui-button v-else :params="{ in_refresh_status: 1 }">Search for input port</vui-button>
    <div style="margin-top: 2em;" v-if="state['output']">
      <vui-item :balance="0.65" label="Output:">
        <span v-if="state['output'].power">Open</span>
        <span v-else>On Hold</span>&nbsp;
        <vui-button :params="{ out_toggle_power: 1 }" icon="power-off">Toggle Power</vui-button>
      </vui-item>
      <vui-item :balance="0.65" label="Max Output Pressure:">{{ state['output'].pressure }} kPa</vui-item>
      <vui-item :balance="0.65" label="Command:">
        <vui-input-numeric
          @keypress.enter="$toTopic({ out_set_pressure: state['output'].setpressure })"
          width="5em"
          :button-count="4"
          :decimal-places="2"
          v-model="state['output'].setpressure"
          :max="state.maxpressure"
        />
        <br >
        <vui-button
          push-state
          :params="{ out_set_pressure: state['output'].setpressure }"
        >Set Pressure</vui-button>
      </vui-item>
    </div>
    <vui-button v-else :params="{ out_refresh_status: 1 }">Search for output port</vui-button>
    <vui-item :balance="0.65" label="Ignition:">
      <vui-button :params="{ fire_igniter: 1 }" icon="alert">Fire</vui-button>
    </vui-item>
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