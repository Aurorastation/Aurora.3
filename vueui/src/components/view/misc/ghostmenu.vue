<template>
  <div>
    <div v-for="(cat, catname) in menuinfo" :key="cat">
      <h3>{{ catname }}</h3>
      <vui-button v-for="thing in cat" :class="{'button' : 1}" :params="{ follow_target: thing.ref }" :key="thing.ref">{{ thing.name }}</vui-button>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return this.$root.$data.state;
  }
}
</script>