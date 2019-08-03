<template>
  <div>
    <vui-button :unsafe-params="{src: s.holder_ref, check_antagonist: 1}">Check antagonists</vui-button>
    <vui-input-search style="float: right;" :input="players_filtered" v-model="search_results" :keys="['name', 'real_name', 'assigment', 'key', 'ip']"/>
    <div class="table">
      <div class="header">
        <div class="header-item">Name</div>
        <div class="header-item">Assignment</div>
        <div class="header-item">Key</div>
        <div class="header-item" v-if="s.ismod">Age</div>
        <div class="header-item" v-if="s.ismod">Antag</div>
        <div class="header-item">Actions</div>
      </div>
      <div class="player" v-for="p in search_results" :key="p.ref">
        <div class="item">
          <template v-if="(p.name == p.real_name) || (p.assigment == 'NA')">{{p.name}}</template>
          <vui-tooltip v-else :label="p.name">{{p.real_name}}</vui-tooltip>
        </div>
        <div class="item">
          <template v-if="p.assigment == 'NA'">{{p.real_name}}</template>
          <template v-else>{{p.assigment}}</template>
        </div>
        <div class="item">
          <template v-if="!s.ismod">
            {{p.key}}<span v-if="!p.connected"> (DC)</span>
          </template>
          <vui-tooltip v-else>
            <template v-slot:label>{{p.key}}<span v-if="!p.connected"> (DC)</span></template>
            {{p.ip}}
          </vui-tooltip>
        </div>
        <div class="item">{{p.age}}</div>
        <div class="item" v-if="s.ismod">
          <span v-if="p.antag == -1">NA</span>
          <span v-else-if="p.antag == 0">No</span>
          <span class="red" v-if="p.antag == 1"><vui-tooltip label="ADD">This antag was added by admin.</vui-tooltip></span>
          <span class="red" v-if="p.antag == 2"><vui-tooltip label="GM">This antag was added by gamemode.</vui-tooltip></span>
        </div>
        <div class="item" style="text-align: right;">
          <vui-button :unsafe-params="{src: s.holder_ref, adminplayeropts: p.ref}">PP</vui-button>
          <vui-button :unsafe-params="{src: s.holder_ref, mob: p.ref, notes: 'show'}">N</vui-button>
          <vui-button :unsafe-params="{src: s.holder_ref, traitor: p.ref}">TP</vui-button>
          <vui-button :unsafe-params="{src: s.holder_ref, priv_msg: p.ref}">PM</vui-button>
          <vui-button :unsafe-params="{src: s.holder_ref, subtlemessage: p.ref}">SM</vui-button>
          <vui-button :unsafe-params="{src: s.holder_ref, adminplayerobservejump: p.ref}">JMP</vui-button>
          <vui-button :unsafe-params="{src: s.holder_ref, admin_wind_player: p.ref}">WIND</vui-button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      search_results: [],
      s: this.$root.$data.state
    }
  },
  computed: {
    players_filtered() {
      return Object.values(this.s.players).filter(x => x)
    }
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
  .header, .player {
    display: table-row;
    .header-item, .item {
      display: table-cell;
      padding: 1px;
    }
  }

}
</style>

