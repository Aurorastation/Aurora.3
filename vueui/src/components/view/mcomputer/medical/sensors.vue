<template>
  <div>
    <div class="table">
      <div class="header">
        <div class="header-item">Name</div>
        <div class="header-item"><vui-tooltip label="Pulse/Cell">Pulse rate or Cell Charge (IPCs)</vui-tooltip></div>
        <div class="header-item"><vui-tooltip label="BP">Blood pressure</vui-tooltip></div>
        <div class="header-item"><vui-tooltip label="Oxy">Oxygenation</vui-tooltip></div>
        <div class="header-item"><vui-tooltip label="Temp">Temperature</vui-tooltip></div>
        <div class="header-item">Location</div>
        <div class="header-item"/>
      </div>
      <div class="sensor" v-for="sensor in crewmembers" :key="sensor.ref">
        <div class="item">{{ sensor.name }} ({{ sensor.ass }})</div>
        <div class="item center" :class="getPulseClass(sensor.tpulse)" v-if="sensor.cellCharge == -1">{{ sensor.pulse }}</div>
        <div class="item center" :class="getChargeClass(sensor.cellCharge)" v-else>{{ sensor.cellCharge }}%</div>
        <div class="item center" :class="getPressureClass(sensor.tpressure)" v-if="sensor.stype > 1">{{ sensor.pressure }}</div>
        <div class="item center" v-else>N/A</div>
        <div class="item center" :class="getOxyClass(sensor.oxyg)">{{ toOxyLabel(sensor.oxyg) }}</div>
        <div class="item center"><span v-if="sensor.stype > 1">{{ roundTemp(sensor.bodytemp) }}</span></div>
        <div class="item right" v-if="sensor.stype > 2">{{sensor.area}} ({{sensor.x}}, {{sensor.y}}, {{sensor.z}})</div>
        <div class="item right" v-else>Not Available</div>
        <div class="item right" v-if="isAI"><vui-button :params="{track: sensor.ref}" :disabled="sensor.stype < 3">Track</vui-button></div>
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
    toOxyLabel(value) {
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
          return "N/A"
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
          return "neutral"
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
          return "neutral"
      }
    },
    getPressureClass(tpressure) {
      switch (tpressure) {
        case 1:
          return "bad"
        case 2:
          return "good"
        case 3:
          return "average"
        case 4:
          return "bad"
        default:
          return "neutral"
      }
    },
    getChargeClass(cellCharge) {
      if(cellCharge > 10) {
        return "highlight"
      }
        return "bad"
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

.right {
  text-align: right;
}
</style>