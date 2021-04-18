<template>
  <div>
    <table>
      <ul v-for="listitem in listvar" :key="listitem.key">
        <li>
            {{listitem}}
        </li>
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
