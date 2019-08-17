<template>
  <div>
    <div class="tagselector" v-show="!spawnpoint">
      <vui-button v-for="(amount,tag) in tags" :key="tag" v-on:click="current_tag = tag" v-bind:class="{ selected: current_tag == tag}">{{tag}} ({{amount}})</vui-button>
    </div>
    <hr v-show="!spawnpoint">
    <table>
      <tr>
        <th>Name</th>
        <th>Description</th>
        <th>Available Slots</th>
        <th class="action">Actions</th>
      </tr>
      <tr v-for="(data,index) in spawners" :key="index" v-show="showEntry(data)">
        <td>{{data.name}}</td>
        <td>{{data.desc}}</td>
        <td v-if="data.max_count > 0">{{data.max_count - data.count}} / {{data.max_count}}</td>
        <td v-else>&infin;</td>
        <td class="action">
          <vui-button :disabled="(data.cant_spawn !== 0)" :params="{spawn: index, spawnpoint: spawnpoint}" icon="star">Spawn</vui-button> 
          <vui-button v-if="data.can_edit == 1" :disabled="(data.enabled == 1)" :params="{enable: index}">Enable</vui-button> 
          <vui-button v-if="data.can_edit == 1" :disabled="(data.enabled == 0)" :params="{disable: index}">Disable</vui-button> 
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
    tags: function() {
      let st = Object.values(this.spawners).flatMap(s => s.tags)
      let tags = {All: Object.values(this.spawners).length}
      st.filter((v, i, a) => a.indexOf(v) === i).forEach(tag => {
          tags[tag] = st.filter(t => t == tag).length
      })
      return tags
    }
  }, methods:{
    showEntry: function(data) {
      if(!this.spawnpoint){
        //if we dont have a spawnpoint-filter set, then look at the tag filter
        return !data.tags.indexOf(this.current_tag) || this.current_tag == 'All'
      } else {
        //if we have a spawnpoint filter set, filter by spawnpoints
        if(!data.hasOwnProperty('spawnpoints'))
          return false
        return !data.spawnpoints.indexOf(this.spawnpoint)
      }
    }
  }
}
</script>

<style lang="scss" scoped>
  table {
    width: 100%;
    th, td {
      text-align: center;
      width: auto;
      &.action {
        width: 1%;
        white-space: nowrap;
      }
    }
    th {
      font-weight: bold;
    }
  }
  .tagselector {
    display: flex;
  }
</style>

