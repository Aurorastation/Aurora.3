<template>
  <div>
    <vui-button :params="{ close: 1, code: code }">Save and Close</vui-button>
    <vui-button :params="{ execute: 1, code: code }"
    >Save and Execute</vui-button
    >
    <vui-button :params="{ close: 1, code: s.code }">Close</vui-button>
    <view-ntsl-editor v-model="code" />
  </div>
</template>

<script>
export default {
  data() {
    return {
      s: this.$root.$data.state,
      code: 'Term.write("AAA")',
    }
  },
  created() {
    this.code = this.s.code
  },
}
</script>
