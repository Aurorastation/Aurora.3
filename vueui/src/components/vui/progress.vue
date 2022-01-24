<template>
  <div class="displayBar">
    <div class="displayBarFill" :style="{ width: percentage + '%'}"><span><slot/></span></div>
  </div>
</template>

<script>
export default {
  props: {
    value: {
      type: Number,
      default: 50
    },
    max: {
      type: Number,
      default: 100
    },
    min: {
      type: Number,
      default: 0
    }
  },
  computed: {
    percentage() {
      return (Math.min(this.max, Math.max(this.value, this.min)) - this.min) / (this.max - this.min) * 100;
    }
  }
}
</script>

<style lang="scss" scoped>
  .displayBar {
    position: relative;
    width: 236px;
    height: 16px;
    border: 1px solid #666666;
    float: left;
    margin: 0 5px 0 0;
    overflow: hidden;
    background: #000000;
  }
  .displayBar.good {
    border: 1px solid #4f7529;
  }
  .displayBar.average {
    border: 1px solid #cd6500;
  }
  .displayBar.bad {
    border: 1px solid #ee0000;
  }
  .displayBar.highlight {
    border: 1px solid #8BA5C4;
  }
  .displayBarFill {
    line-height: 1em;
    white-space: nowrap;
    overflow: visible;
    text-align: left;
    span {
      vertical-align: middle;
      margin-left: 2px;
    }
  }
  .displayBarFill.good {
      color: #ffffff;
      background: #4f7529;
    }
  .displayBarFill.average {
    color: #ffffff;
    background: #cd6500;
  }
  .displayBarFill.bad {
    color: #ffffff;
    background: #ee0000;
  }
  .displayBarFill.highlight {
    color: #ffffff;
    background: #8BA5C4;
  }
</style>
