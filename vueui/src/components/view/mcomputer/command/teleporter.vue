<template>
  <div>
    <div v-if="has_linked_pad">
      <h3>Linked Pad Info</h3>
      <span :class="selected_target ? 'good' : 'bad'">{{ selected_target ? 'Locked In ' : 'Not Locked In ' }}</span><span :class="selected_target ? 'good' : 'bad'">({{ selected_target_name }})</span>
      <br><span>Calibration: {{calibration}}%</span> <vui-button :params="{ recalibrate: 1 }">Recalibrate</vui-button>
      <h3>Teleporter Beacons</h3>
      <table class="table border">
        <tr class="header border">
          <th>Beacon Name</th>
          <th>Action</th>
        </tr>
        <tr v-for="beacon in teleport_beacons" class="item border" :key="beacon.ref">
          <td>{{ beacon.beacon_name }}</td>
          <td>
            <vui-button :class="{ 'danger' : selected_target == beacon.ref }" :params="{ beacon: beacon.ref, name: beacon.beacon_name }">{{selected_target == beacon.ref ? "Unset" : "Lock On"}}</vui-button>
          </td>
        </tr>
      </table>
      <h3>Tracking Implants</h3>
      <table class="table border">
        <tr class="header border">
          <th>Implant Name</th>
          <th>Action</th>
        </tr>
        <tr v-for="implant in teleport_implants" class="item border" :key="implant.ref">
          <td>{{ implant.implant_name }}</td>
          <td>
            <vui-button :class="{ 'danger' : selected_target == implant.ref}" :params="{ implant: implant.ref, name: implant.implant_name }">{{selected_target == implant.ref ? "Unset" : "Lock On"}}</vui-button>
          </td>
        </tr>
      </table>
    </div>
    <div v-else>
      <h3>Nearby Teleportation Pads</h3>
      <table class="table border">
        <tr class="header border">
          <th>Name</th>
          <th>Action</th>
        </tr>
        <tr v-for="pad in nearby_pads" class="item border" :key="pad.ref">
          <td>{{ pad.pad_name }}</td>
          <td>
            <vui-button :params="{ pad: pad.ref }">Link</vui-button>
          </td>
        </tr>
      </table>
    </div>
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
table {
  width: 100%;
  text-align: center;
}
tr {
  line-height: 135%;
}
</style>
