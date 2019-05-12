<template>
  <div>
    <template v-if="mode">
      <h2>Vote: {{question}}</h2>
      Time Left: {{reman}} s<hr>
      <table>
        <tr>
          <th>Choices</th><th>Votes</th><th v-if="mode == 'gamemode'">Minimum Players</th>
        </tr>
        <tr v-for="(options, choice) in uichoices" :key="choice">
          <td><vui-button :class="{on: choice == voted}" style="text-align:left;" :params="{action: 'vote', vote: choice}">{{options.name}}</vui-button></td><td>{{options.votes}}</td><td v-if="options.extra">{{options.extra}}</td>
        </tr>
      </table>
      <hr>
      <template v-if="isstaff">
        <vui-button :params="{action: 'cancel'}">Cancel</vui-button>
      </template>
    </template>
    <template v-else>
      <h2>Start a vote:</h2>
      <hr>
      <ul>
        <li>
          <vui-button :disabled="!isstaff && !allow_vote_restart" :params="{action: 'restart'}">Restart</vui-button>
        </li>
        <li>
          <vui-button :disabled="!isstaff && !allow_vote_restart" :params="{action: 'crew_transfer'}">Crew Transfer</vui-button>
          <span v-if="(isstaff || allow_vote_restart) && is_code_red">(Disallowed, Code Red or above)</span>
          <vui-button :class="{on: allow_vote_restart}" v-if="isstaff" :params="{action: 'toggle_restart'}">Toggle Restart / Crew Transfer voting</vui-button>
        </li>
        <li>
          <vui-button :disabled="!isstaff && !allow_vote_mode" :params="{action: 'gamemode'}">GameMode</vui-button>
          <vui-button :class="{on: allow_vote_mode}" v-if="isstaff" :params="{action: 'toggle_gamemode'}">Toggle GameMode voting</vui-button>
        </li>
        <li>
          <vui-button :disabled="!allow_extra_antags" :params="{action: 'add_antagonist'}">Add Antagonist Type</vui-button>
        </li>
        <li>
          <vui-button :disabled="!isstaff" :params="{action: 'custom'}">Custom</vui-button>
        </li>
      </ul>
    </template>
  </div>
</template>

<script>
export default {
  data() {
    return this.$root.$data.state;
  },
  computed: {
    uichoices() {
      if(typeof this.choices === 'object') {
        return this.choices
      } else {
        return {}
      }
    },
    reman() {
      return Math.round((this.endtime - this.$root.$data.wtime) / 10)
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

