/datum/computer_file/program/merchant
	filename = "mlist"
	filedesc = "Orion Express Goods Trading"
	extended_desc = "Allows communication and trade between passing vessels, even while jumping."
	program_icon_state = "comm"
	program_key_icon_state = "lightblue_key"
	requires_ntnet = 0
	available_on_ntnet = 0
	size = 12
	usage_flags = PROGRAM_CONSOLE
	tgui_id = "Merchant"
	var/obj/machinery/merchant_pad/pad
	var/current_merchant = 0
	var/show_trades = 0
	var/hailed_merchant = 0
	var/last_comms
	var/temp
	var/bank = 0 //A straight up money till

/datum/computer_file/program/merchant/Destroy()
	pad = null
	. = ..()

/datum/computer_file/program/merchant/proc/get_merchant(var/num)
	if(num > SStrade.traders.len)
		num = SStrade.traders.len
	if(num)
		return SStrade.traders[num]

/datum/computer_file/program/merchant/ui_data(mob/user)
	var/list/data = initial_data()
	var/show_trade = 0
	var/hailed = 0
	var/datum/trader/T
	data["temp"] = temp
	data["mode"] = !!current_merchant
	data["last_comms"] = last_comms
	data["pad"] = !!pad
	data["bank"] = bank
	show_trade = show_trades
	hailed = hailed_merchant
	T = get_merchant(current_merchant)
	data["mode"] = !!T
	if(T)
		data["traderName"] = T.name
		data["origin"]     = T.origin
		data["hailed"]     = hailed
		if(show_trade)
			var/list/trades = list()
			if(T.trading_items.len)
				for(var/i in 1 to T.trading_items.len)
					trades += T.print_trading_items(i)
			data["trades"] = trades
		else
			data["trades"] = null
	return data

/datum/computer_file/program/merchant/proc/connect_pad()
	for(var/obj/machinery/merchant_pad/P in orange(1,get_turf(computer)))
		pad = P
		return

/datum/computer_file/program/merchant/proc/test_fire()
	if(pad && pad.get_target())
		return 1
	return 0

/datum/computer_file/program/merchant/proc/offer_money(var/datum/trader/T, var/num, var/mob/user)
	if(pad)
		var/response = T.offer_money_for_trade(num, bank, user)
		if(istext(response))
			last_comms = T.get_response(response, "No thank you.")
		else
			last_comms = T.get_response("trade_complete", "Thank you!")
			T.trade(null,num, get_turf(pad))
			bank -= response
		return
	last_comms = "PAD NOT CONNECTED"

/datum/computer_file/program/merchant/proc/bulk_offer(var/datum/trader/T, var/num, var/mob/user)
	var/BulkAmount = tgui_input_number(usr, "How many items? (Buy 1-50 items. 0 to cancel.)", "Merchant", 1, 50, 0)
	if(istext(BulkAmount))
		last_comms = "ERROR: NUMBER EXPECTED"
		return
	if(BulkAmount < 0 || BulkAmount > 50)
		last_comms = "ERROR: POSITIVE NUMBER UP TO 50 EXPECTED"
		return
	if(pad)
		for(var/BulkCounter = 0, BulkCounter < BulkAmount, BulkCounter++)
			var/response = T.offer_money_for_trade(num, bank, user)
			if(istext(response))
				last_comms = T.get_response(response, "No thank you.")
			else
				last_comms = T.get_response("trade_complete", "Thank you!")
				T.trade(null,num, get_turf(pad))
				bank -= response
		return
	last_comms = "PAD NOT CONNECTED"

/datum/computer_file/program/merchant/proc/bribe(var/datum/trader/T, var/amt)
	if(bank < amt)
		last_comms = "ERROR: NOT ENOUGH FUNDS."
		return

	bank -= amt
	last_comms = T.bribe_to_stay_longer(amt)

/datum/computer_file/program/merchant/proc/offer_item(var/datum/trader/T, var/num, var/mob/user)
	if(pad)
		var/list/targets = pad.get_targets()
		for(var/target in targets)
			if(!computer_emagged && istype(target,/mob/living/carbon/human))
				last_comms = "SAFETY LOCK ENABLED: SENTIENT MATTER UNTRANSMITTABLE"
				return
		var/response = T.offer_items_for_trade(targets,num, get_turf(pad), user=user)
		if(istext(response))
			last_comms = T.get_response(response,"No, a million times no.")
		else
			last_comms = T.get_response("trade_complete","Thanks for your business!")

		return
	last_comms = "PAD NOT CONNECTED"

