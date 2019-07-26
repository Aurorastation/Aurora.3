<template>
  <div>
    <div class="tagselector">
      <div v-for="(amount,tag) in tags" :key="tag" v-on:click="current_tag = tag" class="button">{{tag}} ({{amount}})</div>
    </div>
    <hr>
    <table>
      <tr>
        <th>Name</th>
        <th>Description</th>
        <th class="taction">Actions</th>
      </tr>
      <tr v-for="(data,index) in spawners" :key="index" v-show="data.tags.indexOf(current_tag) || current_tag == 'All'">
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
    tags: function() {
      let ctags = {}
      ctags.All = 0;
      let s;
      for (s in this.spawners){
        console.log("Spawner:"+s)
        ctags.All += 1;
        let spawner = this.spawners[s]
        let t;
        console.log("Spawner-Data:"+JSON.stringify(spawner))
        for (t in spawner.tags){
          let tag_name = spawner.tags[t]
          if(ctags.hasOwnProperty(tag_name)){
            ctags[tag_name] += 1;
          } else {
            ctags[tag_name] = 1;
          }
        }
      }
      return ctags
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
    .taction {
      width: 200px;
    }
  }
  .tagselector {
    display: flex;
  }
</style>

