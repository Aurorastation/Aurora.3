/datum/component/quikpay_shop
	var/machine_id = ""
	var/list/items = list()
	var/list/buying = list()
	var/new_item = ""
	var/new_price = 0
	var/new_category = ""
	var/sum = 0
	var/editmode = FALSE
	var/receipt = ""
	var/destinationact = "Operations"
	var/credit = 100
	var/shop_name = "Commissary"
	var/obj/owner
	var/can_use_credits = TRUE
	var/stamp = "Idris Quik-Pay Register"
	var/req_one_access = list(ACCESS_BAR, ACCESS_GALLEY, ACCESS_CARGO)

/datum/component/quikpay_shop/quikpay
	shop_name = "Quikpay"
	destinationact = "Service"
	stamp = "Quik-Pay device"

// Add an item by clicking on it with the quikpay
/datum/component/quikpay_shop/quikpay/proc/add_item(atom/target, mob/user)
	if (!istype(target, /obj))
		return
	if (!editmode)
		to_chat(user, SPAN_NOTICE("Unlock \the [owner] to add items."))
		return

	var/obj/O = target
	var/name_guess = O.name
	var/price_guess = 0
	var/category_guess = ""

	price_guess = text2num(sanitizeSafe(tgui_input_text(user, "Set price for [name_guess]:", "[stamp]", 0, 10), 10))
	if(isnull(price_guess) || price_guess == 0)
		return
	price_guess = max(0, round(price_guess, 0.01))

	category_guess = sanitizeSafe(tgui_input_text(user, "Set category for [name_guess]:", "[stamp]", "Uncategorized", 32), 32)
	if(isnull(category_guess) || !length(category_guess))
		category_guess = "Uncategorized"

	items += list(list(
		"name" = "[name_guess]",
		"price" = price_guess,
		"category" = "[category_guess]"
	))

	to_chat(user, SPAN_NOTICE("[owner]: added '[name_guess]' for [price_guess] in category '[category_guess]'."))
	return TRUE


/datum/component/quikpay_shop/Initialize(var/access = list(ACCESS_BAR, ACCESS_GALLEY, ACCESS_CARGO), var/destination = "Operations")
	. = ..()
	machine_id = "[station_name()] [stamp] #[SSeconomy.num_financial_terminals++]"
	if(!istype(parent, /obj))
		return
	req_one_access = access
	destinationact = destination
	owner = parent

// Put credits in or take them out, assuming the device has credits
/datum/component/quikpay_shop/proc/take_give_credits(var/mob/user)
	if(!can_use_credits)
		return
	var/item = user.get_active_hand()

	if(istype(item, /obj/item/spacecash) && !istype(item, /obj/item/spacecash/ewallet))
		var/obj/item/spacecash/cashmoney = item
		credit += cashmoney.worth
		user.drop_from_inventory(cashmoney,get_turf(owner))
		user.visible_message("\The [user] inserts some credits into \the [owner]." )
		qdel(cashmoney)
		return

	var/obj/item/card/id/I = user.GetIdCard()
	if(istype(I) && has_access(req_one_access = src.req_one_access, accesses = I.access))
		var/price_guess = text2num(sanitizeSafe(tgui_input_text(user, "How much do you wish to withdraw? Remaining credits: [credit]电", "QuikPay", 0, 10), 10))
		if(isnull(price_guess) || price_guess == 0)
			return
		price_guess = max(0, round(price_guess, 0.01))
		if(credit >= price_guess)
			spawn_money(price_guess, owner.loc, user)
			credit -= price_guess
		user.visible_message("\The [user] remove some credits from \the [owner]." )
		return

// Print out a relevant receipt
/datum/component/quikpay_shop/proc/print_receipt()
	var/obj/item/paper/notepad/receipt/R = new(owner.loc)
	var/receiptname = "Receipt: [machine_id]"
	R.set_content_unsafe(receiptname, receipt, sum)
	stamp_receipt(R)
	usr.put_in_any_hand_if_possible(R)

