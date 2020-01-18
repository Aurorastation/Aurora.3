#define UIDEBUG
/datum/computer_file/program/cmdr
	filename = "cmdr"
	filedesc = "Syndicate Command and Control"
	program_icon_state = "hostile"
	extended_desc = "Uplink to syndicate command and control. Hosts a variety of features for the discerning operative."
	size = 25
	available_on_ntnet = 0
	available_on_syndinet = 1
	requires_ntnet = 1
	color = LIGHT_COLOR_RED

	var/mob/abstract/eye/syndnet/eye
	var/list/datum/money_account/accounts
	var/active = FALSE
	var/money = 0

/datum/computer_file/program/cmdr/New()
	. = ..()
	eye = new(src)
	LAZYINITLIST(accounts)

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

/datum/computer_file/program/cmdr/ui_interact(mob/user as mob)
	var/datum/vueui/ui = SSvueui.get_open_ui(user, src)
	if (!ui)
		ui = new /datum/vueui/modularcomputer(user, src, "mcomputer-cmdr-main", 450, 520, filedesc)
	ui.open()

VUEUI_MONITOR_VARS(/datum/computer_file/program/cmdr, cmdrmonitor)
	watch_var("active", "active")
	watch_var("money", "money")

/datum/computer_file/program/cmdr/vueui_data_change(var/list/data, var/mob/user, var/datum/vueui/ui)
	. = ..()
	data = . || data || list()

	// Gather data for computer header
	var/headerdata = get_header_data(data["_PC"])
	if(headerdata)
		data["_PC"] = headerdata
		. = data

	VUEUI_SET_CHECK_IFNOTSET(data["activeview"], "resources", ., data)

	if(data["activeview"] == "resources")
		LAZYINITLIST(data["accounts"])
		LAZYINITLIST(data["transfer"])
		build_accounts()
		if(LAZYLEN(data["accounts"]) < LAZYLEN(accounts))
			VUEUI_SET_CHECK(data["accounts"], list(), ., data)
		for(var/datum/money_account/account in accounts)
			LAZYINITLIST(data["accounts"]["\ref[account]"])
			VUEUI_SET_CHECK(data["accounts"]["\ref[account]"]["name"], account.owner_name, ., data)
			VUEUI_SET_CHECK(data["accounts"]["\ref[account]"]["amount"], account.money, ., data)
		VUEUI_SET_CHECK_IFNOTSET(data["transfer"]["amount"], 0, ., data)
		VUEUI_SET_CHECK(data["transfer"]["amount"], max(0, data["transfer"]["amount"]), ., data)
		if(data["transfer"]["amount"] < 0)
			data["transfer"]["amount"] = 0
			. = data
		VUEUI_SET_CHECK(data["crystals"], computer.hidden_uplink.uses, ., data)

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
		active = eye.toggle_eye(usr)
		usr.rebuild_hud()

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

/mob/proc/rebuild_hud()
	if(client && client.screen)
		client.screen.len = null
		if(hud_used)
			qdel(hud_used)
		hud_used = new /datum/hud(src)