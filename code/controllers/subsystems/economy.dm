var/datum/controller/subsystem/economy/SSeconomy

/datum/controller/subsystem/economy
	name = "Economy"
	wait = 30 SECONDS
	flags = SS_NO_FIRE
	init_order = SS_INIT_ECONOMY
	var/datum/money_account/station_account
	var/list/department_accounts = list()
	var/list/all_money_accounts = list()
	var/num_financial_terminals = 1
	var/next_account_number = 0

/datum/controller/subsystem/economy/New()
	NEW_SS_GLOBAL(SSeconomy)

/datum/controller/subsystem/economy/Initialize(timeofday)
	for(var/loc_type in typesof(/datum/trade_destination) - /datum/trade_destination)
		var/datum/trade_destination/D = new loc_type
		weighted_randomevent_locations[D] = D.viable_random_events.len
		weighted_mundaneevent_locations[D] = D.viable_mundane_events.len

	create_station_account()

	for(var/department in station_departments)
		create_department_account(department)
	create_department_account("Vendor")

	..()

/datum/controller/subsystem/economy/Recover()
	src.station_account = SSeconomy.station_account
	src.department_accounts = SSeconomy.department_accounts
	src.all_money_accounts = SSeconomy.all_money_accounts
	src.num_financial_terminals = SSeconomy.num_financial_terminals
	src.next_account_number = SSeconomy.next_account_number


/**
 * Account Creation
 */
 //Create the station Account
/datum/controller/subsystem/economy/proc/create_station_account()
	if(station_account)
		return FALSE

	next_account_number = rand(111111, 999999)

	station_account = new()
	station_account.owner_name = "[station_name()] Station Account"
	station_account.account_number = rand(111111, 999999)
	station_account.remote_access_pin = rand(1111, 111111)
	station_account.money = 75000

	//create an entry in the account transaction log for when it was created
	var/datum/transaction/T = new()
	T.target_name = station_account.owner_name
	T.purpose = "Account creation"
	T.amount = 75000
	T.date = "2nd April, 2454"
	T.time = "11:24"
	T.source_terminal = "Biesel GalaxyNet Terminal #277"

	//add the account
	add_transaction_log(station_account,T)
	all_money_accounts.Add(station_account)
	return TRUE

//Create a departmental account
/datum/controller/subsystem/economy/proc/create_department_account(department)
	if(department_accounts[department])
		return FALSE

	next_account_number = rand(111111, 999999)

	var/datum/money_account/department_account = new()
	department_account.owner_name = "[department] Account"
	department_account.account_number = rand(111111, 999999)
	department_account.remote_access_pin = rand(1111, 111111)
	department_account.money = 5000

	//create an entry in the account transaction log for when it was created
	var/datum/transaction/T = new()
	T.target_name = department_account.owner_name
	T.purpose = "Account creation"
	T.amount = department_account.money
	T.date = "2nd April, 2454"
	T.time = "11:24"
	T.source_terminal = "Biesel GalaxyNet Terminal #277"

	//add the account
	add_transaction_log(department_account,T)
	all_money_accounts.Add(department_account)

	department_accounts[department] = department_account
	return TRUE

//Create a "normal" player account
/datum/controller/subsystem/economy/proc/create_account(var/new_owner_name = "Default user", var/starting_funds = 0, var/obj/machinery/account_database/source_db)
	//create a new account
	var/datum/money_account/M = new()
	M.owner_name = new_owner_name
	M.remote_access_pin = rand(1111, 111111)
	M.money = starting_funds

	//create an entry in the account transaction log for when it was created
	var/datum/transaction/T = new()
	T.target_name = new_owner_name
	T.purpose = "Account creation"
	T.amount = starting_funds
	if(!source_db)
		//set a random date, time and location some time over the past few decades
		T.date = "[num2text(rand(1,31))] [pick("January","February","March","April","May","June","July","August","September","October","November","December")], 24[rand(10,48)]"
		T.time = "[rand(0,24)]:[rand(11,59)]"
		T.source_terminal = "NTGalaxyNet Terminal #[rand(111,1111)]"

		M.account_number = rand(111111, 999999)
	else
		T.date = worlddate2text()
		T.time = worldtime2text()
		T.source_terminal = source_db.machine_id

		M.account_number = next_account_number
		next_account_number += rand(1,25)

		//create a sealed package containing the account details
		var/obj/item/smallDelivery/P = new /obj/item/smallDelivery(source_db.loc)

		var/obj/item/weapon/paper/R = new /obj/item/weapon/paper(P)
		P.wrapped = R
		var/pname = "Account information: [M.owner_name]"
		var/info = "<b>Account details (confidential)</b><br><hr><br>"
		info += "<i>Account holder:</i> [M.owner_name]<br>"
		info += "<i>Account number:</i> [M.account_number]<br>"
		info += "<i>Account pin:</i> [M.remote_access_pin]<br>"
		info += "<i>Starting balance:</i> $[M.money]<br>"
		info += "<i>Date and time:</i> [worldtime2text()], [worlddate2text()]<br><br>"
		info += "<i>Creation terminal ID:</i> [source_db.machine_id]<br>"
		info += "<i>Authorised NT officer overseeing creation:</i> [source_db.held_card.registered_name]<br>"

		R.set_content_unsafe(pname, info)

		//stamp the paper
		var/image/stampoverlay = image('icons/obj/bureaucracy.dmi')
		stampoverlay.icon_state = "paper_stamp-cent"
		if(!R.stamped)
			R.stamped = new
		R.stamped += /obj/item/weapon/stamp
		R.add_overlay(stampoverlay)
		R.stamps += "<HR><i>This paper has been stamped by the Accounts Database.</i>"

	//add the account
	add_transaction_log(M,T)
	all_money_accounts.Add(M)

	return M


//Charge a account
/datum/controller/subsystem/economy/proc/charge_to_account(var/attempt_account_number, var/source_name, var/purpose, var/terminal_id, var/amount)
	for(var/datum/money_account/D in all_money_accounts)
		if(D.account_number == attempt_account_number && !D.suspended)
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

/**
 * Various Getters (Account, Department-Account, ...)
 */
//attempts to access a account by supplying a account number / pin number and passed securilty level check
/datum/controller/subsystem/economy/proc/attempt_account_access(var/attempt_account_number, var/attempt_pin_number, var/security_level_passed = 0)
	for(var/datum/money_account/D in all_money_accounts)
		if(D.account_number == attempt_account_number)
			if( D.security_level <= security_level_passed && (!D.security_level || D.remote_access_pin == attempt_pin_number) )
				return D
			break

//gets a account by account number
/datum/controller/subsystem/economy/proc/get_account(var/account_number)
	for(var/datum/money_account/D in all_money_accounts)
		if(D.account_number == account_number)
			return D
	return 0

//gets a departmental account by name
/datum/controller/subsystem/economy/proc/get_department_account(var/department)
	if(department_accounts[department])
		return department_accounts[department]
	return

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
