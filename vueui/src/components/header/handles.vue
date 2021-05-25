<template>
  <div id="resizehandles">
    <div class="resizeHandle__e" @mousedown.left="startResizing(1, 0, $event)" />
    <div class="resizeHandle__s" @mousedown.left="startResizing(0, 1, $event)" />
    <div class="resizeHandle__se" @mousedown.left="startResizing(1, 1, $event)" />
  </div>
</template>

<script>
import ByWin from '@/byWin';
export default {
  methods: {
    startResizing(x, y, event) {
      ByWin.resizeStartHandler(x, y, event);
    },
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
    transition: opacity .3s;
    opacity: .5;
    background-position: bottom right;
    background-size: 16px 16px;
    background-repeat: no-repeat;
    background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' version='1' fill='white' viewBox='0 0 567 567'%3E%3Cpath d='M437 0c-6 0-12 2-17 7L7 420c-9 10-9 25 0 34l57 57c9 9 24 9 34 0L511 98c9-10 9-25 0-34L454 7c-5-5-11-7-17-7zm27 199c-6 0-12 3-17 7L206 447c-9 9-9 25 0 34l57 57c9 9 25 9 34 0l241-241c9-9 9-25 0-34l-57-57c-5-4-11-7-17-7zm22 204c-6 0-12 3-17 7l-59 59c-9 10-9 25 0 34l57 57c9 9 25 9 34 0l59-59c9-9 9-25 0-34l-57-57c-4-4-11-7-17-7z'/%3E%3C/svg%3E%0A");
    &:hover {
      opacity: 1;
    }
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
