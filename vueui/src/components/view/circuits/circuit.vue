<template>
  <div>
    <div align="center">
      <table border="1" style="undefined;table-layout: fixed; width: 90%">
        <colgroup>
          <col style="width: 35%">
          <col style="width: 30%">
          <col style="width: 35%">
        </colgroup>
        <tr>
          <td colspan="3">
            <vui-button :params="{return: 1}" icon="arrowreturn-1-n" v-if="assembly">Return To Assembly</vui-button> <br>
            <!-- A refresh button, for cases where attempts at reactive UI failed-->
            <vui-button :params="{refresh: 1}" icon="arrowreturn-1-s">Refresh</vui-button>  |  
            <vui-button :params="{rename: 1}" icon="wrench">Rename</vui-button>  |  
            <vui-button :params="{scan: 1}" icon="clipboard">Copy Ref</vui-button>
            <span v-if="assembly && removable">  |  <vui-button :params="{remove: 1}" icon="close" >Remove</vui-button> <br></span>
          </td>
        </tr>
        <tr v-for="row in info_size" :key="row">
          <td align="center" rowspan="this.get_height(column)" v-for="column in 3" :key="column">
            <!-- INPUTS -->
            <div v-if="column == 1 && row <= inputs.length">
              <vui-button :params="{act: 'wire', pin: inputs[row - 1].ref}"><b>{{inputs[row - 1].pin_type}} {{inputs[row - 1].name}}</b></vui-button>
              <vui-button :params="{act: 'data', pin: inputs[row - 1].ref}"><b>{{inputs[row - 1].data}}</b></vui-button>
              <br>
              <span v-if="inputs[row - 1].linked">
                <span v-for="linked in inputs[row - 1].linked" :key="linked">
                  <vui-button :params="{act: 'unwire', pin: inputs[row - 1].ref, link: linked.ref}">{{linked.name}}</vui-button>
                  <!-- TODO: Porting the old code directly, hence the unsafe-params, change later -->
                  @ <vui-button :unsafe-params="{src: linked.holder, examine: 1}">{{linked.holder_name}}</vui-button>
                  <br>
                </span>
              </span>
            </div>
            <!-- DESCRIPTION -->
            <div v-else-if="column == 2 && row == 1">
              <b>{{displayed_name}}</b><br>
              <span v-if="name != displayed_name">({{name}})</span><hr>
              {{desc}} 
            </div>
            <!-- OUTPUTS -->
            <div v-else-if="column == 3 && row <= outputs.length">
              <vui-button :params="{act: 'wire', pin: outputs[row - 1].ref}"><b>{{outputs[row - 1].pin_type}} {{outputs[row - 1].name}}</b></vui-button>
              <vui-button :params="{act: 'data', pin: outputs[row - 1].ref}"><b>{{outputs[row - 1].data}}</b></vui-button>
              <br>
              <span v-if="outputs[row - 1].linked">
                <span v-for="linked in outputs[row - 1].linked" :key="linked">
                  <vui-button :params="{act: 'unwire', pin: outputs[row - 1].ref, link: linked.ref}">{{linked.name}}</vui-button>
                  <!-- Porting the old code directly, hence the unsafe-params, change later -->
                  @ <vui-button :unsafe-params="{src: linked.holder, examine: 1}">{{linked.holder_name}}</vui-button>
                  <br>
                </span>
              </span>
            </div>
          </td>
        </tr>
        <tr>
          <td colspan="3" align="center">
            <span v-for="activator in activators" :key="activator">
              <vui-button :params="{act: 'wire', pin: activator.ref}"><font color="FFFF00"><b>{{activator.name}}</b></font></vui-button>
              <vui-button :params="{act: 'data', pin: activator.ref}"><font color="FFFF00"><b>{{activator.data}}</b></font></vui-button>
              <br>
              <span v-if="activator.linked">
                <span v-for="linked in activator.linked" :key="linked">
                  <vui-button :params="{act: 'unwire', pin: activator.ref, link: linked.ref}"><font color="FFFF00">{{linked.name}}</font></vui-button>
                  <!-- Porting the old code directly, hence the unsafe-params, change later -->
                  @ <vui-button :unsafe-params="{src: linked.holder, examine: 1}"><font color="FFFF00">{{linked.holder_name}}</font></vui-button>
                  <br>
                </span>
              </span>
            </span>
          </td>
        </tr>
      </table>
    </div>
    <div>
      <br><font color="00AA00">Size: {{size}}</font>
      <br><font color="00AA00">Complexity: {{complexity}}</font>
      <br><font color="00AA00">Cooldown per use: {{cooldown_per_use/10}} sec</font>
      <span v-if="ext_cooldown > 0">
        <br><font color="00AA00">External manipulation cooldown: {{ext_cooldown/10}} sec</font>
      </span>
      <span v-if="power_draw_idle > 0">
        <br><font color="00AA00">Power Draw: {{power_draw_idle}} W (Idle)</font>
      </span>
      <span v-if="power_draw_per_use > 0">
        <br><font color="00AA00">Power Draw: {{power_draw_per_use}} W (Active)</font>
      </span>
      <br><font color="00AA00">{{extended_desc}}</font>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return this.$root.$data.state; // Make data more easily accessible
  },
  methods: {
      get_height: function(row) {
          if(row == 2) {
              return this.info_size;
          }
          return 1;
      }
  }
};
</script>