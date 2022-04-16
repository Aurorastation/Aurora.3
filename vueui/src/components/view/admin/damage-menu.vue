<template>
  <div>
    <div>
      <h3>Limbs</h3>
      <table class="table border">
        <tr class="header border">
          <th>Name</th>
          <th>Tools</th>
        </tr>
        <tr v-for="(limbexists, limbname) in limbs" class="item border" :key="limbname">
          <td style="width:20%">{{ limbname }}</td>
          <td>
            <vui-button :params="{ target: 'limb', name: limbname, action: 'brute' }">Brute</vui-button>
            <vui-button :params="{ target: 'limb', name: limbname, action: 'burn' }">Burn</vui-button>
            <vui-button :params="{ target: 'limb', name: limbname, action: 'infection' }">Infection</vui-button>
            <vui-button :params="{ target: 'limb', name: limbname, action: 'shatter' }">Shatter</vui-button>
            <vui-button :params="{ target: 'limb', name: limbname, action: 'arterial' }">Arterial</vui-button>
            <vui-button :params="{ target: 'limb', name: limbname, action: 'sever' }">Sever</vui-button>
          </td>
        </tr>
      </table>
    </div>
    <div>
      <h3>Organs</h3>
      <table class="table border">
        <tr class="header border">
          <th>Name</th>
          <th>Tools</th>
        </tr>
        <tr v-for="(organexists, organname) in organs" class="item border" :key="organname">
          <td style="width:20%">{{ organname }}</td>
          <td>
            <vui-button :params="{ target: 'organ', name: organname, action: 'damage' }">Damage</vui-button>
            <vui-button :params="{ target: 'organ', name: organname, action: 'infection' }">Infection</vui-button>
            <vui-button :params="{ target: 'organ', name: organname, action: 'bruise' }">Bruise</vui-button>
            <vui-button :params="{ target: 'organ', name: organname, action: 'break' }">Break</vui-button>
            <vui-button :params="{ target: 'organ', name: organname, action: 'remove' }">Remove</vui-button>
          </td>
        </tr>
      </table>
    </div>
    <div>
      <h3>Miscellaneous</h3>
      <vui-button :params="{ target: 'misc', action: 'wind' }">Toggle Wind</vui-button>
      <vui-button :params="{ target: 'misc', action: 'gigashatter' }">Gigashatter</vui-button>
      <vui-button :params="{ target: 'misc', action: 'kill' }">Kill</vui-button>
      <vui-button :params="{ target: 'misc', action: 'gib' }">Gib</vui-button>
      <vui-button :params="{ target: 'misc', action: 'dust' }">Dust</vui-button>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return this.$root.$data.state;
  }
}
</script>

<style lang="scss" scoped>
table {
  width: 100%;
  text-align: center;
}
tr {
  line-height: 135%;
}
</style>
