<template>
  <div>
    <h3>Tank Status</h3>
    <vui-group>
      <vui-group-item label="Tank Label:">
        {{name}} <vui-button class="float-right" icon="pencil-alt" :params="{relabel : 1}" :disabled="!canLabel">Relabel</vui-button>
      </vui-group-item>
      <vui-group-item label="Tank Pressure:">
        {{tankPressure}} kPa
      </vui-group-item>
      <vui-group-item label="Port Status:">
        <span :class="portConnected ? good : average">{{portConnected ? "Connected" : "Disconnected"}}</span>
      </vui-group-item>

      <vui-group-row>
        <h3>Holding Tank Status</h3>
      </vui-group-row>
      <template v-if="hasHoldingTank">
        <vui-group-item label="Tank Label:">
          {{holdingTank.name}}<vui-button class="float-right"  icon="eject" :params="{remove_tank : 1}">Eject</vui-button>
        </vui-group-item>

        <vui-group-item label="Tank Pressure:">
          {{holdingTank.tankPressure}} kPa
        </vui-group-item>
      </template>
      <vui-group-item v-else><span class="average"><i>No holding tank inserted.</i></span></vui-group-item>

      <vui-group-row>
        <h3>Release Valve Status</h3>
      </vui-group-row>

      <vui-group-item label="Release Pressure:">
        <vui-progress style="width: 100%;" :value="releasePressure" :min="minReleasePressure" :max="maxReleasePressure"/>
        <div style="clear: both; padding-top: 4px;">
          <vui-input-numeric width="5em" v-model="releasePressure" :button-count="4" :min="minReleasePressure" :max="maxReleasePressure" @input="$toTopic({pressure_set : releasePressure})">{{releasePressure}} kPa&nbsp;</vui-input-numeric>
        </div>
      </vui-group-item>

      <vui-group-item label="Release Valve:">
        <vui-button icon="lock-open" :params="{toggle : 1}" :class="{selected : valveOpen}">Open</vui-button>
        <vui-button icon="lock" :params="{toggle : 1}" :class="{selected : !valveOpen}">Close</vui-button>
      </vui-group-item>
    </vui-group>
  </div>
</template>

<script>
export default {
	data() {
		return this.$root.$data.state;
  }
}
</script>
