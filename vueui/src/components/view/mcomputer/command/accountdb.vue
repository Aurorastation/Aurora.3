<template>
  <div>
    <vui-group>
      <vui-group-item label="Machine:">{{ s.machine_id }}</vui-group-item>
      <vui-group-item label="ID card:">{{ s.id_card ? s.id_card : 'None' }}</vui-group-item>
      <vui-group-item v-if="s.access_level" label="Station funds:">{{ s.accounts[`${s.station_account_number}`].money.toFixed(2) }}电</vui-group-item>
      <vui-group-row><hr></vui-group-row>
      <template v-if="new_name != null">
        <vui-group-row><vui-button @click="new_name = null" icon="arrow-left">Back to list</vui-button></vui-group-row>
        
        <vui-group-item label="Account Holder:"><input type="text" v-model="new_name"></vui-group-item>
        <vui-group-item label="Initial Deposit:"><vui-input-numeric v-model="new_funds" :button-count="0" width="7em" :max="1000000"/></vui-group-item>
        <vui-group-item><vui-button @click="create_account()" icon="plus-square">Create</vui-button></vui-group-item>
      </template>
      <template v-else-if="s.access_level">
        <template v-if="active">
          <vui-group-row>
            <vui-button @click="active = null" icon="arrow-left">Back to list</vui-button>
            <vui-button icon="print" :params="{print: active}">Print</vui-button>
          </vui-group-row>
          <vui-group-row><h2>Account Details</h2></vui-group-row>
          <vui-group-item label="Account Number:">#{{ active_acc.no }}</vui-group-item>
          <vui-group-item label="Holder:">{{ active_acc.owner }}</vui-group-item>
          <vui-group-item label="Balance:">{{ active_acc.money.toFixed(2) }}电</vui-group-item>
          <vui-group-item label="Status:">
            <span v-if="active_acc.sus" class="bad">Suspended </span>
            <span v-else class="good">Active </span>
          </vui-group-item>
          <vui-group-row>
            <vui-button v-if="active_acc.sus" :params="{ suspend: { account: active }}">Unsuspend</vui-button>
            <vui-button v-else :params="{ suspend: { account: active }}">Suspend</vui-button>
            <vui-button v-if="active_acc.no != s.station_account_number" :params="{ revoke_payroll: { account: active }}">Revoke Payroll</vui-button>
            <template v-if="s.access_level == 2">
              <h4>Silent fund adjustment</h4>
              <vui-button v-if="add_funds == null" @click="add_funds = 0">Add</vui-button>
              <template v-else>
                <vui-input-numeric v-model="add_funds" :max="1000000"/>
                <vui-button :params="{add_funds: {account: active, amount: add_funds}}">Add</vui-button>
              </template>
              <br>
              <vui-button v-if="remove_funds == null" @click="remove_funds = 0">Remove</vui-button>
              <template v-else>
                <vui-input-numeric v-model="remove_funds" :max="1000000"/>
                <vui-button :params="{remove_funds: {account: active, amount: remove_funds}}">Remove</vui-button>
              </template>
            </template>
          </vui-group-row>
          <vui-group-row>
            <h2>Transactions</h2>
            <table class="table border" style="width: 100%">
              <tr class="header border">
                <th><b>Timestamp</b></th>
                <th><b>Target</b></th>
                <th><b>Reason</b></th>
                <th><b>Value</b></th>
                <th><b>Terminal</b></th>
              </tr>
              <tr v-for="(trans, ref) in active_acc.transactions" class="item border" :key="ref">
                <td>{{trans.d}} {{trans.t}}</td>
                <td>{{trans.tar}}</td>
                <td>{{trans.purp}}</td>
                <td>{{trans.am}}</td>
                <td>{{trans.src}}</td>
              </tr>
            </table>
          </vui-group-row>
        </template>
        <template v-else>
          <vui-group-row>
            <vui-button v-if="s.has_printer" icon="print" :params="{print: 1}">Print</vui-button>
            <vui-button icon="file" @click="new_name = ''">New Account</vui-button>
          </vui-group-row>
          <vui-group-row><h2>Idris Banking Accounts</h2></vui-group-row>
          <vui-group-row>
            <table class="table border" style="width: 100%">
              <tr class="header border">
                <th><b>Number</b></th>
                <th><b>Name</b></th>
              </tr>
              <tr v-for="(acc, number) in s.accounts" class="item border" :key="number">
                <td><vui-button @click="active = number">#{{acc.no}}</vui-button></td>
                <td><span :class="acc.sus ? 'bad' : ''">{{acc.owner}}</span></td>
              </tr>
            </table>
          </vui-group-row>
        </template>
      </template>
    </vui-group>
    
  </div>
</template>

<script>
export default {
  data() {
    return {
      s: this.$root.$data.state,
      active: null,
      add_funds: null,
      remove_funds: null,
      new_name: null,
      new_funds: 0,
    }
  },
  computed: {
    active_acc() {
      if(this.active) {
        return this.s.accounts[this.active]
      }
      return {}
    }
  },
  methods: {
    create_account() {
      this.$toTopic({create_account: {name: this.new_name, funds: this.new_funds}})
      this.new_name = null
      this.new_funds = 0
    }
  }
}
</script>