/datum/computer_file/program/merchant/proc/sell_items(var/datum/trader/T)
	if(pad)
		var/list/targets = pad.get_targets()
		var/response = T.sell_items(targets)
		if(istext(response))
			last_comms = T.get_response(response, "Nope. Nope nope nope.")
		else
			last_comms = T.get_response("trade_complete", "Glad to be of service!")
			bank += response
		return
	last_comms = "PAD NOT CONNECTED"

/datum/computer_file/program/merchant/proc/transfer_to_bank()
	if(pad)
		var/list/targets = pad.get_targets()
		for(var/target in targets)
			if(istype(target, /obj/item/spacecash))
				var/obj/item/spacecash/cash = target
				bank += cash.worth
				qdel(target)
		last_comms = "ALL MONEY DETECTED ON PAD transferred"
		return
	last_comms = "PAD NOT CONNECTED"

/datum/computer_file/program/merchant/proc/get_money()
	if(!pad)
		last_comms = "PAD NOT CONNECTED. CANNOT TRANSFER"
		return
	var/turf/T = get_turf(pad)
	var/obj/item/spacecash/bundle/B = new(T)
	B.worth = bank
	bank = 0
	B.update_icon()

/datum/computer_file/program/merchant/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	if(..())
		return
	var/mob/user = usr
	switch(action)
		if("PRG_connect_pad")
			. = TRUE
			connect_pad()
		if("PRG_continue")
			. = TRUE
			temp = null
		if("PRG_transfer_to_bank")
			. = TRUE
			transfer_to_bank()
		if("PRG_get_money")
			. = TRUE
			get_money()
		if("PRG_main_menu")
			. = TRUE
			current_merchant = 0
		if("PRG_merchant_list")
			if(SStrade.traders.len == 0)
				. = TRUE
				temp = "Cannot find any traders within broadcasting range."
			else
				. = TRUE
				current_merchant = 1
				hailed_merchant = 0
				last_comms = null
		if("PRG_test_fire")
			. = TRUE
			if(test_fire())
				temp = "Test Fire Successful"
			else
				temp = "Test Fire Unsuccessful"
		if("PRG_scroll")
			. = TRUE
			var/scrolled = 0
			switch(params["PRG_scroll"])
				if("right")
					scrolled = 1
				if("left")
					scrolled = -1
			var/new_merchant  = clamp(current_merchant + scrolled, 1, SStrade.traders.len)
			if(new_merchant != current_merchant)
				hailed_merchant = 0
				last_comms = null
			current_merchant = new_merchant
	if(current_merchant)
		var/datum/trader/T = get_merchant(current_merchant)
		if(!T.can_hail(user))
			if(T.get_bias(user) == TRADER_BIAS_DENY)
				last_comms = T.hail(user)
			else
				last_comms = T.get_response("hail_deny", "No, I'm not speaking with you.")
			. = TRUE
		else
			if(action == "PRG_hail")
				. = TRUE
				last_comms = T.hail(user)
				show_trades = 0
				hailed_merchant = 1
			if(action == "PRG_show_trades")
				. = TRUE
				show_trades = !show_trades
			if(action == "PRG_insult")
				. = TRUE
				last_comms = T.insult()
			if(action == "PRG_compliment")
				. = TRUE
				last_comms = T.compliment()
			if(action == "PRG_offer_item")
				. = TRUE
				offer_item(T,text2num(params["PRG_offer_item"]) + 1, user)
			if(action == "PRG_how_much_do_you_want")
				. = TRUE
				last_comms = T.how_much_do_you_want(text2num(params["PRG_how_much_do_you_want"]) + 1, user)
			if(action == "PRG_offer_money_for_item")
				. = TRUE
				offer_money(T, text2num(params["PRG_offer_money_for_item"])+1, user)
			if (action == "PRG_bulk_money_for_item")
				. = TRUE
				bulk_offer(T, text2num(params["PRG_bulk_money_for_item"])+1, user)
			if(action == "PRG_what_do_you_want")
				. = TRUE
				last_comms = T.what_do_you_want()
			if(action == "PRG_sell_items")
				. = TRUE
				sell_items(T)
			if(action == "PRG_bribe")
				. = TRUE
				bribe(T, text2num(params["PRG_bribe"]))

/datum/computer_file/program/merchant/nka
	required_access_run = list(ACCESS_NKA)
	required_access_download = list(ACCESS_NKA)

/datum/computer_file/program/merchant/guild
	required_access_run = list(ACCESS_MERCHANTS_GUILD)
	required_access_download = list(ACCESS_MERCHANTS_GUILD)

/datum/computer_file/program/merchant/golden_deep
	required_access_run = list(ACCESS_GOLDEN_DEEP, ACCESS_GOLDEN_DEEP_OWNED)
	required_access_download = list(ACCESS_GOLDEN_DEEP, ACCESS_GOLDEN_DEEP_OWNED)
