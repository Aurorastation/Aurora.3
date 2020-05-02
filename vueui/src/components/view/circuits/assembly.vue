<template>

  <div>
    <!-- Refresh button, just in case -->
    <vui-button :params="{refresh: 1}" icon="arrowreturn-1-s">Refresh</vui-button> |
    <vui-button :params="{rename: 1}" icon="wrench">Rename</vui-button> 
    <br>
    {{size}} / {{max_components}} space taken up in the assembly.<br>
    {{complexity}} / {{max_complexity}} complexity in the assembly.<br>

    <span v-if="battery">{{battery_charge}} / {{battery_maxcharge}} ({{battery_percent}}%) cell charge. <vui-button :params="{remove_cell:1}">Remove</vui-button></span>
    <span v-else><font color="FF0000">No power cell detected!</font></span>
    <br><br>
    <span v-if="components.length > 0">
      Components:<br>
      <div v-for="component in components" :key="component">
        <vui-button :params="{component: component.component, set_slot: 1}">{{component.index}}</vui-button> 
        <!-- TODO: Replace unsafe_params with normal params -->
        <vui-button :unsafe-params="{src: component.component, component: component.component, rename:1}">R</vui-button>
        <vui-button :disabled="!component.removable" :params="{component: component.component, remove: 1}">-</vui-button>
        <!-- TODO: Replace unsafe_params with normal params -->
        <vui-button :unsafe-params="{src: component.component, examine: 1}">{{component.name}}</vui-button>
        <br>
      </div>
      <br>
      <span v-for="i in page_num" :key="i">
        <!-- Page index is 0-based in code, but 1-based in UI. Select_page is also 1-based-->
        <vui-button :disabled="(i - 1) == cur_page" :params="{select_page: i}">{{i}}</vui-button>
      </span>
    </span>
  </div>

</template>

<script>
export default {
  data() {
    return this.$root.$data.state; // Make data more easily accessible
  }
};
</script>