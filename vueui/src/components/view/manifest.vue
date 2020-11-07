<template>
  <div>
    <table class="pmon">
      <tr v-for="(el, i) in fixedmanifest" :key="i" :class="{ head: el.head }">
        <th v-if="el.header" colspan="3" :class="el.class">{{ el.header }}</th>
        <template v-else>
          <td>{{ el.name }}</td>
          <td>{{ el.rank }}</td>
          <td>{{ el.active }}</td>
        </template>
      </tr>
    </table>
    <div style="text-align: center; margin-top: 1em">
      <vui-button v-if="allow_printing" :params="{ action: 'print' }" icon="print">Print current manifest</vui-button>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return this.$root.$data.state
  },
  computed: {
    fixedmanifest() {
      var entries = Object.entries(this.manifest)
        .filter(([, crew]) => !!crew.length)
        .flatMap(([name, crew]) =>
          [
            {
              header: name,
              class: "bg-dept-" + name.toLowerCase(),
            },
            crew,
          ].flat()
        )
      return entries
    },
  },
}
</script>

<style lang="scss" scoped>
table {
  background-color: rgba(0, 0, 0, 0.4);
  border: 2px solid RoyalBlue;
  width: 100%;

  td,
  th {
    border-bottom: 1px dotted black;
    padding: 0px 5px;
    width: auto;
  }

  th {
    font-weight: bold;
    color: #ffffff;
  }

  .head {
    font-weight: bold;
  }
}
</style>
