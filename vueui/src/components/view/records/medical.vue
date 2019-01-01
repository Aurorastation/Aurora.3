<template>
  <div v-if="active">
    <view-records-general hideAdvanced/>
    <vui-item label="Blood type:"><view-records-field :editable="(editable & 2) > 0" path="active.medical.blood_type"/></vui-item>
    <vui-item label="DNA:"><view-records-field :editable="(editable & 2) > 0" path="active.medical.blood_dna"/></vui-item>
    <vui-item label="Disabilities:"><view-records-field :editable="(editable & 2) > 0" path="active.medical.disabilities"><textarea v-model="$root.$data.state.editingvalue"></textarea></view-records-field></vui-item>
    <vui-item label="Allergies:"><view-records-field :editable="(editable & 2) > 0" path="active.medical.allergies"><textarea v-model="$root.$data.state.editingvalue"></textarea></view-records-field></vui-item>
    <vui-item label="Diseases:"><view-records-field :editable="(editable & 2) > 0" path="active.medical.diseases"><textarea v-model="$root.$data.state.editingvalue"></textarea></view-records-field></vui-item>
    <vui-item label="Comments:">
      <div v-for="comment in active.medical.comments" :key="comment">{{ comment }}</div>
      <div v-if="active.medical.comments.length == 0">There are no comments.</div>
    </vui-item>
    <vui-item label="Notes:"><view-records-field :editable="(editable & 2) > 0" path="active.medical.notes"><textarea v-model="$root.$data.state.editingvalue"></textarea></view-records-field></vui-item>
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
