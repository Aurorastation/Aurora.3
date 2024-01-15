SUBSYSTEM_DEF(economy)
	name = "Economy"
	wait = 30 SECONDS
	flags = SS_NO_FIRE
	init_order = SS_INIT_ECONOMY
	var/datum/money_account/station_account
	var/list/department_accounts = list()
	var/list/all_money_accounts = list()
	var/num_financial_terminals = 1
	var/next_account_number = 0

/datum/controller/subsystem/economy/Initialize(timeofday)
	next_account_number = rand(111111, 999999)

	for(var/loc_type in typesof(/datum/trade_destination) - /datum/trade_destination)
		var/datum/trade_destination/D = new loc_type
		weighted_randomevent_locations[D] = D.viable_random_events.len
		weighted_mundaneevent_locations[D] = D.viable_mundane_events.len

	create_station_account()

	for(var/account in GLOB.department_funds)
		create_department_account(account)

	return SS_INIT_SUCCESS

/datum/controller/subsystem/economy/Recover()
	src.station_account = SSeconomy.station_account
	src.department_accounts = SSeconomy.department_accounts
	src.all_money_accounts = SSeconomy.all_money_accounts
	src.num_financial_terminals = SSeconomy.num_financial_terminals
	src.next_account_number = SSeconomy.next_account_number


/**
 * Account Creation
 */

///Create the station Account
/datum/controller/subsystem/economy/proc/create_station_account()
	if(station_account)
		return FALSE

	station_account = new()
	station_account.owner_name = "[station_name()] Assigned Conglomerate Funds"
	station_account.account_number = next_account_number
	next_account_number += rand(1,500)
	if(next_account_number > 999999) //If we're hitting 7 digits, reset to the minimum and increase from there.
		next_account_number = 111111 + rand(1,500)
	station_account.remote_access_pin = rand(1111, 111111)
	station_account.money = 75000

	//create an entry in the account transaction log for when it was created
	var/datum/transaction/T = new()
	T.target_name = station_account.owner_name
	T.purpose = "Account creation"
	T.amount = 75000
	T.date = "13th May, 2461"
	T.time = "11:24"
	T.source_terminal = "Idris Remote Terminal #[rand(111,11111)]"

	//add the account
	add_transaction_log(station_account,T)
	all_money_accounts["[station_account.account_number]"] = station_account
	return TRUE

//Create a departmental account
/datum/controller/subsystem/economy/proc/create_department_account(department)
	if(department_accounts[department])
		return FALSE

	var/datum/money_account/department_account = new()
	department_account.owner_name = "[department] Account"
	department_account.account_number = next_account_number
	next_account_number += rand(1,500)
	department_account.remote_access_pin = rand(1111, 111111)
	department_account.money = GLOB.department_funds[department]

	//create an entry in the account transaction log for when it was created
	var/datum/transaction/T = new()
	T.target_name = department_account.owner_name
	T.purpose = "Account creation"
	T.amount = department_account.money
	T.date = "13th May, 2461"
	T.time = "11:24"
	T.source_terminal = "Idris Remote Terminal #[rand(111,11111)]"

	//add the account
	add_transaction_log(department_account,T)
	all_money_accounts["[department_account.account_number]"] = department_account

	department_accounts[department] = department_account
	return TRUE

//Create a "normal" player account
/datum/controller/subsystem/economy/proc/create_account(var/new_owner_name = "Default user", var/starting_funds = 0, var/datum/computer_file/program/account_db/source_db, var/account_public = TRUE)
	//create a new account
	var/datum/money_account/M = new()
	M.owner_name = new_owner_name
	M.remote_access_pin = rand(1111, 111111)
	M.money = starting_funds
	M.account_number = next_account_number
	M.public_account = account_public
	next_account_number += rand(1,25)

	//create an entry in the account transaction log for when it was created
	var/datum/transaction/T = new()
	T.target_name = new_owner_name
	T.purpose = "Account creation"
	T.amount = starting_funds

	if(!source_db)
		//set a random date from recent months
		T.date = "[num2text(rand(1,31))] [pick("January","February","March","April","May")], 2461"
		T.time = "[rand(0,24)]:[rand(11,59)]"
		T.source_terminal = "Idris SelfServ Terminal #[rand(111,11111)]"
	else
		T.date = worlddate2text()
		T.time = worldtime2text()
		T.source_terminal = source_db.machine_id

		if(source_db.computer.nano_printer)
			var/pname = "Account information: [M.owner_name]"
			var/info = "<b>Account details (confidential)</b><br><hr><br>"
			info += "<i>Account holder:</i> [M.owner_name]<br>"
			info += "<i>Account number:</i> [M.account_number]<br>"
			info += "<i>Account pin:</i> [M.remote_access_pin]<br>"
			info += "<i>Starting balance:</i> [M.money]电<br>"
			info += "<i>Date and time:</i> [worldtime2text()], [worlddate2text()]<br><br>"
			info += "<i>Creation terminal ID:</i> [source_db.machine_id]<br>"
			var/obj/item/card/id/held_card = source_db.get_held_card()
			info += "<i>Authorised NT officer overseeing creation:</i> [held_card.registered_name]<br>"

			var/obj/item/paper/R = source_db.computer.nano_printer.print_text("", pname, "#deebff")
			R.set_content_unsafe(pname, info)
			//stamp the paper
			var/image/stampoverlay = image('icons/obj/bureaucracy.dmi')
			stampoverlay.icon_state = "paper_stamp-cent"
			if(!R.stamped)
				R.stamped = new
			R.stamped += /obj/item/stamp
			R.add_overlay(stampoverlay)
			R.stamps += "<HR><i>This paper has been stamped by the Accounts Database.</i>"

	//add the account
	add_transaction_log(M,T)
	all_money_accounts["[M.account_number]"] = M

	return M

