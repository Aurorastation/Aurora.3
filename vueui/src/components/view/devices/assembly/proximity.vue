<template>
  <div>
    <div>
      <h3>Auxiliary Timing Unit:</h3>
      <vui-button v-if="timeractive" :params="{time: 1}">Arming</vui-button>
      <vui-button v-else :params="{time: 1}">Not Arming</vui-button>
    </div>
    <div>
      <h3>Time Left:</h3>
      <vui-button :params="{tp: -30}">--</vui-button>
      <vui-button :params="{tp: -1}">-</vui-button>
      <span class="value">{{minute}}:{{second}}</span>
      <vui-button :params="{tp: 1}">+</vui-button>
      <vui-button :params="{tp: 30}">++</vui-button>
    </div>
    <div>
      <h3>Scanning:</h3>
      <vui-button v-if="scanning" :params="{scanning: 1}">Armed</vui-button>
      <vui-button v-else :params="{scanning: 1}">Not Armed</vui-button>
      <span class="value">Movement sensor active when armed!</span>
    </div>
    <div>
      <h3>Range:</h3>
      <vui-button :params="{range: -1}">-</vui-button>
      <span class="value">{{range}}</span>
      <vui-button :params="{range: 1}">+</vui-button>
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