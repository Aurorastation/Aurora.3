<template>
  <div>
    <h2>Engine Status:</h2>
    <div v-if="is_on">
      The engine is currently running.
      <vui-button :params="{ toggle_engine: 1 }">Stop</vui-button>
    </div>
    <div v-else>
      The engine is off.
      <vui-button :disabled="!has_key || !has_cell" :params="{ toggle_engine: 1 }">Start</vui-button>
    </div>
    <div v-if="has_key">
      There is a key inserted into the ignition.
      <vui-button :params="{ key: 1 }">Remove Key</vui-button>
    </div>
    <div v-else>
      There is no key in the ignition.
    </div>
    <div v-if="has_cell">
      Cell Charge:
      <vui-progress :value="cell_charge" :max="cell_max_charge" :min="0">{{ cell_charge }}J</vui-progress>
      <vui-tooltip label="?"
        >The cell can be removed by using a screwdriver to open the maintenance panel, then using a crowbar to shimmy it
        out.</vui-tooltip
      >
    </div>
    <div v-else>
      There is no cell installed.
      <vui-tooltip label="?"
        >The cell can be installed by using a screwdriver to open the maintenance panel, then clicking on the engine
        with a compatible power cell.</vui-tooltip
      >
    </div>
    <div v-if="is_towing">
      This engine is currently towing the {{ tow }}.
      <vui-button :params="{ unlatch: 1 }">Unlatch</vui-button>
      <div>
        <h2>NT-X1 Vacuum Cleaner Status:</h2>
      </div>
      <div v-if="has_proper_trolley">
        <div v-if="is_hoovering">
          The trolley is currently vacuuming.
          <vui-button :params="{ toggle_hoover: 1 }">Toggle</vui-button>
        </div>
        <div v-else>
          The trolley is not vacuuming.
          <vui-button :disabled="!is_on" :params="{ toggle_hoover: 1 }">Toggle</vui-button>
        </div>
        <div>
          Vacuum Capacity Remaining:
          <vui-progress :value="vacuum_capacity" :max="max_vacuum_capacity" :min="0">{{
            vacuum_capacity
          }}</vui-progress>
          <vui-button :disabled="vacuum_capacity >= max_vacuum_capacity" :params="{ empty_hoover: 1 }"
            >Empty</vui-button
          >
        </div>
        <div v-if="is_mopping">
          The trolley is currently mopping.
          <vui-button :disabled="!is_on || !has_bucket || bucket_capacity <= 0" :params="{ toggle_mops: 1 }"
            >Toggle</vui-button
          >
        </div>
        <div v-else>
          The trolley is not mopping.
          <vui-button :disabled="!is_on || !has_bucket" :params="{ toggle_mops: 1 }">Toggle</vui-button>
        </div>
        <div v-if="has_bucket">
          The trolley has a reagent container installed.
          <vui-tooltip label="?"
            >The trolley must have a reagent container installed to draw reagents from, such as water or space cleaner.
            This can be done by opening the maintenance panel on the trolley with a screwdriver and clicking on it with
            a bucket. Similarly, with an open panel, it can be removed by using a wrench on it.</vui-tooltip
          >
          <div>
            Container Reagents Remaining:
            <vui-progress :value="bucket_capacity" :max="max_bucket_capacity" :min="0"
              >{{ bucket_capacity }}u</vui-progress
            >
          </div>
        </div>
        <div v-else>
          The trolley does not have a reagent container installed.
          <vui-tooltip label="?"
            >The trolley must have a reagent container installed to draw reagents from, such as water or space cleaner.
            This can be done by opening the maintenance panel on the trolley with a screwdriver and clicking on it with
            a bucket. Similarly, with an open panel, it can be removed by using a wrench on it.</vui-tooltip
          >
        </div>
      </div>
      <div v-else>
        The wagon does not have the correct NT-X1 Vacuum Cleaner installed.
      </div>
    </div>
    <div v-else>
      This engine isn't towing anything currently.
      <vui-tooltip label="?"
        >You can latch vehicles together by dragging from the vehicle you want to be the anchor point, to the trolley
        you wish to latch.</vui-tooltip
      >
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
