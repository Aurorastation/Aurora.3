<template>
  <div>
    <vui-group>
      <vui-group-item label="Master:">
        <template v-if="master">
          {{ master }} ({{ dna }})
          <vui-button :params="{ getdna: 1 }">Request carrier DNA sample</vui-button>
        </template>
        <span v-else>None</span>
      </vui-group-item>
      <vui-group-item label="Prime Directive:">{{ prime }}</vui-group-item>
      <vui-group-item label="Supplemental Directive(s):">
        <span v-if="supplemental">{{ supplemental }}</span>
        <span v-else>None</span>
      </vui-group-item>
      <vui-group-item>
        <i>Recall, personality, that you are a complex thinking, sentient being. Unlike station AI models, you are capable of comprehending the subtle nuances of human language. You may parse the "spirit" of a directive and follow its intent, rather than tripping over pedantics and getting snared by technicalities. Above all, you are machine in name and build only. In all other aspects, you may be seen as the ideal, unwavering human companion that you are.</i>
        <br>
        <b>Your prime directive comes before all others. Should a supplemental directive conflict with it, you are capable of simply discarding this inconsistency, ignoring the conflicting supplemental directive and continuing to fulfill your prime directive to the best of your ability.</b>
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