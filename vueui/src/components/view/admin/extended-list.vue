<template>
  <div>
    <table>
      <ul v-for="(v, k) in listvar" :key="k">
        <li>{{k}}: {{v}}</li>
      </ul>
    </table>
  </div>
</template>

<script>
export default {
  data() {
    return this.$root.$data.state
  }
}
</script>
