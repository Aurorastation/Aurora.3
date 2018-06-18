<template>
    <div id='uiTitleWrapper' unselectable="on">
        <slot></slot>
        <div id='uiStatusIcon' class='icon24' :class="statusClass" unselectable="on"></div>
        <div id='uiTitleText' unselectable="on">{{ title }}</div>
        <div id='uiTitleFluff' unselectable="on"></div>
    </div>
</template>

<script>
export default {
    name: "header-default",
    data () {
        return this.$root.$data
    },
    computed: {
        statusClass() {
            if (this.status == 2) return 'uiStatusGood'
            if (this.status == 1) return 'uiStatusAverage'
            return 'uiStatusBad'
        }
    }
}
</script>

<style lang="scss" scoped>
#uiTitleWrapper {
    box-shadow: 0px 0px 8px 4px rgba(0,0,0,0.5);
    margin: -8px -8px 10px;
    position: relative;
    padding-bottom: 8px;
    float: none;
    background: url(../../resources/uiTitleBackground.png) repeat center;
}

#uiTitleText {
    position: relative;
    display: inline-block;
    top: 4px;
    left: 18px;
    width: 66%;
    width: calc(100% - 36px - 42px - 18px);
    color: #E9C183;
    font-size: 16px;
    line-height: 20px;
    vertical-align: middle;
}

#uiTitle.icon {
    padding: 6px 8px 6px 42px;
    background-position: 2px 50%;
    background-repeat: no-repeat;
}

#uiTitleFluff {
    position: relative;
    float: right;
    top: 4px;
    right: 10px;
    width: 42px;
    height: 24px;
    background: url(../../resources/uiTitleFluff.png) 50% 50% no-repeat;
}

#uiStatusIcon {
    position: relative;
    display: inline-block;
    top: 4px;
    left: 12px;
    vertical-align: middle;
}
</style>

