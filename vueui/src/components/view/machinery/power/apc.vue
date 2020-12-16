<template>
  <div>
    <div v-if="failTime" class="notice"> <!-- Failure - Disabled -->
      <h3 class="fw-bold">SYSTEM FAILURE</h3>
      <span class="fst-italic">I/O regulator malfuction detected! Waiting for system reboot...</span><br>
      Automatic reboot in {{failTime}} seconds...
      <vui-button icon="sync" :params="{reboot : 1}">Reboot Now</vui-button>
    </div>
    <vui-group v-else> <!-- Main -->
      <div class="notice"> <!-- Lock -->
        <div v-if="siliconUser">
          <vui-group-item label="Interface Lock:">
            <vui-button icon="lock" :params="{toggleaccess : 1}" :class="{selected : locked}">Engaged</vui-button>
            <vui-button icon="lock-open" :params="{toggleaccess : 1}" :disabled="malfstatus >= 2" :class="{selected : (malfstatus < 2) && !locked}">Disengaged</vui-button>
          </vui-group-item>
        </div>
        <span v-else>Swipe an ID card to {{locked ? 'un' : null}}lock this interface.</span>
      </div>

      <div style="min-width: 480px"> <!-- Body -->
        <h3>Power Status</h3>
        <vui-group-item label="Main Breaker:">
          <div v-if="locked && !siliconUser">
            <span :class="{good : isOperating, bad : !isOperating}">{{isOperating ? 'On' : 'Off'}}</span>
          </div>
          <div v-else>
            <vui-button icon="times" :params="{breaker : 1}" v-if="!isOperating">Off</vui-button>
            <vui-button icon="power" :params="{breaker : 1}" v-else>On</vui-button>
          </div>
        </vui-group-item>

        <vui-group-item label="External Power:">
          <span v-if="externalPower == 2" class="good">Good</span>
          <span v-else-if="externalPower == 1" class="average">Low</span>
          <span v-else class="bad">None</span>
        </vui-group-item>

        <vui-group-item label="Power Cell">
          <span v-if="powerCellStatus == null" class="bad">Power cell removed.</span>
          <span v-else>
            <vui-progress :value="powerCellStatus" :min="0" :max="100" :class="cellClass"/>
            <span style="width:60px">{{Math.round(powerCellStatus * 10)/10}}%</span>
          </span>
        </vui-group-item>

        <vui-group-item label="Power Cell charge status:">
          <div class="statusValue">
            <span v-if="charge_mode == 1">APC's power cell will be fully charged in {{timeRemaining}}.</span>
            <span v-else-if="charge_mode == 2">APC is not charging or discharging.</span>
            <span v-else>APC will run out of charge in {{timeRemaining}}.</span>
          </div>
        </vui-group-item>

        <vui-group-item label="Charge Mode:" v-if="powerCellStatus != null">
          <span v-if="locked && !siliconUser" :class="{good : chargeMode, bad : !chargeMode}">{{chargeMode ? "Auto" : "Off"}}</span>
          <vui-button v-else :icon="chargeMode ? 'sync' : 'times'" :params="{cmode : 1}">{{chargeMode ? 'Auto' : 'Off'}}</vui-button>
          &nbsp;
          [<span :class="chargeClass">{{chargeStatus}}</span>]
        </vui-group-item>

        <vui-group-item label="Night Lighting:">
          <vui-button :icon="lightingMode ? 'moon' : 'times'" :params="{lmode : lightingMode ? 'off' : 'on'}">
            {{lightingMode ? 'On' : 'Off'}}
          </vui-button>
        </vui-group-item>

        <vui-group-item label="Emergency Lighting:">
          <div style="width: 105px">
            <span v-if="locked && !siliconUser">{{emergencyMode ? "On" : "Off"}}</span>
            <vui-button v-else icon="lightbulb" :params="{emergency_lights : 1}">{{emergencyMode ? 'On' : 'Off'}}</vui-button>
          </div>
        </vui-group-item>

        <h3>Power Channels</h3>
        <vui-group-item v-for="(channel, channel_title) in powerChannels" :key="channel_title" :label="channel_title">
          <span style="width: 70px; text-align: right">
            {{channel.powerLoad}}&nbsp;W
          </span>
          <span style="width: 105px">
            &nbsp;&nbsp;
            <span :class="channelStatClass(channel.status)">{{channelStatus(channel.status)}}</span>
            <span v-if="locked">
              <span v-if="channel.status == 1 || channel.status == 3">
                &nbsp;&nbsp;{{channelPower(channel.status)}}
              </span>
            </span>
          </span>
          <div v-if="!locked || siliconUser">
            <vui-button icon="sync" :params="{set : 3, chan : channel_title}" :class="{selected : channel.status == 1 || channel.status == 3}">Auto</vui-button>
            <vui-button icon="power" :params="{set : 2, chan : channel_title}" :class="{selected : channel.status == 2}">On</vui-button>
            <vui-button icon="times" :params="{set : 1, chan : channel_title}" :class="{selected : channel.status == 0}">Off</vui-button>
          </div>
        </vui-group-item>

        <vui-group-item label="Total Load:">
          {{totalLoad}}W{{totalCharging ? ` (+ ${totalCharging}W Charging)` : null}}
        </vui-group-item>

        <vui-group-item :balance="0.69">&nbsp;</vui-group-item>

        <vui-group-item label="Cover Lock">
          <div v-if="locked && !siliconUser">
            <span :class="{good : coverLocked, bad : !coverLocked}" v-if="coverLocked">{{coverLocked ? 'Engaged' : 'Disengaged'}}</span>
          </div>
          <div v-else>
            <vui-button :icon="(coverLocked ? 'un' : null) + locked" :params="{lock : 1}">{{coverLocked ? 'E' : 'Dise'}}ngaged</vui-button>
          </div>
        </vui-group-item>

        <div v-if="siliconUser">
          <h3>System Overrides</h3>
          <div>
            <vui-button icon="lightbulb" :params="{overload : 1}">Overload Lighting Circuit</vui-button>
            <vui-button v-if="malfStatus == 1" icon="script" :params="{malfhack : 1}">Override Programming</vui-button>
            <span class="notice" v-else-if="malfStatus > 1">APC Hacked</span>
          </div>
        </div>
      </div>
    </vui-group>
  </div>
</template>

<script>
export default {
  data() {
    return this.$root.$data.state; // Make data more easily accessible
  },
  computed: {
    chargeClass() {
      if(this.chargingStatus > 1) {return "good"}
      if(this.chargingStatus == 1) {return "average"}
      return "bad";
    },
    chargeStatus() {
      if(this.chargingStatus > 1) {return "Fully Charged"}
      if(this.chargingStatus == 1) {return "Charging"}
      return "Not Charging";
    },
    cellClass() {
      if(this.powerCellStatus >= 50) {return "good"}
      if(this.powerCellStatus >= 25) {return "average"}
      return "bad";
    },
    timeRemaining() {
      var hours = Math.round(this.time / 3600)
      var minutes = Math.round(this.time % 3600 / 60)
      var seconds = Math.round(this.time % 60)
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
      if(channelStat <= 1) {return "Off"}
      return "On";
    },
  }
}
</script>
