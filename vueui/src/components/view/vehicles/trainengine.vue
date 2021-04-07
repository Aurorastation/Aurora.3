<template>
  <div>
    <h2>Engine Status:</h2>
    <div v-if="is_on">
      The engine is currently running. <vui-button :params="{ toggle_engine: 1}">Stop</vui-button>
    </div>
    <div v-else>
      The engine is off. <vui-button :disabled="!has_key || !has_cell" :params="{ toggle_engine: 1}">Start</vui-button>
    </div>
    <div v-if="has_key">
      There is a key inserted into the ignition. <vui-button :params="{ key: 1}">Remove Key</vui-button>
    </div>
    <div v-else>
      There is no key in the ignition.
    </div>
    <div v-if="has_cell">
      Cell Charge: <vui-progress :class="{ good: cell_charge >= cell_max_charge * 0.8, bad: cell_charge <= cell_max_charge * 0.4, average: cell_charge < cell_max_charge * 0.8 && cell_charge > cell_max_charge * 0.4 }" :value="cell_charge" :max="cell_max_charge" :min="0">{{ cell_charge }}J</vui-progress> <vui-tooltip label="?">The cell can be removed by using a screwdriver to open the maintenance panel, then using a crowbar to shimmy it out.</vui-tooltip>
    </div>
    <div v-else>
      There is no cell installed. <vui-tooltip label="?">The cell can be installed by using a screwdriver to open the maintenance panel, then clicking on the engine with a compatible power cell.</vui-tooltip>
    </div>
    <div v-if="is_towing">
      This engine is currently towing the {{ tow }}. <vui-button :params="{ unlatch: 1}">Unlatch</vui-button>
    </div>
    <div v-else>
      This engine isn't towing anything currently. <vui-tooltip label="?">You can latch vehicles together by dragging from the vehicle you want to be the anchor point, to the trolley you wish to latch.</vui-tooltip>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return this.$root.$data.state;
  }
};
</script>