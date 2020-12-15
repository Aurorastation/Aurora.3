<template>
  <div>
    <div v-if="failTime" class="notice"> <!-- Failure - Disabled -->
      <h3 class="fw-bold">SYSTEM FAILURE</h3>
      <span class="fst-italic">I/O regulator malfuction detected! Waiting for system reboot...</span><br/>
      Automatic reboot in {{failTime}} seconds...
      <vui-button icon="refresh" :params="{reboot : 1}">Reboot Now</vui-button>
    </div>
    <div v-else> <!-- Main -->
      <div class="notice"> <!-- Lock -->
        <div v-if="siliconUser">
          <vui-item label="Interface Lock:">
            <vui-button icon="locked" :params="{toggleaccess : 1}" :class="{selected : locked}">Engaged</vui-button>
            <vui-button icon="unlocked" :params="{toggleaccess : 1}" :disabled="malfstatus >= 2" :class="{selected : (malfstatus < 2) && !locked}">Disengaged</vui-button>
          </vui-item>
        </div>
        <span v-else>Swipe an ID card to {{locked ? 'un' : null}}lock this interface.</span>
      </div>

      <div style="min-width: 480px"> <!-- Body -->
        <h3>Power Status</h3>
        <vui-item label="Main Breaker:">
          <div v-if="locked && !siliconUser">
            <span :class="{good : isOperating, bad : !isOperating}">{{isOperating ? 'On' : 'Off'}}</span>
          </div>
          <div v-else>
            <vui-button icon="close" :params="{breaker : 1}" v-if="!isOperating">Off</vui-button>
            <vui-button icon="power" :params="{breaker : 1}" v-else>On</vui-button>
          </div>
        </vui-item>

        <vui-item label="External Power:">
          <span v-if="externalPower == 2" class="good">Good</span>
          <span v-else-if="externalPower == 1" class="average">Low</span>
          <span v-else class="bad">None</span>
        </vui-item>

        <vui-item label="Power Cell">
          <span v-if="powerCellStatus == null" class="bad">Power cell removed.</span>
          <div v-else>
            <vui-progress :value="powerCellStatus" :min="0" :max="100" :class="[(powerCellStatus >= 50) ? good : (powerCellStatus >= 25) ? average : bad]"/>
            <div style="width:60px">
              {{powerCellStatus}}
            </div>
          </div>
        </vui-item>

        <vui-item label="Power Cell charge status:">
          <div class="statusValue">
            <span v-if="charge_mode == 1">APC's power cell will be fully charged in {{time}}</span>
            <span v-else-if="charge_mode == 2">APC consumption and production are equal</span>
            <span v-else>APC will run out of charge in {{time}}</span>
          </div>
        </vui-item>

        <vui-item label="Charge Mode:" v-if="powerCellStatus != null">
          <span v-if="locked && !siliconUser" :class="{good : chargeMode, bad : !chargeMode}">{{chargeMode ? "Auto" : "Off"}}</span>
          <vui-button v-else :icon="chargeMode ? refresh : close" :params="{cmode : 1}">{{chargeMode ? 'Auto' : 'Off'}}</vui-button>
          &nbsp;
          <span v-if="chargingStatus > 1" class="good">Fully Charged</span>
          <span v-else-if="chargingStatus == 1">Charging</span>
          <span v-else>Not Charging<span/></span></vui-item>

        <vui-item label="Night Lighting:">
          <vui-button :icon="lightingMode ? night : close" :params="{lmode : lightingMode ? 'on' : 'off'}">
            {{lightingMode ? 'On' : 'Off'}}
          </vui-button>
        </vui-item>

        <vui-item label="Emergency Lighting:">
          <div style="width: 105px">
            <span v-if="locked && !siliconUser">{{emergencyMode ? "On" : "Off"}}</span>
            <vui-button v-else icon="lightbulb" :params="{emergency_lights : emergencyMode ? 'on' : 'off'}">{{emergencyMode ? 'On' : 'Off'}}</vui-button>
          </div>
        </vui-item>

        <h3>Power Channels</h3>
        <vui-item v-for="channel in powerChannels" :key="channel.title" :label="channel.title">
          <div style="width: 70px; text-align: right">
            {{channel.powerLoad}}&nbsp;W
          </div>
          <div style="width: 105px">
            &nbsp;&nbsp;
            <span v-if="channel.status <= 1" class="bad">Off</span>
            <span v-else class="good">On</span>
            <div v-if="locked">
              <span v-if="channel.status == 1 || channel.status == 3">
                &nbsp;&nbsp;Auto
              </span>
              <span v-else>
                &nbsp;&nbsp;Manual
              </span>
            </div>
          </div>
          <div v-if="!locked || siliconUser">
            <vui-button icon="refresh" :params="channel.topicParams.auto" :class="{selected : value.status == 1 || value.status == 3}">Auto</vui-button>
            <vui-button icon="power" :params="channel.topicParams.on" :class="{selected : value.status == 2}">On</vui-button>
            <vui-button icon="close" :params="channel.topicParams.off" :class="{selected : value.status == 0}">Off</vui-button>
          </div>
        </vui-item>

        <vui-item label="Total Load:">
          {{totalLoad}}W{{totalCharging ? ` (+ ${totalCharging}W Charging)` : null}}
        </vui-item>

        <vui-item>&nbsp;</vui-item>

        <vui-item label="Cover Lock">
          <div v-if="locked && !siliconUser">
            <span :class="{good : coverLocked, bad : !coverLocked}" v-if="coverLocked">{{coverLocked ? 'Engaged' : 'Disengaged'}}</span>
          </div>
          <div v-else>
            <vui-button :icon="(coverLocked ? 'un' : null) + locked" :params="{lock : 1}">{{coverLocked ? 'E' : 'Dise'}}ngaged</vui-button>
          </div>
        </vui-item>

        <div v-if="siliconUser">
          <h3>System Overrides</h3>
          <div>
            <vui-button icon="lightbulb" :params="{overload : 1}">Overload Lighting Circuit</vui-button>
            <vui-button v-if="malfStatus == 1" icon="script" :params="{malfhack : 1}">Override Programming</vui-button>
            <span class="notice" v-else-if="malfStatus > 1">APC Hacked</span>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return this.$root.$state; // Make data more easily accessible
  }
}
</script>
