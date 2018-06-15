<template>
    <div class="displayBar">
        <div class="displayBarFill" :style="{ width: percentage + '%'}"></div>
    </div>
</template>

<script>
export default {
    name: 'vui-progress',
    props: {
        value: {
            type: Number,
            default: 50
        },
        max: {
            type: Number,
            default: 100
        },
        min: {
            type: Number,
            default: 0
        }
    },
    computed: {
        percentage() {
            return (this.value - this.min) / (this.max - this.min) * 100
        }
    }
}
</script>


<style lang="scss" scoped>
.displayBar {
    display: inline-block;
    background: #000000;
    margin: 0 5px 0 0;
    border: 1px solid #666666;
    overflow: hidden;
    width: 236px;
    height: 16px;
    vertical-align: text-bottom;
    .displayBarFill {
        width: 0%;
        height: 100%;
        background: #40628a;
        overflow: hidden;
        float: left;
        color: #ffffff;
    }
    &.good .displayBarFill {
        background: #4f7529;
    }
    &.average .displayBarFill {
        background: #cd6500;
    }
    &.bad .displayBarFill {
        background: #ee0000;
    }
    &.highlight .displayBarFill {
        background: #8BA5C4;
    }
}

</style>
