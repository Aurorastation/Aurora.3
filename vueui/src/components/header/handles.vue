<template>
    <div id="resizehandles">
        <div class="resizeHandle__e" @mousedown.left="startResizing(1, 0, $event)" />
        <div class="resizeHandle__s" @mousedown.left="startResizing(0, 1, $event)" />
        <div class="resizeHandle__se" @mousedown.left="startResizing(1, 1, $event)" />
    </div>
</template>

<script>
import { resizeStartHandler } from '../../drag.js';
export default {
  data () {
    return this.$root.$data;
  },
  methods: {
    startResizing(x, y, event) {
      resizeStartHandler(x, y, event);
    }
  }
}
</script>

<style lang="scss" scoped>
.resizeHandle__se {
    position: fixed;
    bottom: 0;
    right: 0;
    width: 20px;
    height: 20px;
    cursor: se-resize;
  }

  .resizeHandle__s {
    position: fixed;
    bottom: 0;
    left: 0;
    right: 0;
    height: 6px;
    cursor: s-resize;
  }

  .resizeHandle__e {
    position: fixed;
    top: 0;
    bottom: 0;
    right: 0;
    width: 3px;
    cursor: e-resize;
  }
</style>
