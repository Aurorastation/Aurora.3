<template>
  <div>
    <div>
      <vui-button :class="{ selected: upgrade_view }" @click="setUpgView">Upgrades</vui-button>
      <vui-button :class="{ selected: misc_view }" @click="setMiscView">General</vui-button>
    </div>
    <template v-if="upgrade_view">
      <div>
        <p>:b:laceholder</p>
      </div>
    </template>
    <template v-if="misc_view">
      <br>
      <div>
        <vui-button :disabled="canAfford(req_prices['shuttle'])" :params="{ purchase: 'shuttle' }">Syndicate Shuttle Access Codes (${{req_prices['shuttle']['price']}})</vui-button>
        <p class="desc">Command-level authcodes for unlocking the Syndicate's stealth shuttle. Handle with care.</p>
        <vui-button :class="{ disabled: ert_capable }" :params="{ purchase: 'ERT' }">Request Emergency Commando Deployment</vui-button>
        <p class="desc">Requests an immediate deployment of Syndicate forces to the station. Due to the immediacy of the request, neither quality nor loyalty are guaranteed. Only usable once 50% or more operatives are KIA.</p>
      </div>
    </template>
  </div>
</template>

<script>
export default {
	data() {
		return this.$root.$data.state;
	},
	methods: {
		canAfford(item) {
			if(!item.hasOwnProperty('type'))
				return false
			else if(item['type'] == 'money')
				return item['price'] > this.money
			else
				return item['price'] > this.crystal
		},
		setUpgView() {
			this.misc_view = 0;
			this.upgrade_view = 1;
		},
		setMiscView() {
			this.upgrade_view = 0;
			this.misc_view = 1;
		}
	}
};
</script>

<style lang="scss" scoped>
	.desc {
		font-size: 10px;
		font-style: italic;
	}
</style>