<template>
  <div v-if="active">
    <vui-item label="ID:">{{ active.id }}</vui-item>
    <vui-item label="Name:">{{ active.name }}</vui-item>
    <vui-item label="Age:">{{ active.age }}</vui-item>
    <vui-item label="Sex:">{{ active.sex }}</vui-item>
    <vui-item label="Rank:">{{ active.rank }}</vui-item>
    <vui-item label="Phisical Status:">{{ active.phisical_status }}</vui-item>
    <vui-item label="Mental Status:">{{ active.mental_status }}</vui-item>
    <vui-item label="Fingerprint:">{{ active.fingerprint }}</vui-item>
    <vui-item label="Notes:">{{ active.notes }}</vui-item>
  </div>
</template>

<script>
export default {
  data() {
    return this.$root.$data.state
  }
}
</script>

<style>

</style>
