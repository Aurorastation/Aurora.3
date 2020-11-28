<template>
  <div>
    <template v-if="channelTitle != null">
      <input type="text" v-model="channelTitle">
      <vui-button @click="new_channel()">New channel</vui-button>
    </template>
    <vui-button v-else @click="channelTitle = ''">New channel</vui-button><br>
    <view-mcomputer-chat-channel-btn v-for="ref in displayed" :key="ref" :re="ref" :ch="s.channels[ref]"/>
    <h2>Users:</h2>
    <vui-button v-for="(user ,ref) in s.users" :key="ref" :params="{direct: ref}">{{ user}}</vui-button>
  </div>
</template>

<script>
import utils from '@/utils'
export default {
  components: {
    'channel-btn': {
      template: '<div></div>',
      data() {
        return {
          password: null
        }
      },
      methods: {
        join() {

        }
      },
      props: {
        ch: {
          type: Object,
          default: {},
        },
        re: {
          type: String,
          default: '',
        },
      },
    }
  },
  data() {
    return {
      s: this.$root.$data.state,
      channelTitle: null
    };
  },
  methods: {
    new_channel() {
      utils.sendToTopic({new_channel: this.channelTitle})
      this.channelTitle = null
    }
  },
  computed: {
    displayed() {
      return Object.keys(this.s.channels).filter(key => !this.s.channels[key].can_interact)
    }
  }
}
</script>