<template>
  <div>
    <h2 v-if="!s.registered" class="red">No registered user detected.</h2>
    <template v-else>
      <div>
        <vui-button v-if="s.can_netadmin_mode || s.netadmin_mode" :class="{ on: s.netadmin_mode }" :params="{toggleadmin: 1}">Admin Mode</vui-button>
        Ringtone:
        <vui-button v-if="ringtone == null" @click="ringtone = s.ringtone">{{ s.ringtone }}</vui-button>
        <template v-else>
          <input type="text" v-model="ringtone" @keypress.enter="set_ringtone">
          <vui-button @click="set_ringtone">Set ringtone</vui-button>
        </template>
        <vui-button :class="{'selected': s.message_mute == true}" :params="{mute_message: 1}">{{ s.message_mute == true ? "Unmute Messages" : "Mute Messages" }}</vui-button>
      </div>
      <h2 v-if="!s.signal" class="red">No network signal. Limited functionality available.</h2>
      <template v-else>
        <div>
          <vui-button :class="{ on: active == null }" @click="active = null">Explore</vui-button>
          <vui-button v-for="ref in tab_channels" :key="ref" :class="{ on: active == ref }" @click="active = ref">{{ s.channels[ref].title }}</vui-button>
        </div>
        <hr>
        <view-mcomputer-chat-explore v-if="active == null"/>
        <view-mcomputer-chat-chat v-else :reference="active" @on-leave="active = null"/>
      </template>
    </template>
  </div>
</template>

<script>
export default {
  data() {
    return {
      s: this.$root.$data.state,
      active: null,
      ringtone: null
    };
  },
  computed: {
    tab_channels() {
      return Object.keys(this.s.channels).filter(key => this.s.channels[key].can_interact)
    }
  },
  methods: {
    set_ringtone() {
      this.$toTopic({ringtone: this.ringtone})
      this.ringtone = null
    }
  }
}
</script>
