<template>
  <header-default>
    <div class="maincont">
      <img class="valign" v-if="state._PC.batteryicon && state._PC.showbatteryicon" :src="state._PC.batteryicon">
      <b class="valign" v-if="state._PC.batterypercent && state._PC.showbatteryicon">{{state._PC.batterypercent}}</b>
      <img img class="valign" v-if="state._PC.ntneticon" :src="state._PC.ntneticon">
      <img img class="valign" v-if="state._PC.apclinkicon" :src="state._PC.apclinkicon">
      <div style="float: right;">
        <vui-button :params="{ PC_togglelight: 1}" :class="{selected: state._PC.flashlight}" icon="lightbulb" icon-only />
        <template v-if="state._PC.showexitprogram">
          <vui-button :params="{ PC_minimize: 1}" icon="window-minimize" icon-only />
          <vui-button class="danger" :params="{ PC_exit: 1}" icon="window-close" icon-only />
        </template>
        <template v-else>
          <vui-button class="danger" :params="{ PC_shutdown: 1}" icon="power-off" icon-only />
        </template>
      </div>
    </div>
  </header-default>
</template>

<script>
export default {
  data() {
    return this.$root.$data
  },
}
</script>

<style lang="scss" scoped>
button, .button {
  margin-left: 6px;
}
.maincont {
  .valign {
    vertical-align: middle;
  }
}
.uiIcon16 {
  margin-right: 0px;
}
</style>
