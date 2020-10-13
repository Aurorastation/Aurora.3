<template>
  <div>
    <div>
      <vui-button v-if="avaivabletypes & 7" :class="{ selected: activeview == 'list'}" @click="activeview = 'list'">List</vui-button>
      <vui-button v-if="avaivabletypes & 8" :class="{ selected: activeview == 'list-locked'}" @click="activeview = 'list-locked'">List (Locked)</vui-button>
      <template v-if="active">
        <vui-button :class="{ selected: activeview == 'general'}" v-if="avaivabletypes & 1" @click="activeview = 'general'">General</vui-button>
        <vui-button :class="{ selected: activeview == 'security'}" :disabled="!active.security" v-if="avaivabletypes & 4" @click="activeview = 'security'">Security</vui-button>
        <vui-button :class="{ selected: activeview == 'medical'}" :disabled="!active.medical" v-if="avaivabletypes & 2" @click="activeview = 'medical'">Medical</vui-button>
      </template>
      <vui-button style="position: absolute; right: 12px;" :params="{ logout: 1 }">Logout</vui-button>
    </div>
    <hr>
    <component v-if="activeview" :is="&quot;view-records-&quot; + activeview"/>
  </div>
</template>

<script>
export default {
  data() {
    return this.$root.$data.state
  }
}
</script>

<style>
.logout {
  margin-right: 0;
  margin-left: auto;
}
</style>