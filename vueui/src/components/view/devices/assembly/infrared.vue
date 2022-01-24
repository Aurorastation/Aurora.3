<template>
  <div>
    <div>
      <h3>Status:</h3>
      <vui-button v-if="active" :params="{state: 1}">Active</vui-button>
      <vui-button v-else :params="{state: 1}">Inactive</vui-button>
    </div>
    <div>
      <h3>Beam Visibility:</h3>
      <vui-button v-if="visible" :params="{visible: 1}">Visible</vui-button>
      <vui-button v-else :params="{visible: 1}">Invisible</vui-button>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return this.$root.$data.state;
  }
};
</script>