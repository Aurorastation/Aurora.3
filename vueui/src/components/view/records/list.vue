<template>
  <div>
    <vui-input-search style="display: block;" :input="records" v-model="filtered" :keys="['id', 'name', 'rank', 'sex', 'age', 'fingerprint', 'blood', 'dna']"/>
    <div v-for="record in filtered" :key="record.id">
      <vui-button :params="{ setactive: record.id }" @click="state.activeview = state.defaultview" push-state>{{ record.id }}: {{ record.name }} ({{ record.rank }})</vui-button>
    </div>
    <vui-button class="newrecord" :v-if="(editable & 1) > 0" :params="{ newrecord: 1 }" @click="state.activeview = state.defaultview" push-state>New Record</vui-button>
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

<style lang="scss" scoped>
.newrecord {
  margin-top: 6px;
}
</style>