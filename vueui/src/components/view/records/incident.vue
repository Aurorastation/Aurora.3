<template>
  <vui-group>
    <vui-group-item label="UID:">{{incident.id}}</vui-group-item>
    <vui-group-item label="Date:">{{incident.datetime}}</vui-group-item>
    <vui-group-item label="Charges:">
      <span :key="index" v-for="(charge, index) in incident.charges">
        {{charge}}<span v-if="index+1 < incident.charges.length">, </span>
      </span>
    </vui-group-item>
    <vui-group-item label="Notes:">{{incident.notes}}</vui-group-item>
  </vui-group>
</template>

<script>
export default {
  props: {
    incident: {
      type: Object,
      default: () => {}
    }
  }
}
</script>
