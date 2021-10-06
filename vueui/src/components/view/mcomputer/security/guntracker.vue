<template>
  <div>
    <h3>Detected Firearms</h3>
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
          <vui-button :class="{'button' : 1, 'selected' : gun.lock_status == 1}" :params="{ pin: gun.ref, action: 'setdisable' }">Disabled</vui-button>
          <vui-button :class="{'button' : 1, 'selected' : gun.lock_status == 2}" :params="{ pin: gun.ref, action: 'setauto' }">Automatic</vui-button>
          <vui-button :class="{'button' : 1, 'selected' : gun.lock_status == 3}" :params="{ pin: gun.ref, action: 'setstun' }">Stun Only</vui-button>
          <vui-button :class="{'button' : 1, 'selected' : gun.lock_status == 4}" :params="{ pin: gun.ref, action: 'setlethal' }">Unrestricted</vui-button>
        </td>
      </tr>
    </table>
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
</style>