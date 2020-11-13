<template>
  <div class="uiTitleWrapper" draggable @mousedown.left="startDragging($event)" @mouseup.left="stopDragging($event)">
    <div class="titleBar">
      <div class="uiStatusIcon uiIcon24" :class="statusClass" unselectable="on"/>
      <i class="fas ic-bug uiIcon24 uiDebugIcon" :class="debugClass" unselectable="on" @click="activateDebug()" @mousedown.left="prevent($event)"/>
      <div class="uiTitleText" unselectable="on">{{ d.title }}</div>
      <div class="uiTitleClose" unselectable="on" @click="closeUI($event)" @mousedown.left="prevent($event)">×</div>
    </div>
    <slot/>
  </div>
</template>

<script>
import Utils from '../../utils.js';
import { dragStartHandler, dragEndHandler } from '../../drag.js';
export default {
  data () {
    return {
      debug_flip: 0,
      d: this.$root.$data,
    }
  },
  computed: {
    statusClass() {
      if (this.d.status == 2) return 'good'
      if (this.d.status == 1) return 'average'
      return 'bad'
    },
    debugClass() {
      if (this.d.debug == 1) {
        if (this.debug_flip == 1) return 'good';
        if (this.debug_flip == 0) return 'bad';
      }
      return 'hidden';
    }
  },
  methods: {
    closeUI($event) {
      $event.stopPropagation();
      Utils.sendToTopic({'vueuiclose': 1});
    },
    startDragging($event) {
      dragStartHandler($event);
    },
    stopDragging($event) {
      dragEndHandler($event);
    },
    prevent($event) {
      $event.stopPropagation();
    },
    activateDebug() {
      if(this.debug_flip == 0) {
        document.getElementById("content").classList.add("uiDebug");
        document.getElementById("debug").classList.add("uiDebug");
        this.debug_flip = 1;
      } else if (this.debug_flip == 1) {
        document.getElementById("content").classList.remove("uiDebug");
        document.getElementById("debug").classList.remove("uiDebug");
        this.debug_flip = 0;
      }
    }
  }
}
</script>
