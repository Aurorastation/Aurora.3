<template>
  <div>
    <i>No program loaded. Please select program from list below.</i>
    <div v-for="(p, filename) in programs" :key="filename">
      <vui-button >{{ p.desc }}</vui-button>
      <vui-button v-if="p.running">X</vui-button>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return this.$root.$data.state
  }
}
</script>