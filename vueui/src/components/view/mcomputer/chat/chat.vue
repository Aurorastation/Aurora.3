<template>
  <div>
    <h3>{{ channel.title }}</h3>
    <div>
      <template v-if="!channel.direct">
        <vui-button :params="{leave: reference}" @click="$emit('on-leave')">Leave</vui-button>
      </template>
      <template v-if="channel.can_manage">
        <template v-if="password != null">
          <input type="text" v-model="password">
          <vui-button @click="set_password">Set password</vui-button>
        </template>
        <vui-button v-else-if="!channel.direct" @click="password = ''">Set password</vui-button>
        <vui-button :params="{delete: reference}">Delete channel</vui-button>
      </template>
    </div>
    <div>
      <div v-for="(user, uref) in channel.users" :key="uref">
        {{ user }}
        <vui-button v-if="channel.can_manage && !channel.direct" :params="{kick: {target: reference, user: uref}}">Kick</vui-button>
      </div>
    </div>
    <div>
      <input ref="msg" class="message-input" type="text" v-model="send_buffer" @keyup.enter="send_msg"/>
      <vui-button @click="send_msg">Send</vui-button>
    </div>
    <div class="message-chat" ref="chat">
      <div v-for="(msg, index) in messages" :key="index">{{ msg }}</div>
      <span ref="chatend"></span>
    </div>
  </div>
</template>

<script>
import utils from "@/utils"
export default {
  data() {
    return {
      s: this.$root.$data.state,
      send_buffer: "",
      password: null
    }
  },
  computed: {
    channel() {
      return this.s.channels[this.reference]
    },
    messages() {
      return this.channel.msg.reverse()
    }
  },
  props: {
    reference: {
      type: String,
      default: "",
    },
  },
  methods: {
    send_msg() {
      utils.sendToTopic({
        send: { message: this.send_buffer, target: this.reference },
      })
      this.send_buffer = ""
    },
    set_password() {
      utils.sendToTopic({set_password: {target: this.reference, password: this.password}})
      this.password = null
    }
  }
}
</script>

<style lang="scss" scoped>
.message-chat {
  width: 100%;
  background: #000000;
  color: #ffffff;
  border: 1px solid #40628a;
  padding: 0.4em;
  box-sizing: border-box;
}
</style>