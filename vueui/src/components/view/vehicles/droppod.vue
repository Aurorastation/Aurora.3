<template>
  <div>
    <h2 class="white">Welcome, Operative.</h2>

    <h2>Please select your launch target:</h2>

    <div v-if="status == 0">
      <div>Pod status: <span class="good">Operational.</span></div>
      <div>
        <vui-button icon="cog" :params="{ fire: 'arrivals' }">Departures</vui-button>
      </div>
      <div>
        <vui-button icon="cog" :params="{ fire: 'cargo' }">Cargo Surface</vui-button>
      </div>
      <div>
        <vui-button icon="cog" :params="{ fire: 'commandescape' }">Command Surface</vui-button>
      </div>
    </div>
    <div v-else>Pod status: <span class="bad">Non-operational.</span></div>
  </div>
</template>

<script>
export default {
  data() {
    return this.$root.$data.state
  },
}
</script>
