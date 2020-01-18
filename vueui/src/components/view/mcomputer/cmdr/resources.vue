<template v-if="accounts">
	<div>
		<h3>Current Funds: ${{money}}</h3>
		<h3>Uplink TC: {{crystals}}</h3>
		<hr>
		<h3>Linked Accounts</h3>
		<table>
			<tr>
			<th>Owner Name</th>
			<th>Funds</th>
			<th class="action">Actions</th>
			</tr>
			<tr v-for="(account, ref) in accounts">
			<td>{{ account.name }}</td>
			<td>{{ account.amount }}</td>
			<td class="action">
				<vui-button :params="{ transfer: { to: ref, amount: transfer_money, deposit: 1 }}">Deposit</vui-button>
				<vui-button :params="{ transfer: { to: ref, amount: transfer_money, deposit: 0 }}">Withdraw</vui-button>
			</td>
			</tr>
		</table>
		<div class="vui-input">
			<vui-input-numeric width="5em" :button-count="4" :min="0" :max="100000" v-model="transfer_money"/>
		</div>
	</div>
</template>

<script>
export default {
  data() {
    return this.$root.$data.state;
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