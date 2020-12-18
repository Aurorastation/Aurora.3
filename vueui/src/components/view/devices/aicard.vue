<template>
  <div>
    <template v-if="has_ai">
      <vui-group>
        <vui-group-item label="Hardware Integrity">{{ hardware_integrity }}%</vui-group-item>
        <vui-group-item label="Backup Capacitor">{{ backup_capacitor }}%</vui-group-item>
      </vui-group>

      <table v-if="has_laws" class="borders">
        <tr>
          <td class="law_index">Index</td>
          <td>Law</td>
        </tr>

        <div class="itemLabelNarrow">
          Laws:
        </div>
        <tr v-for="law in laws" :key="law.index">
          <td valign="top">{{ law.index }}</td>
          <td>{{ law.law }}</td>
        </tr>
      </table>

      <span class="notice" v-else>
        No laws found.
      </span>

      <vui-group v-if="operational">
        <vui-group-item label="Radio Subspace Transceiver">
          <vui-button :class="{ selected: radio }" :params="{ radio: 0 }">Enabled</vui-button>
          <vui-button :class="{ danger: !radio }" :params="{ radio: 1 }">Disabled</vui-button>
        </vui-group-item>

        <vui-group-item label="Wireless Interface">
          <vui-button :class="{ selected: wireless }" :params="{ wireless: 0 }">Enabled</vui-button>
          <vui-button :class="{ danger: !wireless }" :params="{ wireless: 1 }">Disabled</vui-button>
        </vui-group-item>

        <vui-group-item v-if="flushing">
          <span class="notice">AI wipe in progress...</span>
        </vui-group-item>
        <vui-group-item v-else label="Wipe AI">
          <vui-button class="danger" :params="{ wipe: 1 }">Wipe</vui-button>
        </vui-group-item>
      </vui-group>
    </template>
    <template v-else> Stored AI: <span class="notice">No AI detected.</span> </template>
  </div>
</template>

<script>
export default {
  data() {
    return this.$root.$data.state
  },
}
</script>
