<template>
  <div>
    <h3>Tank Status</h3>
    <vui-item label="Tank Label:">
      <div style="float: left; width: 180px;">{{ name }}</div>
      <vui-button icon="pencil" :params="{ relabel: 1 }" :disabled="!canLabel">Relabel</vui-button>
    </vui-item>

    <vui-item label="Tank Pressure:"> {{ tankPressure }} kPa </vui-item>

    <vui-item label="Port Status:">
      <span :class="portConnected ? good : average">{{ portConnected ? 'Connected' : 'Disconnected' }}</span>
    </vui-item>

    <h3>Holding Tank Status</h3>
    <div v-if="hasHoldingTank">
      <vui-item label="Tank Label:">
        <div style="float: left; width: 180px;">{{ holdingTank.name }}</div>
        <vui-button icon="eject" :params="{ remove_tank: 1 }">Eject</vui-button>
      </vui-item>

      <vui-item label="Tank Pressure:"> {{ holdingTank.tankPressure }} kPa </vui-item>
    </div>
    <div v-else>
      <vui-item
        ><span class="average"><i>No holding tank inserted.</i></span></vui-item
      >
      <vui-item>&nbsp;</vui-item>
    </div>

    <h3>Release Valve Status</h3>
    <vui-item label="Release Pressure:">
      <vui-progress :value="releasePressure" :min="minReleasePressure" :max="maxReleasePressure">&nbsp;</vui-progress>
      <div style="clear: both; padding-top: 4px;">
        <vui-input-numeric
          width="80px"
          v-model="releasePressure"
          :button-count="4"
          :min="minReleasePressure"
          :max="maxReleasePressure"
          @input="$atc({ pressure_set: releasePressure })"
          >{{ releasePressure }} kPa&nbsp;</vui-input-numeric
        >
      </div>
    </vui-item>

    <vui-item label="Release Valve:">
      <vui-button icon="unlocked" :params="{ toggle: 1 }" :class="{ selected: valveOpen }">Open</vui-button
      ><vui-button icon="locked" :params="{ toggle: 1 }" :class="{ selected: valveOpen }" />
    </vui-item>
  </div>
</template>

<script>
export default {
  data() {
    return this.$root.$data.state
  },
}
</script>

<style lang="scss" scoped>
.item {
  width: 100%;
  margin: 4px 0 0 0;
  clear: both;
}
</style>
