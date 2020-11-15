<template>
  <div class="uiTitleWrapper" draggable @mousedown.left="startDragging($event)" @mouseup.left="stopDragging($event)">
    <div class="titleBar">
      <div class="uiStatusIcon uiIcon24" :class="statusClass" unselectable="on"/>
      <div class="uiTitleText" unselectable="on">{{ d.title }}</div>
      <div class="uiTitleClose" unselectable="on" @click="closeUI($event)" @mousedown.left="prevent($event)">×</div>
    </div>
    <slot/>
  </div>
</template>

<script>
import Utils from '@/utils'
import ByWin from '@/byWin'
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
      ByWin.dragStartHandler($event);
    },
    stopDragging($event) {
      ByWin.dragEndHandler($event);
    },
  }
}
</script>
