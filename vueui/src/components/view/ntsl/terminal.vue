<template>
  <component class="terminal" :is="term" />
</template>

<script>
const co = {
  props: ["fg", "bg"],
  computed: {
    style() {
      return {
        color: "#" + this.fg,
        "background-color": "#" + this.bg,
      }
    },
  },
  template: '<span :style="style"><slot/></span>',
}

const to = {
  props: ["to"],
  methods: {
    invoke() {
      this.$toTopic({
        terminal_topic: this.to,
      })
    },
  },
  template:
    '<span style="cursor: pointer;" @click.prevent="invoke"><slot/></span>',
}
export default {
  props: {
    buffer: {
      type: String,
      default: "",
    },
  },
  computed: {
    term() {
      return {
        components: {
          co,
          to,
        },
        template: `<div>${this.buffer}</div>`,
      }
    },
  },
}
</script>

<style lang="scss" scoped>
.terminal {
  width: 100%;
  font-family: monospace;
  line-height: 1em;
  font-size: 1em;
  text-align: center;
}
</style>
