<template>
    <div>
        <code>{{ active }}</code> TEST UI IS LOADED
        <button v-on:click="state.c++"></button>
        {{ state.c }}
        <bybutton :params="{ action: 'test', data: 'app' }">TEST BTN</bybutton><a class="button">Normal</a><a class="button on">On</a><a class="button off">Off</a><a class="button danger">Danger</a><a class="button yellow">Yellow</a>
        <div class="uiIcon16 icon-captain green"></div>
    </div>
</template>

<script>
export default {
  name: 'ui-test',
  data() {
    return this.$root.$data;
  }
};
</script>

<style lang="scss" scoped>
</style>