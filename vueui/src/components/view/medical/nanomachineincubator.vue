<template>
  <div>
    <div><vui-item label="Nanomachine Reserve:"><vui-progress :class="{ good: nanomachine_reserve >= max_nanomachine_reserve * 0.8, bad: nanomachine_reserve <= max_nanomachine_reserve * 0.05, average: nanomachine_reserve < max_nanomachine_reserve * 0.8 && nanomachine_reserve > max_nanomachine_reserve * 0.05 }" :value="nanomachine_reserve" :max="max_nanomachine_reserve" :min="0">{{ nanomachine_reserve }}</vui-progress></vui-item></div>
    <vui-button :disabled="nanomachine_reserve < 100" :params="{print: 1}">Print Nanomachine Capsule (100)</vui-button> <vui-tooltip label="?">Prints a Nanomachine Capsule, a device which can be used to restock incubator reserves. Holds 100 nanomachines.</vui-tooltip>
    <div v-if="loaded_nanomachines">
      <h3>Nanomachine Sculptor</h3>
      <vui-item label="Nanomachine Program Capacity:"><vui-progress :class="{ good: space_remaining > max_space - 1, bad: space_remaining < 1, average: space_remaining < max_space - 1 && space_remaining > 1 }" :value="space_remaining" :max="max_space" :min="0">{{ space_remaining }}</vui-progress></vui-item>
      <div class="program" v-for="(desc, progname) in available_programs" :key="progname">
        <vui-button :disabled="!space_remaining && !loaded_programs.includes(progname)" :class="{'button' : 1, 'selected' : loaded_programs.includes(progname)}" :params="{ program: progname }">{{ progname }}</vui-button><br>
        <span>{{ desc }}</span>
      </div>
      <br>
      <vui-button :params="{flush: 1}">Flush Nanomachine Cluster</vui-button> <vui-tooltip label="?">Returns the cluster to the Nanomachine Reserve.</vui-tooltip>
    </div>
    <div v-else>
      <h3>No Nanomachines in Incubator</h3>
      <vui-button :disabled="nanomachine_reserve < 50" :params="{create: 1}">Create Nanomachine Cluster (50)</vui-button> <vui-tooltip label="?">Creates a Nanomachine Cluster to edit and load into someone.</vui-tooltip>
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
  border-bottom: 1px solid transparent;
  background-color: #1d1d1d33;
  transition: background-color 0.2s, color 0.2s, border 0.2s;
}
.program:hover {
  border-bottom: 1px solid #5c87a8;
  background-color: #1d1d1d;
  color: #99c2c9;
}
</style>