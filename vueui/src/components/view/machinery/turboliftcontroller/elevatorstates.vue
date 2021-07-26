<template>
  <div>
    <h1>Elevator States</h1>
    <table>
      <tr>
        <th></th>
        <th>External Doors</th>
        <th>Status</th>
      </tr>
      <tr v-for="(data,index) in floor_data" :key="index">
        <td>{{ index }}</td>
        <td>{{ data[0] }}</td>
        <td>{{ data[1] }}</td>
      </tr>
    </table>
    <span>Hardware Status: {{ hardware_status }}</span><br>
    <vui-button icon="cog" :params="{ page: 'controlmode' }">Control Mode</vui-button>
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
  div {
    display: flex;
    align-items: center;
    flex-direction: column;
  }
  table {
    text-align: center;
    border-collapse: collapse;
  }
  td {
    border: 1px solid #7b7a7a;
    padding: 5px;
  }
</style>