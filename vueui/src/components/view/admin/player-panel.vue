<template>
  <div>
    <vui-button :unsafe-params="{src: s.holder_ref, check_antagonist: 1}">Check antagonists</vui-button>
    <vui-input-search style="float: right;" :input="players_filtered" v-model="search_results" :keys="['name', 'real_name', 'assigment', 'key', 'ip']" autofocus :threshold="threshold" include-score/>
    <div class="table">
      <div class="header">
        <div class="header-item">Name</div>
        <div class="header-item">Assignment</div>
        <div class="header-item">Key</div>
        <div class="header-item" v-if="s.ismod">Age</div>
        <div class="header-item" v-if="s.ismod">Antag</div>
        <div class="header-item">Actions</div>
      </div>
      <div class="player" v-for="p in search_results" :key="p.item.ref" :style="{opacity: 1 - (p.score * score_multiplier)}">
        <div class="item">
          <template v-if="(p.item.name == p.item.real_name) || (p.item.assigment == 'NA')">{{p.item.name}}</template>
          <vui-tooltip v-else :label="p.item.name">{{p.item.real_name}}</vui-tooltip>
        </div>
        <div class="item">
          <template v-if="p.item.assigment == 'NA'">{{p.item.real_name}}</template>
          <template v-else>{{p.item.assigment}}</template>
        </div>
        <div class="item">
          <template v-if="!s.ismod">
            {{p.item.key}}<span v-if="!p.item.connected"> (DC)</span>
          </template>
          <vui-tooltip v-else>
            <template v-slot:label>{{p.item.key}}<span v-if="!p.item.connected"> (DC)</span></template>
            {{p.item.ip}}
          </vui-tooltip>
        </div>
        <div class="item" v-if="s.ismod">{{p.item.age}}</div>
        <div class="item" v-if="s.ismod">
          <span v-if="p.item.antag == -1">NA</span>
          <span v-else-if="p.item.antag == 0">No</span>
          <span class="red" v-if="p.item.antag == 1"><vui-tooltip label="ADD">This antag was added by admin.</vui-tooltip></span>
          <span class="red" v-if="p.item.antag == 2"><vui-tooltip label="GM">This antag was added by gamemode.</vui-tooltip></span>
        </div>
        <div class="item" style="text-align: right;">
          <vui-button :unsafe-params="{src: s.holder_ref, adminplayeropts: p.item.ref}">PP</vui-button>
          <vui-button :unsafe-params="{src: s.holder_ref, priv_msg: p.item.ref}">PM</vui-button>
          <vui-button :unsafe-params="{src: s.holder_ref, subtlemessage: p.item.ref}">SM</vui-button>
          <vui-button :unsafe-params="{_src_: 'vars', Vars: p.item.ref}">VV</vui-button>
          <vui-button :unsafe-params="{src: s.holder_ref, mob: p.item.ref, notes: 'show'}">N</vui-button>
          <vui-button :unsafe-params="{src: s.holder_ref, traitor: p.item.ref}">TP</vui-button>
          <vui-button :unsafe-params="{src: s.holder_ref, adminplayerobservejump: p.item.ref}">JMP</vui-button>
          <vui-button :unsafe-params="{src: s.holder_ref, admin_wind_player: p.item.ref}">WIND</vui-button>
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
      s: this.$root.$data.state,
      threshold: 0.3
    }
  },
  computed: {
    players_filtered() {
      return Object.values(this.s.players).filter(x => x)
    },
    score_multiplier() {
      return 1 / this.threshold
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

