<template>
  <div v-if="active">
    
    <vui-item label="ID:">{{ active.id }}</vui-item>
    <vui-item label="Name:"><view-records-field :value="active.name"/></vui-item>
    <vui-item label="Age:"><view-records-field :value="active.age"><input v-model="editingvalue" type="number" min=0 max=200></view-records-field></vui-item>
    <vui-item label="Sex:"><view-records-field :value="active.sex"/></vui-item>
    <vui-item label="Rank:"><view-records-field :value="active.rank"/></vui-item>
    <vui-item label="Phisical Status:"><view-records-field :value="active.phisical_status"/></vui-item>
    <vui-item label="Mental Status:"><view-records-field :value="active.mental_status"/></vui-item>
    <vui-item label="Fingerprint:"><view-records-field :value="active.fingerprint"/></vui-item>
    <template v-if="!hideAdvanced && (avaivabletypes & 1)">
      <vui-item label="Species:"><view-records-field :value="active.species"/></vui-item>
      <vui-item label="Citizenship:"><view-records-field :value="active.citizenship"/></vui-item>
      <vui-item label="Home System:"><view-records-field :value="active.home_system"/></vui-item>
      <vui-item label="Religion:"><view-records-field :value="active.religion"/></vui-item>
      <vui-item label="Employment/skills summary:"><view-records-field :value="active.notes"><textarea v-model="editingvalue"></textarea></view-records-field></vui-item>
      <vui-item label="CCIA Notes:">{{ active.ccia_record }}</vui-item>
      <vui-item label="CCIA Actions:">
        <div v-for="item in active.ccia_record" :key="item[0]">
          <h5>{{ item[0] }} <i>({{ item[1] }})</i></h5>
          <div>
            {{ item[3] | replace('\r\n', '<br/>') |  }}
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

<style>

</style>
