<template>
  <div>
    <div>
      <vui-button icon="cog" class="fixedLeft" :params="{ close: 1 }">Close</vui-button>
    </div>

    <div>
      <h2>Storage</h2>
      <span v-if="secure" class="notice">
        {{
          locked == -1
            ? "Sec.re ACC_** //):securi_nt.diag=>##'or 1=1'%($..."
            : 'Secure Access: Please have your identification ready.'
        }}
      </span>
    </div>

    <template v-if="contents">
      <div v-for="vend_item in contents" :key="vend_item.vend">
        <div>
          <span class="highlight">{{ vend_item.display_name }} ({{ vend_item.quantity }} available)</span>
        </div>
        <div style="float: left;">Vend:&nbsp;</div>
        <vui-button :params="{ vendItem: vend_item.vend, amount: 1 }" class="statusValue" icon="arrow-alt-circle-down"
          >x1</vui-button
        >
        <vui-button
          v-if="vend_item.quantity >= 5"
          :params="{ vendItem: vend_item.vend, amount: 5 }"
          class="statusValue"
          icon="arrow-alt-circle-down"
          >x5</vui-button
        >
        <vui-button
          v-if="vend_item.quantity >= 10"
          :params="{ vendItem: vend_item.vend, amount: 10 }"
          class="statusValue"
          icon="arrow-alt-circle-down"
          >x10</vui-button
        >
        <vui-button
          v-if="vend_item.quantity >= 25"
          :params="{ vendItem: vend_item.vend, amount: 25 }"
          class="statusValue"
          icon="arrow-alt-circle-down"
          >x25</vui-button
        >
        <vui-button
          v-if="vend_item.quantity > 1"
          :params="{ vendItem: vend_item.vend, amount: vend_item.quantity }"
          class="statusValue"
          icon="arrow-alt-circle-down"
          >All</vui-button
        >
      </div>
    </template>
    <div v-else class="average">
      No products loaded.
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return this.$root.$data.state
  },
}
</script>
