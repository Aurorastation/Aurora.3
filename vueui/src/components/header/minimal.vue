<template>
  <div
    class="ui-header"
    draggable
    @mousedown.left="startDragging($event)"
    @mouseup.left="stopDragging($event)"
  >
    <div class="titleBar">
      <div class="titleText" unselectable="on">{{ title }}</div>
      <div
        class="closeBtn"
        unselectable="on"
        @click="closeUI($event)"
        @mousedown.left="prevent($event)"
      >
        ×
      </div>
    </div>
    <slot />
  </div>
</template>

<script>
import ByWin from "@/byWin"
export default {
  data() {
    return this.$root.$data
  },
  methods: {
    closeUI($event) {
      $event.stopPropagation()
      this.$toTopicRaw({ src: this.uiref, vueuiclose: 1 })
      ByWin.setVisibility(0)
    },
    startDragging($event) {
      ByWin.dragStartHandler($event)
    },
    stopDragging($event) {
      ByWin.dragEndHandler($event)
    },
    prevent($event) {
      $event.stopPropagation()
    },
  },
}
</script>
