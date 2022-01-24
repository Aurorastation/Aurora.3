<template>
  <div class="uiTitleWrapper" draggable @mousedown.left="startDragging($event)" @mouseup.left="stopDragging($event)">
    <div class="titleBar">
      <div class="uiStatusIcon uiIcon24" :class="statusClass" unselectable="on"/>
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
    statusClass() {
      if (this.status == 2) return 'good'
      if (this.status == 1) return 'average'
      return 'bad'
    },
    debugClass() {
      if (this.debug_view == 1) return 'good';
      if (this.debug == 1) return 'bad';
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
