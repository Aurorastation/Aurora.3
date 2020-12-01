<template>
  <div>
    <div class="uiTitleWrapper" draggable @mousedown.left="startDragging($event)" @mouseup.left="stopDragging($event)">
      <div class="uiRigthButtons">
        <i v-if="debug == 1" @click="debug_enabled = !debug_enabled" @mousedown.left.prevent class="uiDbgBtn fas ic-bug"/>
        <i @click="close" @mousedown.left.prevent class="uiCloseBtn fas ic-times"/>
      </div>
      <component :is="'header-' + header"/>
    </div>
    <header-handles/>
  </div>
</template>

<script>
import Utils from '../../utils'
import Store from '../../store'
import ByWin from '../../byWin'

export default {
  data() {
    return this.$root.$data
  },
  methods: {
    close($event) {
      $event.stopPropagation()
      Utils.sendToTopicRaw({'vueuiclose': Store.state.uiref})
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
