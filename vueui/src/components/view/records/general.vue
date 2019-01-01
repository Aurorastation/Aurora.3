<template>
  <div v-if="active">
    <div class="photos">
      <vui-img name="front"/><br>
      <vui-img name="side"/>
    </div>
    <vui-item label="ID:">{{ active.id }}</vui-item>
    <vui-item label="Name:"><view-records-field :editable="(editable & 1) > 0" path="active.name"/></vui-item>
    <vui-item label="Age:"><view-records-field :editable="(editable & 1) > 0" path="active.age"/></vui-item>
    <vui-item label="Sex:"><view-records-field :editable="(editable & 1) > 0" path="active.sex"/></vui-item>
    <vui-item label="Rank:"><view-records-field :editable="(editable & 1) > 0" path="active.rank"/></vui-item>
    <vui-item label="Phisical Status:"><view-records-field :editable="(editable & 1) > 0" path="active.phisical_status"/></vui-item>
    <vui-item label="Mental Status:"><view-records-field :editable="(editable & 1) > 0" path="active.mental_status"/></vui-item>
    <vui-item label="Fingerprint:"><view-records-field :editable="(editable & 1) > 0" path="active.fingerprint"/></vui-item>
    <template v-if="!hideAdvanced && (avaivabletypes & 1)">
      <vui-item label="Species:"><view-records-field :editable="(editable & 1) > 0" path="active.species"/></vui-item>
      <vui-item label="Citizenship:"><view-records-field :editable="(editable & 1) > 0" path="active.citizenship"/></vui-item>
      <vui-item label="Home System:"><view-records-field :editable="(editable & 1) > 0" path="active.home_system"/></vui-item>
      <vui-item label="Religion:"><view-records-field :editable="(editable & 1) > 0" path="active.religion"/></vui-item>
      <vui-item label="Employment/skills summary:"><view-records-field :editable="(editable & 1) > 0" path="active.notes"><textarea v-model="$root.$data.state.editingvalue"></textarea></view-records-field></vui-item>
      <vui-item label="CCIA Notes:">{{ active.ccia_record }}</vui-item>
      <vui-item label="CCIA Actions:">
        <div v-for="item in active.ccia_record" :key="item[0]">
          <h5>{{ item[0] }} <i>({{ item[1] }})</i></h5>
          <div v-html="item[3].replace('\r\n', '<br/>')">
          </div>
          <a :href="item[4]">Open</a>
        </div>
      </vui-item>
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
