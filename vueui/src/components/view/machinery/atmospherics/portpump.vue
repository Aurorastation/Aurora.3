<template>
  <div>
    <h3>Pump Status</h3>
    <vui-item label="Tank Pressure:">
      {{tankPressure}} kPa
    </vui-item>

    <vui-item label="Port Status:">
      <span :class="portConnected ? good : average">{{portConnected ? 'Connected' : 'Disconnected'}}</span>
    </vui-item>

    <vui-item label="Load:">
      {{powerDraw}} W
    </vui-item>

    <vui-item label="Cell Charge:">
      <vui-progress :value="cellCharge" :min="0" :max="cellMaxCharge"/>
    </vui-item>

    <h3>Holding Tank Status</h3>
    <div v-if="hasHoldingTank">
      <vui-item label="Tank Label:">
        <div style="float: left; width: 180px;">{{holdingTank.name}}</div> {{helper.link('Eject', 'eject', {'remove_tank' : 1})}}
      </vui-item>

      <vui-item label="Tank Pressure:">
        {{holdingTank.tankPressure}} kPa
      </vui-item>
    </div>
    <div v-else>
      <div class="item"><span class="average"><i>No holding tank inserted.</i></span></div>
      <div class="item">&nbsp;</div>
    </div>


    <h3>Power Regulator Status</h3>
    <vui-item label="Target Pressure:">
      <vui-progress :value="targetpressure" :min="minpressure" :max="maxpressure"/>
      <div style="float: left; clear: both; padding-top: 4px; text-align: center;">
        <vui-input-numeric v-model="targetPressure" :min="minpressure" :max="maxpressure" width="80px" :button-count="4" @input="s({pressure_set : targetPressure})">
          &nbsp;{{targetpressure}} kPa&nbsp;
        </vui-input-numeric>
      </div>
    </vui-item>

    <vui-item label="Power Switch:">
      <vui-button :icon="on ? 'lock-open' : 'lock'" :params="{power : 1}">
        {{on ? 'On' : 'Off'}}
      </vui-button>
    </vui-item>

    <vui-item label="Pump Direction:">
      <vui-button :icon="pump_dir ? 'arrowreturn-1-e' : 'arrowreturn-1-w'" :params="{direction : 1}">
        {{pump_dir ? 'Out' : 'In'}}
      </vui-button>
    </vui-item>
  </div>
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

<style lang="scss">
  .item {
    width: 100%;
    margin: 4px 0 0 0;
    clear: both;
  }
</style>
