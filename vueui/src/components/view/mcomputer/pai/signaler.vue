<template>
  <div>
    <vui-group>
      <vui-group-item label="Frequency:">
        <vui-button :params="{freq:-10}">--</vui-button>
        <vui-button :params="{freq:-2}">-</vui-button>
        <span class="value-setting">{{ frequency }}</span>
        <vui-button :params="{freq:2}">+</vui-button>
        <vui-button :params="{freq:10}">++</vui-button>
      </vui-group-item>
      <vui-group-item label="Code:">
        <vui-button :params="{code:-10}">--</vui-button>
        <vui-button :params="{code:-2}">-</vui-button>
        <span class="value-setting">{{ code }}</span>
        <vui-button :params="{code:2}">+</vui-button>
        <vui-button :params="{code:10}">++</vui-button>
      </vui-group-item>
      <vui-group-item>
        <vui-button :params="{send: 1}">Send</vui-button>
      </vui-group-item>
    </vui-group>
  </div>
</template>

<script>
export default {
  data() {
    return this.$root.$data.state;
  }
}
</script>

<style lang="scss" scoped>
.value-setting {
  width: 5em;
  display: inline-block;
  text-align: center;
}
</style>