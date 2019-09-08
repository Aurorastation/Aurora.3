<template>
  <div>
    <input v-model="passcode" placeholder="Enter passcode..." autofocus>
    <vui-button :params="{ set_passcode: passcode }">Set</vui-button>
    <vui-button :params="{ lock: 1 }">Lock</vui-button>
  </div>
</template>

<script>
export default {
  data() {
    return this.$root.$data.state;
  }
}
</script>

