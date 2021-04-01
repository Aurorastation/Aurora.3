<template>
  <div>
    <div v-if="connected_incubator && occupant">
      <vui-button :disabled="!has_nanomachine_cluster" :params="{infuse: 1}">Infuse Cluster</vui-button>
      <div v-if="loaded_programs && loaded_programs.length">
        <span class="program" v-for="program in loaded_programs" :key="program">{{ program }}</span>
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

<style lang="scss" scoped>
.program {
  border-radius: 5px;
  border: 1px solid #009141;
  background-color: #01ac4e;
  margin-right: 5px;
  padding: 2px;
}
</style>