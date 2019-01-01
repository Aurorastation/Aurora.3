<template>
  <div>
    <template v-if="!reditable">{{ rvalue }}</template>
    <vui-button v-else-if="!editing && reditable" @click="beginEditing">{{ rvalue }}</vui-button>
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
    path: {
      type: String,
      default: null
    },
    editable: {
      type: Boolean,
      default: false
    }
  },
  computed: {
    reditable() {
      if(this.path) {
        return true && this.editable
      }
      return false
    },
    rvalue() {
      if(this.path) {
        return Utils.dotNotationRead(this.gdata.state, this.path)
      }
      return value
    }
  },
  methods: {
    beginEditing() {
      if(!this.reditable) return
      this.$root.$emit("record-field-start-editing")
      this.gdata.state.editingvalue = this.rvalue
      this.startEditHandler = () => {
        this.endEditing()
      }
      this.$root.$on("record-field-start-editing", this.startEditHandler)
      this.editing = true
    },
    endEditing() {
      if(!this.reditable) return
      this.editing = false
      this.$root.$off("record-field-start-editing", this.startEditHandler)
    },
    save() {
      if(!this.reditable) return
      this.endEditing()
      Utils.sendToTopic({
        editrecord: {
          value: this.gdata.state.editingvalue,
          key: this.path.split(".")
        }
      })
    }
  }
}
</script>

<style lang="scss" scoped>
textarea {
  height: 6em;
}
</style>

