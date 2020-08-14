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
          <th>Area</th>
          <th>Firearm</th>
          <th/>
        </tr>
        <tr v-for="gun in wireless_firing_pins" :key="gun.ref">
          <td>{{ gun.registered_info }}</td>
          <td>{{ gun.area }}</td>
          <td>{{ gun.gun_name }}</td>
          <td>
            <template v-if="gun.automatic_state">
              <vui-button disabled :params="{ togglepin1: gun.ref }">Automatic</vui-button>
            </template>
            <template v-else class="buttons">
              <vui-button :params="{ togglepin1: gun.ref }">Automatic</vui-button>
            </template>
            <template v-if="gun.disabled_state">
              <vui-button disabled :params="{ togglepin2: gun.ref }">Disabled</vui-button>
            </template>
            <template v-else class="buttons">
              <vui-button :params="{ togglepin2: gun.ref }">Disabled</vui-button>
            </template>
            <template v-if="gun.stun_state">
              <vui-button disabled :params="{ togglepin3: gun.ref }">Stun Only</vui-button>
            </template>
            <template v-else class="buttons">
              <vui-button :params="{ togglepin3: gun.ref }">Stun Only</vui-button>
            </template>
            <template v-if="gun.lethal_state">
              <vui-button disabled :params="{ togglepin4: gun.ref }">Unrestricted</vui-button>
            </template>
            <template v-else class="buttons">
              <vui-button :params="{ togglepin4: gun.ref }">Unrestricted</vui-button>
            </template>
          </td>
        </tr></table>
    </template>
  </div>
</template>



<script>
export default {
			data() {
			return this.$root.$data.state
			},

};
</script>

<style lang="scss" scoped>
table {
    width: 100%;
    text-align: center;
  }
</style>