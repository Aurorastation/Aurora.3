<template>
  <div>
    <template v-if="on">
      <p>Cooking...</p>
      <vui-progress :value="$root.$data.wtime" :min="start_time" :max="start_time + cook_time"/>
      <vui-button class="danger danger-control" icon="exclamation-triangle" :params="{abort: 1}">Abort!</vui-button>
    </template>
    <template v-else>
      <h4>Ingredients</h4>
      <ul>
        <li v-if="!ingredientsPresent">The microwave is empty!</li>
        <li v-for="(amt, name) in cookingobjs" :key="name">
          <vui-button push-state :params="{ eject: name }"> {{ name }} • {{ amt }}
          </vui-button>
        </li>
        <li v-for="(amt, name) in cookingreas" :key="name">
          <vui-button push-state :params="{ eject: name }"> {{ name }} • {{ amt }} units
          </vui-button>
        </li>
      </ul>
      <vui-button class="danger danger-control" icon="trash" :params="{eject_all: 1}">Eject All</vui-button>
      <vui-button class="control" :params="{cook: 1}">Cook!</vui-button>
    </template>
  </div>
</template>

<script>
export default {
  data() {
    return this.$root.$data.state; // Make data more easily accessible
  },
  computed: {
    ingredientsPresent() {
      return (Object.keys(this.cookingobjs).length > 0 || Object.keys(this.cookingreas).length > 0);
    }
  }
};
</script>

<style lang="scss" scoped>
  // I am so sorry.
  ul {
    padding: 4px 4px 10px 10px;
  }
  .danger-control {
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