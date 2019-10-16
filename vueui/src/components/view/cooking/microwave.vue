<template>
  <div>
    <template v-if="on == true">
      <p>Cooking...</p>
      <vui-progress v-if="cook_time" :value="cur_time" :max="cook_time"></vui-progress>
      <vui-button class="danger" icon="exclamation-triangle" push-state :params="{abort: 1}">Abort!</vui-button>
    </template>
    <template v-else>
      <h4>Ingredients</h4>
      <ul>
        <li v-if="cookingobjs.length == 0 && cookingreas.length == 0">The microwave is empty!</li>
        <li v-for="obj in cookingobjs">
          <vui-button push-state :params="{ eject: obj.name }"> {{ obj.name }} • {{ obj.qty }}
          </vui-button>
        </li>
        <li v-for="r in cookingreas">
          <vui-button push-state :params="{ eject: r.name }"> {{ r.name }} • {{ r.amt }} units
          </vui-button>
        </li>
      </ul>
        <vui-button class="danger" icon="trash" push-state :params="{eject_all: 1}">Eject All</vui-button>
        <vui-button class="control" :params="{cook: 1}">Cook!</vui-button>
    </template>
  </div>
</template>

<script>
export default {
  data() {
    return this.$root.$data.state; // Make data more easily accessible
  }
};
</script>

<style lang="scss" scoped>
  // I am so sorry.
  ul {
    padding: 4px 4px 10px 10px;
  }
  .danger {
    position: fixed;
    right: 20px;
    bottom: 20px;
  }
  .control {
    position: fixed;
    left: 20px;
    bottom: 20px;
  }
</style>