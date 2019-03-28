<template>
  <div>
    <div class="item">
        Behaviour controls are {{data.locked ? "locked" : "unlocked"}}.
        <vui-button :params="{ action: 'test', data: 'This is from ui.' }">Call topic</vui-button>
        <vui-button @click="counter++">Increment counter</vui-button>
    </div>
    <div v-if="data.access">
        <div class="item">
            <div class="itemLabelWide">
                Turret Status:
            </div>
            <div class="itemContentNarrow">
                <vui-button :params="{'command' : 'enable', 'value' : 1, 'turret_ref': value.ref}" :class="{'redButton': value.settings.enabled}">Enabled</vui-button>
                <vui-button :params="{'command' : 'enable', 'value' : 0, 'turret_ref': value.ref}" :class="{'selected': !value.settings.enabled}">Disalbed</vui-button>
            </div>
        </div>	

        <div v-if="data.is_lethal">
            <div class="item">
                <div class="itemLabelWide">
                    Lethal Mode:
                </div>
                <div v-if="data.can_switch">
                    <div class="itemContentNarrow">
                        <vui-button :params="{'command' : 'lethal', 'value' : 1, 'turret_ref': value.ref}" :class="{'redButton': value.settings.lethal}">On</vui-button>
                        <vui-button :params="{'command' : 'lethal', 'value' : 0, 'turret_ref': value.ref}" :class="{'selected': !value.settings.lethal}">Off</vui-button>
                    </div>

                </div>
                <div v-if-else>
                    <div class="itemContentNarrow">
                        <vui-button :class="{'disabled': value.settings.lethal}">On</vui-button>
                        <vui-button :class="{'disabled': !value.settings.lethal}">Off</vui-button>
                    </div>
                </div>
            </div>	
        </div>
        
        <div class="item">
            <div v-for="setting in data" :key="settings">
                <div class="itemLabelWide">
                    {{setting}}
                </div>
                <div class="itemContentNarrow">
                    <vui-button :params="{'command' : setting, 'value' : 1, 'turret_ref': value.ref}" :class="{'redButton': value.settings.lethal}">On</vui-button>
                    <vui-button :params="{'command' : setting, 'value' : 0, 'turret_ref': value.ref}" :class="{'selected': !value.settings.lethal}">Off</vui-button>
                    {{helper.link('On', null, {'command' : value.setting, 'value' : 1},  value.value ? 'selected' : null)}}
                    {{helper.link('Off',null, {'command' : value.setting, 'value' : 0}, !value.value ? 'selected' : null)}}
                </div>
            </div>
        </div>
    </div>
  </div>
</template>