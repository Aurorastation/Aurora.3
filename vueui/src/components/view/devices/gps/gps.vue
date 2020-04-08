<template>
  <div>
    <!-- Controls -->
    <input v-model="new_own_tag" :placeholder="own_tag"><vui-button :params="{ tag: new_own_tag }">Set GPS Tag</vui-button><br>
    <input v-model="add_track_tag"><vui-button :params="{ add_tag: add_track_tag }">Track New Tag</vui-button><br>
    <vui-button :params="{ add_all: 1 }">Track All</vui-button>
    <vui-button :params="{ clear_all: 1 }">Untrack All</vui-button>
    <hr>

    <!-- Tracking List -->
    <table>
      <tr>
        <th>GPS Tag</th>
        <th>Location</th>
        <th>Area</th>
        <th>Remove</th>
      </tr>
      <tr v-for="gps in tracking_list" :key="gps.tag">
        <td> {{ gps.tag }} </td>
        <td> {{ gps.pos_x }}, {{ gps.pos_y }}, {{ gps.pos_z }} </td>
        <td> {{ gps.area }} </td>
        <vui-button v-if="gps.tag != own_tag" :params="{ remove_tag: gps.tag }">Untrack</vui-button>
        <td v-else/>
      </tr>
    </table>
</div></template>

<script>
export default {
  data() {
    return this.$root.$data.state;
  }
}
</script>
