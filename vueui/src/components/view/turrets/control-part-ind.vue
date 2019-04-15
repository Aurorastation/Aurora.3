<template>
  <div>
    <vui-item label="Turret Status:" :balance="0.4">
      <vui-button :params="{'turret' : 'enable', 'value' : 1, 'turret_ref': turret.ref}" :class="{'red': turret.settings.enabled}">Enabled</vui-button>
      <vui-button :params="{'turret' : 'enable', 'value' : 0, 'turret_ref': turret.ref}" :class="{'selected': !turret.settings.enabled}">Disabled</vui-button>
    </vui-item>
    <vui-item v-if="turret.settings.is_lethal" label="Lethal Mode:" :balance="0.4">
      <vui-button :disabled="!turret.settings.can_switch" :params="{'turret' : 'lethal', 'value' : 1, 'turret_ref': turret.ref}" :class="{'red': turret.settings.lethal && turret.settings.can_switch}">On</vui-button>
      <vui-button :disabled="!turret.settings.can_switch" :params="{'turret' : 'lethal', 'value' : 0, 'turret_ref': turret.ref}" :class="{'selected': !turret.settings.lethal && turret.settings.can_switch}">Off</vui-button>
    </vui-item>
    <vui-item v-for="setting in turret.settings.settings" :key="setting.category" :label="setting.category" :balance="0.4">
      <vui-button :params="{'turret' : setting.setting, 'value' : 1, 'turret_ref': turret.ref}" :class="{'selected': setting.value}">On</vui-button>
      <vui-button :params="{'turret' : setting.setting, 'value' : 0, 'turret_ref': turret.ref}" :class="{'selected': !setting.value}">Off</vui-button>
    </vui-item>
  </div>
</template>

<script>
export default {
  props: {
    turret: {
      type: Object,
      default: {}
    }
  }
}
</script>