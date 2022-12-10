<template>
  <div>
    <vui-button :params="{stop: 1}">Stop</vui-button>
    <br>
    <component class="terminal" :is="term"/>
  </div>
</template>

<script>
const co = {
  props: ['fg', 'bg'],
  computed: {
    style() {
      return {
        color: '#' + this.fg,
        'background-color': '#' + this.bg
      }
    }
  },
  template: '<span :style="style"><slot/></span>'
}

const to = {
  props: ['to'],
  methods: {
    invoke() {
      this.$toTopic({
        terminal_topic: this.to
      })
    }
  },
  template: '<span style="cursor: pointer;" @click.prevent="invoke"><slot/></span>'
}

export default {
  data() {
    return {
      s: this.$root.$data.state,

    }
  },
  computed: {
    term() {
      return {
        components: {
          co, to
        },
        template: `<div>${this.s.terminal}</div>`
      }
    }
  }
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