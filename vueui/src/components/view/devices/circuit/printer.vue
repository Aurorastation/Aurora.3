<template>
  <div>
    Metal: <vui-progress :value="s.metal" :max="s.metal_max">{{ s.metal }}/{{ s.metal_max }} sheets</vui-progress><br />
    Circuits avaivable: {{ s.upgraded ? 'Advanced' : 'Regular' }}<br />
    <vui-button v-for="cat in categories" :key="cat" @click="cc = cat" :class="{ selected: cat == cc }">{{
      cat
    }}</vui-button>
    <hr />
    <vui-input-search :input="currentItems" v-model="filtered" :keys="['name', 'desc']" />
    <div v-for="(item, i) in filtered" :key="i">
      <vui-button :disabled="!item.b" :params="{ build: item.path }">{{ item.name }}</vui-button>
      {{ item.desc }}
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      s: this.$root.$data.state,
      cc: 'All',
      filtered: [],
    }
  },
  computed: {
    categories() {
      return ['All', ...Object.keys(this.s.circuits)]
    },
    currentItems() {
      if (this.cc == 'All') {
        return Object.values(this.s.circuits).flat()
      }
      return this.s.circuits[this.cc]
    },
  },
}
</script>
