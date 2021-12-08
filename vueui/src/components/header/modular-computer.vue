<template>
  <header-default>
    <div class="maincont">
      <b>{{ time }}</b>
      <img
        v-if="state._PC.batteryicon && state._PC.showbatteryicon"
        :src="state._PC.batteryicon"
      >
      <b v-if="state._PC.batterypercent && state._PC.showbatteryicon">{{
        state._PC.batterypercent
      }}</b>
      <img v-if="state._PC.ntneticon" :src="state._PC.ntneticon" >
      <img v-if="state._PC.apclinkicon" :src="state._PC.apclinkicon" >
      <div style="float: right;">
        <vui-button
          :params="{ PC_togglelight: 1 }"
          :class="{ active: state._PC.flashlight }"
          icon="lightbulb"
          icon-only
        />
        <template v-if="state._PC.showexitprogram">
          <vui-button
            :params="{ PC_minimize: 1 }"
            icon="window-minimize"
            icon-only
          />
          <vui-button
            type="danger"
            :params="{ PC_exit: 1 }"
            icon="times"
            icon-only
          />
        </template>
        <template v-else>
          <vui-button
            type="danger"
            :params="{ PC_shutdown: 1 }"
            icon="power-off"
            icon-only
          />
        </template>
      </div>
    </div>
  </header-default>
</template>

<script>
import { worldtime2text } from "@/utils"

export default {
  data() {
    return this.$root.$data
  },
  computed: {
    time() {
      return worldtime2text(this.wtime)
    },
  },
}
</script>

<style lang="scss" scoped>
.maincont {
  padding: 0.5rem;
  padding-top: 0.5rem;
  padding-bottom: 0.5rem;
  * {
    vertical-align: middle;
  }
}
</style>
