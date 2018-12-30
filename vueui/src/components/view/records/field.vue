<template>
  <div>
    <template v-if="!editable">{{ rvalue }}</template>
    <vui-button v-else-if="!editing && editable" @click="beginEditing">{{ rvalue }}</vui-button>
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
    key: {
      type: String,
      default: null
    }
  },
  computed: {
    editable() {
      if(key) {
        return true
      }
      return false
    },
    rvalue() {
      if(key) {
        return Utils.dotNotationRead(this.gdata.state, this.key)
      }
      return value
    }
  },
  methods: {
    beginEditing() {
      if(!this.editable) return
      this.$root.$emit("record-field-start-editing")
      this.gdata.state.editingvalue = this.rvalue
      this.startEditHandler = () => {
        this.endEditing()
      }
      this.$root.$on("record-field-start-editing", this.startEditHandler)
      this.editing = true
    },
    endEditing() {
      if(!this.editable) return
      this.editing = false
      this.$root.$off("record-field-start-editing", this.startEditHandler)
    },
    save() {
      if(!this.editable) return
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
