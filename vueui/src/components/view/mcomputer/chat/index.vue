<template>
  <div>
    <h2 v-if="!s.service" class="red">Chat service is not enabled, please enble it from main menu.</h2>
    <template v-else>
      <div>
        <vui-button v-if="s.can_netadmin_mode || s.netadmin_mode" :class="{ on: s.netadmin_mode }" :params="{toggleadmin: 1}">Adm</vui-button>
        <vui-button :class="{ on: active == null }" @click="active = null">Explore</vui-button>
        <vui-button v-for="ref in tab_channels" :key="ref" :class="{ on: active == ref }" @click="active = ref">{{ s.channels[ref].title }}</vui-button>
      </div>
      <hr>
      <view-mcomputer-chat-explore v-if="active == null"/>
      <view-mcomputer-chat-chat v-else :reference="active" @on-leave="active = null"/>
    </template>
  </div>
</template>

<script>
export default {
  data() {
    return {
      s: this.$root.$data.state,
      active: null
    };
  },
  computed: {
    tab_channels() {
      return Object.keys(this.s.channels).filter(key => this.s.channels[key].can_interact)
    }
  }
}
</script>