// Interact with an object. Papers or payment pethods
/datum/component/quikpay_shop/proc/interact_object(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/paper))
		read_paper_list(attacking_item, user)
		return
	if(sum == 0)
		return
	if (istype(attacking_item, /obj/item/spacecash/ewallet))
		card_pay(attacking_item, user)
		return
	else if (istype(attacking_item, /obj/item/card/id))
		ID_pay(attacking_item, user)
		return
	else if(istype(attacking_item, /obj/item/spacecash) && can_use_credits)
		cash_pay(attacking_item, user)
		return

// Paying with cash
/datum/component/quikpay_shop/proc/cash_pay(obj/item/spacecash/cashmoney, mob/user)
	if(!can_use_credits)
		return
	var/transaction_amount = sum
	if(transaction_amount > cashmoney.worth)
		to_chat(user, SPAN_WARNING("[icon2html(cashmoney, user)] That is not enough money."))
		return 0
	if(istype(cashmoney, /obj/item/spacecash/bundle))
		user.visible_message(SPAN_INFO("\The [user] inserts some cash into \the [owner]."))
		var/obj/item/spacecash/bundle/cashmoney_bundle = cashmoney
		cashmoney_bundle.worth -= transaction_amount

		if(cashmoney_bundle.worth <= 0)
			usr.drop_from_inventory(cashmoney_bundle,get_turf(owner))
			qdel(cashmoney_bundle)
		else
			cashmoney_bundle.update_icon()
	else
		user.visible_message(SPAN_INFO("\The [user] inserts a bill into \the [owner]."))
		var/left = cashmoney.worth - transaction_amount
		user.drop_from_inventory(cashmoney,get_turf(owner))
		qdel(cashmoney)

		if(left)
			spawn_money(left, get_turf(user), user)
	credit += transaction_amount
	print_receipt()
	clear_order()
	return 1

// Paying with an id card
/datum/component/quikpay_shop/proc/ID_pay(obj/item/attacking_item, mob/user)
	var/obj/item/card/id/I = attacking_item.GetID()
	var/transaction_amount = sum
	var/transaction_purpose = "[destinationact] Payment"
	var/transaction_terminal = machine_id

	var/transaction = SSeconomy.transfer_money(I.associated_account_number, SSeconomy.get_department_account(destinationact)?.account_number,transaction_purpose,transaction_terminal,transaction_amount,null,usr)

	if(transaction)
		to_chat(user, SPAN_NOTICE("[icon2html(owner, user)]<span class='warning'>[transaction].</span>"))
	else
		user.visible_message("\The [user] swipes a card on \the [owner]." )
		owner.audible_message(SPAN_NOTICE("[icon2html(owner, viewers(get_turf(owner)))] \The [owner] chimes."))
		playsound(owner, 'sound/machines/chime.ogg', 50, 1)
		print_receipt()
		sum = 0
		receipt = ""
		to_chat(user, SPAN_NOTICE("Transaction completed, please return to the home screen."))
		clear_order()

// Paying with a charge card
/datum/component/quikpay_shop/proc/card_pay(obj/item/attacking_item, mob/user)
	var/obj/item/spacecash/ewallet/E = attacking_item
	var/transaction_amount = sum
	var/transaction_purpose = "[destinationact] Payment"
	var/transaction_terminal = machine_id

	if(transaction_amount <= E.worth)
		SSeconomy.charge_to_account(SSeconomy.get_department_account(destinationact)?.account_number, E.owner_name, transaction_purpose, transaction_terminal, transaction_amount)
		E.worth -= transaction_amount

		user.visible_message("\The [user] swipes a card on \the [owner]." )
		owner.audible_message(SPAN_NOTICE("[icon2html(owner, viewers(get_turf(owner)))] \The [owner] chimes."))
		playsound(owner, 'sound/machines/chime.ogg', 50, 1)
		print_receipt()
		sum = 0
		receipt = ""
		to_chat(user, SPAN_NOTICE("Transaction completed, please return to the home screen."))
		clear_order()
	else if (transaction_amount > E.worth)
		to_chat(user, SPAN_WARNING("[icon2html(owner, user)]\The [E] doesn't have that much money!"))
	return

