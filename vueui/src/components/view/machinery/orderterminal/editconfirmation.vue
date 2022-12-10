<template>
  <div>
    <h3> Activating Configuration Mode</h3>
    <span> Swipe id card to enter configuration mode.<br></span>
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