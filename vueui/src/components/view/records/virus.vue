<template>
  <div>
    <vui-item label="ID:">{{ active_virus.id }}</vui-item>
    <vui-item label="Description:" v-html="active_virus.description"/>
    <vui-item label="Notes:"><view-records-field :editable="(editable & 32) > 0" path="active_virus.notes"><textarea v-model="$root.$data.state.editingvalue"/></view-records-field></vui-item>
  </div>
</template>

<script>
export default {
  data() {
    return this.$root.$data.state
  }
}
</script>
