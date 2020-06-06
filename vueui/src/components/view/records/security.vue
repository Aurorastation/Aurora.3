<template>
  <view-records-general v-if="active" hide-advanced>
    <vui-group-item label="Criminal Status:">
      <view-records-field :editable="(editable & 4) > 0" path="active.security.criminal">
        <select v-model="$root.$data.state.editingvalue">
          <option v-for="i in choices.criminal_status" :key="i" :value="i">{{ i }}</option>
        </select>
      </view-records-field>
    </vui-group-item>
    <vui-group-item label="Crimes:"><view-records-field :editable="(editable & 4) > 0" path="active.security.crimes"><textarea v-model="$root.$data.state.editingvalue"/></view-records-field></vui-group-item>
    
    <vui-group-item label="Comments:">
      <div v-for="comment in active.security.comments" :key="comment">{{ comment }} <vui-button v-if="(editable & 4) > 0" :params="{ removefromrecord: { value: comment, key: ['active', 'security', 'comments'] }}" icon="trash-alt" class="danger"/></div>
      <div v-if="active.security.comments.length == 0">There are no comments.</div>
      <view-records-field v-if="(editable & 4) > 0" edit-button="Add" @save="add('active.security.comments', $event)"/>
    </vui-group-item>
    <vui-group-item label="Notes:"><view-records-field :editable="(editable & 4) > 0" path="active.security.notes"><textarea v-model="$root.$data.state.editingvalue"/></view-records-field></vui-group-item>
    <vui-group-item label="Incidents:">
      <div class="incidents" v-for="(incident, i) in active.security.incidents" :key="i">
        <view-records-incident :incident="incident"/><hr v-if="i+1 < active.security.incidents.length">
      </div>
      <div v-if="active.security.incidents.length == 0">There are no incidents.</div>
    </vui-group-item>
  </view-records-general>
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

<style lang="scss" scoped>
div.incidents {
  background-color: rgba(128, 128, 128, 0.2);
  padding: 4px;
}
</style>

