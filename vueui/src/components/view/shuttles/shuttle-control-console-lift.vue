<template>
  <div>
    <h3>Lift Status</h3>
    <div class="docking_controls">
      <vui-item label="Status:">{{ engine_status }}</vui-item>
    </div>
    <h3>Lift Controls</h3>
    <vui-button :disabled="!can_launch" :params="{ move: 1 }">Move Lift</vui-button>
    <vui-button :disabled="!can_cancel" :params="{ cancel: 1 }">Stop Lift</vui-button>
  </div>
</template>

<script>
export default {
  data() {
    return this.$root.$data.state;
  }
}
</script>