// Read a paper to get data
/datum/component/quikpay_shop/proc/read_paper_list(obj/item/paper/R, mob/user)
	if(!editmode)
		owner.balloon_alert(user, "device locked!")
		return FALSE

	var/result = read_paper_price_list(R)
	for(var/item in result)
		items += list(list(
			"name" = item["name"],
			"price" = item["price"],
			"category" = item["category"] || "Uncategorized"
		))
	owner.balloon_alert(user, "device set!")
	return TRUE

// Print the prices to a paper
/datum/component/quikpay_shop/proc/print_price(mob/user, var/spawn_loc)
	return print_price_to_paper(shop_name, items, spawn_loc, user)

// Handles receipt creation
/datum/component/quikpay_shop/proc/buying_receipt(mob/user)
	receipt = ""
	sum = 0
	var/obj/item/card/id/id_card = user.GetIdCard()
	var/cashier = id_card ? id_card.registered_name : "Unknown"
	receipt = "<center><H2>[shop_name] receipt</H2>Today's date: [worlddate2text()]<BR>Cashier: [cashier]</center><HR>Purchased items:<ul>"
	for(var/list/bought_item in buying)
		var/item_name = bought_item["name"]
		var/item_amount = bought_item["amount"]
		var/item_price = bought_item["price"]

		receipt += "<li><b>[item_name]</b>: [item_amount] x [item_price]电: [item_amount * item_price]电<br>"
		sum += item_price * item_amount

	receipt += "</ul><HR>Total:</b> [sum]电<br>"

// Open the tgui
/datum/component/quikpay_shop/proc/interact_with_ui(mob/living/user)
	ui_interact(user)

/datum/component/quikpay_shop/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "QuikPay", "[stamp]", 550, 550)
		ui.open()

/datum/component/quikpay_shop/ui_data(var/mob/user)
	var/list/data = list()

	data["items"] = items
	data["buying"] = buying
	data["sum"] = sum
	data["new_item"] = new_item
	data["new_price"] = new_price
	data["new_category"] = new_category
	data["editmode"] = editmode
	data["destinationact"] = destinationact

	return data

/datum/component/quikpay_shop/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	switch(action)
		if("add")
			if(!editmode)
				owner.balloon_alert(usr, "device locked!")
				return FALSE

			if(!length(new_item))
				return FALSE

			if(!length(new_category))
				new_category = "Uncategorized"

			for(var/list/L in items)
				if(L["name"] == new_item)
					return FALSE

			items += list(list(
				"name" = new_item,
				"price" = new_price,
				"category" = new_category
			))

			new_item = ""
			. = TRUE

		if("remove")
			if(!editmode)
				owner.balloon_alert(usr, "device locked!")
				return FALSE
			var/index = 0
			for(var/list/L in items)
				index++
				if(L["name"] == params["removing"])
					items.Cut(index, index+1)
					break
			. = TRUE

		if("set_new_price")
			new_price = params["set_new_price"]
			. = TRUE

		if("set_new_item")
			new_item = params["set_new_item"]
			. = TRUE

		if("set_new_category")
			new_category = params["set_new_category"]
			. = TRUE

		if("clear")
			clear_order()
			. = TRUE

		if("buy")
			for(var/list/L in buying)
				if(L["name"] == params["buying"])
					L["amount"]++
					return TRUE
			buying += list(list("name" = params["buying"], "amount" = params["amount"], "price" = params["price"]))

		if("removal")
			var/index = 0
			for(var/list/L in buying)
				index++
				if(L["name"] == params["removal"])
					if(L["amount"] > 1)
						L["amount"]--
					else
						buying.Cut(index, index+1)
					break
			. = TRUE

		if("confirm")
			buying_receipt(usr)
			playsound(owner, 'sound/machines/ping.ogg', 25, 1)
			owner.audible_message(SPAN_NOTICE("[icon2html(owner, viewers(get_turf(owner)))] \The [owner] pings."))
			. = TRUE

		if("locking")
			if(editmode)
				editmode = FALSE
				owner.balloon_alert(usr, "device locked!")
			else
				if(!editmode)
					var/obj/item/card/id/I = usr.GetIdCard()
					if(!istype(I))
						return
					if(!has_access(req_one_access = src.req_one_access, accesses = I.access))
						owner.balloon_alert(usr, "no access!")
						return
					editmode = !editmode
					owner.balloon_alert(usr, "device [editmode ? "un" : ""]locked")
			. = TRUE

		if("accountselect")
			if(!editmode)
				owner.balloon_alert(usr, "device locked!")
				return FALSE

			var/dest = tgui_input_list(usr, "What account would you like to select?", "Destination Account", assoc_to_keys(SSeconomy.department_accounts))
			if(!dest)
				return FALSE
			destinationact = dest
			. = TRUE

		if("print_dsv")
			if(!editmode)
				owner.balloon_alert(usr, "device locked!")
				return FALSE
			print_price(usr)
			. = TRUE

