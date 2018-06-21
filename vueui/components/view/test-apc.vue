<template>
    <div>
        <div class='notice'>
            Swipe an ID card to unlock this interface
        </div>
        <div style="min-width: 480px">
            <h3>Power Status</h3>
            <div class="item">
                <div class="itemLabel">Main Breaker:</div>
                <div class="itemContent">
                    <span class='good'>On</span>
                </div>
            </div>
            <div class="item">
                <div class="itemLabel">External Power:</div>
                <div class="itemContent">
                    <span class='bad'>None</span>
                </div>
            </div>
            <div class="item">
                <div class="itemLabel">Power Cell:</div>
                <div class="itemContent">
                    <vui-progress :value="90" class="good"></vui-progress>
                    90%
                </div>
            </div>
            <div class="item">
                <div class="itemLabel">Charge Mode:</div>
                <div class="itemContent">
                    <span class='good'>Auto</span> [<span class='bad'>Not Charging</span>]
                </div>
            </div>
            <div class="item">
                <div class="itemLabel">Night Lighting:</div>
                <div class="itemContent">
                    <vui-button icon="night" disabled>On</vui-button>
                    <vui-button icon="close" class="selected">Off</vui-button>
                </div>
            </div>
            <div class="item">
                <div class="itemLabel">Emergency Lighting:</div>
                <div class="itemContent">
                    On
                </div>
            </div>
            <h3>Power Channels</h3>
            <div v-for="value in [
            {title: 'Equipment', powerLoad: 10, status: 3},
            {title: 'Lighting', powerLoad: 2, status: 3},
            {title: 'Envoriment', powerLoad: 10, status: 3}
            ]" :key="value.title" class="item">
                <div class="itemLabel">{{ value.title }}:</div>
                <div class="itemContent" style="width: 70px; text-align: right">{{ value.powerLoad }} W</div>
                <div class="itemContent" style="width: 105px;">&nbsp;&nbsp;
                    <span class='bad' v-if="value.status <= 1">Off</span>
                    <span class='good' v-if="value.status >= 2">On</span>
                    <span v-if="value.status == 1 || value.status == 3">&nbsp;&nbsp;Auto</span>
                    <span v-else>&nbsp;&nbsp;Manual</span>
                </div>
            </div>
            <div class="item" style="font-weight: bold;">
                <div class="itemLabel">Total Load:</div>
                <div class="itemContent">
                    22W
                </div>
            </div>
            <div class="item">
                <div class="itemLabel">Cover Lock:</div>
                <div class="itemContent">
                    <span class='good'>Engaged</span>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
export default {
    name: "view-test-apc"
}
</script>
