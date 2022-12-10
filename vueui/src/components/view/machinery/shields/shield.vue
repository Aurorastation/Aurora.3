<template>
  <div>
    <vui-group>
      <vui-group-item label="Capacitator status:">
        <span :class="owned_capacitor ? good : 'red'">{{owned_capacitor ? "Charge capacitor connected" : "Unable to locate charge capacitor"}}</span>
      </vui-group-item>

      <vui-group-item label="This generator is:">
        <span :class="active ? 'green' : 'red'">{{active ? "Online" : "Offline"}}</span> <vui-button class="float-right" icon="" :params="{toggle : 1}">Toggle</vui-button>
      </vui-group-item>

      <vui-group-item v-if="multi_unlocked" label="Multi-level Shields:">
        <span :class="multiz ? 'green' : 'red'">{{multiz ? "Online" : "Offline"}}</span> <vui-button class="float-right" icon="" :params="{multiz : 1}">Toggle</vui-button>
      </vui-group-item>

      <vui-group-item label="Field Status:">
        <span :class="time_since_fail > 2 ? 'green' : 'red'">{{time_since_fail > 2 ? "Stable" : "Unstable"}}</span>
      </vui-group-item>

      <vui-group-item label="Overall Field Strength:">
        <span :class="average">{{ average_field }} Renwick ({{ progress_field }}%)</span>
      </vui-group-item>

      <vui-group-item label="Upkeep Power:">
        <span :class="average">{{ power_take }} W</span>
      </vui-group-item>

      <vui-group-item label="Shield Generation Power:">
        <span :class="average">{{ shield_power }} W</span>
      </vui-group-item>

      <vui-group-item label="Coverage Radius (restart required):">
        <div style="clear: both; padding-top: 4px;">
          <vui-input-numeric width="5em" v-model="field_radius" :button-count="2" :min="min_field_radius" :max="max_field_radius" @input="$toTopic({size_set : field_radius})">{{field_radius}} M&nbsp;</vui-input-numeric>
        </div>
      </vui-group-item>

      <vui-group-item label="Charge Rate:">
        <div style="clear: both; padding-top: 4px;">
          <vui-input-numeric width="5em" v-model="strengthen_rate" :button-count="1" :min="1" :max="max_strengthen_rate" @input="$toTopic({charge_set : strengthen_rate})">{{strengthen_rate}} Renwick&nbsp;</vui-input-numeric>
        </div>
      </vui-group-item>

      <vui-group-item label="Maximum Field strength:">
        <div style="clear: both; padding-top: 4px;">
          <vui-input-numeric width="5em" v-model="target_field_strength" :button-count="2" :min="1" :max="10" @input="$toTopic({field_set : target_field_strength})">{{target_field_strength}} &nbsp;</vui-input-numeric>
        </div>
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