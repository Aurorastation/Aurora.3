<template>
    <img :width="width" :height="height" :src="source">
</template>

<script>
export default {
    name: "vui-img",
    props: {
        name: {
            type: String,
            default: ""
        },
        width: {
            type: Number
        },
        heigth: {
            type: Number
        }
    },
    computed: {
        source() {
            return "vueuiimg_" + this.$root.$data.assets[this.name].ref + ".png"
        }
    }
}
</script>
