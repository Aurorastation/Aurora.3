<template>
  <div>
    <h2>Ghost Roles</h2>

    <table>
      <tr>
        <th>Name</th>
        <th>Description</th>
        <th>Actions</th>
      </tr>
      <tr v-for="(data,index) in spawnchoices" :key="index">
        <td>{{data.name}}</td>
        <td>{{data.desc}}</td>
        <td>
          <vui-button :disabled="(data.cant_spawn !== 0)" :params="{action: 'spawn', spawner: index}" icon="star">Spawn</vui-button> 
          <vui-button v-if="data.can_edit == 1" :disabled="(data.enabled == 1)" :params="{action: 'enable', spawner: index}" icon="unlocked">Enable</vui-button> 
          <vui-button v-if="data.can_edit == 1" :disabled="(data.enabled == 0)" :params="{action: 'disable', spawner: index}" icon="locked">Disable</vui-button> 
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
    spawnchoices() {
      if(typeof this.spawners === 'object') {
        return this.spawners
      } else {
        return {}
      }
    }
  }
}
</script>

<style lang="scss" scoped>
  table {
    width: 100%;
    th {
      font-weight: bold;
    }
    th, td {
      text-align: center;
    }
  }
</style>

