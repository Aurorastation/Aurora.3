<template>
  <div>
    <vui-button :params="{close: 1, code: code}">Save and Close</vui-button>
    <vui-button :params="{execute: 1, code: code}">Save and Execute</vui-button>
    <vui-button :params="{close: 1, code: s.code}">Close</vui-button>
    <editor v-model="code" @init="editorInit" lang="javascript" theme="monokai" width="100%" height="50em"/>
  </div>
</template>

<script>
export default {
  data() {
    return {
      s: this.$root.$data.state,
      code: "Term.write(\"AAA\")"
    }
  },
  components: {
    editor: require("vue2-ace-editor"),
  },
  created() {
    this.code = this.s.code
  },
  methods: {
    editorInit: function() {
      require("brace/ext/language_tools") //language extension prerequsite...
      require("brace/mode/javascript") //language
      require("brace/theme/monokai")
      require("brace/snippets/javascript") //snippet
    },
  },
}
</script>