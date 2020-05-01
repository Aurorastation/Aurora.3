<template>
  <div>
    <vui-button :params="{refresh: 1}">Refresh</vui-button> <vui-button :params="{closefile: 1}">Exit</vui-button>
    <h2>{{running_name}}</h2>
    <div class="item">
      <div class="itemContent" style="width: 100%; font-family: monospace; line-height:8pt; font-size:8pt; text-align:center;">
        <span id="ntsl_terminalbody" v-html="terminal"/>
      </div>
    </div>
  </div>
</template>
<!-- Can't scope due to custom HTML injection. Shoot me if you use ntsl_terminalbody as an ID for something else -->
<style lang="scss">
#ntsl_terminalbody a{
  background: none;
  border: none;
  float: none;
  vertical-align: baseline;
  height:0px;
  line-height: 0px;
  padding: 0 0 0 0;
  margin: 0 0 0 0;
  box-sizing: revert;
  &:hover {
    background-color: none;
    cursor: pointer;
  }
}
</style>
<script>
export default {
  data() {
    return this.$root.$data.state
  },
  watch: {
    last_update(newVal, oldVal){
      if(newVal > oldVal){ // Ensure updates are done in chronological order
        var blok = document.getElementById("ntsl_terminalbody")
        if(blok){
          blok.innerHTML = this.terminal;
        }
      }
    }
  }
}
</script>