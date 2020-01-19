/datum/computer_file/program/cmdr
	filename = "cmdr"
	filedesc = "Syndicate Command and Control"
	program_icon_state = "hostile"
	extended_desc = "Uplink to Syndicate command and control. Hosts a variety of features for the discerning operative."
	size = 25
	available_on_ntnet = 0
	available_on_syndinet = 1
	requires_ntnet = 1
	color = LIGHT_COLOR_RED

	var/mob/abstract/eye/syndnet/eye
	var/list/datum/money_account/accounts
	var/list/obj/item/device/uplink/uplinks
	var/list/req_prices = list()

	var/active = FALSE
	var/money = 0
	var/tc_price = 2500

/datum/computer_file/program/cmdr/New()
	. = ..()
	eye = new(src)
	LAZYINITLIST(accounts)
	LAZYINITLIST(uplinks)
	build_prices()

/datum/computer_file/program/cmdr/Destroy()
	if(eye)
		if(active)
			eye.toggle_eye(usr)
		qdel(eye)
		eye = null

	..()

/datum/computer_file/program/cmdr/proc/build_accounts()
	for(var/datum/mind/player in SSticker.minds)
		if(istype(player.initial_account, /datum/money_account))
			LAZYADD(accounts, player.initial_account)
	// var/list/datum/mind/traitors = get_antags("traitor")
	// if(!traitors)
	// 	return FALSE

	// for(var/datum/mind/traitor in traitors)
	// 	if(istype(traitor.initial_account, /datum/money_account))
	// 		accounts += traitor.initial_account

/datum/computer_file/program/cmdr/proc/build_uplinks()
	for(var/obj/item/device/uplink/U in world_uplinks)
		if(istype(U) && U.uplink_owner)
			var/datum/mind/M = U.uplink_owner
			if(istype(M) && M.current.faction == "syndicate")
				LAZYADD(uplinks, U)

/datum/computer_file/program/cmdr/proc/build_prices()
	req_prices["shuttle"] = list()
	req_prices["shuttle"]["price"] = 25000
	req_prices["shuttle"]["type"] = "money"

/datum/computer_file/program/cmdr/ui_interact(mob/user as mob)
	var/datum/vueui/ui = SSvueui.get_open_ui(user, src)
	if (!ui)
		ui = new /datum/vueui/modularcomputer(user, src, "mcomputer-cmdr-main", 450, 520, filedesc)
	ui.open()

VUEUI_MONITOR_VARS(/datum/computer_file/program/cmdr, cmdrmonitor)
	watch_var("active", "active")
	watch_var("money", "money")
	watch_var("tc_price", "tc_price")

/datum/computer_file/program/cmdr/vueui_data_change(var/list/data, var/mob/user, var/datum/vueui/ui)
	. = ..()
	data = . || data || list()

	// Gather data for computer header
	var/headerdata = get_header_data(data["_PC"])
	if(headerdata)
		data["_PC"] = headerdata
		. = data

	VUEUI_SET_CHECK_IFNOTSET(data["activeview"], "resources", ., data)
	VUEUI_SET_CHECK_IFNOTSET(data["account_view"], 0, ., data)
	VUEUI_SET_CHECK_IFNOTSET(data["tc_view"], 0, ., data)
	VUEUI_SET_CHECK_IFNOTSET(data["res_view"], 0, ., data)
	VUEUI_SET_CHECK_IFNOTSET(data["misc_view"], 0, ., data)
	VUEUI_SET_CHECK_IFNOTSET(data["upgrade_view"], 0, ., data)

	LAZYINITLIST(data["accounts"])
	LAZYINITLIST(data["transfer"])
	LAZYINITLIST(data["uplinks"])
	LAZYINITLIST(data["supply"])
	LAZYINITLIST(data["req_prices"])
	build_accounts()
	build_uplinks()

	VUEUI_SET_CHECK(data["crystals"], computer.hidden_uplink.uses, ., data)

	if(LAZYLEN(data["accounts"]) < LAZYLEN(accounts))
		VUEUI_SET_CHECK(data["accounts"], list(), ., data)

	if(LAZYLEN(data["uplinks"]) < LAZYLEN(uplinks))
		VUEUI_SET_CHECK(data["uplinks"], list(), ., data)

	for(var/datum/money_account/account in accounts)
		LAZYINITLIST(data["accounts"]["\ref[account]"])
		VUEUI_SET_CHECK(data["accounts"]["\ref[account]"]["name"], account.owner_name, ., data)
		VUEUI_SET_CHECK(data["accounts"]["\ref[account]"]["amount"], account.money, ., data)

	for(var/obj/item/device/uplink/U in uplinks)
		LAZYINITLIST(data["uplinks"]["\ref[U]"])
		VUEUI_SET_CHECK(data["uplinks"]["\ref[U]"]["name"], U.uplink_owner.current.name, ., data)
		VUEUI_SET_CHECK(data["uplinks"]["\ref[U]"]["amount"], U.uses, ., data)

	VUEUI_SET_CHECK_IFNOTSET(data["transfer"]["amount"], 0, ., data)
	VUEUI_SET_CHECK(data["transfer"]["amount"], max(0, data["transfer"]["amount"]), ., data)

	VUEUI_SET_CHECK_IFNOTSET(data["supply"]["amount"], 0, ., data)
	VUEUI_SET_CHECK(data["supply"]["amount"], max(0, data["supply"]["amount"]), ., data)

	for(var/item in req_prices)
		LAZYINITLIST(data["req_prices"][item])
		VUEUI_SET_CHECK(data["req_prices"][item], req_prices[item], ., data)

