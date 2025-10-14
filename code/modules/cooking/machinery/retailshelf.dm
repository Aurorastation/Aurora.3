// Item shelves
/obj/machinery/smartfridge/tradeshelf
	name = "cigarette shelf"
	desc = "A commercialized shelf for cigarettes and associated items."
	// icon = 'icons/obj/structure/urban/restaurant.dmi'
	icon_state = "trade_smokes"
	use_power = POWER_USE_OFF
	idle_power_usage = 0
	active_power_usage = 0
	contents_path = "-cigarettebox"
	accepted_items = list(/obj/item/storage/box/fancy/cigarettes,
	/obj/item/storage/chewables,
	/obj/item/storage/box/fancy/chewables,
	/obj/item/storage/cigfilters,
	/obj/item/storage/box/fancy/cigpaper,
	/obj/item/storage/box/fancy/matches,
	/obj/item/flame/lighter,
	/obj/item/clothing/mask/smokable/ecig,
	/obj/item/reagent_containers/ecig_cartridge
	)
	display_tiers = list(
		"3" = "-1",
		"6" = "-2",
		"9" = "-3",
		"12" = "-4"
	)
	infinity_tier = "-5"

/obj/machinery/smartfridge/tradeshelf/Initialize()
	. = ..()
	// contents_path = "[rand(1, 4)]" // overriding the update icon anyway, so this var is free.

// /obj/machinery/smartfridge/tradeshelf/update_icon()
// 	if(stat & (BROKEN|NOPOWER))
// 		icon_state = "[initial(icon_state)]"
// 	else
// 		icon_state = "[initial(icon_state)][contents_path]"

/obj/machinery/smartfridge/tradeshelf/clothing
	name = "clothing shelf"
	desc = "A commercialized shelf for clothing and associated items."
	icon_state = "trade_clothes"
	contents_path = "-clothing"
	accepted_items = list(/obj/item/storage/backpack,
	/obj/item/storage/belt,
	/obj/item/clothing
	)
	display_tiers = list(
		"5" = "-1",
		"10" = "-2"
	)
	infinity_tier = "-3"

/obj/machinery/smartfridge/tradeshelf/food
	name = "food and drinks shelf"
	desc = "A commercialized shelf for food and drinks."
	icon_state = "trade_food"
	contents_path = "-edible"
	accepted_items = list(/obj/item/reagent_containers/food,
	/obj/item/storage/box/fancy/cookiesnack
	)
	display_tiers = list(
		"5" = "-1",
		"10" = "-2",
		"15" = "-3"
	)
	infinity_tier = "-4"

/obj/machinery/smartfridge/tradeshelf/toy
	name = "toy shelf"
	desc = "A commercialized shelf for toys and associated items."
	icon_state = "trade_toys"
	contents_path = "-toy"
	accepted_items = list(/obj/item/toy,
	/obj/item/lipstick,
	/obj/item/device/paicard,
	/obj/item/device/camera,
	/obj/item/device/synthesized_instrument,
	/obj/item/storage/box/unique/snappops,
	/obj/item/haircomb,
	/obj/item/storage/box/fancy/crayons,
	/obj/item/melee/dinograbber
	)
	display_tiers = list(
		"5" = "-1",
		"10" = "-2",
		"15" = "-3"
	)
	infinity_tier = "-4"

// -------------------------------------------------
/obj/structure/cash_register/commissary
	// name = "\improper Idris Quik-Pay"
	// desc = "Swipe your ID to make direct company purchases."
	// icon = 'icons/obj/item/device/eftpos.dmi'
	// icon_state = "quikpay"
	// item_state = "electronic"
	// w_class = WEIGHT_CLASS_SMALL
	// slot_flags = SLOT_BELT
	var/machine_id = ""
	var/list/items = list()
	var/list/items_to_price = list()
	var/list/buying = list()
	var/new_item = ""
	var/new_price = 0
	var/sum = 0
	var/editmode = FALSE
	var/receipt = ""
	var/destinationact = "Service"

