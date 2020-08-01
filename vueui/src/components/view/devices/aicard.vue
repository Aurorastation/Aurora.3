<template>
  <div>
    <template v-if="has_ai">
      <div class="item">
        <div class="itemLabel">
          Hardware Integrity:
        </div>
        <div class="itemContent">
          {{hardware_integrity}}%
        </div>
        <div class="itemLabel">
          Backup Capacitor:
        </div>
        <div class="itemContent">
          {{backup_capacitor}}%
        </div>
      </div>

      <template v-if="has_laws">
        <table class="borders">
          <tr><td class="law_index">Index</td><td>Law</td></tr>
            
          <div class="itemLabelNarrow">
            Laws:
          </div>
          <tr v-for="law in laws" :key="law.index">
            <td valign="top">{{law.index}}</td>
            <td>{{law.law}}</td>
          </tr>
        </table>
      </template>
      <template v-else>
        <span class="notice">No laws found.</span>
      </template>

      <template v-if="operational">
        <table>
          <tr>
            <td><span class="itemLabelWidest">Radio Subspace Transceiver</span></td>
            <td><vui-button :params="{ radio: 0 }" v-bind:disabled="radio">Enabled</vui-button></td>
            <td><vui-button class="danger" :params="{ radio: 1 }" v-bind:disabled="!radio">Disabled</vui-button></td>
          </tr>
          <tr>
            <td><span class="itemLabelWidest">Wireless Interface</span></td>
            <td><vui-button :params="{ wireless: 0 }" v-bind:disabled="wireless">Enabled</vui-button></td>
            <td><vui-button class="danger" :params="{ wireless: 1 }" v-bind:disabled="!wireless">Disabled</vui-button></td>
          </tr>

          <tr v-if="flushing">
            <td><span class="notice">AI wipe in progress...</span></td>
          </tr>
          <tr v-else>
            <td><span class="itemLabelWidest">Wipe AI</span></td>
            <td><vui-button class="danger" :params="{ wipe: 1 }">Wipe</vui-button></td>
          </tr>
        </table>
      </template>
    </template>
    <template v-else>
      Stored AI: <span class="notice">No AI detected.</span>
    </template>
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
table.borders   {
    width:95%; 
    margin-left:2.4%; 
    margin-right:2.4%;
}

table.borders, table.borders tr {
    border: 1px solid White;
}

td.law_index {
    width: 50px;
}

td.state {
    width: 63px;
    text-align:center; 
}

td.add {
    width: 36px;
}

td.edit {
    width: 36px;
    text-align:center; 
}

td.delete {
    width: 53px;
    text-align:center; 
}

td.law_type {
    width: 65px;
}

td.position {
    width: 37px;
}
</style>