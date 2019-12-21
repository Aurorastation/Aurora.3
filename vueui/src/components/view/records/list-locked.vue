<template>
  <div>
    <vui-input-search :input="records" v-model="filtered" :keys="['id', 'name', 'rank']"/>
    <div v-for="record in filtered" :key="record.id">
      <vui-button :params="{ setactive_locked: record.id}" @click="activeview = defaultview" push-state>{{ record.id }}: {{ record.name }}</vui-button>
    </div>
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
      return Object.values(this.state.allrecords_locked)
    }
  }
}
</script>
