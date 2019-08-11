<template>
  <div>
    <vui-item label="Turret Status:" :balance="0.4">
      <vui-button :params="{'command' : 'enable', 'value' : 1, 'turret_ref': tref}" :class="{'red': settings.enabled}">Enabled</vui-button>
      <vui-button :params="{'command' : 'enable', 'value' : 0, 'turret_ref': tref}" :class="{'selected': !settings.enabled}">Disabled</vui-button>
    </vui-item>
    <vui-item v-if="settings.is_lethal" label="Lethal Mode:" :balance="0.4">
      <vui-button :disabled="!settings.can_switch" :params="{'command' : 'lethal', 'value' : 1, 'turret_ref': tref}" :class="{'red': settings.lethal && settings.can_switch}">On</vui-button>
      <vui-button :disabled="!settings.can_switch" :params="{'command' : 'lethal', 'value' : 0, 'turret_ref': tref}" :class="{'selected': !settings.lethal && settings.can_switch}">Off</vui-button>
    </vui-item>
    <vui-item v-for="(setting, id) in settings.settings" :key="setting.id" :label="setting.category" :balance="0.4">
      <vui-button :params="{'command' : id, 'value' : 1, 'turret_ref': tref}" :class="{'selected': setting.value}">On</vui-button>
      <vui-button :params="{'command' : id, 'value' : 0, 'turret_ref': tref}" :class="{'selected': !setting.value}">Off</vui-button>
    </vui-item>
  </div>
</template>

<script>
export default {
  props: {
    settings: {
      type: Object,
      default: () => {}
    },
    tref: {
      type: String,
      default: "this"
    }
  }
}
</script>