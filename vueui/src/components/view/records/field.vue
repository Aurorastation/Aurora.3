<template>
  <div>
    <vui-button v-if="!editing" @click="editing = true">{{ value }}</vui-button>
    <template v-else>
      <input v-model="value"><vui-button>Save</vui-button>
    </template>
  </div>
</template>

<script>
export default {
  data() {
    return {
      editing: false
    }
  },
  props: {
    value: {
      type: String,
      default: ""
    },
    editKey: {
      type: String,
      default: ""
    },
  }
}
</script>

<style>

</style>
