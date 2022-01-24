<template>
  <div>
    <i>Welcome to the NanoTrasen™ computer configuration utility.
      Please consult your system administrator if you have any questions about your device.</i><hr>
    <h2>Power Supply</h2>
    <vui-item label="Battery Status:">
      <span v-if="battery">Active</span>
      <span v-else>Not Available</span>
    </vui-item>
    <vui-item v-if="battery" label="Battery Rating:">{{battery.rating}} Wh</vui-item>
    <vui-item v-if="battery" label="Battery Charge:">
      <vui-progress :value="battery.percent">{{battery.percent}}%</vui-progress>
    </vui-item>
    <vui-item label="Power Usage:">{{power_usage}} W</vui-item>
    <h2>File System</h2>
    <vui-item v-if="battery" label="Used Capacity:">
      <vui-progress :value="disk_used" min="0" :max="disk_size">{{disk_used}} GQ / {{disk_size}} GQ</vui-progress>
    </vui-item>
    <h2>Misc. Settings</h2>
    <vui-item label="Registered ID:">
      <vui-button :params="{ PC_register: 1}" :disabled="!card_slot">{{ registered ? registered : "Unregistered" }}</vui-button>
    </vui-item>
    <vui-item v-if="brightness !== null" label="Brightness:">
      <vui-input-slider :min="0" :max="10" v-model="brightness"/>
    </vui-item>
    <vui-item label="Audible Message Output Range:">
      <vui-input-slider :min="0" :max="max_message_range" v-model="message_range"/>
    </vui-item>
    <h2>Computer Components</h2>
    <div v-for="(h, name) in hardware" :key="name">
      <h3>{{name}}</h3>
      <vui-item label="State:">
        <span v-if="h.enabled">Enabled</span>
        <span v-else>Disabled</span>
      </vui-item>
      <vui-item label="Power Usage:" v-if="h.power_usage > 0">{{h.power_usage}} W</vui-item>
      <vui-item v-if="!h.critical" label="Toggle Component:">
        <vui-button :params="{ PC_enable_component: name}" :disabled="!!h.enabled">ON</vui-button>
        <vui-button :params="{ PC_disable_component: name}" :disabled="!h.enabled">OFF</vui-button>
      </vui-item>
    </div>
    <i>ntOS v2.1.0 -- © NanoTrasen 2457 - 2462</i>
  </div>
</template>

<script>
export default {
  data() {
    return this.$root.$data.state
  }
}
</script>