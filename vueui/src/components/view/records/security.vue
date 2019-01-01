<template>
  <div v-if="active">
    <view-records-general hideAdvanced/>
    <vui-item label="Criminal Status:"><view-records-field :editable="(editable & 4) > 0" path="active.security.criminal"/></vui-item>
    <vui-item label="Crimes:"><view-records-field :editable="(editable & 4) > 0" path="active.security.crimes"><textarea v-model="$root.$data.state.editingvalue"></textarea></view-records-field></vui-item>
    <vui-item label="Incidents:">
      <div v-for="incident in active.security.incidents" :key="incident">{{ incident }} <vui-button v-if="(editable & 4) > 0" :params="{ removefromrecord: { value: incident, key: ['active', 'security', 'incidents'] }}" icon="trash-alt" class="danger"/></div>
      <div v-if="active.security.incidents.length == 0">There are no incidents.</div>
      <view-records-field v-if="(editable & 4) > 0" edit-button="Add" @save="add('active.security.incidents', $event)"/>
    </vui-item>
    <vui-item label="Comments:">
      <div v-for="comment in active.security.comments" :key="comment">{{ comment }} <vui-button v-if="(editable & 4) > 0" :params="{ removefromrecord: { value: comment, key: ['active', 'security', 'comments'] }}" icon="trash-alt" class="danger"/></div>
      <div v-if="active.security.comments.length == 0">There are no comments.</div>
      <view-records-field v-if="(editable & 4) > 0" edit-button="Add" @save="add('active.security.comments', $event)"/>
    </vui-item>
    <vui-item label="Notes:"><view-records-field :editable="(editable & 4) > 0" path="active.security.notes"><textarea v-model="$root.$data.state.editingvalue"></textarea></view-records-field></vui-item>
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
