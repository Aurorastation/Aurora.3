<template>
  <div v-if="active">
    <div v-if="$root.$data.assets['front']" class="photos">
      <vui-img name="front"/><br>
      <vui-img name="side"/>
    </div>
    <vui-group>
      <vui-group-item label="ID:">{{ active.id }}</vui-group-item>
      <vui-group-item label="Name:"><view-records-field :editable="(editable & 1) > 0" path="active.name"/></vui-group-item>
      <vui-group-item label="Age:"><view-records-field :editable="(editable & 1) > 0" path="active.age"/></vui-group-item>
      <vui-group-item label="Sex:"><view-records-field :editable="(editable & 1) > 0" path="active.sex"/></vui-group-item>
      <vui-group-item label="Rank:"><view-records-field :editable="(editable & 1) > 0" path="active.rank"/></vui-group-item>
      <vui-group-item label="Physical Status:">
        <view-records-field :editable="(editable & 1) > 0" path="active.physical_status">
          <select v-model="$root.$data.state.editingvalue">
            <option v-for="i in choices.physical_status" :key="i" :value="i">{{ i }}</option>
          </select>
        </view-records-field>
      </vui-group-item>
      <vui-group-item label="Mental Status:">
        <view-records-field :editable="(editable & 1) > 0" path="active.mental_status">
          <select v-model="$root.$data.state.editingvalue">
            <option v-for="i in choices.mental_status" :key="i" :value="i">{{ i }}</option>
          </select>
        </view-records-field>
      </vui-group-item>
      <vui-group-item label="Fingerprint:"><view-records-field :editable="(editable & 1) > 0" path="active.fingerprint"/></vui-group-item>
      <template v-if="!hideAdvanced && (avaivabletypes & 1)">
        <vui-group-item label="Species:"><view-records-field :editable="(editable & 1) > 0" path="active.species"/></vui-group-item>
        <vui-group-item label="Citizenship:"><view-records-field :editable="(editable & 1) > 0" path="active.citizenship"/></vui-group-item>
        <vui-group-item label="Religion:"><view-records-field :editable="(editable & 1) > 0" path="active.religion"/></vui-group-item>
        <vui-group-item label="Employer:"><view-records-field :editable="(editable & 1) > 0" path="active.employer"/></vui-group-item>
        <vui-group-item label="Employment/skills summary:"><view-records-field :editable="(editable & 1) > 0" path="active.notes"><textarea v-model="$root.$data.state.editingvalue"/></view-records-field></vui-group-item>
        <vui-group-item label="CCIA Notes:">{{ active.ccia_record }}</vui-group-item>
        <vui-group-item label="CCIA Actions:">
          <div v-for="item in active.ccia_actions" :key="item[0]">
            <h5>{{ item[0] }} <i>({{ item[1] }})</i></h5>
            <div v-html="item[3].replace('\r\n', '<br/>')"/>
            <vui-button :params="{ _openurl: item[4] }">Open</vui-button>
          </div>
        </vui-group-item>
      </template>
      <slot/>
    </vui-group>
    <vui-button v-if="!hideAdvanced && (avaivabletypes & 1)" :params="{ deleterecord: 1 }" icon="trash-alt" class="danger">Delete record</vui-button>
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
  },
  filters: {
    replace(value, needle, substitute) {
      return value.replace(needle, substitute)
    }
  }
}
</script>

<style lang="scss" scoped>
.photos {
  display: inline-block;
  position: absolute;
  right: 0;
  * {
    height: 64px;
    -ms-interpolation-mode: nearest-neighbor;
    image-rendering: crisp-edges;
  }
}
</style>
