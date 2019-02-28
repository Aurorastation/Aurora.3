<template>
  <div>
    <h3>Fuel Injection System</h3>
    <template v-if="state['device']">
      <vui-item label="Input:">
        <span v-if="state.device.power">Injecting</span>
        <span v-else>On Hold</span>
        <vui-button :params="{ in_toggle_injector: 1 }">Toggle Power</vui-button>
      </vui-item>
      <vui-item label="Rate:">{{ state.device.rate }} L/s</vui-item>
      <vui-item label="Automated Fuel Injection:">
        <vui-button v-if="state.device.automation" :params="{ toggle_automation: 1 }">Engaged</vui-button>
        <vui-button v-else :params="{ toggle_automation: 1 }">Disengaged</vui-button>
      </vui-item>
      <vui-item label="Inject:">
        <template v-if="state.device.automation">
          Controls Locked Out
        </template>
        <template v-else>
          <vui-button :params="{ toggle_injector: 1 }" icon="power-off">Toggle Power</vui-button>
          <vui-button :params="{ injection: 1 }">Inject (1 Cycle)</vui-button>
        </template>
      </vui-item>
    </template>
    <vui-button v-else :params="{ in_refresh_status: 1 }">Search for device</vui-button>
  </div>
</template>

<script>
export default {
  data() {
    return this.$root.$data;
  }
};
</script>