<template>
  <vui-group>
    <vui-group-item label="Status:">
      <vui-button :class="{ selected: on }" :params="{ toggleStatus: 1 }">On</vui-button>
      <vui-button :class="{ selected: !on }" :params="{ toggleStatus: 1 }">Off</vui-button>
    </vui-group-item>

    <vui-group-item label="Power Level:">
      <vui-button :class="{ selected: powerSetting == 20 }" :params="{ setPower: 20 }">1</vui-button>
      <vui-button :class="{ selected: powerSetting == 40 }" :params="{ setPower: 40 }">2</vui-button>
      <vui-button :class="{ selected: powerSetting == 60 }" :params="{ setPower: 60 }">3</vui-button>
      <vui-button :class="{ selected: powerSetting == 80 }" :params="{ setPower: 80 }">4</vui-button>
      <vui-button :class="{ selected: powerSetting == 100 }" :params="{ setPower: 100 }">5</vui-button>
    </vui-group-item>

    <vui-group-item label="Gas Pressure:"> {{ gasPressure }} kPa </vui-group-item>

    <h3>Gas Temperature</h3>
    <vui-group-item label="Current:">
      <vui-progress
        :value="gasTemperature"
        :max="maxGasTemperature"
        :min="minGasTemperature"
        :class="gasTemperatureClass"
      >
        {{ gasTemperature }} K
      </vui-progress>
    </vui-group-item>

    <vui-group-item label="Target:">
      <vui-progress :value="targetGasTemperature" :max="maxGasTemperature" :min="minGasTemperature">
        {{ targetGasTemperature }} K
      </vui-progress>
      <div style="clear: both; padding-top: 4px;">
        <vui-button :disabled="targetGasTemperature <= minGasTemperature" :params="{ temp: -100 }">-</vui-button>
        <vui-button :disabled="targetGasTemperature <= minGasTemperature" :params="{ temp: -10 }">-</vui-button>
        <vui-button :disabled="targetGasTemperature <= minGasTemperature" :params="{ temp: -1 }">-</vui-button>

        <vui-button :disabled="targetGasTemperature >= maxGasTemperature" :params="{ temp: 1 }">+</vui-button>
        <vui-button :disabled="targetGasTemperature >= maxGasTemperature" :params="{ temp: 10 }">+</vui-button>
        <vui-button :disabled="targetGasTemperature >= maxGasTemperature" :params="{ temp: 100 }">+</vui-button>
      </div>
    </vui-group-item>
  </vui-group>
</template>

<script>
export default {
  data() {
    return this.$root.$data.state
  },
  computed: {
    gasTemperatureClass() {
      if (this.temperatureBadTop != null && this.gasTemperature > this.temperatureBadTop) {
        return 'bad'
      }

      if (this.temperatureBadBottom != null && this.gasTemperature < this.temperatureBadBottom) {
        return 'bad'
      }

      if (
        this.temperatureAvgTop != null &&
        this.temperatureAvgBottom != null &&
        this.gasTemperature < this.temperatureAvgTop &&
        this.gasTemperature > this.temperatureAvgBottom
      ) {
        return 'average'
      }

      return 'good'
    },
  },
}
</script>
