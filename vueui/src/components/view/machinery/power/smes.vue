<template>
  <div>
    <div v-if="failTime" class="notice"> <!-- Failure - Disabled -->
      <h3 class="fw-bold">SYSTEM FAILURE</h3>
      <span class="fst-italic">I/O regulator malfuction detected! Waiting for system reboot...</span><br>
      Automatic reboot in {{failTime}} seconds...
      <vui-button icon="refresh" :params="{reboot : 1}">Reboot Now</vui-button>
    </div>
    <div v-else>
      <vui-item label="Stored Capacity:">
        <vui-progress :value="storedCapacity" :min="0" :max="100" :class="charging ? good : average"/>
        <div class="statusValue">
          {{Math.round(storedCapacity)}}%
        </div>
      </vui-item>

      <vui-item label="Charge status:">
        <div class="statusValue">
          <span v-if="charge_mode == 1">
            SMES will be fully charged in {{time}}
          </span>
          <span v-else-if="charge_mode == 2">
            SMES input and output are equal
          </span>
          <span v-else>
            SMES will run out of charge in {{time}}
          </span>
        </div>
      </vui-item>

      <h3>Input Management</h3>
      <vui-item label="Charge Mode:">
        <vui-button :icon="chargeMode ? 'refresh' : 'close'" :params="{cmode : 1}">{{chargeMode ? 'Auto' : 'Off'}}</vui-button>
        &nbsp;
        [{{chargeStatus}}]
      </vui-item>

      <vui-item label="Input Level:">
        <vui-progress :value="chargeLevel" :min="0" :max="chargeMax"/>
        <div style="clear: both; padding-top: 4px; text-align:center;">
          <vui-input-numeric width="100px" v-model="chargeLevel" :button-count="getNumButtons(chargeMax)" :min="0" :max="chargeMax" @input="s({input : chargeLevel})">&nbsp;{{chargeLevel}} W&nbsp;</vui-input-numeric>
        </div>
      </vui-item>

      <vui-item label="Input Load:">
        <vui-progress :value="charge_taken" :min="0" :max="chargeMax" :class="(charge_taken < chargeLevel) ? average : good"/>
        <div class="statusValue">
          {{charge_taken}} W
        </div>
      </vui-item>

      <h3>Output Management</h3>
      <vui-item label="Output Status:">
        <vui-button :icon="outputOnline ? 'power' : 'close'" :params="{online : 1}">{{outputOnline ? 'On' : 'Off'}}line</vui-button>
        &nbsp;
        [{{outputStatus}}]
      </vui-item>

      <vui-item label="Output Level:">
        <vui-progress :value="outputLevel" :min="0" :max="outputMax"/>
        <div style="clear: both; padding-top: 4px; text-align: center;">
          <vui-input-numeric width="100px" v-model="outputLevel" :button-count="getNumButtons(outputMax)" :min="0" :max="outputMax" @input="s({input : outputLevel})">&nbsp;{{outputLevel}} W&nbsp;</vui-input-numeric>
        </div>
      </vui-item>

      <vui-item label="Output Load:">
        <vui-progress :value="outputLoad" :min="0" :max="outputMax" :class="(outputLoad < outputLevel) ? good : average"/>
        <div class="statusValue">
          {{outputLoad}} W
        </div>
      </vui-item>
    </div>
  </div>
</template>

<script>
import Utils from "../../../../utils.js";
export default {
  data() {
    return this.$root.$data.state; // Make data more easily accessible
  },
  methods: {
    getNumButtons(max) {
      return Math.floor(Math.log10(max))
    },
    s(parameters) {
      Utils.sendToTopic(parameters)
    }
  },
  computed: {
    chargeStatus() {
      switch(this.charging){
        case 2: return "<span class='good'>Charging</span>";
        case 1: return "<span class='average'>Partially Charging</span>";
        default: return "<span class='bad'>Not Charging</span>";
      }
    },
    outputStatus() {
      switch(this.outputting){
        case 2: return "<span class='good'>Outputting</span>";
        case 1: return "<span class='average'>Disconnected or No Charge</span>";
        default: return "<span class='bad'>Not Outputting</span>";
      }
    }
  }
}
</script>
