<template>
  <div>
    <div v-if="has_linked_comp">
      <h3>Linked Computer Info</h3>
      <span :class="comp_locked_in ? 'good' : 'bad'">{{ comp_locked_in ? 'Locked In ' : 'Not Locked In ' }}</span><span :class="comp_locked_in ? 'good' : 'bad'">({{ locked_in_name }})</span>
      <h3>Teleporter Beacons</h3>
      <table class="table border">
        <tr class="header border">
          <th>Beacon Name</th>
          <th>Action</th>
        </tr>
        <tr v-for="beacon in teleport_beacons" class="item border" :key="beacon.ref">
          <td>{{ beacon.beacon_name }}</td>
          <td>
            <vui-button :params="{ beacon: beacon.ref, name: beacon.beacon_name }">Lock On</vui-button>
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
            <vui-button :params="{ implant: implant.ref, name: implant.implant_name }">Lock On</vui-button>
          </td>
        </tr>
      </table>
    </div>
    <div v-else>
      <h3>Nearby Teleportation Computers</h3>
      <table class="table border">
        <tr class="header border">
          <th>Name</th>
          <th>Action</th>
        </tr>
        <tr v-for="comp in nearby_comps" class="item border" :key="comp.ref">
          <td>{{ comp.comp_name }}</td>
          <td>
            <vui-button :params="{ comp: comp.ref }">Link</vui-button>
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