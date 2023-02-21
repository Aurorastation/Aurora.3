<template>
  <div>
    <h3>Core Cooling Control System</h3>
    <div v-if="state['input']">
      <vui-item label="Input:">
        <span v-if="state['input'].power">Injecting</span>
        <span v-else>On Hold</span>&nbsp;
        <vui-button :params="{ in_toggle_injector: 1 }" icon="power-off">Toggle Power</vui-button>
      </vui-item>
      <vui-item label="Flow Rate Limit:">{{ inputRate }} L/s</vui-item>
      <vui-item label="Command:">
        <vui-input-numeric
          width="3em"
          :button-count="3"
          v-model="inputRate"
          :max="state.maxrate"
        />
        <br>
      </vui-item>
    </div>
    <vui-button v-else :params="{ in_refresh_status: 1 }">Search for input port</vui-button>
    <div style="margin-top: 2em;" v-if="state['output']">
      <vui-item label="Core Outpump:">
        <span v-if="state['output'].power">Open</span>
        <span v-else>On Hold</span>&nbsp;
        <vui-button :params="{ out_toggle_power: 1 }" icon="power-off">Toggle Power</vui-button>
      </vui-item>
      <vui-item label="Min Core Pressure:">{{ outputPressure }} kPa</vui-item>
      <vui-item label="Command:">
        <vui-input-numeric
          width="5em"
          :button-count="3"
          :decimal-places="2"
          v-model="outputPressure"
          :max="state.maxpressure"
        />
        <br>
      </vui-item>
    </div>
    <vui-button v-else :params="{ out_refresh_status: 1 }">Search for output port</vui-button>
  </div>
</template>

<script>
export default {
  data() {
    return this.$root.$data
  },
  computed: {
    inputRate: {
      get() {
        return this.state['input'].setrate
      },
      set(value) {
        this.$toTopic({ in_set_flowrate: value })
      }
    },
    outputPressure: {
      get() {
        return this.state['output'].setpressure
      },
      set(value) {
        this.$toTopic({ out_set_pressure: value })
      }
    }
  },
};
</script>
