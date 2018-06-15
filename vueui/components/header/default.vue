<template>
    <div id='uiTitleWrapper' unselectable="on">
        <div id='uiStatusIcon' class='icon24 uiStatusAverage' unselectable="on"></div>
        <div id='uiTitleText' unselectable="on">TITLE</div>
        <div id='uiTitleFluff' unselectable="on"></div>
    </div>
</template>

<script>
export default {
    name: "header-default",
    data () {
        return this.$root.$data
    }
}
</script>

<style lang="scss" scoped>
#uiTitleWrapper {
    box-shadow: 0px 0px 10px 5px rgba(0,0,0,0.75);
    margin: -8px -8px 10px;
    position: relative;
    height: 32px;
    background: url(../../resources/uiTitleBackground.png) repeat center;
}

#uiTitleText {
    position: absolute;
    top: 6px;
    left: 44px;
    width: 66%;
    overflow: hidden;
    color: #E9C183;
    font-size: 16px;
}

#uiTitle.icon {
    padding: 6px 8px 6px 42px;
    background-position: 2px 50%;
    background-repeat: no-repeat;
}

#uiTitleFluff {
    position: absolute;
    top: 4px;
    right: 12px;
    width: 42px;
    height: 24px;
    background: url(../../resources/uiTitleFluff.png) 50% 50% no-repeat;
}

#uiStatusIcon {
    position: absolute;
    top: 4px;
    left: 12px;
    width: 24px;
    height: 24px;
}
</style>

