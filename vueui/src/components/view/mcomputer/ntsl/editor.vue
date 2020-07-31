<template>
  <div>
    <editor v-model="content" @init="editorInit" lang="javascript" theme="monokai" width="100%" height="10em"/>
  </div>
</template>

<script>
export default {
  data: () => ({
    content: "Term.write(\"AAA\")"
  }),
  components: {
    editor: require("vue2-ace-editor"),
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