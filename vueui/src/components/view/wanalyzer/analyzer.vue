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

            <b-table striped hover :items="gun_mods"></b-table>
          <!-- <vui-item v-for="(info, index) in gun_mods" :key="index" :label="index" :balance="0.4">
            <div> {{info}} : {{gun_mods[index]}}</div> <br>
          </vui-item> -->
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