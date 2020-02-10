<template>

  <div>
    <template v-if="debug">
      <center><h3>DEBUG PRINTER -- Infinite materials. Cloning available.</h3></center>
    </template>
    <template v-else>
      Materials: &nbsp;
      <span v-for="(amount, material) in materials" :key="material">
        {{material}}: {{amount}};&nbsp;&nbsp;
      </span>
    </template> <br> <br>

    Assembly duplication: {{can_clone ? (fast_clone ? "Instant" : "Available") : "Unavailable"}}. <br>
    Circuits available: {{upgraded || debug ? "Advanced" : "Regular"}}.
    <span v-if="!(upgraded || debug)">
      <br>Greyed out circuits mean that the printer is not sufficiently upgraded to create that circuit.
    </span>

    <hr>

    Here you can load script for your assembly.<br>
    <vui-button :params="{ print: 'load' }" icon="folder-open" :disabled="cloning != 0">Load Program</vui-button>
    <vui-button :params="{ print: 'print' }" icon="print" :disabled="program == null" push-state v-if="!cloning">{{fast_clone ? "Print" : "Begin Printing"}}</vui-button>
    <vui-button :params="{ print: 'cancel' }" icon="close" push-state v-else>Cancel Print</vui-button>

    <br><hr>
    
    Categories:
    <span v-for="(_, category) in recipes" :key="category">
      <vui-button :params="{ category: category }" :disabled="category == current_category">{{category}}</vui-button>
    </span>

    <hr>

    <center><h4>{{current_category}}</h4></center>
    <div v-for="(info, name) in category_recipes" :key="name">
      <vui-button :params="{ build: info[2] }" :disabled="info[1] == 0">{{name}}</vui-button>{{info[0]}}<br>
    </div>
    
  </div>

</template>

<script>
export default {
  data() {
    return this.$root.$data.state; // Make data more easily accessible
  }
};
</script>