<template>
    <div>
        <view-test-apc></view-test-apc>
        <div>------</div>
        <view-fax></view-fax>
        <div>------</div>
        <code>{{ active }}</code> TEST UI IS LOADED
        <vui-button v-on:click="state.c++"></vui-button>
        {{ state.c }}
        <vui-img name="testimg"></vui-img>
        <vui-button :params="{ action: 'test', data: 'app' }" icon="shuffle">TEST BTN</vui-button><vui-button>Normal</vui-button><vui-button class="on">On</vui-button><vui-button class="off">Off</vui-button><vui-button class="danger">Danger</vui-button><vui-button class="yellow">Yellow</vui-button>
        <div class="uiIcon16 icon-captain green"></div>
        
    </div>
</template>

<script>
export default {
    name: 'view-test',
    data() {
        return this.$root.$data;
    }
};
</script>