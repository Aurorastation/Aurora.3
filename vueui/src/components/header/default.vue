<template>
  <div class="uiTitleWrapper" draggable v-on:dragstart="startDragging($event)">
    <div class="titleBar">
      <div class="uiStatusIcon uiIcon24" :class="statusClass" unselectable="on"/>
      <i class="fas ic-bug uiIcon24 uiDebugIcon" :class="debugClass" unselectable="on" @click="activateDebug()"/>
      <div class="uiTitleText" unselectable="on">{{ d.title }}</div>
      <div class="uiTitleClose" unselectable="on" @click="closeUI()">×</div>
    </div>
    <slot/>
  </div>
</template>

<script>
import Utils from '../../utils.js';
import { dragStartHandler } from '../../drag.js';
export default {
  data () {
    return {
      debug_flip: 0,
      d: this.$root.$data,
    }
  },
  computed: {
    statusClass() {
      if (this.d.status == 2) return 'uiStatusGood'
      if (this.d.status == 1) return 'uiStatusAverage'
      return 'uiStatusBad'
    },
    debugClass() {
      if (this.d.debug == 1) {
        if (this.debug_flip == 1) return 'uiDebugOn';
        if (this.debug_flip == 0) return 'uiDebugOff';
      }
      return 'uiNoDebug';
    }
  },
  methods: {
    closeUI() {
      Utils.sendToTopic({'vueuiclose': 1});
    },
    startDragging($event) {
      dragStartHandler($event);
    },
    activateDebug() {
      if(this.debug_flip == 0) {
        // document.getElementById("content").style.height = "calc(50vh - " + offset + ")";
        // document.getElementById("debug").style.display = "inherit";
        document.getElementById("content").classList.add("uiDebug");
        document.getElementById("debug").classList.add("uiDebug");
        this.debug_flip = 1;
      } else if (this.debug_flip == 1) {
        // document.getElementById("content").style.height = "calc(100vh - " + offset + ")";
        // document.getElementById("debug").style.display = "none";
        document.getElementById("content").classList.remove("uiDebug");
        document.getElementById("debug").classList.remove("uiDebug");
        this.debug_flip = 0;
      }
    }
  }
}
</script>

<style lang="scss">
@import '../../assets/_mixins.scss';

.uiTitleWrapper {
  margin: -8px -8px 10px;
  position: relative;
  float: none;
  background-color: #b9b9b9;
  clear: both;
  user-select: none;
  -ms-user-select: none;
  cursor: default;
  & > .titleBar {
    height: 32px;
    @include vertical-align(middle, 24px);
    & > * {
      display: inline-block;
      margin-left: 8px;
    }
    & > .uiTitleText {
      font-size: 16px;
    }
    & > .uiDebugIcon {
      cursor: pointer;
      transition: color 250ms;
      &.uiDebugOn {
        color: #4e7428;
      }
      &.uiDebugOff {
        color: #a70000;
      }
      &.uiNoDebug {
        display: none;
      }
      &:hover {
        color: #507aac;
        transition: color 0ms;
      }
    }
  }
}
</style>
