<template>
  <div>
    Analyzing {{name}} <br>
    <div v-if="$root.$data.assets['icon']">
        <vui-img name="icon"/>
    </div>
    <div v-if="item == 1">
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
        Damage: {{damage}} <br>
        Burst: {{burst}} <br>
        Self recharge: {{recharge}} <br>
        Recharge time: {{recharge_time}} <br>
        Reliability: {{reliability}} <br>
        <div v-if="secondary_damage">
            Secondary mode damage: {{secondary_damage}}
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