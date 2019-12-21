<template>
  <div>
    <vui-input-search style="display: block;" :input="records" v-model="filtered" :keys="['id', 'name', 'rank', 'sex', 'age', 'fingerprint', 'blood', 'dna']"/>
    <div v-for="record in filtered" :key="record.id">
      <vui-button :params="{ setactive: record.id}" @click="state.activeview = state.defaultview" push-state>{{ record.id }}: {{ record.name }}</vui-button>
    </div>
    <vui-button :params="{ newrecord: 1 }" @click="state.activeview = state.defaultview" push-state>New record</vui-button>
  </div>
</template>

<script>
export default {
  data() {
    return {
      state: this.$root.$data.state,
      filtered: []
    }
    
  },
  computed: {
    records() {
      return Object.values(this.state.allrecords)
    }
  }
}
</script>