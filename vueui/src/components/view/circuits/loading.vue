<template>
  <div>
    <textarea v-model="loading_code" placeholder="Paste your Integrated Assembly schema." style="width: 100%; height: 20em;"/>
    <br>
    <vui-button :params="{mainMenu:1}" @click="load_assembly()">Load</vui-button>
    <vui-button :params="{mainMenu:1}">Cancel</vui-button>
  </div>
</template>

<script>
import Utils from '../../../utils.js'
import Store from '../../../store.js'

export default {
  data() {
    return {
      loading_code: null,
      assembly_data: null,
      global: this.$root.$data
    }
  },
  methods: {
      load_assembly: function() {
          try {
            this.assembly_data = JSON.parse(this.loading_code);
          }
          catch {
            // Report malformed JSON
            Utils.sendToTopic({uiError: "Malformed Assembly schema."})
            return
          }
          // Send parsed info to the server
          // So. Stuff that doesn't work HERE (some work in the template):
          // global.state.uiref, global.state.printer_ref, state.printer_ref, state.uiref, printer_ref, uiref
          // (printer_ref doesn't exist anymore, used to be \ref[src] in the printer, all correct)
          // What works, not quite sure why:
          Utils.sendToTopicRaw({
            src: Store.state.uiref,
            print: 'load', 
            assembly: this.assembly_data['assembly'] ? 
              JSON.stringify(this.assembly_data['assembly']) : null,
            components: this.assembly_data['components'] ? 
              this.assembly_data['components'].map(JSON.stringify) : null,
            wires: this.assembly_data['wires'] ? 
              this.assembly_data['wires'].map(JSON.stringify) : null
          });
      }
  }
};
</script>