<template>
  <div>
    <vui-input-search :input="s.reactions" v-model="output" :keys="['result.name', 'reagents.name', 'result.description']" autofocus :threshold="threshold" include-score/>
    <div clsss="recipe-block" v-for="reac in output" :key="reac.item.id" :style="{opacity: 1 - (reac.score * score_multiplier)}">
      <h2 class="highlight">{{ reac.item.result.name }} ({{ u(reac.item.result.amount) }})</h2>
      <p>{{ reac.item.result.description }}</p>
      <h3 class="highlight">Required Reagents</h3>
      <span v-for="r in reac.item.reagents" :key="'re'+r.name+reac.item.result.name">{{ r.name }}: {{ u(r.amount) }}<br></span>
      <template v-if="reac.item.catalysts.length">
        <h3 class="highlight">Catalysts</h3>
        <span v-for="r in reac.item.catalysts" :key="'ca'+r.name+reac.item.result.name">{{ r.name }}: {{ u(r.amount) }}<br></span>
      </template>
      <template v-if="reac.item.inhibitors.length">
        <h3 class="highlight">Inhibitors</h3>
        <span v-for="r in reac.item.inhibitors" :key="'in'+r.name+reac.item.result.name">{{ r.name }}: {{ u(r.amount) }}<br></span>
      </template>
      <template v-if="reac.item.temp_min.length">
        <h3 class="highlight">Minimum required temparatures</h3>
        <span v-for="t in reac.item.temp_min" :key="'tm'+t.name+reac.item.result.name">{{ t.name }}: {{ t.temp }}&deg;K<br></span>
      </template>
      <template v-if="reac.item.temp_max.length">
        <h3 class="highlight">Maximum required temparatures</h3>
        <span v-for="t in reac.item.temp_max" :key="'tx'+t.name+reac.item.result.name">{{ t.name }}: {{ t.temp }}&deg;K<br></span>
      </template>
      <hr>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      s: this.$root.$data.state,
      output: [],
      threshold: 0.3
    }
  },
  methods: {
    u(num) {
      if(num == 1) {
        return `${num} unit`
      } else {
        return `${num} units`
      }
    }
  },
  computed: {
    score_multiplier() {
      return 1 / this.threshold
    }
  }
}
</script>

<style lang="scss" scoped>
</style>