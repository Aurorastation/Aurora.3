<template>
  <div>
    <vui-group>
      <vui-group-item label="Designation:">
        {{ s.doorArea }} - {{ s.doorName }}
      </vui-group-item>
      <vui-group-item label="Main power:">
        <vui-progress
          :class="{ good: s.plu_main == 0, bad: s.plu_main == -1, average: s.plu_main > 0 }"
          style="width: 12em;"
          :value="gs.wtime"
          :min="s.plua_main"
          :max="s.plu_main || 10">
          {{ mainMsg }}
        </vui-progress>
        <vui-button :disabled="s.plu_main != 0" :params="{ command: 'main_power'}">Interrupt</vui-button>
      </vui-group-item>
      <vui-group-item label="Backup power:">
        <vui-progress
          :class="{ good: s.plu_back == 0 || s.plu_main == 0, bad: s.plu_back == -1 && s.plu_main != 0, average: s.plu_back > 0 }"
          style="width: 12em;"
          :value="gs.wtime"
          :min="s.plua_back"
          :max="s.plu_back || 10">
          {{ backupMsg }}
        </vui-progress>
        <vui-button :disabled="s.plu_back != 0" :params="{ command: 'backup_power'}">Interrupt</vui-button>
      </vui-group-item>
      <vui-group-item label="Electrified status:">
        <vui-progress
          :class="{ good: s.ele == 0, bad: s.ele == -1, average: s.ele > 0 }"
          style="width: 12em;"
          :value="gs.wtime"
          :min="s.elea"
          :max="s.ele || 10">
          {{ eleMsg }}
        </vui-progress>
        <vui-button :disabled="s.ele == 0" :params="{ command: 'electrify_permanently', activate: 0}">R</vui-button>
        <template v-if="s.isAdmin || !s.isai">
          <vui-button :disabled="s.ele > 0" :params="{ command: 'electrify_temporary', activate: 1}">T</vui-button>
          <vui-button :disabled="s.ele == -1" :params="{ command: 'electrify_permanently', activate: 1}">P</vui-button>
        </template>
      </vui-group-item>
      <vui-group-item>
        &nbsp;
      </vui-group-item>
      <vui-group-item v-for="(c, k) in commands" :key="k" :label="c.name + ':'">
        <vui-button style="min-width: 6em" :class="{on: s[k] && !c.noActivate, danger: !!c.alwaysDanger}" :params="{ command: k, activate: c.i ? 1 : 0 }">{{ c.et || 'Enabled' }}</vui-button>
        <vui-button :disabled="!!(c.a && s.isai && !s.isAdmin)" style="min-width: 6em" :class="{on: !s[k] && !c.d && !c.noActivate, danger: !!c.alwaysDanger || (!s[k] && c.danger)}" :params="{ command: k, activate: c.i ? 0 : 1 }">{{ c.dt || 'Disabled' }}</vui-button>
      </vui-group-item>
    </vui-group>
  </div>
</template>

<script>
export default {
  data() {
    var gs = this.$root.$data
    var s = gs.state
    var ret = {
      gs,
      s,
      commands: {
        idscan: {
          name: 'IdScan',
          i: true
        },
        bolts: {
          name: 'Bolts',
          et: 'Raised',
          dt: 'Dropped',
          a: !s.aiCanBolt
        },
        bolts_override: {
          name: 'Bolts Override',
          et: 'Raise Now',
          dt: 'Drop Now',
          noActivate: true,
          alwaysDanger: true
        },
        lights: {
          name: 'Bolt Lights',
          i: true
        },
        safeties: {
          name: 'Safeties',
          et: 'Nominal',
          dt: 'Overridden',
          danger: true,
          a: true
        },
        timing: {
          name: 'Timing',
          et: 'Nominal',
          dt: 'Overridden',
          danger: true
        },
        open: {
          name: 'Door State',
          et: 'Opened',
          dt: 'Closed',
          i: 1
        }
      }
    }
    if(!s.boltsOverride) {
      delete ret.commands.bolts_override
    }
    return ret
  },
  computed: {
    mainMsg() {
      return this.getPowerStatusMessage(this.s.plu_main, this.gs.wtime)
    },
    backupMsg() {
      return this.getPowerStatusMessage(this.s.plu_back, this.gs.wtime)
    },
    eleMsg() {
      if(this.s.ele == 0) {
        return 'Safe'
      } else if (this.s.ele == -1) {
        return 'Permanently'
      } else {
        var lt = Math.max(Math.round((this.s.ele - this.gs.wtime) / 10), 0)
        return `${lt}s left`
      }
    }
  },
  methods: {
    getPowerStatusMessage(state, time) {
      if(state == -1) {
        return 'Offline'
      } else if (state == 0) {
        return 'Online'
      } else {
        var lt = Math.max(Math.round((state - time) / 10), 0)
        return `Interrupted, ${lt}s left`
      }
    }
  }
}
</script>
