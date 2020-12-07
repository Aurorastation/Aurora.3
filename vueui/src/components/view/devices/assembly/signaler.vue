<template>
  <div>
    <div>
      <vui-button :params="{send: 1}">Send Signal</vui-button>
    </div>
    <div>
      <h3>Frequency:</h3>
      <vui-button :params="{freq: -10}">--</vui-button>
      <vui-button :params="{freq: -2}">-</vui-button>
      <span class="value">{{frequency}}</span>
      <vui-button :params="{freq: 2}">+</vui-button>
      <vui-button :params="{freq: 10}">++</vui-button>
    </div>
    <div>
      <h3>Code:</h3>
      <vui-button :params="{code: -5}">--</vui-button>
      <vui-button :params="{code: -1}">-</vui-button>
      <span class="value">{{code}}</span>
      <vui-button :params="{code: 1}">+</vui-button>
      <vui-button :params="{code: 5}">++</vui-button>
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