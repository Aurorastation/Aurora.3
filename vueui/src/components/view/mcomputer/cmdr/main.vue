<template>
  <div>
    <div class="container">
      <div id="button-panel">
        <vui-button :class="{ selected: activeview == 'resources'}" @click="activeview = 'resources'">Resources</vui-button>
        <vui-button :class="{ selected: activeview == 'requisition'}" @click="activeview = 'requisition'">Requisition</vui-button>
        <vui-button :params="{uplink: 1}">Uplink</vui-button>
        <vui-button :params="{cams: 1}">Camera View</vui-button>
      </div>
      <div id="resource-panel">
        <span>$</span> {{money}} &nbsp;&nbsp; <span>♦</span> {{crystals}}
      </div>
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

<style lang="scss" scoped>
  .container {
    display: flex;
    justify-content: space-between;
  }
  #resource-panel {
    text-align: right;
    :nth-child(1) {
      color: gold;
      font-weight: bold;
    }
    :nth-child(2) {
      color: red;
      font-weight: bold;
    }
  }
</style>