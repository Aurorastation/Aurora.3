<template>
  <div>
    <h3>Group Turret controls:</h3>
    <div class="item">
      <div class="itemLabelWide">
        Behaviour controls are {{locked ? "locked" : "unlocked"}}.
      </div>
    </div>
    <template v-if="access">
      <view-turrets-control-part :settings="this"/>
    </template>
    <h2>List of turrets and individual controls:</h2>
    <div v-for="turret in turrets" :key="turret.name">
      <h4>{{ turret.name }}</h4>
      <view-turrets-control-part-ind :turret="turret"/>
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