<template>
  <div>
    <div class="item">
      <div class="itemLabel">Confirm identity:</div>
      <div class="itemContent">
        <vui-button :params="{ scan: 1 }" icon="eject"><span v-if="state.idname">{{ state.idname }}</span><span v-else>--------</span></vui-button>
      </div>
    </div>
    <div v-if="state.auth" style="margin-top: 24px; clear: both;">
      <b>Logged in to:</b> {{ state.bossname }} Quantum Entanglement Network
      <template v-if="remaining_cooldown <= 0">
        <vui-item label="Sending to:">
          <select v-model.lazy="state.destination" class="button">
            <option v-for="dep in state.departiments" :key="dep" :value="dep">{{ dep }}</option>
          </select>
        </vui-item>
        <template v-if="state.paper">
          <vui-item label="Currently sending:">{{ state.paper }}</vui-item>
          <vui-button push-state :params="{ send: 1}">Send</vui-button>
        </template>
        <span v-else>Please insert paper to send via secure connection.</span>
      </template>
      <span v-else><b>Transmitter arrays realigning. Please stand by. {{ remaining_cooldown | roundRemaining}} seconds remaining.</b></span>
    </div>
    <vui-button v-if="state.paper" :params="{ remove: 1}">Remove item</vui-button>
        
    <h3>PDAs to notify:</h3>
    <div v-for="pda in state.alertpdas" :key="pda.ref">
      {{ pda.name }} <vui-button :params="{ unlink: pda.ref }">Unlink</vui-button>
    </div>
    <div v-if="state.alertpdas.length <= 0">No PDAs are linked.</div>
    <vui-button :params="{ linkpda: 1 }">Add PDA to Notify</vui-button>
  </div>
</template>

<script>
export default {
  data() {
    return this.$root.$data;
  },
  computed: {
    remaining_cooldown() {
      return this.state.cooldownend - this.wtime 
    }
  },
  filters: {
    roundRemaining(value) {
      return Math.round(value / 10);
    }
  }
};
</script>

<style lang="scss" scoped>
</style>