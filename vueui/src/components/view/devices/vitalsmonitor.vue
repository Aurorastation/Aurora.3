<template>
  <div>
    <h3>Patient Vitals:</h3>
    <template v-if="has_occupant">
      <vui-group>
        <vui-group-item label="Status:"><span :style="{color:consciousnessLabel(stat)}">{{ consciousnessText(stat) }}</span></vui-group-item>
        <vui-group-item label="Brain Activity:"><vui-progress :class="progressClass(brain_activity)" :value="brain_activity">{{brain_activity}}%</vui-progress></vui-group-item>
        <vui-group-item label="BP:" :style="{color:getPressureClass(blood_pressure_level)}">{{blood_pressure}}</vui-group-item>
        <vui-group-item label="Blood Oxygenation:"><vui-progress :class="progressClass(brain_activity)" :value="Math.round(blood_o2)">{{Math.round(blood_o2)}}%</vui-progress></vui-group-item>
        <vui-group-item label="Blood Volume:"><vui-progress :class="progressClass(brain_activity)" :value="Math.round(blood_volume)">{{Math.round(blood_volume)}}%</vui-progress></vui-group-item>
      </vui-group>
    </template>
    <template v-else>
      <span class="bad">No patient detected.</span>
    </template>
  </div>
</template>

<script>
export default {
  data() {
    return this.$root.$data.state;
  },
  methods: {
    consciousnessLabel(value) {
      switch (value) {
        case 0:
          return "LimeGreen"
        case 1:
          return "OrangeRed"
        case 2:
          return "Crimson"
      }
    },
    consciousnessText(value) {
      switch (value) {
        case 0:
          return "Conscious"
        case 1:
          return "Unconscious"
        case 2:
          return "DEAD"
      }
    },
    progressClass(value) {
      if (value <= 50) {
        return "bad"
      }
      else if (value <= 90) {
        return "average"
      }
      else {
        return "good"
      }
    },
    getPressureClass(tpressure) {
      switch (tpressure) {
        case 1:
          return "Crimson"
        case 2:
          return "LimeGreen"
        case 3:
          return "LawnGreen"
        case 4:
          return "Crimson"
        default:
          return "LightSkyBlue"
      }
    }
  }
};
</script>
