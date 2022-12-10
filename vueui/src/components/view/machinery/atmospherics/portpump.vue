<template>
  <vui-group>
    <vui-group-row><h3>Pump Status</h3></vui-group-row>
    <vui-group-item label="Tank Pressure:">
      {{tankPressure}} kPa
    </vui-group-item>

    <vui-group-item label="Port Status:">
      <span :class="portConnected ? 'good' : 'average'">{{portConnected ? 'Connected' : 'Disconnected'}}</span>
    </vui-group-item>

    <vui-group-item label="Load:">
      {{powerDraw}} W
    </vui-group-item>

    <vui-group-item label="Cell Charge:">
      <vui-progress :value="cellCharge" :min="0" :max="cellMaxCharge"/>
    </vui-group-item>

    <vui-group-row><h3>Holding Tank Status</h3></vui-group-row>
    <vui-group-item v-if="hasHoldingTank" label="Tank Label:">
      {{holdingTank.name}}&nbsp;<vui-button icon="eject" :params="{'remove_tank': 1}">Eject</vui-button>
    </vui-group-item>
    <vui-group-item v-if="hasHoldingTank" label="Tank Pressure:">{{holdingTank.tankPressure}} kPa</vui-group-item>
    <vui-group-row v-else>
      <span class="average"><i>No holding tank inserted.</i></span>
    </vui-group-row>


    <vui-group-row><h3>Power Regulator Status</h3></vui-group-row>
    <vui-group-item label="Target Pressure:">
      <vui-progress :value="targetpressure" :min="minpressure" :max="maxpressure"/>
      <div style="float: left; clear: both; padding-top: 4px; text-align: center;">
        <vui-input-numeric v-model="targetpressure" :min="minpressure" :max="maxpressure" min-button max-button width="4em" :button-count="0" @input="s({pressure_set : targetpressure})"/>
      </div>
    </vui-group-item>

    <vui-group-item label="Power Switch:">
      <vui-button :class="{selected: on}" :icon="on ? 'power-off' : 'times'" :params="{power : 1}">{{on ? 'On' : 'Off'}}</vui-button>
    </vui-group-item>

    <vui-group-item label="Pump Direction:">
      <vui-button icon="share" :flip="pump_dir ? 'horizontal' : ''" :params="{direction : 1}">{{pump_dir ? 'Out' : 'In'}}</vui-button>
    </vui-group-item>
  </vui-group>
</template>

<script>
import Utils from "../../../../utils.js";
export default {
	data() {
		return this.$root.$data.state;
  },
	methods: {
    s(parameters) {
      Utils.sendToTopic(parameters);
    }
	}
}
</script>

<style lang="scss" scoped>
  .item {
    width: 100%;
    margin: 4px 0 0 0;
    clear: both;
  }
</style>
