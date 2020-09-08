<template>
  <div>
    <h3>Firearm Control System</h3>
    <h3>Detected Firearms</h3>
    <table>
      <tr>
        <th>User</th>
        <th>Firearm</th>
        <th/>
      </tr>
      <tr v-for="gun in wireless_firing_pins" :key="gun.ref">
        <td>{{ gun.registered_info }}</td>
        <td>{{ gun.gun_name }}</td>
        <td>
          <vui-button :class="{'button' : 1, 'selected' : gun.disabled_state}" :params="{ togglepin2: gun.ref }">Disabled</vui-button>
          <vui-button :class="{'button' : 1, 'selected' : gun.automatic_state}" :params="{ togglepin1: gun.ref }">Automatic</vui-button>
          <vui-button :class="{'button' : 1, 'selected' : gun.stun_state}" :params="{ togglepin3: gun.ref }">Stun Only</vui-button>
          <vui-button :class="{'button' : 1, 'selected' : gun.lethal_state}" :params="{ togglepin4: gun.ref }">Unrestricted</vui-button>
        </td>
      </tr>
    </table>
  </div>
</template>



<script>
export default {
		data() {return this.$root.$data.state},

};
</script>

<style lang="scss" scoped>
table {
    width: 100%;
    text-align: center;
  }
</style>
