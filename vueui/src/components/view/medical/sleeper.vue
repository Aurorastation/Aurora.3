<template>
  <div>
    <div v-if="!power">
      <div class="itemLabel">
        <h2>NO POWER</h2>
      </div>
    </div>
    <div v-else>
      <div v-if="occupant">
        <div class="columnHolder">
          <div class="column">
            <div>
              <h3>Occupant Status:</h3>
              <div><span class="text">Status:</span> <span :style="{color:consciousnessLabel(stat)}">{{ consciousnessText(stat) }}</span></div>
              <div><span class="text">Stasis Level:</span> {{stasis}}</div>
              <div><span class="text">Species:</span> {{species}}</div>
              <div><span class="text">Brain Activity:</span> <vui-progress :class="progressClass(brain_activity)" :value="brain_activity">{{brain_activity}}%</vui-progress></div>
              <div><span class="text">Pulse:</span> {{pulse}}</div>
              <div><span class="text">BP:</span> <span :style="{color:getPressureClass(blood_pressure_level)}">{{blood_pressure}}</span></div>
              <div><span class="text">Blood Oxygenation:</span> <vui-progress :class="progressClass(brain_activity)" :value="Math.round(blood_o2)">{{Math.round(blood_o2)}}%</vui-progress></div>
              <h3>Bloodstream Reagents:</h3>
              <div v-if="bloodreagents">
                <table>
                  <tr v-for="reagent in bloodreagents" :key="reagent.name">
                    <td><span class="text">{{reagent.name}}:</span></td>
                    <td class="shifted">{{reagent.amount}}u</td>
                  </tr>
                </table>
              </div>
              <div v-else>
                The occupant has no additional reagents in their bloodstream.
              </div>
              <h3>Stomach Reagents:</h3>
              <div v-if="hasstomach">
                <div v-if="stomachreagents">
                  <table>
                    <tr v-for="reagent in stomachreagents" :key="reagent.name">
                      <td><span class="text">{{reagent.name}}:</span></td>
                      <td class="shifted">{{reagent.amount}}u</td>
                    </tr>
                  </table>
                </div>
                <div v-else>
                  The occupant has nothing in their stomach.
                </div>
              </div>
              <div v-else>
                The occupant does not have a stomach.
              </div>
            </div>
          </div>
          <div class="column">
            <h3>Injectable Reagents:</h3>
            <table>
              <tr v-for="reagent in reagents" :key="reagent.name">
                <td><span class="text">{{reagent.name}}:</span></td>
                <td><vui-button :params="{chemical: reagent.type, amount: 5}">Inject 5</vui-button></td>
                <td><vui-button :params="{chemical: reagent.type, amount: 10}">Inject 10</vui-button></td>
              </tr>
            </table>
            <h3>Stasis Settings:</h3>
            <table>
              <tr>
                <td v-for="setting in stasissettings" :key="setting">
                  <vui-button :params="{stasis: setting}">{{setting}}</vui-button>
                </td>
              </tr>
            </table>
          </div>
        </div>
      </div>
      <div v-else>
        No occupant.
      </div>
    </div>
    <div v-if="occupant">
      <div class="columnHolder">
        <div class="float">
          <vui-button :params="{eject: 1}">Eject Occupant</vui-button>
        </div>
        <div class="float">
          <div v-if="filtering">
            <vui-button :params="{filter: -1}">Dialysis Active</vui-button>
          </div>
          <div v-else>
            <vui-button :params="{filter: 1}">Dialysis Inactive</vui-button>
          </div>
        </div>
        <div class="float">
          <div v-if="pump">
            <vui-button :params="{pump: -1}">Stomach Pump Active</vui-button>
          </div>
          <div v-else>
            <vui-button :params="{pump: 1}">Stomach Pump Inactive</vui-button>
          </div>
        </div>
      </div>
    </div>
    <div v-if="beaker != -1">
      <span class="text">Beaker:</span> {{beaker}} units of free space remaining. <vui-button :params="{beaker: 1}">Eject Beaker</vui-button>
    </div>
    <div v-else>
      No beaker inserted.
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return this.$root.$data.state;
  },
  methods: {
  consciousnessLabel(value) {
    switch (value) {
      case 0:
        return "LimeGreen"
      case 1:
        return "OrangeRed"
      case 2:
        return "Crimson"
      }
    },
  consciousnessText(value) {
  switch (value) {
    case 0:
      return "Conscious"
    case 1:
      return "Unconscious"
    case 2:
      return "DEAD"
    }
  },
  progressClass(value) {
    if (value <= 50) {
      return "bad"
    }
    else if (value <= 90) {
      return "average"
    }
    else {
      return "good"
    }
  },
  getPressureClass(tpressure) {
    switch (tpressure) {
      case 1:
        return "Crimson"
      case 2:
        return "LimeGreen"
      case 3:
        return "LawnGreen"
      case 4:
        return "Crimson"
      default:
        return "LightSkyBlue"
      }
    }
  }
};
</script>

<style lang="scss" scoped>
.column {
    float: left;
    width: 45%;
    margin: 1%;
    padding: 10px;
    outline-style: ridge;
    outline-color: black;
    background-color: rgba(0, 0, 0, 0.4);
    height: 500px;
    overflow: auto;
}
/* Clear floats after the columns */
.columnHolder:after {
    content:"";
    display: block;
    height: 0;
    overflow: hidden;
    clear: both;
}
.text {
  color: #b99d71;
}
.float .button {
  float: left;
  padding-left: 5px;
}
td .shifted {
  padding-left: 5px;
}
</style>