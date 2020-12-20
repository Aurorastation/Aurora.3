<template>
  <div>
    <div class="item">
      <div class="itemLabelNarrow">
        <b>Machine</b>:
      </div>
      <div class="itemContent">
        <span class="average">{{machine_id}}</span>
      </div>
    </div>
    <div class="item">
      <div class="itemLabelNarrow">
        <b>ID</b>: {{id_card}}
      </div>
    </div>

    <div v-if="access_level > 0">
      <div class='item'>
        <h2>Menu</h2>
      </div>
      <vui-button :params="{choice: 'view_accounts_list'}" :disabled="creating_new_account == 0 && detailed_account_view == 0">Home</vui-button>
      <vui-button :params="{choice: 'create_account'}" :disabled="creating_new_account == 1">New Account</vui-button>
      <vui-button v-if="has_printer" :params="{choice: 'print'}" :disabled="creating_new_account == 1">Print</vui-button>

      <div v-if="creating_new_account">
        <div class='item'>
          <h2>Create Account</h2>
        </div>

        <form name='create_account' :action='"?src=" + src' method='get'>
          <input type='hidden' name='src' :value='src'>
          <input type='hidden' name='choice' value='finalise_create_account'>
          <div class='item'>
            <div class='itemLabel'>
              <b>Account Holder</b>:
            </div>
            <div class='itemContent'>
              <input type='text' id='holder_name' name='holder_name'>
            </div>
          </div>
          <div class='item'>
            <div class='itemLabel'>
              <b>Initial Deposit</b>:
            </div>
            <div class='itemContent'>
              <input type='text' id='starting_funds' name='starting_funds'>
            </div>
          </div>
          <div class='item'>
            <input type='submit' value='Create'>
          </div>
        </form>
      </div>
      <div v-else>
        <div v-if="detailed_account_view">
          <div class='item'>
            <h2>Account Details</h2>
          </div>

          <div class='item'>
            <div class="itemLabel">
              <span class='average'><b>Account Number</b>:</span>
            </div>
            <div class="itemContent">
              #{{account_number}}
            </div>
          </div>

          <div class='item'>
            <div class="itemLabel">
              <span class='average'><b>Holder</b>:</span>
            </div>
            <div class="itemContent">
              {{owner_name}}
            </div>
          </div>

          <div class='item'>
            <div class="itemLabel">
              <span class='average'><b>Balance</b>:</span>
            </div>
            <div class="itemContent">
              {{money.toFixed(2)}}电
            </div>
          </div>

          <div class='item'>
            <div class="itemLabel">
              <span class='average'><b>Status</b>:</span>
            </div>
            <div class="itemContent">
              <span :class='suspended ? "bad" : "good"'>
                {{suspended ? "Suspended" : "Active"}}
              </span>
            </div>
          </div>
          <div class='item'>
            <vui-button :params="{choice: 'toggle_suspension'}">{{suspended ? "Unsuspend" : "Suspend"}}</vui-button>
          </div>

          <div class="statusDisplay" style="overflow: auto;">
            <div v-if="transactions.length">
              <table class="table border" style='width: 100%'>
                <thead>
                  <tr class="header border">
                    <th><b>Timestamp</b></th>
                    <th><b>Target</b></th>
                    <th><b>Reason</b></th>
                    <th><b>Value</b></th>
                    <th><b>Terminal</b></th>
                  </tr>
                </thead>
                <tbody>
                    <tr v-for="trx in transactions" class="item border" :key="trx">
                        <td>{{trx.date}} {{trx.time}}</td>
                        <td>{{trx.target_name}}</td>
                        <td>{{trx.purpose}}</td>
                        <td>{{trx.amount}}</td>
                        <td>{{trx.source_terminal}}</td>
                    </tr>
                </tbody>
              </table>
            </div>
            <div v-else>
              <span class='alert'>This account has no financial transactions on record for today.</span>
            </div>
          </div>
            <div class='item'>
              <h2>Administrator Controls</h2>
            </div>
            <div class='item'>
              <div class='fixedLeft'>
                Payroll:
              </div>
              <vui-button class="danger" :params="{choice: 'revoke_payroll'}" :disabled="account_number == station_account_number">Revoke Payroll</vui-button>
            </div>
            <div v-if="access_level >= 2">
              <div class='item'>
                <div class='fixedLeft'>
                  Silent Fund Adjustment:
                </div>
                <vui-button :params="{choice: 'add_funds'}">Add</vui-button>
                <vui-button :params="{choice: 'remove_funds'}">Remove</vui-button>
              </div>
            </div>
        </div>

        <div class='item'>
          <h2>Idris Banking Accounts</h2>
        </div>
        <div v-if="accounts.length">
          <table class="table border" style="width: 100%">
            <tr class="header border">
              <th><b>Account Number</b></th>
              <th><b>Account Name</b></th>
            </tr>
            <tr v-for="acc in accounts" class="item border" :key="acc">
              <td><vui-button :params="{choice: 'view_account_detail', account_number: acc.account_number}">#{{acc.account_number}}</vui-button></td>
              <td><span :class="acc.suspended ? 'bad' : ''" style="text-align:left">{{acc.owner_name}}</span></td>
            </tr>
          </table>
        </div>
        <div v-else>
          <span class='alert'>There are no accounts available.</span>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return this.$root.$data.state
  }
}
</script>

<style lang="scss" scoped>
table {
  width: 100%;
  text-align: center;
}
tr {
  line-height: 135%;
}
</style>