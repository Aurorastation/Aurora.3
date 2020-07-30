<template>
  <div>
    <div v-if="forumuserui_enabled" class="notice">
        <center>Modifications done do not outlast the round!</center>
    </div>
    <div class="table">
      <div class="header">
        <div class="header-item">Ckey <vui-button :params="{ action: 'add' }">Add</vui-button></div>
        <div class="header-item">Rank</div>
        <div class="header-item">Permissions</div>
      </div>

      <div class="entry" v-for="admin in admins" :key="admin.ckey">
        <div class="item">
          <vui-button :params="{ action: 'remove', ckey: admin.ckey }">Edit</vui-button> {{admin.ckey}}
        </div>
        <div class="item">
          <vui-button :params="{ action: 'rank', ckey: admin.ckey }">Edit</vui-button> {{admin.rank}}
        </div>
        <div class="item" width="30%">
          <vui-button :params="{ action: 'rights', ckey: admin.ckey }">Edit</vui-button> {{admin.rights}}
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return this.$root.$data.state
  }
}
</script>

<style lang="scss" scoped>
.table {
  display: table;
  width: 100%;

  .header {
    text-align: center;
    font-weight: bold;
  }
  .header, .entry {
    display: table-row;
    .header-item, .item {
      display: table-cell;
      padding: 1px;
    }
  }
}
</style>
