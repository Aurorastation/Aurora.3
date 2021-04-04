<template>
  <div>
    <div v-if="connected_incubator">
      <h3>Nanomachine Incubator</h3>
      <div v-if="connected_incubator_nanomachine_cluster">
        <div v-if="connected_incubator_loaded_programs && connected_incubator_loaded_programs.length">
          <vui-item label="Incubator Nanomachine Programs:"><span class="program" v-for="program in connected_incubator_loaded_programs" :key="program">{{ program }}</span></vui-item>
          <vui-button :disabled="!occupant || working == true || occupant_synthetic == true" :params="{infuse: 1}">{{ working ? "Infuse Cluster (Working)" : occupant_synthetic ? "Infuse Cluster (Synthetic)" : "Infuse Cluster" }}</vui-button>
        </div>
        <div v-else>
          <vui-item label="Incubator Nanomachine Programs:"><span class="program danger">The incubator cluster has no programs loaded.</span></vui-item>
        </div>
      </div>
      <div v-else>
        <vui-item label="Incubator Nanomachine Programs:"><span class="program danger">The incubator has no nanomachine cluster loaded.</span></vui-item>
      </div>
    </div>
    <div v-if="occupant">
      <h3>Chamber Occupant</h3>
      <vui-item label="Occupant Species:">{{ occupant_species }}</vui-item>
      <div v-if="occupant_nanomachines">
        <div><vui-item label="Occupant Nanomachine Reserve:"><vui-progress :class="{ good: occupant_nanomachine_reserve >= occupant_max_nanomachine_reserve * 0.8, bad: occupant_nanomachine_reserve <= occupant_max_nanomachine_reserve * 0.05, average: occupant_nanomachine_reserve < occupant_max_nanomachine_reserve * 0.8 && occupant_nanomachine_reserve > occupant_max_nanomachine_reserve * 0.05 }" :value="occupant_nanomachine_reserve" :max="occupant_max_nanomachine_reserve" :min="0">{{ occupant_nanomachine_reserve }}</vui-progress></vui-item></div>
        <div v-if="occupant_nanomachines_loaded_programs && occupant_nanomachines_loaded_programs.length">
          <vui-item label="Occupant Nanomachine Programs:"><span class="program" v-for="program in occupant_nanomachines_loaded_programs" :key="program">{{ program }}</span></vui-item>
        </div>
        <div v-else>
          <vui-item label="Occupant Nanomachine Programs:"><span class="program danger">The occupant's nanomachine cluster lacks programs.</span></vui-item>
        </div>
      </div>
      <div v-else>
        <vui-item label="Occupant Nanomachine Programs:"><span class="program normal">The occupant does not have a nanomachine cluster.</span></vui-item>
      </div>
      <vui-button :disabled="locked == true" :params="{eject: 1}">{{ locked ? "Eject Occupant (Locked)" : "Eject Occupant" }}</vui-button>
      <vui-button v-if="occupant_nanomachines" :disabled="connected_incubator == false || connected_incubator_nanomachine_cluster == true || working == true" :params="{extract: 1}">{{ connected_incubator_nanomachine_cluster ? "Extract Cluster (Incubator Full)" : working ? "Extract Cluster (Working)" : "Extract Cluster" }}</vui-button>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return this.$root.$data.state;
  }
}
</script>

<style lang="scss" scoped>
.program {
  border-radius: 5px;
  border: 1px solid #009141;
  background-color: #01ac4e;
  margin-right: 5px;
  padding: 2px;
}
.program.danger {
  border: 1px solid #910000;
  background-color: #ac0101;
}
.program.normal {
  border: 1px solid #003391;
  background-color: #0145ac;
}
</style>