/obj/structure/cash_register/commissary/Initialize()
	. = ..()
	machine_id = "[station_name()] Idris Quik-Pay Register #[SSeconomy.num_financial_terminals++]"

	//create a short manual as well
	// var/obj/item/paper/R = new(src.loc)
	// R.name = "Quik And Easy: How to make a transaction"

	// R.info += "<b>Quik-Pay setup:</b><br>"
	// R.info += "<ol><li>Remember your access code included on the paper that is included with your device</li>"
	// R.info += "<li>Unlock it to be able to add items to the menu</li>"
	// R.info += "<li>Add items to the menu by typing the item name and its price</li></ol>"
	// R.info += "<b>When starting a new transaction:</b><br>"
	// R.info += "<ol><li>Have the customer enter the amount of the item they want and then confirm the purchase.</li>"
	// R.info += "<li>Allow them to review the sum.</li>"
	// R.info += "<li>Have them swipe their card to pay for the items.</li></ol>"

	// //stamp the paper
	// var/image/stampoverlay = image('icons/obj/bureaucracy.dmi')
	// stampoverlay.icon_state = "paper_stamp-cent"
	// if(!R.stamped)
	// 	R.stamped = new
	// R.offset_x += 0
	// R.offset_y += 0
	// R.ico += "paper_stamp-cent"
	// R.stamped += /obj/item/stamp
	// R.AddOverlays(stampoverlay)
	// R.stamps += "<HR><i>This paper has been stamped by the Executive Officer's desk.</i>"

/obj/structure/cash_register/commissary/AltClick(var/mob/user)
	var/obj/item/card/id/I = user.GetIdCard()
	if(istype(I) && (ACCESS_HEADS in I.access))
		editmode = TRUE
		to_chat(user, SPAN_NOTICE("Command access granted."))
		SStgui.update_uis(src)

/obj/structure/cash_register/commissary/proc/print_receipt()
	var/obj/item/paper/R = new(usr.loc)
	var/receiptname = "Receipt: [machine_id]"
	R.set_content_unsafe(receiptname, receipt, sum)

	//stamp the paper
	var/image/stampoverlay = image('icons/obj/bureaucracy.dmi')
	stampoverlay.icon_state = "paper_stamp-cent"
	if(!R.stamped)
		R.stamped = new
	R.stamped += /obj/item/stamp
	R.AddOverlays(stampoverlay)
	R.stamps += "<HR><i>This paper has been stamped by the Quik-Pay device.</i>"

/obj/structure/cash_register/commissary/attackby(obj/item/attacking_item, mob/user)
	if (istype(attacking_item, /obj/item/spacecash/ewallet))
		var/obj/item/spacecash/ewallet/E = attacking_item
		var/transaction_amount = sum
		var/transaction_purpose = "[destinationact] Payment"
		var/transaction_terminal = machine_id

		if(transaction_amount <= E.worth)
			playsound(src, 'sound/machines/chime.ogg', 50, 1)
			src.visible_message(SPAN_NOTICE("[icon2html(src, viewers(get_turf(src)))] \The [src] chimes."))

			SSeconomy.charge_to_account(SSeconomy.get_department_account(destinationact)?.account_number, E.owner_name, transaction_purpose, transaction_terminal, transaction_amount)
			E.worth -= transaction_amount
			print_receipt()
			sum = 0
			receipt = ""
			to_chat(user, SPAN_NOTICE("Transaction completed, please return to the home screen."))
		else if (transaction_amount > E.worth)
			to_chat(user, SPAN_WARNING("[icon2html(src, user)]\The [E] doesn't have that much money!"))
		return

	var/obj/item/card/id/I = attacking_item.GetID()
	if (!istype(attacking_item))
		return

	var/transaction_amount = sum
	var/transaction_purpose = "[destinationact] Payment"
	var/transaction_terminal = machine_id

	var/transaction = SSeconomy.transfer_money(I.associated_account_number, SSeconomy.get_department_account(destinationact)?.account_number,transaction_purpose,transaction_terminal,transaction_amount,null,usr)

	if(transaction)
		to_chat(user, SPAN_NOTICE("[icon2html(src, user)]<span class='warning'>[transaction].</span>"))
	else
		playsound(src, 'sound/machines/chime.ogg', 50, 1)
		visible_message(SPAN_NOTICE("[icon2html(src, viewers(get_turf(src)))] \The [src] chimes."))
		print_receipt()
		sum = 0
		receipt = ""
		to_chat(user, SPAN_NOTICE("Transaction completed, please return to the home screen."))

// /obj/structure/cash_register/commissary/attack_self(var/mob/user)
// 	ui_interact(user)

/obj/structure/cash_register/commissary/attack_hand(mob/living/user)
	. = ..()
	ui_interact(user)

