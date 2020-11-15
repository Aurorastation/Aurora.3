<template>
  <div>
    <div class="titleBar">
      <div class="uiTitleText" unselectable="on">{{ d.title }}</div>
    </div>
    <slot/>
  </div>
</template>

<script>
import Utils from '../../utils'
import ByWin from '../../byWin'

export default {
  data () {
    return {
      d: this.$root.$data,
    }
  },
}
</script>
