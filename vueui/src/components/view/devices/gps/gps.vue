<template>
  <div>
    <!-- Controls -->
    <input type="text" v-model="new_own_tag" :placeholder="s.own_tag"><vui-button :params="{ tag: new_own_tag }">Set GPS Tag</vui-button><br>
    <input type="text" v-model="add_track_tag"><vui-button :params="{ add_tag: add_track_tag }">Track New Tag</vui-button><br>
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
        <th>C-Track</th>
      </tr>
      <tr v-for="gps in s.tracking_list" :key="gps.tag">
        <td> {{ gps.tag }} </td>
        <td> {{ gps.pos_x }}, {{ gps.pos_y }}, {{ gps.pos_z }} </td>
        <td> {{ gps.area }} </td>
        <td v-if="gps.tag != s.own_tag"><vui-button :params="{ remove_tag: gps.tag }">Untrack</vui-button></td>
        <td v-else />
        <td v-if="gps.tag != s.own_tag"><vui-button :class="{selected: s.compass_list && s.compass_list.includes(gps.tag)}" :params="{ compass: gps.tag }">Compass</vui-button></td>
        <td v-else />
      </tr>
    </table>
  </div>
</template>

<script>
export default {
  data() {
    return {
      s: this.$root.$data.state,
      new_own_tag: '',
      add_track_tag: '',
    }
  },
}
</script>
