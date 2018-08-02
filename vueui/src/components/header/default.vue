<template>
  <div class="uiTitleWrapper" unselectable="on">
    <slot/>
    <div class="uiStatusIcon uiIcon24" :class="statusClass" unselectable="on"/>
    <div class="uiTitleText" unselectable="on">{{ title }}</div>
    <div class="uiTitleFluff" unselectable="on"/>
  </div>
</template>

<script>
export default {
  data () {
    return this.$root.$data
  },
  computed: {
    statusClass() {
      if (this.status == 2) return 'uiStatusGood'
      if (this.status == 1) return 'uiStatusAverage'
      return 'uiStatusBad'
    }
  }
}
</script>

<style lang="scss">
.uiTitleWrapper {
  margin: -8px -8px 10px;
  position: relative;
  padding-bottom: 8px;
  float: none;
  background-color: #b9b9b9;
}

.uiTitleText {
  position: relative;
  display: inline-block;
  top: 4px;
  left: 18px;
  width: 66%;
  width: calc(100% - 36px - 42px - 18px);
  font-size: 16px;
  line-height: 20px;
  vertical-align: middle;
}

.uiTitle.icon {
  padding: 6px 8px 6px 42px;
  background-position: 2px 50%;
  background-repeat: no-repeat;
}

.uiStatusIcon {
  position: relative;
  display: inline-block;
  top: 4px;
  left: 12px;
  vertical-align: middle;
}
</style>

