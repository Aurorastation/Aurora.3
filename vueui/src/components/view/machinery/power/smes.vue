<template>
  <div>
    <div v-if="state.failTime" class="notice"> <!-- Failure - Disabled -->
      <h3 class="fw-bold">SYSTEM FAILURE</h3>
      <span class="fst-italic">I/O regulator malfuction detected! Waiting for system reboot...</span><br>
      Automatic reboot in {{state.failTime}} seconds...
      <vui-button icon="sync" :params="{reboot : 1}">Reboot Now</vui-button>
    </div>
    <vui-group v-else>
      <vui-group-item label="Stored Capacity:">
        <vui-progress :value="state.storedCapacity" :min="0" :max="100" :class="state.charging ? 'good' : 'average'"/>
        <div class="statusValue">
          {{Math.round(state.storedCapacity)}}%
        </div>
      </vui-group-item>

      <vui-group-item label="Charge status:">
        <div class="statusValue">
          <span v-if="state.chargeMode == 1">
            SMES will be fully charged in {{timeRemaining}}
          </span>
          <span v-else-if="state.chargeMode == 2">
            SMES input and output are equal
          </span>
          <span v-else>
            SMES will run out of charge in {{timeRemaining}}
          </span>
        </div>
      </vui-group-item>

      <h3>Input Management</h3>
      <vui-group-item label="Charge Mode:">
        <vui-button :icon="state.chargeAttempt ? 'sync' : 'times'" :params="{cmode : 1}">{{state.chargeAttempt ? 'Auto' : 'Off'}}</vui-button>
        &nbsp;
        [<span :class="chargeClass">{{chargeStatus}}</span>]
      </vui-group-item>

      <vui-group-item label="Input Level:">
        <vui-progress :value="state.chargeLevel" :min="0" :max="state.chargeMax"/>
        <div style="clear: both; padding-top: 4px; text-align:center;">
          <vui-input-numeric width="100px" v-model="state.chargeLevel" min-button max-button :button-count="0" :min="0" :max="state.chargeMax" @input="s({input : state.chargeLevel})">&nbsp;{{state.chargeLevel}} W&nbsp;</vui-input-numeric>
        </div>
      </vui-group-item>

      <vui-group-item label="Input Load:">
        <vui-progress :value="state.chargeTaken" :min="0" :max="state.chargeMax" :class="(state.chargeTaken < state.chargeLevel) ? 'average' : 'good'"/>
        <div class="statusValue">
          {{state.chargeTaken}} W
        </div>
      </vui-group-item>

      <h3>Output Management</h3>
      <vui-group-item label="Output Status:">
        <vui-button :icon="state.outputOnline ? 'power-off' : 'times'" :params="{online : 1}">{{state.outputOnline ? 'On' : 'Off'}}line</vui-button>
        &nbsp;
        [<span :class="outputClass">{{outputStatus}}</span>]
      </vui-group-item>

      <vui-group-item label="Output Level:">
        <vui-progress :value="state.outputLevel" :min="0" :max="state.outputMax"/>
        <div style="clear: both; padding-top: 4px; text-align: center;">
          <vui-input-numeric width="100px" v-model="state.outputLevel" min-button max-button :button-count="0" :min="0" :max="state.outputMax" @input="s({output : state.outputLevel})">&nbsp;{{state.outputLevel}} W&nbsp;</vui-input-numeric>
        </div>
      </vui-group-item>

      <vui-group-item label="Output Load:">
        <vui-progress :value="state.outputLoad" :min="0" :max="state.outputMax" :class="(state.outputLoad < state.outputLevel) ? 'good' : 'average'"/>
        <div class="statusValue">
          {{state.outputLoad}} W
        </div>
      </vui-group-item>
    </vui-group>
  </div>
</template>

<script>
import Utils from "../../../../utils.js";
export default {
  data() {
    return this.$root.$data; // Make data more easily accessible
  },
  methods: {
    s(parameters) {
      Utils.sendToTopic(parameters)
    },
  },
  computed: {
    chargeClass() {
      switch(this.state.chargeMode){
        case 2: return 'good';
        case 1: return 'average';
        default: return 'bad';
      }
    },
    chargeStatus() {
      switch(this.state.chargeMode){
        case 2: return "Charging";
        case 1: return "Partially Charging";
        default: return "Not Charging";
      }
    },
    outputClass() {
      switch(this.state.outputting){
        case 2: return 'good';
        case 1: return 'average';
        default: return 'bad';
      }
    },
    outputStatus() {
      switch(this.state.outputting){
        case 2: return "Outputting";
        case 1: return "Disconnected or No Charge";
        default: return "Not Outputting";
      }
    },
    timeRemaining() {
      var timeleft = (this.state.time - this.wtime)/10 // deciseconds
      var hours = Math.round(timeleft / 3600)
      var minutes = Math.round(timeleft % 3600 / 60)
      var seconds = Math.round(timeleft % 60)
      return [hours >= 1 && `${hours} hours`, minutes >= 1 && `${minutes} minutes`, seconds >= 1 && `${seconds} seconds`].filter(Boolean).join(", ")
    }
  }
}
</script>
