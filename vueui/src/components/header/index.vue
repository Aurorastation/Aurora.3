<template>
  <div>
    <div class="uiTitleWrapper" draggable @mousedown.left="startDragging($event)" @mouseup.left="stopDragging($event)">
      <i @click="close" @mousedown.left.prevent class="uiCloseBtn fas ic-times"></i>
      <component :is="'header-' + header"/>
    </div>
    <header-handles/>
  </div>
</template>

<script>
import Utils from '../../utils'
import ByWin from '../../byWin'

export default {
  data() {
    return this.$root.$data
  },
  methods: {
    close($event) {
      $event.stopPropagation()
      Utils.sendToTopic({'vueuiclose': 1})
    },
    startDragging($event) {
      ByWin.dragStartHandler($event)
    },
    stopDragging($event) {
      ByWin.dragEndHandler($event)
    },
  }
}
</script>
