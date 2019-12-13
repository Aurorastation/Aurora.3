<template>
  <div v-if="active">
    <view-records-general hide-advanced>
      <vui-group-item label="Blood type:">
        <view-records-field :editable="(editable & 2) > 0" path="active.medical.blood_type">
          <select v-model="$root.$data.state.editingvalue">
            <option v-for="i in choices.medical.blood_type" :key="i" :value="i">{{ i }}</option>
          </select>
        </view-records-field>
      </vui-group-item>
      <vui-group-item label="DNA:"><view-records-field :editable="(editable & 2) > 0" path="active.medical.blood_dna"/></vui-group-item>
      <vui-group-item label="Disabilities:"><view-records-field :editable="(editable & 2) > 0" path="active.medical.disabilities"><textarea v-model="$root.$data.state.editingvalue"/></view-records-field></vui-group-item>
      <vui-group-item label="Allergies:"><view-records-field :editable="(editable & 2) > 0" path="active.medical.allergies"><textarea v-model="$root.$data.state.editingvalue"/></view-records-field></vui-group-item>
      <vui-group-item label="Diseases:"><view-records-field :editable="(editable & 2) > 0" path="active.medical.diseases"><textarea v-model="$root.$data.state.editingvalue"/></view-records-field></vui-group-item>
      <vui-group-item label="Comments:">
        <div v-for="comment in active.medical.comments" :key="comment">{{ comment }} <vui-button v-if="(editable & 2) > 0" :params="{ removefromrecord: { value: comment, key: ['active', 'medical', 'comments'] }}" icon="trash-alt" class="danger"/></div>
        <div v-if="active.medical.comments.length == 0">There are no comments.</div>
        <view-records-field v-if="(editable & 2) > 0" edit-button="Add" @save="add('active.medical.comments', $event)"/>
      </vui-group-item>
      <vui-group-item label="Notes:"><view-records-field :editable="(editable & 2) > 0" path="active.medical.notes"><textarea v-model="$root.$data.state.editingvalue"/></view-records-field></vui-group-item>
    </view-records-general>
  </div>
</template>

<script>
import Utils from '../../../utils.js'
export default {
  data() {
    return this.$root.$data.state
  },
  methods: {
    add(path, value) {
      Utils.sendToTopic({
        addtorecord: {
          value: value,
          key: path.split(".")
        }
      })
    }
  }
}
</script>

<style>

</style>
