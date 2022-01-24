<template>
  <div>
    <div>
      <h3>Timing Unit:</h3>
      <vui-button v-if="timeractive" :params="{time: 1}">Active</vui-button>
      <vui-button v-else :params="{time: 1}">Inactive</vui-button>
    </div>
    <div>
      <h3>Time Left:</h3>
      <vui-button :params="{tp: -30}">--</vui-button>
      <vui-button :params="{tp: -1}">-</vui-button>
      <span class="value">{{minute}}:{{second}}</span>
      <vui-button :params="{tp: 1}">+</vui-button>
      <vui-button :params="{tp: 30}">++</vui-button>
    </div>
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
.value {
  color: white;
  font-size: 140%;
  background-color: rgba(0, 0, 0, 0.4);
  padding-left: 5px;
  padding-right: 5px;
  border: 1px solid #40628a;
}
</style>