<template>
  <div>
    <div v-if="forumuserui_enabled" class="notice">
      <center>Modifications done do not outlast the round! Use the forums/WI to modify ranks.</center>
    </div>
    <table>
      <tr>
        <th>Ckey <vui-button :params="{ action: 'add' }">Add</vui-button></th>
        <th>Rank</th>
        <th>Permissions</th>
      </tr>

      <tr v-for="admin in admins" :key="admin.ckey">
        <td>
          <vui-button :params="{ action: 'remove', ckey: admin.ckey }">Edit</vui-button> {{admin.ckey}}
        </td>
        <td>
          <vui-button :params="{ action: 'rank', ckey: admin.ckey }">Edit</vui-button> {{admin.rank}}
        </td>
        <td>
          <vui-button :params="{ action: 'rights', ckey: admin.ckey }">Edit</vui-button> {{admin.rights}}
        </td>
      </tr>
    </table>
  </div>
</template>

<script>
export default {
  data() {
    return this.$root.$data.state
  }
}
</script>
