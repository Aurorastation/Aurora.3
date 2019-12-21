<template>
  <div>
    <i>No program loaded. Please select program from list below.</i>
    <div v-for="(p, filename) in programs" :key="filename">
      <vui-button :params="{ PC_runprogram: filename}">{{ p.desc }}</vui-button>
      <vui-button :params="{ PC_killprogram: filename}" v-if="p.running">X</vui-button>
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