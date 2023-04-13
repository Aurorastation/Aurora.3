<template>
  <!-- {{if data.connected_name}}
    <h3>
      Connected to network: {{:data.connected_name}}
    </h3>
  {{else}}
    <h3>
      Connected to network: ???
    </h3>
    {{:helper.link('Reconnect', null, {'action' : 'reconnect'}, null)}}
  {{/if}} -->
  <div>
    <h3 v-if="connected_name">
      Connected to network: {{ connected_name }}
    </h3>
    <h3 v-else>
      Connected to network: ???
      <vui-button :params="{ action: 'reconnect' }" icon="plug">Reconnect</vui-button>
    </h3>

    <table style="border: 1px solid black;">
      <tr>
        <td><b>Docking port</b></td>
        <td><b>Docked ship</b></td>
      </tr>
      <tr v-for="dock in docks" :key="dock.name">
        <td>
          {{ dock.name }}
        </td>
        <td v-if="dock.shuttle">
          {{ dock.shuttle}}
        </td>
      </tr>
    </table>
  </div>
</template>

<script>
export default {
  data() {
    return this.$root.$data.state;
  }
}
</script>

<style lang="scss" scoped>
table {
  width: 100%;
  border-collapse: collapse;
  color: white;
  background-color: rgba(0, 0, 0, 0.6);
  border: 2px solid;
  margin-top: .5rem;

  td {
    padding-left: .5rem;
    padding-right: .5rem;
  }
}
</style>
