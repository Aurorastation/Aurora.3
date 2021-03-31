<template>
  <div>
    <div v-if="connected_incubator && occupant">
      <vui-button :disabled="!has_nanomachine_cluster" :params="{infuse: 1}">Infuse Cluster</vui-button>
      <div v-if="loaded_programs && loaded_programs.length">
        <span v-for="program in loaded_programs" :key="program">{{ program }}</span>
      </div>
    </div>
    <div v-else>
      <h3>Ruh Roh</h3>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return this.$root.$data.state;
  }
}
</script>