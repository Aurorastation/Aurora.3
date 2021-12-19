<template>
  <div>
    <vui-button v-if="!hasServers" :params="{ scan: 1 }">Scan</vui-button>
    <vui-button v-if="hasServers" :params="{ clear: 1 }">Clear</vui-button>
    <ul>
      <li v-for="(s, ref) in s.servers" :key="ref">
        <vui-button :params="{ select: ref }"
        >{{ s.name }} ({{ s.id }})</vui-button
        >
      </li>
    </ul>
    <template v-if="s.current">
      <h3>{{ s.current.name }} ({{ s.current.id }})</h3>
      <view-ntsl-terminal :buffer="s.current.terminal" />
      <vui-button :params="{ submit: 1, code: code }"
      >Save and execute</vui-button
      >
      <view-ntsl-editor v-model="code" />
    </template>
  </div>
</template>

<script>
export default {
  data() {
    return {
      s: this.$root.$data.state,
      code: "",
    }
  },
  created() {
    this.code = this.s.current.code
  },
  computed: {
    hasServers() {
      return !Array.isArray(this.s.servers)
    },
  },
  watch: {
    "s.current.code"(newValue) {
      this.code = newValue
    },
  },
}
</script>
