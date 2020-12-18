<template>
  <div class="ores">
    <h3>Selected Ores:</h3>
    <div v-for="ore in ore_names" :key="ore">
      <vui-button :class="{ selected: selected_ores.includes(ore) }" :params="{ chosen_ore: ore }">{{
        ore
      }}</vui-button>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return this.$root.$data.state
  },
}
</script>

<style lang="scss" scoped>
.ores {
  text-transform: capitalize;
}
</style>