/obj/structure/cash_register/commissary/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "QuikPay", "Idris Quik-Pay Register", 400, 400)
		ui.open()

/obj/structure/cash_register/commissary/ui_data(var/mob/user)
	var/list/data = list()

	data["items"] = items
	data["buying"] = buying
	data["sum"] = sum
	data["new_item"] = new_item
	data["new_price"] = new_price
	data["editmode"] = editmode
	data["destinationact"] = destinationact

	return data

/obj/structure/cash_register/commissary/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("add")
			if(!editmode)
				to_chat(usr, SPAN_WARNING("Device locked."))
				return FALSE

			items += list(list("name" = new_item, "price" = new_price))
			items_to_price[new_item] = new_price
			. = TRUE

		if("remove")
			if(!editmode)
				to_chat(usr, SPAN_NOTICE("Device locked."))
				return FALSE
			var/index = 0
			for(var/list/L in items)
				index++
				if(L["name"] == params["removing"])
					items.Cut(index, index+1)
			. = TRUE

		if("set_new_price")
			new_price = params["set_new_price"]
			. = TRUE

		if("set_new_item")
			new_item = params["set_new_item"]
			. = TRUE

		if("clear")
			clear_order()
			. = TRUE

		if("buy")
			for(var/list/L in buying)
				if(L["name"] == params["buying"])
					L["amount"]++
					return TRUE
			buying += list(list("name" = params["buying"], "amount" = params["amount"]))

		if("removal")
			for(var/list/L in buying)
				if(L["name"] == params["removal"])
					if(L["amount"] > 1)
						L["amount"]--
					else
						buying -= L
			. = TRUE

		if("confirm")
			for(var/list/bought_item in buying)
				var/item_name = bought_item["name"]
				var/item_amount = bought_item["amount"]
				var/item_price = items_to_price[item_name]

				receipt += "<b>[name]</b>: [item_name] x[item_amount] at [item_price]cr each<br>"
				sum += item_price
			. = TRUE

		if("locking")
			if(editmode)
				editmode = FALSE
				to_chat(usr, SPAN_NOTICE("Device locked."))
			else
				if(!editmode)
					var/obj/item/card/id/I = usr.GetIdCard()
					if(!istype(I))
						return
					if(check_access(I))
						editmode = !editmode
						to_chat(usr, SPAN_NOTICE("Device [editmode ? "un" : ""]locked."))
			. = TRUE

		if("accountselect")
			if(!editmode)
				to_chat(usr, SPAN_WARNING("Device locked."))
				return FALSE

			switch(input("What account would you like to select?", "Destination Account") as null|anything in list("Service", "Operations", "Command", "Medical", "Security", "Engineering", "Science"))
				if("Service")
					destinationact = "Service"
				if("Operations")
					destinationact = "Operations"
				if("Command")
					destinationact = "Command"
				if("Medical")
					destinationact = "Medical"
				if("Security")
					destinationact = "Security"
				if("Engineering")
					destinationact = "Engineering"
				if("Science")
					destinationact = "Science"
			. = TRUE

/obj/structure/cash_register/commissary/proc/clear_order()
	buying.Cut()
	sum = 0
	receipt = ""

// -------------------------------------------------
// /obj/structure/cash_register
// 	name = "cash register machine"
// 	desc = "A retail nightmare object."
// 	icon = 'icons/obj/structure/urban/infrastructure.dmi'
// 	icon_state = "cashier"
// 	layer = 2.99
// 	density = 0
// 	anchored = 0
// 	var/storage_type = /obj/item/storage/toolbox/cash_register_storage
// 	var/obj/item/storage/storage_compartment

// /obj/structure/cash_register/mechanics_hints(mob/user, distance, is_adjacent)
// 	. += ..()
// 	. += "Drag this onto yourself to open the cash compartment."

// /obj/structure/cash_register/Initialize(mapload)
// 	. = ..()
// 	if(storage_type)
// 		storage_compartment = new storage_type(src)

// /obj/item/storage/toolbox/cash_register_storage
// 	name = "cash compartment"
// 	use_sound = null
// 	drop_sound = null
// 	pickup_sound = null

// /obj/structure/cash_register/mouse_drop_dragged(atom/over, mob/user, src_location, over_location, params)
// 	if(user == over && ishuman(over))
// 		var/mob/living/carbon/human/H = over
// 		storage_compartment.open(H)
