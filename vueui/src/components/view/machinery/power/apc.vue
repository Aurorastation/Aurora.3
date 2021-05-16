<template>
  <div>
    <div v-if="state.failTime" class="notice" style="color: white;"> <!-- Failure - Disabled -->
      <h3 class="fw-bold">SYSTEM FAILURE</h3>
      <span class="fst-italic">I/O regulator malfuction detected! Waiting for system reboot...</span><br>
      Automatic reboot in {{state.failTime}} seconds...
      <vui-button icon="sync" :params="{reboot : 1}">Reboot Now</vui-button>
    </div>
    <vui-group v-else> <!-- Main -->
      <div class="notice"> <!-- Lock -->
        <div v-if="state.siliconUser">
          <vui-group-item label="Interface Lock:">
            <vui-button v-if="state.locked" icon="lock" :params="{toggleaccess : 1}" :class="{selected : state.locked}">Engaged</vui-button>
            <vui-button v-else icon="lock-open" :params="{toggleaccess : 1}" :disabled="state.malfstatus >= 2" :class="{selected : (state.malfstatus < 2) && !state.locked}">Disengaged</vui-button>
          </vui-group-item>
        </div>
        <span v-else>Swipe an ID card to {{state.locked ? "un" : null}}lock this interface.</span>
      </div>

      <div style="min-width: 480px"> <!-- Body -->
        <h3>Power Status</h3>
        <vui-group-item label="Main Breaker:">
          <div v-if="state.locked && !state.siliconUser">
            <span :class="{good : state.isOperating, bad : !state.isOperating}">{{state.isOperating ? "On" : "Off"}}</span>
          </div>
          <vui-button v-else :icon="state.isOperating ? 'power-off' : 'times'" :params="{breaker : 1}" :class="{selected: state.isOperating}">{{state.isOperating ? "On" : "Off"}}</vui-button>
        </vui-group-item>

        <vui-group-item label="External Power:">
          <span v-if="state.externalPower == 2" class="good">Good</span>
          <span v-else-if="state.externalPower == 1" class="average">Low</span>
          <span v-else class="bad">None</span>
        </vui-group-item>

        <vui-group-item label="Power Cell">
          <span v-if="state.powerCellStatus == null" class="bad">Power cell removed.</span>
          <span v-else>
            <vui-progress :value="state.powerCellStatus" :min="0" :max="100" :class="cellClass"/>
            <span style="width:60px">{{Math.round(state.powerCellStatus * 10)/10}}%</span>
          </span>
        </vui-group-item>

        <vui-group-item label="Power Cell charge status:">
          <div class="statusValue">
            <span v-if="state.charge_mode == 1">APC's power cell will run out of charge in {{timeRemaining}}.</span>
            <span v-else-if="state.charge_mode == 2">APC is not charging or discharging.</span>
            <span v-else>APC will be fully charged in {{timeRemaining}}.</span>
          </div>
        </vui-group-item>

        <vui-group-item label="Charge Mode:" v-if="state.powerCellStatus != null">
          <span v-if="state.locked && !state.siliconUser" :class="{good : state.chargeMode, bad : !state.chargeMode}">{{state.chargeMode ? "Auto" : "Off"}}</span>
          <vui-button v-else :icon="state.chargeMode ? 'sync' : 'times'" :class="{selected: state.chargeMode}" :params="{cmode : 1}">{{state.chargeMode ? "Auto" : "Off"}}</vui-button>
          &nbsp;
          [<span :class="chargeClass">{{chargeStatus}}</span>]
        </vui-group-item>

        <vui-group-item label="Night Lighting:">
          <vui-button :icon="state.lightingMode ? 'moon' : 'sun'" :class="{selected: state.lightingMode}" :params="{lmode : state.lightingMode ? 'off' : 'on'}">{{state.lightingMode ? "On" : "Off"}}</vui-button>
        </vui-group-item>

        <vui-group-item label="Emergency Lighting:">
          <div style="width: 105px">
            <span v-if="state.locked && !state.siliconUser">{{state.emergencyMode ? "On" : "Off"}}</span>
            <vui-button v-else icon="lightbulb" :class="{selected: state.emergencyMode}" :params="{emergency_lights : 1}">{{state.emergencyMode ? "On" : "Off"}}</vui-button>
          </div>
        </vui-group-item>

        <h3>Power Channels</h3>
        <vui-group-row v-for="(channel, channel_title) in state.powerChannels" :key="channel_title">
          <div style="display:table-cell;vertical-align:top;padding-right:8px;width:4%;" class="itemLabel">
            {{channel_title}}
            <span style="float:right;">
              [<span :class="channelStatClass(channel.status)">{{channelStatus(channel.status)}}</span>]&nbsp;
              [<span class="good">{{channelPower(channel.status)}}</span>]
            </span>
          </div>
          <div style="display:table-cell;width:10%;">
            <span style="width: 70px; text-align: right; display:inline-block;">
              {{channel.powerLoad}}&nbsp;W
            </span>
            <span style="width: 105px">
              &nbsp;&nbsp;
              <span v-if="state.locked">
                <span v-if="channel.status == 1 || channel.status == 3">
                  &nbsp;&nbsp;{{channelPower(channel.status)}}
                </span>
              </span>
            </span>
            &nbsp;&nbsp;
            <span v-if="!state.locked || state.siliconUser">
              <vui-button icon="sync" :params="{set : 3, chan : channel_title}" :class="{selected : channel.status == 1 || channel.status == 3}">Auto</vui-button>
              <vui-button icon="power-off" :params="{set : 2, chan : channel_title}" :class="{selected : channel.status == 2}">On</vui-button>
              <vui-button icon="times" :params="{set : 1, chan : channel_title}" :class="{selected : channel.status == 0}">Off</vui-button>
            </span>
          </div>
        </vui-group-row>

        <vui-group-item label="Total Load:">
          {{state.totalLoad}}W{{state.totalCharging ? ` (+ ${state.totalCharging}W Charging)` : null}}
        </vui-group-item>

        <vui-group-item :balance="0.69">&nbsp;</vui-group-item>

        <vui-group-item label="Cover Lock">
          <div v-if="state.locked && !state.siliconUser">
            <span :class="{good : state.coverLocked, bad : !state.coverLocked}" v-if="state.coverLocked">{{state.coverLocked ? "E" : "Dise"}}ngaged</span>
          </div>
          <div v-else>
            <vui-button :icon="state.coverLocked ? 'lock' : 'lock-open'" :class="{selected: state.coverLocked}" :params="{lock : 1}">{{state.coverLocked ? "E" : "Dise"}}ngaged</vui-button>
          </div>
        </vui-group-item>

        <div v-if="state.siliconUser">
          <h3>System Overrides</h3>
          <div>
            <vui-button icon="lightbulb" :params="{overload : 1}">Overload Lighting Circuit</vui-button>
            <vui-button v-if="state.malfStatus == 1" icon="script" :params="{malfhack : 1}">Override Programming</vui-button>
            <span class="notice" v-else-if="state.malfStatus > 1">APC Hacked</span>
          </div>
        </div>
      </div>
    </vui-group>
  </div>
