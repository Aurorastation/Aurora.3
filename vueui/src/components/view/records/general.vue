<template>
  <div v-if="active">
    
    <vui-item label="ID:">{{ active.id }}</vui-item>
    <vui-item label="Name:"><view-records-field :value="active.name"/></vui-item>
    <vui-item label="Age:">{{ active.age }}</vui-item>
    <vui-item label="Sex:">{{ active.sex }}</vui-item>
    <vui-item label="Rank:">{{ active.rank }}</vui-item>
    <vui-item label="Phisical Status:">{{ active.phisical_status }}</vui-item>
    <vui-item label="Mental Status:">{{ active.mental_status }}</vui-item>
    <vui-item label="Fingerprint:">{{ active.fingerprint }}</vui-item>
    <template v-if="!hideAdvanced && (avaivabletypes & 1)">
      <vui-item label="Species:">{{ active.species }}</vui-item>
      <vui-item label="Citizenship:">{{ active.citizenship }}</vui-item>
      <vui-item label="Home System:">{{ active.home_system }}</vui-item>
      <vui-item label="Religion:">{{ active.religion }}</vui-item>
      <vui-item label="Employment/skills summary:">{{ active.notes }}</vui-item>
      <vui-item label="CCIA Notes:">{{ active.ccia_record }}</vui-item>
    </template>
  </div>
</template>

<script>
export default {
  data() {
    return this.$root.$data.state
  },
  props: {
    hideAdvanced: {
      type: Boolean,
      default: false
    }
  }
}
</script>

<style>

</style>
