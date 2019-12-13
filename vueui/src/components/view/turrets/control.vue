<template>
  <div>
    <h3>Group Turret controls:</h3>
    <div class="item">
      <div class="itemLabelWide">
        Behaviour controls are {{settings.locked ? "locked" : "unlocked"}}.
      </div>
    </div>
    <view-turrets-control-part :settings="$data"/>
    <h2>List of turrets and individual controls:</h2>
    <div v-for="turret in turrets" :key="turret.name">
      <h4>{{ turret.name }}</h4>
      <view-turrets-control-part :settings="turret.settings" :tref="turret.ref"/>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return this.$root.$data.state;
  }
}
</script>