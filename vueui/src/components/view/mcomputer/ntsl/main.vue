<template>
  <div>
    <component :is="&quot;view-mcomputer-ntsl-&quot; + s.mode"/>
  </div>
</template>

<script>
export default {
  data() {
    return {
      s: this.$root.$data.state
    }
  }
}
</script>