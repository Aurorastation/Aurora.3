<template>
  <div>
    <b>Analyzing {{name}} </b><br>
    <div v-if="$root.$data.assets['icon']">
        <vui-img name="icon"/>
    </div>
    <div v-if="item == 1">
        Damage type: {{damage_type}} <br>
        Force: {{force}} <br>
        Throw force: {{throw_force}} <br>
        <div v-if="energy == 1">
            Active force: {{active_force}} <br>
            Active throw force: {{active_throw_force}} <br>
            Base block chance: {{base_block_chance}}% <br>
            Base reflect chance: {{base_reflectchance}}% <br>
            Shield power: {{shield_power}} <br>
            Can block bullets: {{can_block}} <br>
        </div>
        Is sharp: {{sharp}} <br>
        Chance to dismember: {{edge}} <br>
        Armor penetration: {{penetration}} <br>
    </div>
    <div v-if="gun == 1">
        Max shots: {{max_shots}} <br>
        Burst: {{burst}} <br>
        Self recharge: {{recharge}} <br>
        Recharge time: {{recharge_time}} <br>
        Reliability: {{reliability}} <br>
        <div>
            <br><b>First projectile information: </b><br>
            Damage: {{damage}} <br>
            Damage type: {{damage_type}} <br>
            Armor penetration: {{armor_penetration}} <br>
            Armor damage type: {{check_armor}} <br>
            Shrapnel type: {{shrapnel_type}} <br>
            Stun: {{stun}} <br>
        </div>
        <div v-if="secondary_damage">
            <br><b>Second projectile information: </b><br>
            Damage: {{secondary_damage}} <br>
            Damage type: {{secondary_damage_type}} <br>
            Armor penetration: {{secondary_armor_penetration}} <br>
            Armor damage type: {{secondary_check_armor}} <br>
            Shrapnel type: {{secondary_shrapnel_type}} <br>
            Stun: {{secondary_stun}} <br>
        </div>
        <div v-if="gun_mods">
          <br><b>Modular gun information: </b><br>
          <table>
            <tr>
                <th> Name </th>
                <th> Reliability </th>
                <th> Damage modifier </th>
                <th> Fire delay modifier </th>
                <th> Number of Shots modifier </th>
                <th> Burst modifier </th>
                <th> Accuracy modifier </th>
                <th> Repair tool </th>
            </tr>
            <vui-item v-for="(mod_info, mod_index) in gun_mods" :key="mod_index" :label="mod_index" :balance="0.4">
              <tr>
                <td>{{mod_index}}</td>
                <vui-item v-for="(info, index) in gun_mods[mod_index]" :key="index" :label="index" :balance="0.4">
                  <td> {{gun_mods[mod_index][index]}} </td>
                </vui-item>
              </tr>
            </vui-item>
          </table>
        </div>
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
  font-family: arial, sans-serif;
  border-collapse: collapse;
  width: 100%;
}

td, th {
  border: 1px solid #dddddd;
  text-align: left;
  padding: 8px;
}
</style>