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
      type: Array,
      default() {
        return [];
      }
    },
    includeScore: {
      type: Boolean,
      default: false
    },
    threshold: {
      type: Number,
      default: 0.6
    },
    input: {
      type: Array,
      default() {
        return [];
      }
    },
    value: {
      type: Array,
      default() {
        return [];
      }
    }
  },
  watch: {
    keys() {
      this.fuse = null;
    },
    includeScore() {
      this.fuse = null;
    },
    threshold() {
      this.fuse = null;
    },
    input() {
      this.onFieldUpdate(this.searchValue)
    },
    searchValue(newValue) {
      this.onFieldUpdate(newValue)
    }
  },
  methods: {
    onFieldUpdate(value) {
      this.initFuse();
      var searchResult = this.fuse.search(value)
      if(searchResult.length == 0) {
        if(this.includeScore) {
          searchResult = this.input.map(x => ({item: x, score: 0}))
        } else {
          searchResult = this.input;
        }
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
        keys: this.keys,
        includeScore: this.includeScore,
        threshold: this.threshold
      };
      this.fuse = new Fuse(this.input, options);
    }
  }
}
</script>

<style>

</style>
