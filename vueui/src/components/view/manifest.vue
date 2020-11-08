<template>
  <div>
    <div v-if="manifestLen(fixedmanifest) > 0">
      <table v-for="(el, dept) in fixedmanifest" :key="dept" class="mt-2" :class="'border-dept-' + dept.toLowerCase()">
        <tr :class="'bg-dept-' + dept.toLowerCase()">
          <th colspan="3" class="fw-bold">{{ dept }}</th>
        </tr>
        <tr v-for="entry in el" :key="entry.name" :class="{fwBold: entry.head}">
          <td class="pl-2">{{ entry.name }}</td>
          <td class="px-1">{{ entry.rank }}</td>
          <td class="pr-2 text-right">{{ entry.active }}</td>
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
}
</style>
