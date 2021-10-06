<template>
  <div>
    <div v-if="detonating" class="notice" style="color: #000000;">
      <h2 style="color: #000000;">CRYSTAL DELAMINATING</h2>
      <h3 style="color: #000000;">Evacuate area immediately</h3>
      <div class="clearBoth"/>
    </div>
    <vui-group v-else>
      <vui-group-row>
        <h3>Crystal Integrity</h3><!--
        --><vui-progress :value="integrity_percentage" :min="0" :max="100" :class="integrity_class"/><!--
        --><b>{{integrity_percentage}} %</b>
      </vui-group-row>
      <h3>Environment</h3>
      <vui-group-item label="Temperature:">
        <vui-progress :value="ambient_temp" :min="0" :max="10000" :class="temp_class"/>
        {{ambient_temp}} K
      </vui-group-item>
      <vui-group-item label="Pressure:">
        {{ambient_pressure}} kPa
      </vui-group-item>
    </vui-group>
  </div>
</template>

<script>
export default {
  data() {
    return this.$root.$data.state; // Make data more easily accessible
  },
  computed: {
    temp_class() {
      if(this.ambient_temp >= 5000){return "bad"}
      if(this.ambient_temp >= 4000){return "average"}
      return "good";
    },
    integrity_class() {
      if(this.integrity_percentage >= 90){return "good"}
      if(this.integrity_percentage >= 25){return "average"}
      return "bad";
    }
  }
}
</script>
