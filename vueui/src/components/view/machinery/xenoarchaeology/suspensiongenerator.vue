<template>
  <div>
    <div>
      <h3>Overview</h3>
      <vui-group>
        <vui-group-item label="Cell Charge:"><vui-progress :class="progressClass(charge)" :value="charge">{{ charge }}%</vui-progress></vui-group-item>
        <vui-group-item label="Field Status:">{{ active ? "Active" : "Disabled" }}</vui-group-item>
        <vui-group-item label="Toggle Field:"><vui-button :disabled="locked || !anchored" :params="{togglefield: 1}">{{ locked ? "Toggle Field (Locked)" : anchored ? "Toggle Field" : "Toggle Field (Unanchored)"}}</vui-button></vui-group-item>
      </vui-group>
    </div>
    <div>
      <h3>Field Types:</h3>
      <div v-for="(desc, field) in fieldtypes" :key="field">
        <vui-button :class="{'button' : 1, 'selected' : fieldtype == field}" :params="{ fieldtype: field }">{{ desc }}</vui-button>
      </div>
    </div>
    <footer>Always wear safety gear and consult a field manual before operation.</footer>
  </div>
</template>

<script>
export default {
  data() {
    return this.$root.$data.state;
  },
  methods: {
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
    }
  }
}
</script>