/datum/controller/subsystem/economy/proc/get_public_accounts()
	var/list/public_accounts = list()
	for(var/account in all_money_accounts)
		var/datum/money_account/M = all_money_accounts[account]
		if(M.public_account)
			public_accounts += account // yes, we're passing the number
	return public_accounts

//Charge a account
/datum/controller/subsystem/economy/proc/charge_to_account(var/attempt_account_number, var/source_name, var/purpose, var/terminal_id, var/amount)
	var/datum/money_account/D = get_account(attempt_account_number)
	if(D && !D.suspended)
		D.money += amount

		//create a transaction log entry
		var/datum/transaction/T = new()
		T.target_name = source_name
		T.purpose = purpose
		if(amount < 0)
			T.amount = "([amount])"
		else
			T.amount = "[amount]"
		T.date = worlddate2text()
		T.time = worldtime2text()
		T.source_terminal = terminal_id
		add_transaction_log(D,T)
		return 1

	return 0

//Transfer money from one account to another
//Returns a string with a error message if it fails
//Returns a null if it succeeeds
/datum/controller/subsystem/economy/proc/transfer_money(var/source_number, var/dest_number, var/purpose, var/terminal_id, var/amount, var/source_pin=null, var/mob/user=null)
	if(amount <= 0)
		return "Invalid charge amount. Must be greater than 0."

	//Check if the accounts exist
	var/datum/money_account/source = get_account(source_number)
	if(!source)
		return "A account with the account number [source_number] does not exist"
	var/datum/money_account/dest = get_account(dest_number)
	if(!dest)
		return "A account with the account number [dest_number] does not exist"

	//Check if the accounts are suspended
	if(source.suspended)
		return "Customer Account is suspended. - Transaction aborted."
	if(dest.suspended)
		return "Destination Account is suspended. - Transaction aborted."

	//Check if we need a pin for the source account and if the pin has been supplied
	if(source.security_level == 2)
		if(user != null && !source_pin)
			source_pin = input(user,"Enter Account PIN") as num
		else
			return "No PIN specified."
		if(source_pin != source.remote_access_pin)
			return "Invalid PIN specified."

	//Check if there is enough money on the source account
	if(source.money < amount)
		return "Insufficient money on customer account"

	//Make the transfers
	charge_to_account(source.account_number, dest.owner_name, purpose, terminal_id, -amount)
	charge_to_account(dest.account_number, source.owner_name, purpose, terminal_id, amount)
	return null

/**
 * Various Getters (Account, Department-Account, ...)
 */
//attempts to access a account by supplying a account number / pin number and passed securilty level check
/datum/controller/subsystem/economy/proc/attempt_account_access(var/attempt_account_number, var/attempt_pin_number, var/security_level_passed = 0)
	var/datum/money_account/D = get_account(attempt_account_number)
	if(D && D.security_level <= security_level_passed && (!D.security_level || D.remote_access_pin == attempt_pin_number) )
		return D

//get the security level of a account
/datum/controller/subsystem/economy/proc/get_account_security_level(var/account_number)
	var/datum/money_account/D = get_account(account_number)
	if(D)
		return D.security_level

//Check if a account is suspended
/datum/controller/subsystem/economy/proc/get_account_suspended(var/account_number)
	var/datum/money_account/D = get_account(account_number)
	if(D)
		return D.suspended

//gets a account by account number
/datum/controller/subsystem/economy/proc/get_account(var/account_number)
	if(all_money_accounts["[account_number]"])
		return all_money_accounts["[account_number]"]
	return

//gets a departmental account by name
/datum/controller/subsystem/economy/proc/get_department_account(var/department)
	RETURN_TYPE(/datum/money_account)
	if(department_accounts[department])
		return department_accounts[department]

/**
 * Logging functions
 */
//adds a transaction log to a specific account
/datum/controller/subsystem/economy/proc/add_transaction_log(var/datum/money_account/bank_account, var/datum/transaction/T)
	//Thats there as a place to hook the persistant transaction logs into
	bank_account.transactions.Add(T)

//log a failed access attempt
/datum/controller/subsystem/economy/proc/bank_log_unauthorized(var/datum/money_account/bank_account, var/machine_id = "Unknown machine ID")
	var/datum/transaction/T = new()
	T.target_name = bank_account.owner_name
	T.purpose = "Unauthorised login attempt"
	T.source_terminal = machine_id
	T.date = worlddate2text()
	T.time = worldtime2text()
	add_transaction_log(bank_account,T)
	return

//Log a successful access
/datum/controller/subsystem/economy/proc/bank_log_access(var/datum/money_account/bank_account, var/machine_id = "Unknown machine ID")
	var/datum/transaction/T = new()
	T.target_name = bank_account.owner_name
	T.purpose = "Remote terminal access"
	T.source_terminal = machine_id
	T.date = worlddate2text()
	T.time = worldtime2text()
	add_transaction_log(bank_account,T)
	return


/datum/money_account
	var/owner_name = ""
	var/account_number = 0
	var/public_account = TRUE
	var/remote_access_pin = 0
	var/money = 0
	var/list/transactions = list()
	var/suspended = 0
	var/security_level = 0	//0 - auto-identify from worn ID, require only account number
							//1 - require manual login / account number and pin
							//2 - require card and manual login

/datum/transaction
	var/target_name = ""
	var/purpose = ""
	var/amount = 0
	var/date = ""
	var/time = ""
	var/source_terminal = ""
