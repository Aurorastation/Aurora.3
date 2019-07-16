<template>
  <header-default>
    <div class="maincont">
      <img class="valign" v-if="state._PC.batteryicon && state._PC.showbatteryicon" :src="state._PC.batteryicon">
      <b class="valign" v-if="state._PC.batterypercent && state._PC.showbatteryicon">{{state._PC.batterypercent}}</b>
      <img img class="valign" v-if="state._PC.ntneticon" :src="state._PC.ntneticon">
      <img img class="valign" v-if="state._PC.apclinkicon" :src="state._PC.apclinkicon">
      <!-- <img v-for=""  :src=''> -->
      <div style="float: right;">
        <vui-button :params="{ PC_shutdown: 1}">Shutdown</vui-button>
        <template v-if="state._PC.showexitprogram">
          <vui-button :params="{ PC_exit: 1}">Exit Program</vui-button>
          <vui-button :params="{ PC_minimize: 1}">Minimize Program</vui-button>
        </template>
      </div>
    </div>
  </header-default>
</template>

<script>
export default {
  data() {
    return this.$root.$data
  }
}
</script>

<style lang="scss" scoped>
.maincont {
  padding: 4px;
  padding-bottom: 0px;
  margin-bottom: -4px;
  .valign {
    vertical-align: middle;
  }
}
</style>


