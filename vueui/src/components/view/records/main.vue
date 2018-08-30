<template>
  <div>
    <div>
      <vui-button :class="{ selected: activeview == 'list'}" @click="activeview = 'list'">List</vui-button>
      <template v-if="active">
        <vui-button :class="{ selected: activeview == 'general'}" @click="activeview = 'general'">General</vui-button>
        <vui-button :class="{ selected: activeview == 'security'}" :disabled="!active.security" v-if="avaivabletypes & 4" @click="activeview = 'security'">Security</vui-button>
        <vui-button :class="{ selected: activeview == 'medical'}" :disabled="!active.medical" v-if="avaivabletypes & 2" @click="activeview = 'medical'">Medical</vui-button>
        <vui-button :params="{ setactive: 'null'}" @click="activeview = 'list'" push-state>Unload record</vui-button>
      </template>
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


<style lang="scss" scoped>

</style>
 

