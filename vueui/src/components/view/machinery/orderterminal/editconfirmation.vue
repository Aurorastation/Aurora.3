<template>
  <div>
    <h3> Awaiting ID confirmation</h3>
    <span> Swipe id card to enter to configure the terminal.</span>
    <vui-button :params="{ return: 1 }" width="3em">Return to order menu</vui-button>
  </div>
</template>

<script>
export default {
  data() {
    return this.$root.$data.state;
  }
}
</script>