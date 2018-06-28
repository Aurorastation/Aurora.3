<template>
    <div>
        <span v-if="state.toner">Current toner level: {{ state.toner }}</span><br>
        <vui-button v-if="state.gotitem" :params="{remove: 1}">Remove Item</vui-button>
        <template v-if="state.toner">
            <template v-if="state.gotitem">
                <div class="item">
                    <div class="itemLabel">Copies to print:</div>
                    <div class="itemContent">
                        {{ state.copies }} <vui-button :disabled="state.copies <= 1" @click="state.copies--">-</vui-button><vui-button :disabled="state.copies >= state.maxcopies" @click="state.copies++">+</vui-button>
                    </div>
                </div>
                <div class="item">
                    <div class="itemLabel"/>
                    <div class="itemContent">
                        <vui-button push-state :params="{copy: 1}">Copy</vui-button>
                    </div>
                </div>
            </template>
            <template v-else>
                <h3>Please insert something to copy.</h3>
            </template><br>
            <vui-button v-if="state.isAI" :params="{aipic: 1}">Print photo from database</vui-button>
        </template>
        <template v-else>
            <h2>Please insert a new toner cartridge!</h2>
        </template>
    </div>
</template>


<script>
export default {
    name: 'view-paperwork-photocopier',
    data() {
        return this.$root.$data;
    }
};
</script>