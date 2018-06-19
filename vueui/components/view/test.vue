<template>
    <div>
        <code>{{ active }}</code> TEST UI IS LOADED
        <vui-button v-on:click="state.c++"></vui-button>
        {{ state.c }}
        <vui-img name="testimg"></vui-img>
        <vui-button :params="{ action: 'test', data: 'app' }" icon="shuffle">TEST BTN</vui-button><a class="button">Normal</a><a class="button on">On</a><a class="button off">Off</a><a class="button danger">Danger</a><a class="button yellow">Yellow</a>
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

<style lang="scss" scoped>
</style>