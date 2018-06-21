<template>
    <div @click="senddata()" class="button" :disabled="$root.$data.status < 2">
        <div v-if="icon" :class="'uiIcon16 icon-' + icon"></div>
        <span><slot></slot></span>
    </div>
</template>

<script>
export default {
    name: 'vui-button',
    props: {
        icon: {
            type: String,
            default: ""
        },
        params: {
            type: Object,
            default() {
                return {}
            }
        }
    },
    methods: {
        senddata() {
            if(this.$root.$data.status < 2) {
                return
            }
            this.$emit('click')
            if(!this.params) {
                return
            }
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