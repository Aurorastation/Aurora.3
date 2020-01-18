<template>
	<div>
		<div>
			<vui-button :class="{ selected: state.account_view }" @click="setAccountView">Cash Accounts</vui-button>
			<vui-button :class="{ selected: state.tc_view }" @click="setTCView">Telecrystal Uplinks</vui-button>
		</div>
		<template v-if="state.account_view && accountsPresent">
			<table>
				<tr>
				<th>Owner Name</th>
				<th>Funds</th>
				<th class="action">Actions</th>
				</tr>
				<tr v-for="(account, ref) in state.accounts">
				<td>{{ account.name }}</td>
				<td>{{ account.amount }}</td>
				<td class="action">
					<vui-button :params="{ transfer: { to: ref, amount: tr_money, deposit: 1 }}">Deposit</vui-button>
					<vui-button :params="{ transfer: { to: ref, amount: tr_money, deposit: 0 }}">Withdraw</vui-button>
				</td>
				</tr>
			</table>
			<div class="vui-input">
				<vui-input-numeric width="5em" :button-count="4" :min="0" :max="100000" v-model="tr_money"/>
			</div>
		</template>
		<template v-else-if="state.account_view">
			<div><p>No accounts found.</p></div>
		</template>
		<template v-else-if="state.tc_view && uplinksPresent">
			<table>
				<tr>
				<th>Uplink Owner</th>
				<th>TC</th>
				<th class="action">Actions</th>
				</tr>
				<tr v-for="(uplink, ref) in uplinks">
				<td>{{ uplink.name }}</td>
				<td>{{ uplink.amount }}</td>
				<td class="action">
					<vui-button :params="{ supply: { to: ref, amount: tr_crystal }}">Give</vui-button>
				</td>
				</tr>
			</table>
			<div class="vui-input">
				<vui-input-numeric width="5em" :button-count="3" :min="0" :max="100" v-model="tr_crystal"/>
			</div>
		</template>
		<template v-else-if="state.tc_view">
			<div><p>No uplinks found.</p></div>
		</template>
	</div>
</template>

<script>
export default {
  data() {
    return {
		state: this.$root.$data.state,
		tr_money: this.$root.$data.state.transfer_money,
		tr_crystal: this.$root.$data.state.transfer_crystal
	};
  },
  computed: {
	  accountsPresent() {
		  return Object.keys(this.state.accounts).length > 0;
	  },
	  uplinksPresent() {
		  return Object.keys(this.state.uplinks).length > 0;
	  }
  },
  methods: {
	  setAccountView() {
		  this.state.tc_view = 0;
		  this.state.account_view = 1;
	  },
	  setTCView() {
		  this.state.account_view = 0;
		  this.state.tc_view = 1;
	  }
  }
};
</script>

<style lang="scss" scoped>
  table {
    width: 100%;
    th, td {
      text-align: center;
      width: auto;
      &.action {
        width: 1%;
        white-space: nowrap;
      }
    }
    th {
      font-weight: bold;
    }
  }

  .vui-input {
	  text-align: center;
  }
</style>