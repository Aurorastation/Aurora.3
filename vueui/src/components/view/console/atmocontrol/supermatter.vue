<template>
  <div>
    <h3>Core Cooling Control System</h3>
    <div v-if="state['input']">
      <vui-item label="Input:">
        <span v-if="state['input'].power">Injecting</span>
        <span v-else>On Hold</span>&nbsp;
        <vui-button :params="{ in_toggle_injector: 1 }" icon="power-off">Toggle Power</vui-button>
      </vui-item>
      <vui-item label="Flow Rate Limit:">{{ state['input'].rate }} L/s</vui-item>
      <vui-item label="Command:">
        <vui-input-numeric width="3em" :button-count="3" v-model="state['input'].setrate" :max="state.maxrate"/><br>
        <vui-button push-state :params="{ in_set_flowrate: state['input'].setrate }">Set Flow Rate</vui-button>
      </vui-item>
    </div>
    <vui-button v-else :params="{ in_refresh_status: 1 }">Search for input port</vui-button>
    <div style="margin-top: 2em;" v-if="state['output']">
      <vui-item label="Core Outpump:">
        <span v-if="state['output'].power">Open</span>
        <span v-else>On Hold</span>&nbsp;
        <vui-button :params="{ out_toggle_power: 1 }" icon="power-off">Toggle Power</vui-button>
      </vui-item>
      <vui-item label="Min Core Pressure:">{{ state['output'].pressure }} kPa</vui-item>
      <vui-item label="Command:">
        <vui-input-numeric width="5em" :button-count="3" :decimal-places="2" v-model="state['output'].setpressure" :max="state.maxpressure"/><br>
        <vui-button push-state :params="{ out_set_pressure: state['output'].setpressure }">Set Pressure</vui-button>
      </vui-item>
    </div>
    <vui-button v-else :params="{ out_refresh_status: 1 }">Search for output port</vui-button>
  </div>
</template>

<script>
export default {
  data() {
    return this.$root.$data;
  }
};
</script>