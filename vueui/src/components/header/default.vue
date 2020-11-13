<template>
  <div class="uiTitleWrapper" draggable v-on:dragstart="startDragging($event)">
    <div style="clear: both;">
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
    },
    modularComputer() {
      return this.d.active.includes("mcomputer") ? true : false;
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
      var offset = this.modularComputer ? '72px' : '36px';
      if(this.debug_flip == 0) {
        document.getElementById("content").style.height = "calc(50vh - " + offset + ")";
        document.getElementById("debug").style.display = "inherit";
        this.debug_flip = 1;
      } else if (this.debug_flip == 1) {
        document.getElementById("content").style.height = "calc(100vh - " + offset + ")";
        document.getElementById("debug").style.display = "none";
        this.debug_flip = 0;
      }
    }
  }
}
</script>

<style lang="scss">
.uiTitleWrapper {
  margin: -8px -8px 10px;
  position: relative;
  float: none;
  background-color: #b9b9b9;
  clear: both;
  user-select: none;
  -ms-user-select: none;
  cursor: default;
}

.uiTitleWrapper > div:nth-child(1) {
  height: 32px;
}

.uiTitleText {
  position: relative;
  display: inline-block;
  left: 20px;
  font-size: 16px;
  line-height: 20px;
}

.uiTitle.icon {
  padding: 6px 8px 6px 42px;
  background-position: 2px 50%;
  background-repeat: no-repeat;
}

.uiStatusIcon {
  position: relative;
  display: inline-block;
  top: 2px;
  left: 12px;
}

.uiDebugIcon {
  position: relative;
  left: 16px;
  top: 2px;
  &.uiDebugOn {
    color: #4e7428;
  }
  &.uiDebugOff {
    color: #a70000;
  }
  &.uiNoDebug {
    display: none;
  }
}
</style>