// Clear the order from the selection
/datum/component/quikpay_shop/proc/clear_order()
	buying.Cut()
	sum = 0
	receipt = ""

/datum/component/quikpay_shop/orderterminal

	shop_name = "Commissary"
	stamp = "Self-serve Shop Teller"

/datum/component/quikpay_shop/orderterminal/food
	var/ticket = ""
	var/ticket_number = 1
	shop_name = "Service terminal"
	stamp = "Idris Food Terminal"

/datum/component/quikpay_shop/orderterminal/food/buying_receipt(mob/user)
	ticket = ""
	receipt = ""
	sum = 0
	receipt += "<center><font size=\"4\"><b>[stamp] Receipt</b></font></br><img src = idrislogo.png></center><hr>"
	ticket += "<center><font size=\"4\"><b>[stamp] Ticket</b></font></br><img src = idrislogo.png></center><hr>"
	for(var/list/bought_item in buying)
		var/item_name = bought_item["name"]
		var/item_amount = bought_item["amount"]
		var/item_price = bought_item["price"]
		sum += item_price * item_amount

		receipt += "<li><b>[item_name]</b>: [item_amount] x [item_price]电: [item_amount * item_price]电<br>"
		ticket += "<li><b>[item_name]</b>: [item_amount] x [item_price]电: [item_amount * item_price]电<br>"
	receipt += "<hr><b>Total:</b> [sum]电"
	ticket += "<hr><b>Total:</b> [sum]电"
	sum = sum

// Print the receipt followed by the order ticket
/datum/component/quikpay_shop/orderterminal/food/print_receipt()
	var/obj/item/card/id/id_card = usr.GetIdCard()
	ticket += "<br><b>Customer:</b> [id_card ? id_card.registered_name : "Unknown"]"
	receipt += "<br><b>Customer:</b> [id_card ? id_card.registered_name : "Unknown"]"
	var/obj/item/paper/notepad/receipt/R = new(owner.loc)
	var/receiptname = "Receipt: [machine_id]"
	R.set_content_unsafe(receiptname, receipt, sum)
	stamp_receipt(R)
	usr.put_in_any_hand_if_possible(R)
	// And now we do it but for the ticket.
	var/obj/item/paper/notepad/receipt/T = new(owner.loc)
	var/tickettname = "Order ticket: [ticket_number]"
	ticket_number++
	T.set_content_unsafe(tickettname, ticket, sum)
	stamp_receipt(T)
	usr.put_in_any_hand_if_possible(T)
	ticket = ""
	receipt = ""

/datum/component/quikpay_shop/proc/stamp_receipt(obj/item/paper/R) // Stamps the papers, made into a proc to avoid copy pasting too much
	var/image/stampoverlay = image('icons/obj/bureaucracy.dmi')
	stampoverlay.icon_state = "paper_stamp-hop"
	if(!R.stamped)
		R.stamped = new
	R.stamped += /obj/item/stamp
	R.AddOverlays(stampoverlay)
	R.stamps += "<HR><i>This paper has been stamped by \the [owner].</i>"
	R.ripped = TRUE
