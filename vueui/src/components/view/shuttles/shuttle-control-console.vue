<template>
  <div>
    <h3>Shuttle Status</h3>
    <vui-group>
      <vui-group-item label="Status:">{{ shuttle_status }}</vui-group-item>
      <vui-group-item label="Engines:">{{ engine_status }}</vui-group-item>
      <vui-group-item v-if="has_docking" label="Docking:">{{ docking_status }}</vui-group-item>
    </vui-group>

    <h3>Shuttle Control</h3>
    <vui-button :disabled="!can_launch" :params="{ move: 1 }">Launch Shuttle</vui-button>
    <vui-button :disabled="!can_cancel" :params="{ cancel: 1 }">Cancel Launch</vui-button>
    <vui-button class="red" :disabled="!can_force" :params="{ force: 1 }">Force Launch</vui-button>
  </div>
</template>

<script>
export default {
  data() {
    return this.$root.$data.state;
  }
}
</script>