<template>
  <div>
    <div>
      <vui-button :class="{ selected: activeview == 'resources'}" @click="activeview = 'resources'">Resources</vui-button>
      <vui-button :class="{ selected: activeview == 'requisition'}" @click="activeview = 'requisition'">Requisition</vui-button>
      <vui-button :params="{uplink: 1}">Uplink</vui-button>
      <vui-button :params="{cams: 1}">Camera View</vui-button>
    </div>
    <hr>
    <component v-if="activeview" :is="&quot;view-mcomputer-cmdr-&quot; + activeview"/>
  </div>
</template>

<script>
export default {
  data() {
    return this.$root.$data.state;
  }
};
</script>