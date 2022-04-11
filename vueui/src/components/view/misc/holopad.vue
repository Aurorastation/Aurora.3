<template>
  <div>
    <vui-button :params="{ call_ai: 1 }">Summon AI</vui-button>
    <vui-button v-if="s.command_auth == true" :class="{ selected: s.forcing_call == true}" :params="{ toggle_command: 1 }">Toggle Command Authorization</vui-button>
    <br><br>
    <vui-input-search :input="holopads_filtered" v-model="search_results" :keys="['id', 'ref']" autofocus :threshold="threshold" include-score/>
    <div v-if="!search_results.length">
      <span>No compatible holopads detected within range{{ s.call_range > 0 ? " " + s.call_range : "" }}.</span>
    </div>
    <div v-else>
      <div v-for="h in search_results" :key="h.item.ref" :style="{opacity: 1 - (h.score * score_multiplier)}">
        <vui-button :disabled="h.item.busy == true" :params="{ call_holopad: h.item.ref }">{{ h.item.id }}</vui-button>
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
    holopads_filtered() {
      return Object.values(this.s.holopad_list).filter(x => x).sort((a,b) => {
        let fa = a.id.toLowerCase(), fb = b.id.toLowerCase();
        if (fa < fb) {
          return -1
        }
        if (fa > fb) {
          return 1
        }
        return 0
      })
    },
    score_multiplier() {
      return 1 / this.threshold
    }
  }
}
</script>