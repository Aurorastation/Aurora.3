<template>
    <div>
      <vui-item label="ID:">{{ active_virus.id }}</vui-item>
      <vui-item label="Description:" v-html="active_virus.description"></vui-item>
      <vui-item label="Notes:">{{ active_virus.notes }}</vui-item>
    </div>
</template>

<script>
export default {
  data() {
    return this.$root.$data.state
  }
}
</script>
