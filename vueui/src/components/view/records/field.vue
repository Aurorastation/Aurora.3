<template>
  <div>
    <template v-if="!reditable && !editButton">{{ rvalue }}</template>
    <vui-button v-else-if="!editing && (reditable || editButton)" @click="beginEditing">{{ editbtnname }}</vui-button>
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
    },
    editButton: {
      type: String,
      default: null
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
      return this.value
    },
    editbtnname() {
      if(this.editButton) {
        return this.editButton
      }
      return this.rvalue
    }
  },
  methods: {
    beginEditing() {
      if(!this.reditable && !this.editButton) return
      this.$root.$emit("record-field-start-editing")
      this.gdata.state.editingvalue = this.rvalue
      this.startEditHandler = () => {
        this.endEditing()
      }
      this.$root.$on("record-field-start-editing", this.startEditHandler)
      this.editing = true
    },
    endEditing() {
      if(!this.reditable && !this.editButton) return
      this.editing = false
      this.$root.$off("record-field-start-editing", this.startEditHandler)
    },
    save() {
      if(!this.reditable && !this.editButton) return
      this.endEditing()
      if(this.editButton) {
        this.$emit("save", this.gdata.state.editingvalue)
        return
      }
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

