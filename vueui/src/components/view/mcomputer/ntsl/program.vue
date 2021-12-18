<template>
  <div>
    <vui-button :params="{ stop: 1 }">Stop</vui-button>
    <br >
    <view-ntsl-terminal :buffer="terminal" />
  </div>
</template>

<script>
export default {
  data() {
    return this.$root.$data.state
  },
}
</script>
