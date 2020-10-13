<template>
  <div>
    <b>Analyzing {{name}} </b><br>
    <div v-if="$root.$data.assets['icon']">
      <vui-img name="icon"/>
    </div>
    <div v-if="item == 1">
      <table class="other">
        <tr><td> Damage type: </td> <td class = "right"> {{damage_type}} </td> </tr>
        <tr><td> Item's estimated force-rating: </td> <td class = "right"> {{force}} points</td> </tr>
        <tr><td> Item's estimated throw force-rating: </td> <td class = "right"> {{throw_force}} points </td> </tr>
        <template class="active_energy" v-if="energy == 1">
          <tr> <td> Item's estimated force-rating when activated: </td> <td class = "right"> {{active_force}} points </td> </tr>
          <tr> <td> Item's estimated throw force-rating when activated: </td> <td class = "right"> {{active_throw_force}} points</td> </tr>
          <tr> <td> Base block chance is: </td> <td class = "right"> {{base_block_chance}}% </td> </tr>
          <tr> <td> Base reflect chance is: </td> <td class = "right"> {{base_reflectchance}}% </td> </tr>
          <tr> <td> Item's estimated shield rating: </td> <td class = "right"> {{shield_power}} points</td> </tr>
          <tr> <td> Can block bullets: </td> <td class = "right"> {{can_block}} </td> </tr>
        </template>
        <tr> <td> Is sharp:</td> <td class = "right"> {{sharp}} </td> </tr>
        <tr> <td> Chance to dismember: </td> <td class = "right"> {{edge}} </td> </tr>
        <tr> <td> Item's estimated armor penetration rating: </td> <td class = "right"> {{penetration}} points</td> </tr>
      </table>
    </div>
    <div class="active_energy" v-if="gun == 1">
      <table class="other">
        <tr><td> Maximum shots: </td> <td class = "right"> {{max_shots}} </td> </tr>
        <tr><td> Burst: </td> <td class = "right"> {{burst}} </td> </tr>
        <tr><td> Self recharge: </td> <td class = "right"> {{recharge}} </td> </tr>
        <tr><td> Recharge time: </td> <td class = "right"> {{recharge_time}} </td> </tr>
        <tr><td> Reliability: </td> <td class = "right"> {{reliability}} </td> </tr>
        <br><b>First projectile information: </b><br>
        <tr><td> Projectile's estimated damage rating: </td> <td class = "right"> {{damage}} points</td> </tr>
        <tr><td> Projectile's Damage type: </td> <td class = "right"> {{damage_type}} </td> </tr>
        <tr><td> Projectile's estimated armor penetration rating: </td> <td class = "right"> {{armor_penetration}} points</td> </tr>
        <tr><td> Projectile's armor damage type: </td> <td class = "right"> {{check_armor}} </td> </tr>
        <tr><td> Projectile's shrapnel type: </td> <td class = "right"> {{shrapnel_type}} </td> </tr>
        <tr><td> Stun: </td> <td class = "right"> {{stun}} </td> </tr>
        <template class="active_energy" v-if="secondary_damage">
          <br><b>Second projectile information: </b><br>
          <tr><td> Projectile's estimated damage rating: </td> <td class = "right"> {{secondary_damage}} points</td> </tr>
          <tr><td> Projectile's damage type: </td> <td class = "right"> {{secondary_damage_type}} </td> </tr>
          <tr><td> Projectile's estimated armor penetration rating: </td> <td class = "right"> {{secondary_armor_penetration}} points</td> </tr>
          <tr><td> Projectile's armor damage type: </td> <td class = "right"> {{secondary_check_armor}} </td> </tr>
          <tr><td> Projectile's shrapnel type: </td> <td class = "right"> {{secondary_shrapnel_type}} </td> </tr>
          <tr><td> Stun: </td> <td class = "right"> {{secondary_stun}} </td> </tr>
        </template>
      </table>
    </div>
    <div v-if="gun_mods">
      <br><b>Modular gun information: </b><br>
      <table class="modular">
        <tr>
          <th> Name </th>
          <th> Reliability </th>
          <th> Damage modifier </th>
          <th> Fire delay modifier </th>
          <th> Number of shots modifier </th>
          <th> Burst modifier </th>
          <th> Accuracy modifier </th>
          <th> Repair tool </th>
        </tr>
        <tr v-for="(mod_info, mod_index) in gun_mods" :key="mod_index">
          <td>{{mod_index}}</td>
          <td v-for="(info, index) in mod_info" :key="index">
            {{mod_info[index]}}
          </td>
        </tr>
      </table>
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
.modular {
  font-family: arial, sans-serif;
  border-collapse: collapse;
}

.modular td, .modular th {
  border: 1px solid #dddddd;
  text-align: left;
  padding: 8px;
}
.modular td {
  text-align: center;
}

.other td {
  padding: 5px;
}

.right{ 
  text-align: right;
}

.active_energy {
  display: contents;
}
</style>