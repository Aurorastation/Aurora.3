<template>
  <div>
    <h3>Core Cooling Control System</h3>
    <vui-group>
      <template v-if="s['input']">
        <vui-group-item label="Input:">
          <span v-if="s['input'].power">Injecting</span>
          <span v-else>On Hold</span>&nbsp;
          <vui-button :params="{ in_toggle_injector: 1 }" icon="power-off">Toggle Power</vui-button>
        </vui-group-item>
        <vui-group-item label="Flow Rate Limit:">{{ s['input'].rate }} L/s</vui-group-item>
        <vui-group-item label="Command:">
          <vui-input-numeric
            @keypress.enter="$atc({ in_set_flowrate: setRate })"
            width="3em"
            :button-count="3"
            v-model="setRate"
            :max="s.maxrate"
          />
          <br>
          <vui-button :params="{ in_set_flowrate: setRate }">Set Flow Rate</vui-button>
        </vui-group-item>
      </template>
      <vui-group-row v-else>
        <vui-button :params="{ in_refresh_status: 1 }">Search for input port</vui-button>
      </vui-group-row>

      <template v-if="s['output']">
        <vui-group-item style="margin-top: 2em;" label="Core Outpump:">
          <span v-if="s['output'].power">Open</span>
          <span v-else>On Hold</span>&nbsp;
          <vui-button :params="{ out_toggle_power: 1 }" icon="power-off">Toggle Power</vui-button>
        </vui-group-item>
        <vui-group-item label="Min Core Pressure:">{{ s['output'].pressure }} kPa</vui-group-item>
        <vui-group-item label="Command:">
          <vui-input-numeric
            @keypress.enter="$atc({ out_set_pressure: setPressure })"
            width="5em"
            :button-count="3"
            :decimal-places="2"
            v-model="setPressure"
            :max="s.maxpressure"
          />
          <br>
          <vui-button :params="{ out_set_pressure: setPressure }">Set Pressure</vui-button>
        </vui-group-item>
      </template>
      <vui-group-row v-else>
        <vui-button :params="{ out_refresh_status: 1 }">Search for output port</vui-button>
      </vui-group-row>
    </vui-group>
  </div>
</template>

<script>
export default {
  data() {
    return {
      s: this.$root.$data.state,
      setRate: this.$root.$data.input?.setrate ?? 200,
      setPressure: this.$root.$data.output?.setpressure ?? 5066.25
    }
  }
};
</script>