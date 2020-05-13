<template>
  <div>
    <h2 v-if="services.length">Programs</h2>
    <i>No program loaded. Please select program from list below.</i>
    <div v-for="p in displayed_programs" :key="p.filename">
      <vui-button :params="{ PC_runprogram: p.filename}">{{ p.desc }}</vui-button>
      <vui-button :params="{ PC_killprogram: p.filename}" v-if="p.running">X</vui-button>
    </div>
    <h2 v-if="services.length">Services</h2>
    <div v-for="p in services" :key="p.filename">
      <vui-button :class="{ on: p.service.enabled }" :params="{ PC_toggleservice: p.filename}">{{ p.desc }}</vui-button>
      <i v-if="p.service.online">Running</i>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return this.$root.$data.state
  },
  computed: {
    services() {
      var entries = Object.entries(this.programs)
        .filter(([, value]) => value.type & 2)
        .map(([key, value]) => {
          value.filename = key
          return value
        })
      return entries
    },
    displayed_programs() {
      var entries = Object.entries(this.programs)
        .filter(([, value]) => value.type & 1)
        .map(([key, value]) => {
          value.filename = key
          return value
        })
      return entries
    }
  }
}
</script>