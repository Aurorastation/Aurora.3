<template>
  <div>
    Testing
    <div v-for="record in allrecords" :key="record.id">
      {{ record.id }}:{{ record.name }} <vui-button :params="{ setactive: record.id}">Activate</vui-button>
    </div>
    <vui-button :params="{ setactive: 'null'}">Activate</vui-button>
  </div>
</template>

<script>
export default {
  data() {
    return this.$root.$data.state
  }
}
</script>


<style lang="scss" scoped>

</style>
 

