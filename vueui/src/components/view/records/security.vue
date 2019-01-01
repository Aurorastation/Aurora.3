<template>
  <div v-if="active">
    <view-records-general hideAdvanced/>
    <vui-item label="Criminal Status:"><view-records-field :editable="(editable & 4) > 0" path="active.security.criminal"/></vui-item>
    <vui-item label="Crimes:"><view-records-field :editable="(editable & 4) > 0" path="active.security.crimes"><textarea v-model="$root.$data.state.editingvalue"></textarea></view-records-field></vui-item>
    <vui-item label="Incidents:">
      <div v-for="incident in active.security.incidents" :key="incident">{{ incident }}</div>
      <div v-if="active.security.incidents.length == 0">There are no incidents.</div>
    </vui-item>
    <vui-item label="Comments:">
      <div v-for="comment in active.security.comments" :key="comment">{{ comment }}</div>
      <div v-if="active.security.comments.length == 0">There are no comments.</div>
    </vui-item>
    <vui-item label="Notes:"><view-records-field :editable="(editable & 4) > 0" path="active.security.notes"><textarea v-model="$root.$data.state.editingvalue"></textarea></view-records-field></vui-item>
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
