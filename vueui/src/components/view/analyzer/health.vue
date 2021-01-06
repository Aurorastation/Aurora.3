<template>
  <div v-html="analyzerHtml">
  </div>
</template>

<script>
export default {
  data() {
    return {analyzerHtml: this.$root.$data.state.healthdata};
  }
}
</script>