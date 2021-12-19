<template>
  <div>
    <vui-input-search :input="ghosts_filtered" v-model="search_results" :keys="['name']" autofocus :threshold="threshold" include-score/>
    <div v-for="cat in ghost_categories" :key="cat">
      <h3>{{ cat }}</h3>
      <vui-button v-for="res in ghosts_category_filtered(cat)" :class="{'button' : 1}" :params="{ follow_target: res.item.ref }" :key="res.item.ref">{{ res.item.name }}</vui-button>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      search_results: [],
      s: this.$root.$data.state,
      threshold: 0.3
    }
  },
  computed: {
    ghosts_filtered() {
      return Object.values(this.s.ghosts).filter(x => x)
    },
    ghost_categories() {
      let cats =  this.s.ghosts.map( g => g.category)
      return [...new Set(cats)] //Gets only the unique categories
    }
  },
  methods: {
    ghosts_category_filtered(cat) {
        return this.search_results.filter(result => result.item.category == cat)
    },
  }
}
</script>
