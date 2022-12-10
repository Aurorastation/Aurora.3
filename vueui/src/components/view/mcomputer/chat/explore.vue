<template>
  <div>
    <template v-if="channelTitle != null">
      <input type="text" v-model="channelTitle" @keydown.enter="new_channel()">
      <vui-button @click="new_channel()">New channel</vui-button>
    </template>
    <vui-button v-else @click="channelTitle = ''">New channel</vui-button><br>
    <view-mcomputer-chat-channel-btn v-for="ref in displayed" :key="ref" :re="ref" :ch="s.channels[ref]"/>
    <h2>Users:</h2>
    <vui-input-search :input="users" v-model="users_result" :keys="['user']"/><br>
    <div v-for="u in users_result" :key="u.ref"><vui-button :params="{direct: u.ref}">{{ u.user }}</vui-button></div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      s: this.$root.$data.state,
      channelTitle: null,
      users_result: []
    };
  },
  methods: {
    new_channel() {
      this.$toTopic({new_channel: this.channelTitle})
      this.channelTitle = null
    }
  },
  computed: {
    displayed() {
      return Object.keys(this.s.channels).filter(key => !this.s.channels[key].can_interact)
    },
    users() {
      return Object.entries(this.s.users).map(v => ({ref: v[0], user: v[1]}))
    }
  }
}
</script>