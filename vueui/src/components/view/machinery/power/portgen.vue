<template>
  <div>
    <h3>Status</h3>
    <vui-group>
      <vui-group-item label="Generator Status:">
        <span v-if="active" class="good">Online</span>
        <span v-else class="average">Offline</span>
      </vui-group-item>
      <vui-group-item label="Generator Control:">
        <vui-button v-if="active" :params="{action: 'disable'}" icon="power-off">STOP</vui-button>
        <vui-button v-else :params="{action: 'enable'}" :disabled="!!is_broken" icon="power-off">START</vui-button>
      </vui-group-item>
    </vui-group>

    <h3>Fuel</h3>
    <vui-group>
      <vui-group-item label="Fuel Type:">{{ fuel.fuel_type }}</vui-group-item>
      <vui-group-item label="Fuel Level:">
        <vui-progress :value="fuel.fuel_stored" :max="fuel.fuel_capacity">{{ Math.round(fuel.fuel_stored / fuel.fuel_capacity * 100)}}%</vui-progress>
      </vui-group-item>
      <vui-group-item :class="{ 'bad': fuel.fuel_stored == 0, 'good': fuel.fuel_stored > 0 }">{{ fuel.fuel_stored }} cm³ / {{ fuel.fuel_capacity }} cm³</vui-group-item>
      <vui-group-item v-if="(fuel.fuel_usage > 0) && active" label="Fuel Usage:">{{ fuel.fuel_usage }} cm³/s - ({{ Math.round(fuel.fuel_stored / fuel.fuel_usage) }} s remaining)</vui-group-item>
      <vui-group-item label="Control:">
        <vui-button :params="{action: 'eject'}" :disabled="!!(is_broken || is_ai)" icon="eject">EJECT FUEL</vui-button>
      </vui-group-item>
    </vui-group>

    <h3>Output</h3>
    <vui-group>
      <vui-group-item label="Power Setting:">
        <span :class="{ 'bad': output_set > output_safe, 'good': output_set <= output_safe }">{{output_set}} / {{output_max}} ({{output_watts}} W)</span>
      </vui-group-item>
      <vui-group-item label="Control:">
        <vui-button :params="{action: 'higher_power'}" :disabled="output_set == output_max">+</vui-button>
        <vui-button :params="{action: 'lower_power'}" :disabled="output_set == output_min">-</vui-button>
      </vui-group-item>
    </vui-group>

    <h3>Temperature</h3>
    <vui-group>
      <vui-group-item label="Temperature:">
        <vui-progress :value="temperature_current" :min="temperature_min" :max="temperature_max * 1.5" :class="getTemperatureClass(temperature_current)">{{ Math.max(temperature_min, temperature_current) }}C</vui-progress>
      </vui-group-item>
      <vui-group-item label="Generator Status:">
        <span v-if="temperature_overheat > 50" class="bad">DANGER: CRITICAL OVERHEAT! Deactivate generator immediately!</span>
        <span v-else-if="temperature_overheat > 20" class="average">WARNING: Overheating!</span>
        <span v-else-if="temperature_overheat > 1" class="average">Temperature High</span>
        <span v-else class="good">Optimal</span>
      </vui-group-item>
    </vui-group>

    <div v-if="uses_coolant">
      <h3>Coolant</h3>
      <vui-group>
        <vui-group-item label="Coolant:">
          <vui-progress :value="coolant_stored" :max="coolant_capacity">{{ Math.round(coolant_stored / coolant_capacity * 100)}}%</vui-progress>
        </vui-group-item>
      </vui-group>
    </div>
  </div>
</template>


<script>
export default {
  data() {
    return this.$root.$data.state; // Make data more easily accessible
  },
  methods: {
    getTemperatureClass(current) {
      if(current < (this.$root.$data.state.temperature_max * 0.8))
        return "good"
      else if(current < this.$root.$data.state.temperature_max)
        return "average"
      else
        return "bad"
    }
  }
}
</script>