<template>
  <div>
    <div class="item">
      <div class="itemLabelWide">
        Behaviour controls are {{locked ? "locked" : "unlocked"}}.
      </div>
    </div>
    <template v-if="access">
      <view-turrets-control-part :settings="this"/>
    </template>
    <h3>List of Turrets:</h3>
    <div v-for="turret in turrets" :key="turret.name">
      <h4>{{ turret.name }}</h4>
      <view-turrets-control-part :settings="turret.settings"/>
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