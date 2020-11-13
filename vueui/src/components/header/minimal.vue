<template>
  <div class="uiTitleWrapper" draggable @mousedown.left="startDragging($event)" @mouseup.left="stopDragging($event)">
    <div class="titleBar">
      <div class="uiTitleText" unselectable="on">{{ title }}</div>
      <div class="uiTitleClose" unselectable="on" @click="closeUI()" @mousedown.left="prevent($event)">×</div>
    </div>
    <slot/>
  </div>
</template>

<script>
import Utils from '../../utils.js';
import { dragStartHandler, dragEndHandler } from '../../drag.js';
export default {
  data () {
    return this.$root.$data
  },
  methods: {
    closeUI() {
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
  }
}
</script>
