#define UIDEBUG
/obj/item/device/nanoquikpay
	name = "\improper NT Quik-Pay"
	desc = "Swipe you're ID to make direct company purcheses"
	icon = 'icons/obj/device.dmi'
	icon_state = "eftpos"
	req_one_access = list(access_lawyer, access_heads, access_armory)
	var/machine_id = ""
	var/list/items = list()
	var/sum = 0
	var/access_code = 0
	var/editmode = 0
	var/obj/item/weapon/card/id/held_card


	proc/get_access_level()
		if (!held_card)
			return 0
		if((access_bar in held_card.access) || (access_kitchen in held_card.access))
			return 1
		else if((access_hop in held_card.access) || (access_captain in held_card.access))
			return 2



/obj/item/device/nanoquikpay/New()
	..()
	machine_id = "[station_name()] Quik-Pay #[SSeconomy.num_financial_terminals++]"
	access_code = rand(1111,111111)


/obj/item/device/nanoquikpay/proc/is_authenticated()
	return held_card ? check_access(held_card) : FALSE

/obj/item/device/nanoquikpay/attackby(obj/O, mob/user)
	if(!istype(O, /obj/item/weapon/card/id))
		return ..()

	if(!held_card)
		user.drop_from_inventory(O,src)
		held_card = O

// UI Shit Below


/obj/item/device/nanoquikpay/verb/openui()
	set name = "Quik-Pay UI"
	set category = "Quik-Pay"
	var/datum/vueui/ui = SSvueui.get_open_ui(usr, src)
	if (!ui)
		ui = new(usr, src, "quikpay-main", 500, 500, "NT Quik-Pay")
	ui.open()

/obj/item/device/nanoquikpay/vueui_data_change(var/list/data, var/mob/user, var/datum/vueui/ui)
	if(!data)
		. = data = list()

	VUEUI_SET_CHECK_IFNOTSET(data["items"], items, ., data)
	VUEUI_SET_CHECK_IFNOTSET(data["tmp_name"], "", ., data)
	VUEUI_SET_CHECK_IFNOTSET(data["tmp_price"], 0, ., data)
	VUEUI_SET_CHECK(data["tmp_price"], max(0, data["tmp_price"]), ., data)
	if(data["tmp_price"] < 0)
		data["tmp_price"] = 0
		. = data
	VUEUI_SET_CHECK_IFNOTSET(data["selection"], list("_" = 0), ., data)
	VUEUI_SET_CHECK(newdata["auth"], check_access(held_card), ., newdata)

/obj/item/device/nanoquikpay/Topic(href, href_list)
	var/datum/vueui/ui = href_list["vueui"]
	if(!istype(ui))
		return
	if(href_list["add"])
		items[href_list["add"]["name"]] = href_list["add"]["price"]
		ui.data["items"][href_list["add"]["name"]] = href_list["add"]["price"]
		. = TRUE
	if(href_list["remove"])
		items -= href_list["remove"]
		ui.data["items"] -= href_list["remove"]
		. = TRUE
	if(href_list["confirm"])
		to_world("Payment selection: [json_encode(href_list["confirm"])]")
		var/selection = ui.data["selection"]
		var/items = ui.data["items"]
		for(var/name in selection)
			if(items[name])
				sum += items[name] * selection[name]
		ui.activeui = "quikpay-confirmation"	
		. = TRUE
	if(href_list["return"])
		sum= 0
		ui.activeui = "quikpay-main"	
		. = TRUE

	if(href_list["processpayment"])
		var/datum/money_account/quickpay_account = SSeconomy.get_department_account("Civilian")
		var/datum/money_account/customer_account = SSeconomy.get_account(held_card.associated_account_number)
		if (!customer_account)
			src << "<span class='warning'>\icon[src] The [src] beeps: Error: Unable to access account. Please contact technical support if problem persists</span>"
			return 0

		if(customer_account.suspended)
			src << "<span class='warning'>\icon[src] The [src] beeps: Error: Account Suspended</span>"
			return 0

		if(customer_account.security_level != 0) //If card requires pin authentication (ie seclevel 1 or 2)
			var/attempt_pin = input("Enter pin code", "Quik-Pay transaction") as num
			customer_account = SSeconomy.attempt_account_access(held_card.associated_account_number, attempt_pin, 2)

			if(!customer_account)
				src << "<span class='warning'>\icon[src] The [src] beeps: Error: Card Missing Account Number</span>"
				return 0

		if(sum > customer_account.money)
			src << "<span class='warning'>\icon[src] The [src] beeps: Error: Missing funds for transaction</span>"
			return 0
		else


		// debit money from the purchaser's account
			customer_account.money -= sum
			quickpay_account.money += sum




		// create entry in the purchaser's account log
			var/datum/transaction/T = new()
			T.target_name = machine_id
			T.purpose = "Quik Pay Transaction"
			T.amount = sum
			T.source_terminal = machine_id
			T.date = worlddate2text()
			T.time = worldtime2text()
			SSeconomy.add_transaction_log(customer_account,T)

			ui.close()
			var/sum = 0

	if(href_list["unlock"])
		var/attempt_code = input("Enter the edit code", "Confirm edit access code") as num //Copied the eftpos method, dont judge
		if(attempt_code == access_code)
			editmode = 1

	if(href_list["lock"])
		editmode = 0

	// DM code to go over selection list and sum it up