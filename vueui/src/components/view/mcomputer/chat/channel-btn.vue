<template>
  <div>
    <vui-button v-if="password == null" @click="join">{{ ch.title }}</vui-button>
    <template v-else>
      <input type="text" v-model="password" @keydown.enter="join_with">
      <vui-button :params="{join: {target: re, password: password}}">Join {{ ch.title }}</vui-button>
    </template>
  </div>
</template>

<script>
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
        this.$toTopic({join: {target: this.re}})
      }
    },
    join_with() {
      this.$toTopic({join: {target: this.re, password: this.password}})
    }
  },
  props: {
    ch: {
      type: Object,
      default: () => ({}),
    },
    re: {
      type: String,
      default: "",
    },
  },
}
</script>