/datum/computer_file/program/clientmanager/vueui_transfer(oldobj)
	SSvueui.transfer_uis(oldobj, src, "mcomputer-cmdr-main", 450, 520, filedesc)
	return TRUE

/datum/computer_file/program/cmdr/Topic(href, href_list)
	if(..())
		return 1

	var/datum/vueui/ui = href_list["vueui"]
	if(!istype(ui))
		return

	if(href_list["cams"] && eye)
		if(!eye.attached_console)
			eye.attached_console = computer
		active = eye.toggle_eye(usr)

	if(href_list["uplink"])
		if(computer.hidden_uplink)
			computer.hidden_uplink.trigger(usr)
			ui.close()
		else
			to_chat(usr, span("warning", "No attached uplink detected at this console!"))

	if(href_list["transfer"])
		var/datum/money_account/transfer_acct = locate(href_list["transfer"]["to"])
		if(istype(transfer_acct))
			var/transfer_amount = href_list["transfer"]["amount"]
			if(href_list["transfer"]["deposit"])
				if(money >= transfer_amount)
					SSeconomy.charge_to_account(transfer_acct.account_number, "null", "null", "NaN", transfer_amount)
					money -= transfer_amount
				else
					to_chat(usr, span("warning", "Transaction failed: Insufficient funds."))
			else
				if(transfer_acct.money >= transfer_amount)
					SSeconomy.charge_to_account(transfer_acct.account_number, "null", "null", "NaN", -transfer_amount)
					money += transfer_amount
				else
					to_chat(usr, span("warning", "Transaction failed: Insufficient funds."))
		SSvueui.check_uis_for_change(src)

	if(href_list["supply"])
		var/obj/item/device/uplink/transfer_uplink = locate(href_list["supply"]["to"])
		if(istype(transfer_uplink))
			var/supply_amount = href_list["supply"]["amount"]
			if(computer.hidden_uplink.uses >= supply_amount)
				computer.hidden_uplink.uses -= supply_amount
				transfer_uplink.uses += supply_amount
			else
				to_chat(usr, span("warning", "Supply Request Failed: Insufficient TC."))
		SSvueui.check_uis_for_change(src)

	if(href_list["crystal"])
		var/crystal_amt = href_list["crystal"]
		if(istype(computer.hidden_uplink, /obj/item/device/uplink))
			if((crystal_amt < 0 && crystal_amt * -1 > computer.hidden_uplink.uses) || (crystal_amt > 0 && crystal_amt * tc_price > money))
				to_chat(usr, span("warning", "Crystal transaction failed. Insufficient resources."))
				return
			money -= crystal_amt * tc_price
			computer.hidden_uplink.uses += crystal_amt
		else
			to_chat(usr, span("warning", "Crystal purchase failed."))
		SSvueui.check_uis_for_change(src)