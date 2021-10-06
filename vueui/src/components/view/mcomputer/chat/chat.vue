<template>
  <div>
    <h3>{{ channel.title }}</h3>
    <div>
      <template v-if="!channel.direct">
        <vui-button :params="{leave: reference}" @click="$emit('on-leave')">Leave</vui-button>
      </template>
      <template v-if="channel.can_manage">
        <template v-if="password != null">
          <input type="text" v-model="password" @keydown.enter="set_password">
          <vui-button @click="set_password">Set password</vui-button>
        </template>
        <vui-button v-else-if="!channel.direct" @click="password = ''">Set password</vui-button>
        <template v-if="title != null">
          <input type="text" v-model="title" @keydown.enter="set_title">
          <vui-button @click="set_title">Change title</vui-button>
        </template>
        <vui-button v-else-if="!channel.direct" @click="title = channel.title">Change title</vui-button>
        <vui-button :params="{delete: reference}" @click="$emit('on-leave')">Delete channel</vui-button>
      </template>
      <vui-button :class="{'selected': channel.focused == true}" :params="{focus: reference}">{{ channel.focused == true ? "Disable Speech-To-Text" : "Enable Speech-To-Text" }}</vui-button>
    </div>
    <div>
      <div v-for="(user, uref) in channel.users" :key="uref">
        {{ user }}
        <vui-button v-if="channel.can_manage && !channel.direct" :params="{kick: {target: reference, user: uref}}">Kick</vui-button>
      </div>
    </div>
    <div class="message-chat" ref="chat">
      <div v-for="(msg, index) in messages" :key="index">{{ msg }}</div>
    </div>
    <div class="message-container">
      <input class="message-input" type="text" v-model="send_buffer" @keydown.enter="send_msg">
      <vui-button @click="send_msg" class="message-send">Send</vui-button>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      s: this.$root.$data.state,
      send_buffer: "",
      password: null,
      title: null,
      wasAtBottom: true,
    }
  },
  computed: {
    channel() {
      return this.s.channels[this.reference]
    },
    messages() {
      return this.channel.msg
    }
  },
  props: {
    reference: {
      type: String,
      default: ""
    }
  },
  methods: {
    send_msg() {
      this.$toTopic({
        send: { message: this.send_buffer, target: this.reference },
      })
      this.send_buffer = ""
    },
    set_password() {
      this.$toTopic({set_password: {target: this.reference, password: this.password}})
      this.password = null
    },
    set_title() {
      this.$toTopic({change_title: {target: this.reference, title: this.title}})
      this.title = null
    },
    scrollBottom() {
      let chat = this.$refs.chat
      chat.scrollTop = chat.scrollHeight
    }
  },
  mounted() {
    this.scrollBottom()
  },
  beforeUpdate() {
    let chat = this.$refs.chat
    this.wasAtBottom = (chat.scrollHeight - chat.scrollTop === chat.clientHeight)
  },
  updated() {
    if(this.wasAtBottom) {
      this.scrollBottom()
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
  height: 20em;
  overflow-y: scroll;
}

.message-container {
  display: flex;
}

.message-input {
  width: 80%;
  flex-grow: 1;
}
</style>