<template>
  <div>
    <h3>Shuttle Status</h3>
    <vui-group>
      <vui-group-item label="Status:">{{ shuttle_status }}</vui-group-item>
      <vui-group-item label="Engines:">{{ engine_status }}</vui-group-item>
      <vui-group-item v-if="has_docking" label="Docking:">{{ docking_status }}</vui-group-item>
      <vui-group-item label="Cloaking:">{{ cloak_status }}</vui-group-item>
    </vui-group>
    <h3>Shuttle Control</h3>
    <vui-item label="Current Destination:">
      <select v-model="$root.$data.state.current_destination" class="button">
        <option v-for="des in destinations" :key="des" :value="des">{{ des }}</option>
      </select>
      <vui-button :params="{ set_destination: 1 }">Lock Destination</vui-button>
    </vui-item>
    <vui-button :disabled="!can_launch" :params="{ move: 1 }">Launch Shuttle</vui-button>
    <vui-button :disabled="!can_cancel" :params="{ cancel: 1 }">Cancel Launch</vui-button>
    <vui-button class="red" :disabled="!can_force" :params="{ force: 1 }">Force Launch</vui-button>
    <vui-button class="red" :params="{ toggle_cloaked: 1 }">Toggle Cloaking</vui-button>
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
vui-group, .docking_controls {
  background-color: rgba(0, 0, 0, 0.4);
  border: 2px solid RoyalBlue;
  border-radius: 0.15em;
  width: 100%;
}
</style>