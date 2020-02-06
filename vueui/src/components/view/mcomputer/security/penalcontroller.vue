<template>
  <div>
    <hr>
    <h3>Remote Penal Mechs</h3>
    <hr>
    <div>
      <table>
        <tr>
          <th>Pilot</th>
          <th>Mech Type</th>
          <th>Location</th>
          <th>Camera</th>
          <th>Lockdown</th>
          <th>End Connection</th>
        </tr>
        <tr v-for="mech in mechs" :key="mech.ref">
          <td>
            <template v-if="mech.pilot"><vui-button :params="{message_pilot: mech.ref}">{{ mech.pilot }}</vui-button></template>
            <template v-else><span class="red">n/a</span></template>
          </td>
          <td>{{ mech.name }}</td>
          <td>{{ mech.location }}</td>
          <td><vui-button :class="{'selected': current_cam_loc == mech.ref}" :params="{track_mech: mech.ref}" :disabled="!mech.camera_status">Track</vui-button></td>
          <td><vui-button :class="{'red': mech.lockdown}" :params="{lockdown_mech: mech.ref}">Lockdown</vui-button></td>
          <td><vui-button :params="{terminate: mech.ref}" icon="eject">Terminate</vui-button></td>
        </tr>
      </table>
    </div>
    <hr>
    <h3>Remote Penal Cyborgs</h3>
    <hr>
    <table>
      <tr>
        <th>Pilot</th>
        <th>Robot Type</th>
        <th>Location</th>
        <th>End Connection</th>
      </tr>
      <tr v-for="robot in robots" :key="robot.ref">
        <td>
          <template v-if="robot.pilot"><vui-button :params="{message_pilot: robot.ref}">{{ robot.pilot }}</vui-button></template>
          <template v-else><span class="red">n/a</span></template>
        </td>
        <td>{{ robot.name }}</td>
        <td>{{ robot.location }}</td>
        <td><vui-button :params="{terminate: robot.ref}" icon="eject">Terminate</vui-button></td>
      </tr>
    </table>
  </div>
</template>

<script>
export default {
  data() {
    return this.$root.$data.state
  }
}
</script>

<style lang="scss" scoped>
.table {
  display: table;
  width: 100%;

  .header, .mech, .cyborg {
    display: table-row;
    font-weight: bold;
    width: 20%;
    .header-item, .item {
      display: table-cell;
      padding: 1px;
      vertical-align: middle;
      font-weight: normal;
    }
  }
}

.center {
  text-align: center;
}
</style>