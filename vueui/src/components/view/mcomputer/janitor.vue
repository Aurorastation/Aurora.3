<template>
  <div>
    <table class="table border">
      <tr class="header">
        <th v-for="category in categories" :key="category">
          <vui-button :class="{ selected: category === sel_category }" :params="{ selected: category }">{{
            category
          }}</vui-button>
        </th>
      </tr>
      <template v-if="sel_category">
        <template v-if="supplies.length">
          <tr class="header border">
            <th scope="col">ID</th>
            <th scope="col">Location</th>
            <th scope="col">Direction</th>
            <th scope="col">Status</th>
          </tr>
          <tr v-for="supply in supplies" :key="supply.key" class="item border">
            <td>{{ generateName(supply.name, supply.key) }}</td>
            <td>({{ supply.x }}, {{ supply.y }})</td>
            <td>{{ supply.dir }}</td>
            <td>{{ supply.status }}</td>
          </tr>
          <tr class="header border">
            <td colspan="4">User location: ({{ user_loc.x }}, {{ user_loc.y }})</td>
          </tr>
        </template>
        <tr v-else>
          <td colspan="4">Unable to locate any {{ sel_category.toLowerCase() }} in your vicinity.</td>
        </tr>
      </template>
    </table>
  </div>
</template>

<script>
export default {
  data() {
    return this.$root.$data.state
  },
  methods: {
    generateName(n, k) {
      if (n && !isNaN(k)) {
        k += 1
        return n + ' (#' + k + ')'
      }
    },
  },
}
</script>

<style lang="scss" scoped>
table {
  width: 100%;
  text-align: center;
}
tr {
  line-height: 135%;
}
</style>
