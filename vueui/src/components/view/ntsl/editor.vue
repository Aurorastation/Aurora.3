<template>
  <editor
    :value="value"
    @input="$emit('input', $event)"
    @init="editorInit"
    lang="javascript"
    theme="monokai"
    width="100%"
    height="50em"
  />
</template>

<script>
export default {
  props: {
    value: {
      type: String,
      default: "",
    },
  },
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
