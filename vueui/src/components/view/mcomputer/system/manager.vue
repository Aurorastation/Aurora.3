<template>
  <div>
    <i>Welcome to NT IT client manager</i><hr>
    <div>This is the Client Management Application of the Nanotrasen IT Department. It is used ensure that the clients comply with the corporate IT policy, enroll new clients and manage clients remotely</div>
    <br>
    <h2>Status</h2>
    <vui-item label="Enrollment Status:">
      <span v-if="enrollment_status == 0">Unconfigured</span>
      <span v-else-if="enrollment_status == 1">Work Device</span>
      <span v-else-if="enrollment_status == 2">Private Device</span>
      <span v-else>Unknown</span>
    </vui-item>
    <template v-if="enrollment_status == 1">
      <vui-item label="Policy Compliance Status:">Compliant</vui-item>
      <vui-item label="Remote Management Status:">Active</vui-item>
    </template>
    <template v-if="enrollment_status == 0">
      <h2>Device Enrollment</h2>
      <vui-item label="Device Type:">
        <vui-button :class="{'selected': device_type == 1}" @click="device_type = 1">Company</vui-button>
        <vui-button :class="{'selected': device_type == 2}" @click="device_type = 2">Private</vui-button>
      </vui-item>
      <vui-item v-if="device_type == 1" label="Device Preset:">
        <vui-button v-for="(preset, id) in presets" :key="id" :class="{'selected': device_preset == id}" @click="device_preset = id">{{preset.name}}</vui-button>
      </vui-item>
      <vui-item label="Enroll Device:">
        <vui-button 
          :disabled="device_type == 0 || (device_type == 1 && device_preset == '') || ntnet_status == 0"
          :params="{enroll: {type: device_type, preset: device_preset}}"
        >Confirm</vui-button>
        <div v-if="ntnet_status == 0" style="color: red;">NTNET unavailable. Unable to enroll device.</div>
      </vui-item>
      
    </template>
  </div>
</template>

<script>
export default {
  data() {
    return this.$root.$data.state
  }
}
</script>