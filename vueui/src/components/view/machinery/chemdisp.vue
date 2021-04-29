<template>
  <div>
    <div style="clear:both; margin:auto; width:20em">
      <vui-button v-for="n in [5, 10, 20, 30, 40]" icon="cog" :params="{ amount : n }" :class="{selected : (state.amount == n)}" :key="amount-button-n">{{n}}</vui-button>
      <br><br>
      <div style="text-align:center">
        <vui-input-numeric width="2.5em" v-model="state.amount" @input="$toTopic({amount : state.amount})" :button-count="2" :min="1" :max="state.beakerMaxVolume || 120"/>
      </div>
    </div>
    <div style="clear:both;">&nbsp;</div>
    <div style="float:left; width: 100%;">
      <div v-if="state.chemicals.length">
        <vui-button icon="arrow-alt-circle-down" class="fixedLeftWide" v-for="chem in state.chemicals" :params="{dispense : chem.label}" :key="chem-btn">{{chem.label}} ({{chem.amount}})</vui-button>
      </div>
      <span v-else class="bad">No cartridges installed!</span>
    </div>
    <div style="clear:both;">&nbsp;</div>
    <vui-button icon="eject" style="float:right;" :class="state.isBeakerLoaded && disabled" :params="{ejectBeaker : 1}">Eject {{state.glass ? "Glass" : "Beaker"}}</vui-button>
    <div class="statusDisplay" style="clear:both; min-height: 180px;">
      <div v-if="state.isBeakerLoaded">
        <b>Volume:&nbsp;{{state.beakerCurrentVolume}}&nbsp;/&nbsp;{{state.beakerMaxVolume}}</b><br>
        <div v-if="state.beakerContents.length">
          <span v-for="beakerchem in state.beakerContents" :key="beakerchem-amt" class="highlight">{{u(beakerchem.volume)}} of {{beakerchem.name}}<br></span>
        </div>
        <span v-else class="bad">{{state.glass ? "Glass" : "Beaker"}} is empty.</span>
      </div>
      <div v-else><span class="average"><i>No {{state.glass ? "glass" : "beaker"}} loaded.</i></span></div>
    </div>
  </div>
</template>

<script>
export default {
	data() {
		return this.$root.$data;
	},
	methods: {
		u(num) {
			if(num == 1) {
				return `${num} unit`
			} else {
				return `${num} units`
			}
    }
	}
}
</script>

<style lang="scss" scoped>
	.statusDisplay {
			background: #000000;
			color: #ffffff;
			border: 1px solid #40628a;
			padding: 4px;
			margin: 3px 0;
	}
	.fixedLeftWide {
			width: 165px;
			float: left;
  }
  .item {
    width: 100%;
    margin: 4px 0 0 0;
    clear: both;
  }
</style>
