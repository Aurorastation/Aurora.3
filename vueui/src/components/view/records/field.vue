<template>
  <div>
    <template v-if="!editable">{{ value }}</template>
    <vui-button v-else-if="!editing && editable" @click="beginEditing">{{ value }}</vui-button>
    <template v-else>
      <slot><input v-model="gdata.state.editingvalue"></slot><vui-button @click="save" icon="check"/>
    </template>
  </div>
</template>

<script>
import Utils from '../../../utils.js'
export default {
  data() {
    return {
      editing: false,
      gdata: this.$root.$data,
      startEditHandler: null
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
    editable: {
      type: Boolean,
      default: true,
    }
  },
  methods: {
    beginEditing() {
      this.$root.$emit("record-field-start-editing")
      this.gdata.state.editingvalue = this.value
      this.startEditHandler = () => {
        this.endEditing()
      }
      this.$root.$on("record-field-start-editing", this.startEditHandler)
      this.editing = true
    },
    endEditing() {
      this.editing = false
      this.$root.$off("record-field-start-editing", this.startEditHandler)
    },
    save() {
      this.endEditing()
      Utils.sendToTopic({
        editrecord: {
          value: this.gdata.state.editingvalue,
          key: this.editKey.split(".")
        }
      })
    }
  }
}
</script>

<style>

</style>
