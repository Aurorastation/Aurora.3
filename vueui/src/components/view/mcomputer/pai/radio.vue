<template>
  <div>
    <vui-group>
      <vui-group-item label="Microphone:">
        <vui-button :class="{ selected: listening }" :params="{ talk: 1, nowindow: 1 }">On</vui-button>
        <vui-button :class="{ selected: !listening }" :params="{ talk: 1, nowindow: 1 }">Off</vui-button>
      </vui-group-item>
      <vui-group-item label="Frequency:">
        <vui-button :params="{ freq: -10, nowindow: 1 }">--</vui-button>
        <vui-button :params="{ freq: -2, nowindow: 1 }">-</vui-button>
        <span>{{ frequency }}</span>
        <vui-button :params="{ freq: 2, nowindow: 1 }">+</vui-button>
        <vui-button :params="{ freq: 10, nowindow: 1 }">++</vui-button>
      </vui-group-item>
      <vui-item label="Range:">
        <vui-input-slider :min="0" :max="4" v-model="radio_range" />
      </vui-item>
      <hr />
      <vui-group-item v-for="channel in channels" :label="channel.name" :key="channel.name">
        <vui-button :class="{ selected: channel.listening }" :params="{ ch_name: channel.name, listen: 1, nowindow: 1 }"
          >On</vui-button
        >
        <vui-button
          :class="{ selected: !channel.listening }"
          :params="{ ch_name: channel.name, listen: 1, nowindow: 1 }"
          >Off</vui-button
        >
      </vui-group-item>
    </vui-group>
  </div>
</template>

<script>
export default {
  data() {
    return this.$root.$data.state
  },
}
</script>
