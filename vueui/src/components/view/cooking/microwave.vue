<template>
  <div>
    <template v-if="on == true && cur_time && cook_time">
      <p>Cooking...</p>
      <vui-progress :value="cur_time" :max="cook_time"></vui-progress>
      <vui-button class="danger" icon="exclamation-triangle" push-state :params="{abort: 1}">Abort!</vui-button>
    </template>
    <template v-else-if="on == true">
      <p>Warming up...</p>
    </template>
    <template v-else>
      <ul>
        <li v-for="obj in cookingobjs">
          <vui-button push-state :params="{ eject: obj.name }"> {{ obj.name }} • {{ obj.qty }}
          </vui-button>
        </li>
        <li v-for="r in cookingreas">
          <vui-button push-state> {{ r.name }} • {{ r.amt }} units
          </vui-button>
        </li>
      </ul>
      <div id="cook-panel">
        <vui-button push-state :params="{cook: 1}">Cook!</vui-button>
        <vui-button class="danger" icon="trash" push-state :params="{dispose: 1}">Eject all ingredients</vui-button>
      </div>
    </template>
  </div>
</template>

<script>
export default {
  data() {
    var cur_time = 0;
    var cook_time = 40;
    return this.$root.$data.state; // Make data more easily accessible
  }
};
</script>

<style lang="scss" scoped>
  vui-progress {
    align: center;
  }
  #cook-panel vui-button {
    width: 50%;
  }
</style>