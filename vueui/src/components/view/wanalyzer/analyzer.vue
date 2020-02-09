<template>
  <div>
    <div v-if="$root.$data.assets['object-icon']">
        <vui-img name="object-icon"/>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return this.$root.$data.state; // Make data more easily accessible
  }
};
</script>