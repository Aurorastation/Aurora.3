<template>
  <div>
    <vui-group>
      <vui-group-item label="Cable:">
        <span v-if="connected">Connected</span>
        <span v-else-if="extended">Extended</span>
        <vui-button v-else :params="{extend: 1}">Retracted</vui-button>
      </vui-group-item>
      <vui-group-item v-if="connected" label="Hack:">
        <template v-if="ishacking">
          <vui-progress :max="1000" :value="progress">{{ progress / 10 }}%</vui-progress>
          <vui-button :params="{cancel: 1}">Cancel</vui-button>
        </template>
        <vui-button v-else :params="{hack: 1}">Start</vui-button>
      </vui-group-item>
      <vui-group-item v-else-if="aborted">
        <div class="bad">Hack aborted!</div>
      </vui-group-item>
    </vui-group>
  </div>
</template>

<script>
export default {
  data() {
    return this.$root.$data.state
  }
}
</script>

<style lang="scss" scoped>

</style>