<template>
  <div>
    <div v-if="manifestLen(fixedmanifest) > 0">
      <table v-for="(el, dept) in fixedmanifest" :key="dept" :class="'border-dept-' + dept.toLowerCase()">
        <tr :class="'bg-dept-' + dept.toLowerCase()">
          <th colspan="100%" class="fw-bold">{{ dept }}</th>
        </tr>
        <tr v-for="entry in el" :key="entry.name" :class="{'fw-bold': entry.head}">
          <td>{{ entry.name }}</td>
          <td>{{ entry.rank }}</td>
          <td>{{ entry.active }}</td>
          <td v-if="allow_follow">
            <vui-button :params="{ action: 'follow', name: entry.name }">Follow</vui-button>
          </td>
        </tr>
      </table>
    </div>
    <div v-else class="fst-italic">
      There is no crew.
    </div>
    <div v-if="allow_printing" class="text-center mt-2">
      <vui-button :params="{ action: 'print' }" icon="print">Print current manifest</vui-button>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    let ret = this.$root.$data.state
    ret.manifestLen = function(manif) {
      let len = 0
      Object.values(manif).forEach((val) => len += val.length)
      return len
    }
    return ret
  },
  computed: {
    fixedmanifest() {
      return Object.fromEntries(Object.entries(this.manifest).filter(([, crew]) => Object.entries(crew).length > 0))
    },
  },
}
</script>

<style lang="scss" scoped>
table {
  width: 100%;
  border-collapse: collapse;
  color: white;
  background-color: rgba(0, 0, 0, 0.6);
  border: 2px solid;
  margin-top: .5rem;

  td {
    padding-left: .5rem;
    padding-right: .5rem;
  }

  // middle (rank) column
  td:nth-child(2) {
    width: 12.5rem;
  }

  // last (activity) column
  td:last-child {
    text-align: right;
    width: 6.5rem;
  }
}
</style>
