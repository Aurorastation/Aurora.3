<template>
  <div>
    <vui-group>
      <vui-group-item label="Microphone:">
        <vui-button :class="{selected: listening}" :params="{talk: 1, nowindow: 1}">On</vui-button>
        <vui-button :class="{selected: !listening}" :params="{talk: 1, nowindow: 1}">Off</vui-button>
      </vui-group-item>
      <vui-group-item label="Frequency:">
        <vui-button :params="{freq:-10, nowindow:1}">--</vui-button>
        <vui-button :params="{freq:-2, nowindow:1}">-</vui-button>
        <span>{{ frequency }}</span>
        <vui-button :params="{freq:2, nowindow:1}">+</vui-button>
        <vui-button :params="{freq:10, nowindow:1}">++</vui-button>
      </vui-group-item>
      <vui-group-item v-for="(channel_listening, name) in channels" :label="name" :key="name">
        <vui-button
          :class="{selected: channel_listening}"
          :params="{channel:value.name, listen: 1, nowindow: 1}"
        >On</vui-button>
        <vui-button
          :class="{selected: !channel_listening}"
          :params="{channel:value.name, listen: 1, nowindow: 1}"
        >Off</vui-button>
      </vui-group-item>
    </vui-group>
  </div>
</template>

<script>
export default {
  data() {
    return this.$root.$data.state;
  }
};
</script>