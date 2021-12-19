<template>
  <div>
    <h3>Smart Track</h3>
    <vui-button :disabled="has_selected_io == true" :class="{'button': 1, 'selected': tracking_apc}" :params="{track_apc: 1}">{{ has_selected_io ? "Toggle APC Smart Tracking (I/O in Buffer)" : "Toggle APC Smart Tracking" }}</vui-button> <vui-tooltip label="?">Enabling this will update the multitool's icon to point in the direction of the nearest APC <i>within your area</i>.</vui-tooltip>
    <h3>Circuit Input/Output</h3>
    <vui-group>
      <vui-group-item label="I/O Name:">{{ selected_io_name }}</vui-group-item>
      <vui-group-item label="I/O Type:">{{ selected_io_name }}</vui-group-item>
    </vui-group>
    <vui-button :disabled="!has_selected_io" :class="{'danger': has_selected_io}" :params="{clear_io: 1}">{{ has_selected_io ? "Clear I/O" : "No I/O in Buffer" }}</vui-button> <vui-tooltip label="?">The I/O Buffer refers to the input/output wires of integrated circuits, which can be wired up using a multitool.</vui-tooltip>
  </div>
</template>

<script>
export default {
  data() {
    return this.$root.$data.state;
  }
};
</script>

<style lang="scss" scoped>
.itemContent {
  text-transform: capitalize;
}
</style>