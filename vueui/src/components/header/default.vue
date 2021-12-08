<template>
  <div
    class="ui-header"
    draggable
    @mousedown.left="startDragging($event)"
    @mouseup.left="stopDragging($event)"
  >
    <div
      class="closeBtn"
      unselectable="on"
      @click="closeUI($event)"
      @mousedown.left="prevent($event)"
    >
      ×
    </div>
    <div class="titleBar">
      <div
        class="uiStatusIcon uiIcon24"
        :class="statusClass"
        unselectable="on"
      />
      <div class="titleText" unselectable="on">{{ title }}</div>
    </div>
    <slot />
    <div class="endSpacer" />
  </div>
</template>

<script>
import ByWin from "@/byWin"
export default {
  data() {
    return this.$root.$data
  },
  computed: {
    statusClass() {
      if (this.status == 2) return "good"
      if (this.status == 1) return "average"
      return "bad"
    },
    debugClass() {
      if (this.debug_view == 1) return "good"
      if (this.debug == 1) return "bad"
      return "hidden"
    },
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
