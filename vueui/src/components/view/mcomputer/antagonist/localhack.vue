<template>
  <div>
    <hr>
    <h3>Local Devices</h3>
    <hr>
    <div>
      <table>
        <tr>
          <th>Device Name</th>
          <th>Location</th>
          <th>Interface</th>
        </tr>
        <tr v-for="hackable in hackables" :key="hackable.ref">
          <td>{{ hackable.name }}</td>
          <td>{{ hackable.location }}</td>
          <td><vui-button :params="{hack: hackable.ref}" icon="eject">Hack</vui-button></td>
        </tr>
      </table>
    </div>
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

  .header, .hackable {
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