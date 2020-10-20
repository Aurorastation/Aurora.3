<template>
  <div>
    <h3>Chemical Implants</h3>
    <div v-if="ntnet_active">
      <table class="table border">
        <tr class="header border">
          <th>Implanted User</th>
          <th>Remaining Chemical Units</th>
          <th>Options</th>
        </tr>
        <tr v-for="chem in chem_implants" class="item border" :key="chem.ref">
          <td>{{ chem.implanted_name }}</td>
          <td>{{ chem.remaining_units }}</td>
          <td>
            <vui-button :disabled="chem.remaining_units < 1" :params="{ inject1: chem.ref }">Inject 1u</vui-button>
            <vui-button :disabled="chem.remaining_units < 5" :params="{ inject5: chem.ref }">Inject 5u</vui-button>
            <vui-button :disabled="chem.remaining_units < 10" :params="{ inject5: chem.ref }">Inject 10u</vui-button>
          </td>
        </tr>
      </table>
    </div>
    <div v-else>
      <span class="error">Connection to NTNet unsuccessful, wireless tracking disabled.</span>
    </div>
    <h3>Tracking Implants</h3>
    <div v-if="ntnet_active">
      <table class="table border">
        <tr class="header border">
          <th>Tracking ID</th>
          <th>Current Area</th>
          <th>Options</th>
        </tr>
        <tr v-for="tracker in tracking_implants" class="item border" :key="tracker.ref">
          <td>{{ tracker.id }}</td>
          <td>{{ tracker.loc_display }}</td>
          <td>
            <vui-button :params="{ warn: tracker.ref }">Message Implanted User</vui-button>
          </td>
        </tr>
      </table>
    </div>
    <div v-else>
      <span class="error">Connection to NTNet unsuccessful, wireless tracking disabled.</span>
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
.error {
  display: block;
  width: 80%;
  text-align: center;
  border: 0.5px solid rgba(0, 0, 0, 0.5);
  border-radius: 0.15em;
  background-color: rgba(0, 0, 0, 0.3);
  color: #ff3434;
  font-weight: bold;
  padding: 10px, 10px;
}
</style>