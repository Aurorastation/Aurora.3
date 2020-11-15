<template>
  <div class="uiTitleWrapper" draggable @mousedown.left="startDragging($event)" @mouseup.left="stopDragging($event)">
    <div class="titleBar">
      <div class="uiTitleText" unselectable="on">{{ d.title }}</div>
      <div class="uiTitleClose" unselectable="on" @click="closeUI()" @mousedown.left="prevent($event)">×</div>
    </div>
    <slot/>
  </div>
</template>

<script>
import Utils from '../../utils'
import ByWin from '../../byWin'

export default {
  data () {
    return {
      debug_flip: 0,
      d: this.$root.$data,
    }
  },
  methods: {
    closeUI() {
      Utils.sendToTopic({'vueuiclose': 1});
    },
    startDragging($event) {
      ByWin.dragStartHandler($event);
    },
    stopDragging($event) {
      ByWin.dragEndHandler($event);
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
