<template>
  <div>
    <div class="table">
      <div class="header">
        <div class="header-item">Name</div>
        <div class="header-item">Pulse</div>
        <div class="header-item">Pressure</div>
        <div class="header-item">Oxy</div>
        <div class="header-item">Temp</div>
        <div class="header-item">Location</div>
        <div class="header-item"/>
      </div>
      <div class="sensor" v-for="sensor in crewmembers" :key="sensor.ref">
        <div class="item">{{ sensor.name }} ({{ sensor.ass }})</div>
        <template v-if="sensor.stype > 1">
          <div class="item center" :class="getPulseClass(sensor.tpulse)">{{ sensor.pulse }}</div>
          <div class="item center">{{ sensor.pressure }}</div>
        </template>
        <td colspan="2" class="center" v-else><span v-if="sensor.dead" class="bad">Dead</span><span v-else class="good">Alive</span></td>
        <div class="item center" :class="getOxyClass(sensor.oxyg)">{{ toOxiLabel(sensor.oxyg) }}</div>
        <div class="item center"><span v-if="sensor.stype > 1">{{ roundTemp(sensor.bodytemp) }}</span></div>
        <div class="item rigth" v-if="sensor.stype > 2">{{sensor.area}} ({{sensor.x}}, {{sensor.y}}, {{sensor.z}})</div>
        <div class="item rigth" v-else>Not Available</div>
        <div class="item rigth" v-if="isAI"><vui-button :params="{'Track': sensor.ref}" :disabled="sensor.stype < 3">Track</vui-button></div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return this.$root.$data.state
  },
  methods: {
    roundTemp(t) {
      return Math.round(t * 10) / 10
    },
    toOxiLabel(value) {
      switch (value) {
        case 5:
          return "increased"
        case 4:
          return "normal"
        case 3:
          return "low"
        case 2:
          return "very low"
        case 1:
          return "extremely low"
        default:
          return "N/A";
      }
    },
    getOxyClass(value) {
      switch (value) {
        case 5:
          return "highlight"
        case 4:
          return "good"
        case 3:
          return "average"
        case 2:
          return "bad"
        case 1:
          return "bad"
        default:
          return "neutral";
      }
    },
    getPulseClass(tpulse) {
      switch (tpulse) {
        case 0:
          return "bad"
        case 1:
          return "average"
        case 2:
          return "good"
        case 3:
          return "highlight"
        case 4:
          return "average"
        case 5:
          return "bad"
        default:
          return "neutral";
      }
    }
  }
}
</script>

<style lang="scss" scoped>
.table {
  display: table;
  width: 100%;

  .header {
    text-align: center;
    font-weight: bold;
  }
  .header, .sensor {
    display: table-row;
    .header-item, .item {
      display: table-cell;
      padding: 1px;
      vertical-align: middle;
    }
  }
}

.center {
  text-align: center;
}

.rigth {
  text-align: right;
}
</style>