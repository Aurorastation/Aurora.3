<template>
  <div>
    <div v-for="record in allrecords" :key="record.id">
      <vui-button :params="{ setactive: record.id}" @click="activeview = defaultview" push-state>{{ record.id }}: {{ record.name }}</vui-button>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return this.$root.$data.state
  }
}
</script>
