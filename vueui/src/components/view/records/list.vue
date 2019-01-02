<template>
  <div>
    <div v-for="record in allrecords" :key="record.id" v-if="record">
      <vui-button :params="{ setactive: record.id}" @click="activeview = defaultview" push-state>{{ record.id }}: {{ record.name }}</vui-button>
    </div>
    <vui-button :params="{ newrecord: 1 }" @click="activeview = defaultview" push-state>New record</vui-button>
  </div>
</template>

<script>
export default {
  data() {
    return this.$root.$data.state
  }
}
</script>