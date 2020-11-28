<template>
  <div>
    <vui-button v-if="password == null" @click="join">{{ ch.title }}</vui-button>
    <template v-else>
      <input type="text" v-model="password">
      <vui-button :params="{join: {target: re, password: password}}">Join {{ ch.title }}</vui-button>
    </template>
  </div>
</template>

<script>
import utils from "@/utils"
export default {
  data() {
    return {
      password: null,
    }
  },
  methods: {
    join() {
      if(this.ch.password) {
        this.password = ''
      } else {
        utils.sendToTopic({join: {target: this.re}})
      }
    },
  },
  props: {
    ch: {
      type: Object,
      default: {},
    },
    re: {
      type: String,
      default: "",
    },
  },
}
</script>