</template>

<script>
export default {
  data() {
    return this.$root.$data; // Make data more easily accessible
  },
  computed: {
    chargeClass() {
      if(this.state.chargingStatus > 1) {return "good"}
      if(this.state.chargingStatus == 1) {return "average"}
      return "bad";
    },
    chargeStatus() {
      if(this.state.chargingStatus > 1) {return "Fully Charged"}
      if(this.state.chargingStatus == 1) {return "Charging"}
      return "Not Charging";
    },
    cellClass() {
      if(this.state.powerCellStatus >= 50) {return "good"}
      if(this.state.powerCellStatus >= 25) {return "average"}
      return "bad";
    },
    timeRemaining() {
      var timeleft = (this.state.time - this.wtime)/10 // deciseconds
      var hours = Math.round(timeleft / 3600)
      var minutes = Math.round(timeleft % 3600 / 60)
      var seconds = Math.round(timeleft % 60)
      return [hours >= 1 && `${hours} hours`, minutes >= 1 && `${minutes} minutes`, seconds >= 1 && `${seconds} seconds`].filter(Boolean).join(", ")
    }
  },
  methods: {
    channelStatus(channelStat) {
      if(channelStat <= 1) {return "Off"}
      return "On";
    },
    channelPower(channelStat) {
      if(channelStat == 1 || channelStat == 3) {return "Auto"}
      return "Manual";
    },
    channelStatClass(channelStat) {
      if(channelStat <= 1) {return "bad"}
      return "good";
    },
  }
}
</script>
