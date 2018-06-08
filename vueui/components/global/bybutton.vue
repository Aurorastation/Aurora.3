<template>
    <div @click="senddata()" class="button">
        <slot>A button</slot>
    </div>
</template>

<script>
export default {
    name: 'bybutton',
    props: {
        icon: {
            type: [String],
            default: ""
        },
        params: {
            type: Object,
            default: []
        }
    },
    methods: {
        senddata() {
            var sendparams = []
            for(var val in this.params) {
                sendparams.push(encodeURIComponent(val) + "=" + encodeURIComponent(this.params[val]))
            }
            
            var r = new XMLHttpRequest()
            r.open("GET", "?src=" + this.$root.$data.uiref + "&" + sendparams.join("&"), true);
            r.send()
        }
    }
}
</script>

<style lang="scss">
    
</style>