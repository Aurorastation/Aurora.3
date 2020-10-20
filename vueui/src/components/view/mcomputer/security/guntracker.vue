<template>
  <div>
    <h3>Detected Firearms</h3>
    <div v-if="ntnet_active">
      <table class="table border">
        <tr class="header border">
          <th>User</th>
          <th>Firearm</th>
          <th>Settings</th>
        </tr>
        <tr v-for="gun in sorted_pins" class="item border" :key="gun.ref">
          <td>{{ gun.registered_info }}</td>
          <td>{{ gun.gun_name }}</td>
          <td>
            <vui-button :class="{'button' : 1, 'selected' : gun.lockstatus == 2}" :params="{ pin: gun.ref, action: 'setdisable' }">Disabled</vui-button>
            <vui-button :class="{'button' : 1, 'selected' : gun.lockstatus == 1}" :params="{ pin: gun.ref, action: 'setauto' }">Automatic</vui-button>
            <vui-button :class="{'button' : 1, 'selected' : gun.lockstatus == 3}" :params="{ pin: gun.ref, action: 'setstun' }">Stun Only</vui-button>
            <vui-button :class="{'button' : 1, 'selected' : gun.lockstatus == 4}" :params="{ pin: gun.ref, action: 'setlethal' }">Unrestricted</vui-button>
          </td>
        </tr>
      </table>
    </div>
    <div v-else>
      <span class="error">Connection to NTNet unsuccessful, wireless control disabled.</span>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return this.$root.$data.state;
  },
  computed: {
    sorted_pins: function() {
      return this.wireless_firing_pins.slice(0).sort((a, b) => (a.registered_info > b.registered_info) ? 1 : -1)
    }
  }
}
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