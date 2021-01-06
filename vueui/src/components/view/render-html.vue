<template>
  <div v-html="renderHtml">
  </div>
</template>

<script>
export default {
  data() {
    return {renderHtml: this.$root.$data.state.renderdata};
  }
}
</script>