<template>
  <div>
    <h3>Jammer Level:</h3>
    <div>
      <vui-button :class="{ selected: active == 1 }" :params="{ set_active: 1 }">Block All</vui-button>
    </div>
    <div>
      <vui-button :class="{ selected: active == 2 }" :params="{ set_active: 2 }">Block Synthetics</vui-button>
    </div>
    <div>
      <vui-button :class="{ selected: active == -1 }" :params="{ set_active: -1 }">Block Nothing</vui-button>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return this.$root.$data.state
  },
}
</script>
