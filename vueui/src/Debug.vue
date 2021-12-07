<template>
  <div>
    <h2>Debug this UI with inspector by opening URL in your browser:</h2>
    <pre>{{ url }}</pre>
    <h2>Current data of UI:</h2>
    <pre>{{ JSON.stringify(this.$root.$data, null, "    ") }}</pre>
    <button class="btn btn-danger" @click="stop()">STOP WTIME TRACKING</button>
  </div>
</template>

<script>
export default {
  methods: {
    stop() {
      window.clearInterval(window.__wtimetimer)
    },
  },
  computed: {
    url() {
      return window.location.href + "?ext"
    },
  },
}
</script>
