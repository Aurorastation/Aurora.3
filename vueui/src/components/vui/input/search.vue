<template>
  <input type="text" placeholder="Search..." v-model="searchValue">
</template>

<script>
import Fuse from 'fuse.js';

export default {
  data() {
    return {
      fuse: null,
      searchValue: ""
    }
  },
  mounted() {
    this.onFieldUpdate(this.searchValue)
  },
  props: {
    keys: {
      type: Array
    },
    input: {
      type: Array
    },
    value: {
      type: Array
    }
  },
  watch: {
    keys: function (newValue, oldValue) {
      this.fuse = null;
    },
    input: function (newValue, oldValue) {
      this.onFieldUpdate(this.searchValue)
    },
    searchValue: function (newValue, oldValue) {
      this.onFieldUpdate(newValue)
    }
  },
  methods: {
    onFieldUpdate(value) {
      this.initFuse();
      var searchResult = this.fuse.search(value)
      if(searchResult.length == 0) {
        searchResult = this.input;
      }
      this.$emit('input', searchResult)
    },
    initFuse() {
      if(this.fuse != null) {
        this.fuse.setCollection(this.input)
        return
      }
      var options = {
        shouldSort: true,
        findAllMatches: true,
        keys: this.keys
      };
      this.fuse = new Fuse(this.input, options);
    }
  }
}
</script>

<style>

</style>
