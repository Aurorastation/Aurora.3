<template>
  <div class="uiTitleWrapper" draggable @mousedown.left="startDragging($event)" @mouseup.left="stopDragging($event)">
    <div class="titleBar">
      <i class="fas ic-bug uiIcon24 uiDebugIcon" :class="debugClass" unselectable="on" @click="activateDebug()" @mousedown.left="prevent($event)"/>
      <div class="uiTitleText" unselectable="on">{{ title }}</div>
      <div class="uiTitleClose" unselectable="on" @click="closeUI($event)" @mousedown.left="prevent($event)">×</div>
    </div>
    <slot/>
  </div>
</template>

<script>
import ByWin from '@/byWin'
export default {
  data () {
    return this.$root.$data;
  },
  computed: {
    debugClass() {
      if (this.debug_view) return 'good';
      if (this.debug) return 'bad';
      return 'hidden';
    }
  },
  methods: {
    closeUI($event) {
      $event.stopPropagation();
      this.$toTopicRaw({'src': this.uiref, 'vueuiclose': 1});
      ByWin.setVisibility(0);
    },
    startDragging($event) {
      ByWin.dragStartHandler($event);
    },
    stopDragging($event) {
      ByWin.dragEndHandler($event);
    },
    prevent($event) {
      $event.stopPropagation();
    },
    activateDebug() {
      this.debug_view = !this.debug_view
      if(this.debug_view) {
        document.getElementById("content").classList.add("uiDebug");
        document.getElementById("debug").classList.add("uiDebug");
      } else {
        document.getElementById("content").classList.remove("uiDebug");
        document.getElementById("debug").classList.remove("uiDebug");
      }
    }
  }
}
</script>
