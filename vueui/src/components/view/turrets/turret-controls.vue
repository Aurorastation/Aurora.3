<template>
  <div>
    <div class="item">
      Behaviour controls are {{locked ? "locked" : "unlocked"}}.
    </div>
    <div v-if="access">
      <div class="item">
        <div class="itemLabelWide">
          Turret Status:
        </div>
        <div class="itemContentNarrow">
          <vui-button :params="{'command' : 'enable', 'value' : 1}" :class="{'redButton': enabled}">Enabled</vui-button>
          <vui-button :params="{'command' : 'enable', 'value' : 0}" :class="{'selected': !enabled}">Disalbed</vui-button>
        </div>
      </div>	

      <div v-if="is_lethal">
        <div class="item">
          <div class="itemLabelWide">
            Lethal Mode:
          </div>
          <div v-if="can_switch">
            <div class="itemContentNarrow">
              <vui-button :params="{'command' : 'lethal', 'value' : 1}" :class="{'redButton': lethal}">On</vui-button>
              <vui-button :params="{'command' : 'lethal', 'value' : 0}" :class="{'selected': !lethal}">Off</vui-button>
            </div>
          </div>

          <div v-if-else>
            <div class="itemContentNarrow">
              <vui-button :class="{'disabled': lethal}">On</vui-button>
              <vui-button :class="{'disabled': !lethal}">Off</vui-button>
            </div>
          </div>
        </div>	
      </div>
      <div class="item">
        <div v-for="setting in settings">
          <div class="itemLabelWide">
            {{setting}}
          </div>
          <div class="itemContentNarrow">
            <vui-button :params="{'command' : setting.setting, 'value' : 1}" :class="{'selected': setting.value}">On</vui-button>
            <vui-button :params="{'command' : setting.setting, 'value' : 0}" :class="{'selected': !setting.value}">Off</vui-button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return this.$root.$data.state; // Make data more easily accessible
  }
};
</script>