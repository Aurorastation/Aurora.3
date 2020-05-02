<template>
  <div>
    <h2>An error has occured and this program can not continue.</h2>
    Additional information: {{error}}<br>
    <i>Please try again. If the problem persists contact your system administrator for assistance.</i>
    <vui-button :params="{ closefile: 1 }">Restart program</vui-button>
  </div>
</template>
<script>
export default {
  data() {
    return this.$root.$data.state
  }
}
</script>