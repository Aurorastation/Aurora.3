<template>
  <div>
    <h3>Firearm Control System</h3>
    <template v-if="screen">
      <vui-button :params="{ lock: 1 }">Unlock Console</vui-button>
    </template>
    <template v-else>
      <vui-button :params="{ lock: 1 }">Lock Console</vui-button>
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
            <vui-button :class="{'button' : 1, 'selectedoption' : gun.disabled_state}" :params="{ togglepin2: gun.ref }">Disabled</vui-button>
            <vui-button :class="{'button' : 1, 'selectedoption' : gun.automatic_state}" :params="{ togglepin1: gun.ref }">Automatic</vui-button>
            <vui-button :class="{'button' : 1, 'selectedoption' : gun.stun_state}" :params="{ togglepin3: gun.ref }">Stun Only</vui-button>
            <vui-button :class="{'button' : 1, 'selectedoption' : gun.lethal_state}" :params="{ togglepin4: gun.ref }">Unrestricted</vui-button>
          </td>
        </tr></table>
    </template>
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
.selectedoption {
    background-color: #2F943C;
  }
</style>