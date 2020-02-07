<template>
  <div v-if="$root.$data.assets['object-icon']" class="photos">
      <vui-img name="object-icon"/><br>
    </div>
</template>

<script>
export default {
  data() {
    return this.$root.$data.state; // Make data more easily accessible
  }
};
</script>