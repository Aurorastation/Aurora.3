<template>
  <div>
    <div v-if="!power">
      <div class="itemLabel">
        <h2>NO POWER</h2>
      </div>
    </div>
    <div v-else>
      <div v-if="!linked">
        <div class="itemLabel">
          <h2>NO CONNECTION ESTABLISHED</h2>
        </div>
      </div>
      <div v-else>
        <h1>Zavodskoi "Ajax" Targeting Systems</h1>
        <vui-button class="danger" icon="calculator" :params="{ viewing: 1 }">View Targeting Grid</vui-button>
        <div v-if="!is_targeting">
          <div class="itemLabel">
            <h2>No target designated.</h2>
          </div>
        </div>
        <div v-else>
          <div class="itemLabel">
            <h3>Targeting Information</h3>
            <div><span class="text">Target:</span> <span class="normal">{{target}}</span></div>
            <div><span class="text">Distance:</span> <span class="normal">{{dist}} clicks</span></div>
          </div>
          <select v-model="$root.$data.state.entry_point">
            <option v-for="a in entry_points" :key="a" :value="a">{{ a }}</option>
          </select>
        </div>
        <select v-model="$root.$data.state.new_ship_weapon">
          <option v-for="i in ship_weapons" :key="i" :value="i">{{ i }}</option>
        </select>
        <div v-if="new_ship_weapon">
          <h2>{{new_ship_weapon}}</h2>
          <div class="itemLabel">
            <div><span class="text">Status:</span> <span class="normal">{{status}}</span></div>
            <div><span class="text">Ammunition:</span> <span class="normal">{{ammunition}}</span></div>
            <div><span class="text">Caliber:</span> <span class="normal">{{caliber}}</span></div>
          </div>
          <vui-button class="danger" icon="exclamation-triangle" :params="{ fire: 1 }">FIRE</vui-button>
        </div>
      </div>
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

<style lang="scss" scoped>
.text {
  color: #b99d71;
}

.normal {
  color: #FFFFFF;
}
</style>