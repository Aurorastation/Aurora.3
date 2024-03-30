/**
 *  Datum used to hold information about a product in a vending machine
 */
/datum/data/vending_product
	var/product_name = "generic" // Display name for the product
	var/product_path = null
	var/amount = 0  // Amount held in the vending machine
	var/max_amount = 0
	var/price = 0  // Price to buy one
	var/display_color = null  // Display color for vending machine listing
	var/category = CAT_NORMAL  // CAT_HIDDEN for contraband, CAT_COIN for premium
	var/icon/product_icon
	var/icon/icon_state

/datum/data/vending_product/New(var/path, var/name = null, var/amount = 1, var/price = 0, var/color = null, var/category = CAT_NORMAL)
	. = ..()

	product_path = path
	var/atom/A = new path(null)

	if(!name)
		product_name = initial(A.name)
	else
		product_name = name

	src.amount = amount
	src.price = price
	src.display_color = color
	src.category = category
	if(istype(A, /obj/item/seeds))
		// thanks seeds for being overlays defined at runtime
		var/obj/item/seeds/S = A
		product_icon = S.update_appearance(TRUE)
	else
		product_icon = new /icon(A.icon, A.icon_state)

	icon_state = product_icon
	QDEL_NULL(A)

/**
 *  A vending machine
 */
/obj/machinery/vending
	name = "Vendomat"
	desc = "A generic vending machine."
	icon = 'icons/obj/vending.dmi'
	icon_state = "generic"
	layer = 2.99
	anchored = 1
	density = 1
	clicksound = /singleton/sound_category/button_sound
	manufacturer = "idris"

	var/icon_vend //Icon_state when vending
	var/deny_time // How long the physical icon state lasts, used cut the deny overlay

	// Power
	idle_power_usage = 10
	var/vend_power_usage = 150 //actuators and stuff

	// Vending-related
	var/active = 1 //No sales pitches if off!
	var/vend_ready = 1 //Are we ready to vend?? Is it time??
	var/vend_delay = 10 //How long does it take to vend?
	var/vending = FALSE

	var/categories = CAT_NORMAL // Bitmask of cats we're currently showing
	var/datum/data/vending_product/currently_vending = null // What we're requesting payment for right now
	var/status_message = "" // Status screen messages like "insufficient funds", displayed in NanoUI
	var/status_error = 0 // Set to 1 if status_message is an error

	/*
		Variables used to initialize the product list
		These are used for initialization only, and so are optional if
		product_records is specified
	*/
	var/list/products	= list() // For each, use the following pattern:
	var/list/contraband	= list() // list(/type/path = amount,/type/path2 = amount2)
	var/list/premium 	= list() // No specified amount = only one in stock
	var/list/prices     = list() // Prices for each item, list(/type/path = price), items not in the list don't have a price.

	// List of vending_product items available.
	var/list/product_records = list()


	// Variables used to initialize advertising
	var/product_slogans = "" //String of slogans spoken out loud, separated by semicolons
	var/product_ads = "" //String of small ad messages in the vending screen

	var/list/ads_list = list()

	// Stuff relating vocalizations
	var/list/slogan_list = list()
	var/shut_up = 1 //Stop spouting those godawful pitches!
	var/vend_reply //Thank you for shopping!
	var/last_reply = 0
	var/last_slogan = 0 //When did we last pitch?
	var/slogan_delay = 6000 //How long until we can pitch again?

	// Things that can go wrong
	emagged = 0 //Ignores if somebody doesn't have card access to that machine.
	var/seconds_electrified = 0 //Shock customers like an airlock.
	var/shoot_inventory = 0 //Fire items at customers! We're broken!
	var/shoot_inventory_chance = 1

	var/scan_id = 1
	var/obj/item/coin/coin
	var/datum/wires/vending/wires = null

	var/can_move = 1	//if you can wrench the machine out of place
	var/vend_id = "generic"	//Id of the refill cartridge that has to be used
	var/restock_items = 0	//If items can be restocked into the vending machine
	var/list/restock_blocked_items = list() //Items that can not be restocked if restock_items is enabled
	var/random_itemcount = 1 //If the number of items should be randomized
	var/sel_key = 0

	var/temperature_setting = 0 //-1 means cooling, 1 means heating, 0 means doing nothing.

	var/cooling_temperature = T0C + 5 //Best temp for soda.
	var/heating_temperature = T0C + 57 //Best temp for coffee.

	var/vending_sound = 'sound/machines/vending/vending_drop.ogg'

	var/global/list/screen_overlays
	var/exclusive_screen = TRUE // Are we not allowed to show the deny and screen states at the same time?

	var/ui_size = 80 // this is for scaling the ui buttons - i've settled on 80x80 for machines with prices, and 60x60 for those without and with large inventories (boozeomat)
	var/datum/asset/spritesheet/vending/v_asset

	light_range = 2
	light_power = 1.3

/obj/machinery/vending/Initialize(mapload)
	. = ..()
	wires = new(src)
	if(src.product_slogans)
		src.slogan_list += text2list(src.product_slogans, ";")

		// So not all machines speak at the exact same time.
		// The first time this machine says something will be at slogantime + this random value,
		// so if slogantime is 10 minutes, it will say it at somewhere between 10 and 20 minutes after the machine is crated.
		src.last_slogan = world.time + rand(0, slogan_delay)

	if(src.product_ads)
		src.ads_list += text2list(src.product_ads, ";")

	add_screen_overlay()
	build_products()
	build_inventory()
	power_change()

	return INITIALIZE_HINT_LATELOAD

/obj/machinery/vending/LateInitialize()
	v_asset = get_asset_datum(/datum/asset/spritesheet/vending)

/obj/machinery/vending/proc/reset_light()
	set_light(initial(light_range), initial(light_power), initial(light_color))

/obj/machinery/vending/proc/add_screen_overlay(var/deny = FALSE)
	if(!LAZYLEN(screen_overlays))
		LAZYINITLIST(screen_overlays)
	if(!("[icon_state]-screen" in screen_overlays) || (deny && !("[icon_state]-deny" in screen_overlays)))
		var/list/states = icon_states(icon)
		if ("[icon_state]-screen" in states)
			screen_overlays["[icon_state]-screen"] = make_screen_overlay(icon, "[icon_state]-screen")
		if ("[icon_state]-deny" in states)
			screen_overlays["[icon_state]-deny"] = make_screen_overlay(icon, "[icon_state]-deny")
	add_overlay(screen_overlays["[icon_state]-[deny ? "deny" : "screen"]"])
	reset_light()

/**
 *  Build src.products
 *
 *  To be overriden if building the products list is dynamic at runtime or needs any complex logic
 */
/obj/machinery/vending/proc/build_products()
	SHOULD_NOT_SLEEP(TRUE)
	return

/**
 *  Build src.product_records from the products lists
 *
 *  src.products, src.contraband, src.premium, and src.prices allow specifying
 *  products that the vending machine is to carry without manually populating
 *  src.product_records.
 */
/obj/machinery/vending/proc/build_inventory()
	var/list/all_products = list(
		list(src.products, CAT_NORMAL),
		list(src.contraband, CAT_HIDDEN),
		list(src.premium, CAT_COIN))

	for(var/current_list in all_products)
		var/category = current_list[2]

		for(var/entry in current_list[1])
			var/datum/data/vending_product/product = new/datum/data/vending_product(entry)

			product.price = (entry in src.prices) ? src.prices[entry] : 0
			product.max_amount = product.amount = product.amount = (current_list[1][entry]) ? current_list[1][entry] : 1
			if (random_itemcount == 1 && category == CAT_NORMAL) //Only the normal category is randomized.
				product.amount = rand(1,product.max_amount)
			else
				product.amount = product.max_amount
			product.category = category

			src.product_records.Add(product)

/obj/machinery/vending/Destroy()
	qdel(wires)
	wires = null
	qdel(coin)
	coin = null
	return ..()

/obj/machinery/vending/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			if (prob(50))
				qdel(src)
				return
		if(3.0)
			if (prob(25))
				spawn(0)
					src.malfunction()
					return
				return
	return

/obj/machinery/vending/emag_act(var/remaining_charges, var/mob/user)
	if (!emagged)
		src.emagged = 1
		to_chat(user, "You short out the product lock on \the [src]")
		return 1

/obj/machinery/vending/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/device/debugger))
		if(!shut_up)
			to_chat(user, SPAN_WARNING("\The [attacking_item] reads, \"Software error detected. Rectifying.\"."))
			if(attacking_item.use_tool(src, user, 100, volume = 50))
				to_chat(user, SPAN_NOTICE("\The [attacking_item] reads, \"Solution found. Fix applied.\"."))
				shut_up = TRUE
		if(shoot_inventory)
			if(wires.is_cut(WIRE_THROW))
				to_chat(user, SPAN_WARNING("\The [attacking_item] reads, \"Hardware error detected. Manual repair required.\"."))
				return TRUE
			to_chat(user, SPAN_WARNING("\The [attacking_item] reads, \"Software error detected. Rectifying.\"."))
			if(attacking_item.use_tool(src, user, 100, volume = 50))
				to_chat(user, SPAN_NOTICE("\The [attacking_item] reads, \"Solution found. Fix applied. Have a NanoTrasen day!\"."))
				shoot_inventory = FALSE
		else
			to_chat(user, SPAN_NOTICE("\The [attacking_item] reads, \"All systems nominal.\"."))
		return TRUE

	var/obj/item/card/id/I = attacking_item.GetID()
	var/datum/money_account/vendor_account = SSeconomy.get_department_account("Vendor")

	if (currently_vending && vendor_account && !vendor_account.suspended)
		var/paid = 0
		var/handled = 0

		if (currently_vending.amount < 1)
			visible_message(SPAN_WARNING("\The [src] buzzes and flashes a message on its LCD: <b>\"Out of stock.\"</b>"))
			src.status_error = 1
			playsound(src.loc, 'sound/machines/buzz-two.ogg', 35, 1)
			currently_vending = null
			return TRUE

		if (I) //for IDs and PDAs and wallets with IDs
			paid = pay_with_card(I,attacking_item)
			handled = 1
		else if (istype(attacking_item, /obj/item/spacecash/ewallet))
			var/obj/item/spacecash/ewallet/C = attacking_item
			paid = pay_with_ewallet(C)
			handled = 1
		else if (istype(attacking_item, /obj/item/spacecash))
			var/obj/item/spacecash/C = attacking_item
			paid = pay_with_cash(C, user)
			handled = 1

		if(paid)
			SStgui.update_uis(src)
			src.vend(currently_vending, usr)
		else if(handled)
			SStgui.update_uis(src)
		return TRUE // don't smack that machine with your 2 credits

	if (I || istype(attacking_item, /obj/item/spacecash))
		return attack_hand(user)
	else if(attacking_item.isscrewdriver())
		src.panel_open = !src.panel_open
		to_chat(user, "You [src.panel_open ? "open" : "close"] the maintenance panel.")
		cut_overlays()
		add_screen_overlay()
		if(src.panel_open)
			add_overlay("[initial(icon_state)]-panel")
		return TRUE
	else if(attacking_item.ismultitool()||attacking_item.iswirecutter())
		if(src.panel_open)
			return attack_hand(user)
		return TRUE
	else if(istype(attacking_item, /obj/item/coin) && premium.len > 0)
		user.drop_from_inventory(attacking_item,src)
		coin = attacking_item
		categories |= CAT_COIN
		to_chat(user, "<span class='notice'>You insert \the [attacking_item] into \the [src].</span>")
		SStgui.update_uis(src)
		return TRUE
	else if(attacking_item.iswrench())
		if(!can_move)
			return TRUE
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		attacking_item.play_tool_sound(get_turf(src), 50)
		user.visible_message("<b>[user]</b> begins [anchored? "un" : ""]securing \the [src] [anchored? "from" : "to"] the floor.", SPAN_NOTICE("You start [anchored? "un" : ""]securing \the [src] [anchored? "from" : "to"] the floor."))
		if(attacking_item.use_tool(src, user, 20, volume = 50))
			if(!src) return
			to_chat(user, "<span class='notice'>You [anchored? "un" : ""]secured \the [src]!</span>")
			anchored = !anchored
			power_change()
		return TRUE

	else if(istype(attacking_item,/obj/item/device/vending_refill))
		if(panel_open)
			var/obj/item/device/vending_refill/VR = attacking_item
			if(VR.charges)
				if(VR.vend_id == vend_id)
					VR.restock_inventory(src)
					to_chat(user, "<span class='notice'>You restock \the [src] with \the [VR]!</span>")
					if(!VR.charges)
						to_chat(user, "<span class='warning'>\The [VR] is depleted!</span>")
				else
					to_chat(user, "<span class='warning'>\The [VR] is not stocked for this type of vendor!</span>")
			else
				to_chat(user, "<span class='warning'>\The [VR] is depleted!</span>")
		else
			to_chat(user, "<span class='warning'>You must open \the [src]'s maintenance panel first!</span>")
		return TRUE

	else if(!is_borg_item(attacking_item))
		if(!restock_items)
			to_chat(user, "<span class='warning'>\the [src] can not be restocked manually!</span>")
			return TRUE
		for(var/path in restock_blocked_items)
			if(istype(attacking_item, path))
				to_chat(user, "<span class='warning'>\the [src] does not accept this item!</span>")
				return TRUE

		for(var/datum/data/vending_product/R in product_records)
			if(attacking_item.type == R.product_path)
				stock(R, user)
				user.remove_from_mob(attacking_item) //Catches gripper duplication
				qdel(attacking_item)
				return TRUE
	return ..()

/**
 *  Receive payment with cashmoney.
 *
 *  usr is the mob who gets the change.
 */
/obj/machinery/vending/proc/pay_with_cash(var/obj/item/spacecash/cashmoney, mob/user)
	if(currently_vending.price > cashmoney.worth)

		// This is not a status display message, since it's something the character
		// themselves is meant to see BEFORE putting the money in
		to_chat(user, "[icon2html(cashmoney, user)] <span class='warning'>That is not enough money.</span>")
		return 0

	if(istype(cashmoney, /obj/item/spacecash/bundle))
		// Bundles can just have money subtracted, and will work

		visible_message("<span class='info'>\The [user] inserts some cash into \the [src].</span>")
		var/obj/item/spacecash/bundle/cashmoney_bundle = cashmoney
		cashmoney_bundle.worth -= currently_vending.price

		if(cashmoney_bundle.worth <= 0)
			usr.drop_from_inventory(cashmoney_bundle,get_turf(src))
			qdel(cashmoney_bundle)
		else
			cashmoney_bundle.update_icon()
	else
		// Bills (banknotes) cannot really have worth different than face value,
		// so we have to eat the bill and spit out change in a bundle
		// This is really dirty, but there's no superclass for all bills, so we
		// just assume that all spacecash that's not something else is a bill

		visible_message("<span class='info'>\The [user] inserts a bill into \the [src].</span>")
		var/left = cashmoney.worth - currently_vending.price
		user.drop_from_inventory(cashmoney,get_turf(src))
		qdel(cashmoney)

		if(left)
			spawn_money(left, get_turf(user), user)

	// Vending machines have no idea who paid with cash
	credit_purchase("(cash)")
	return 1

/**
 * Scan a chargecard and deduct payment from it.
 *
 * Takes payment for whatever is the currently_vending item. Returns 1 if
 * successful, 0 if failed.
 */
/obj/machinery/vending/proc/pay_with_ewallet(var/obj/item/spacecash/ewallet/wallet)
	visible_message("<span class='info'>\The [usr] swipes \the [wallet] through \the [src].</span>")
	playsound(src.loc, 'sound/machines/id_swipe.ogg', 50, 1)
	if(currently_vending.price > wallet.worth)
		src.status_message = "Insufficient funds on chargecard."
		src.status_error = 1
		return 0
	else
		wallet.worth -= currently_vending.price
		credit_purchase("[wallet.owner_name] (chargecard)")
		return 1

/**
 * Scan a card and attempt to transfer payment from associated account.
 *
 * Takes payment for whatever is the currently_vending item. Returns 1 if
 * successful, 0 if failed
 */
/obj/machinery/vending/proc/pay_with_card(var/obj/item/card/id/I, var/obj/item/ID_container)
	if(I==ID_container || ID_container == null)
		visible_message("<span class='info'>\The [usr] swipes \the [I] through \the [src].</span>")
	else
		visible_message("<span class='info'>\The [usr] swipes \the [ID_container] through \the [src].</span>")
	playsound(src.loc, 'sound/machines/id_swipe.ogg', 50, 1)
	var/datum/money_account/vendor_account = SSeconomy.get_department_account("Vendor")
	var/datum/money_account/customer_account = SSeconomy.get_account(I.associated_account_number)
	if (!customer_account)
		//Allow BSTs to take stuff from vendors, for debugging and adminbus purposes
		if (istype(I, /obj/item/card/id/bst))
			return 1

		src.status_message = "Error: Unable to access account. Please contact technical support if problem persists."
		src.status_error = 1
		return 0

	if(customer_account.suspended)
		src.status_message = "Unable to access account: account suspended."
		src.status_error = 1
		return 0

	// Have the customer punch in the PIN before checking if there's enough money. Prevents people from figuring out acct is
	// empty at high security levels
	if(customer_account.security_level != 0) //If card requires pin authentication (ie seclevel 1 or 2)
		var/attempt_pin = input("Enter pin code", "Vendor transaction") as num
		customer_account = SSeconomy.attempt_account_access(I.associated_account_number, attempt_pin, 2)

		if(!customer_account)
			src.status_message = "Unable to access account: incorrect credentials."
			src.status_error = 1
			return 0

	if(currently_vending.price > customer_account.money)
		src.status_message = "Insufficient funds in account."
		src.status_error = 1
		return 0
	else
		// Okay to move the money at this point

		// debit money from the purchaser's account
		customer_account.money -= currently_vending.price

		// create entry in the purchaser's account log
		var/datum/transaction/T = new()
		T.target_name = "[vendor_account.owner_name] (via [src.name])"
		T.purpose = "Purchase of [currently_vending.product_name]"
		if(currently_vending.price > 0)
			T.amount = "([currently_vending.price])"
		else
			T.amount = "[currently_vending.price]"
		T.source_terminal = src.name
		T.date = worlddate2text()
		T.time = worldtime2text()
		SSeconomy.add_transaction_log(customer_account,T)

		// Give the vendor the money. We use the account owner name, which means
		// that purchases made with stolen/borrowed card will look like the card
		// owner made them
		credit_purchase(customer_account.owner_name)
		return 1

/**
 *  Add money for current purchase to the vendor account.
 *
 *  Called after the money has already been taken from the customer.
 */
/obj/machinery/vending/proc/credit_purchase(var/target as text)
	var/datum/money_account/vendor_account = SSeconomy.get_department_account("Vendor")
	vendor_account.money += currently_vending.price

	var/datum/transaction/T = new()
	T.target_name = target
	T.purpose = "Purchase of [currently_vending.product_name]"
	T.amount = "[currently_vending.price]"
	T.source_terminal = src.name
	T.date = worlddate2text()
	T.time = worldtime2text()
	SSeconomy.add_transaction_log(vendor_account,T)

/obj/machinery/vending/attack_ai(mob/user as mob)
	if(!ai_can_interact(user))
		return
	return attack_hand(user)

/obj/machinery/vending/attack_hand(mob/user as mob)
	if(stat & (BROKEN|NOPOWER))
		return

	if(src.seconds_electrified != 0)
		if(src.shock(user, 100))
			return

	if (panel_open)
		wires.interact(user)
	else
		ui_interact(user)

/obj/machinery/vending/ui_interact(mob/user, var/datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Vending", capitalize_first_letters(name))
		ui.open()

/obj/machinery/vending/ui_assets(mob/user)
	return list(
		get_asset_datum(/datum/asset/spritesheet/vending)
	)

/obj/machinery/vending/ui_data(mob/user)
	var/list/data = list()
	data["manufacturer"] = manufacturer
	data["products"] = list()
	data["ui_size"] = ui_size

	if(currently_vending || !vend_ready)
		data["vending_item"] = TRUE
		data["sel_key"] = sel_key
		data["sel_name"] = capitalize_first_letters(strip_improper(currently_vending.product_name))
		data["sel_price"] = currently_vending.price
		data["sel_icon"] = v_asset.icon_tag(ckey("[currently_vending.product_path]"), FALSE)
		data["message"] = status_message
		data["message_err"] = status_error
	else
		data["vending_item"] = FALSE
		data["sel_key"] = 0
		data["sel_name"] = 0
		data["sel_price"] = 0
		data["sel_icon"] = 0
		data["message"] = ""
		data["message_err"] = 0

	if(!(LAZYLEN(data["products"])) || LAZYLEN(data["products"]) != LAZYLEN(product_records))
		data["products"] = list()
		for(var/key = 1 to LAZYLEN(product_records))
			var/t_key = num2text(key)
			var/datum/data/vending_product/I = product_records[key]

			if(!(I.category & categories))
				continue

			var/product_name = capitalize_first_letters(strip_improper(I.product_name))
			var/icon_tag = v_asset.icon_tag(ckey("[I.product_path]"), FALSE)

			var/list/product = list()

			product["key"] = t_key
			product["name"] = product_name
			product["price"] = I.price
			product["amount"] = I.amount
			product["icon_tag"] = icon_tag
			data["products"] += list(product)

	else if(sel_key && product_records[text2num(sel_key)])
		var/datum/data/vending_product/V = product_records[text2num(sel_key)]
		data["products"] = list("sel_key" = sel_key, "amount" = V.amount)

	if(coin)
		data["coin"] = coin.name
	else
		data["coin"] = null

	if(src.panel_open)
		data["panel"] = TRUE
		data["speaker"] = shut_up ? FALSE : TRUE
	else
		data["panel"] = FALSE

	return data

/obj/machinery/vending/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	var/datum/money_account/vendor_account = SSeconomy.get_department_account("Vendor")

	if(action == "remove_coin" && !issilicon(usr))
		if(!coin)
			to_chat(usr, SPAN_WARNING("There is no coin in this machine."))
			return

		usr.put_in_hands(coin)
		to_chat(usr, SPAN_NOTICE("You remove the [coin] from the [src]."))
		coin = null
		categories &= ~CAT_COIN
		. = TRUE

	if (usr.contents.Find(src) || (in_range(src, usr) && isturf(loc)))
		if (action == "vendItem" && vend_ready && !currently_vending)
			if((!allowed(usr)) && !emagged && scan_id)	//For SECURE VENDING MACHINES YEAH
				to_chat(usr, SPAN_WARNING("Access denied."))	//Unless emagged of course
				if(exclusive_screen)
					cut_overlays()
					addtimer(CALLBACK(src, PROC_REF(add_screen_overlay)), deny_time ? deny_time : 15)
				add_screen_overlay(deny = TRUE)
				addtimer(CALLBACK(src, TYPE_PROC_REF(/atom, cut_overlay), screen_overlays["[icon_state]-deny"]), deny_time ? deny_time : 15)
				set_light(initial(light_range), initial(light_power), COLOR_RED_LIGHT)
				addtimer(CALLBACK(src, PROC_REF(reset_light)), deny_time ? deny_time : 15)
				addtimer(CALLBACK(src, PROC_REF(add_screen_overlay)), deny_time ? deny_time : 15)
				return

			var/key = text2num(params["vendItem"])
			sel_key = params["vendItem"]
			var/datum/data/vending_product/R = product_records[key]

			// This should not happen unless the request from NanoUI was bad
			if(!(R.category & categories))
				return

			if(R.price <= 0)
				currently_vending = R
				vend(R, usr)
				. = TRUE
			else if(issilicon(usr)) //If the item is not free, provide feedback if a synth is trying to buy something.
				to_chat(usr, SPAN_WARNING("Artificial unit recognized.  Artificial units cannot complete this transaction. Purchase canceled."))
				return
			else
				currently_vending = R
				if(!vendor_account || vendor_account.suspended)
					status_message = "This machine is currently unable to process payments due to problems with the associated account."
					status_error = 1
					. = TRUE
				else
					status_message = "Please swipe a card or insert cash to pay for the item."
					status_error = 0
					. = TRUE

		else if (action == "cancelpurchase")
			currently_vending = null
			. = TRUE

		else if (action == "reset")
			// reset button that nobody should ever (hopefully) see
			currently_vending = null
			vend_ready = 1
			. = TRUE

		else if ((action == "togglevoice") && panel_open)
			shut_up = !shut_up

		add_fingerprint(usr)

/obj/machinery/vending/proc/vend(datum/data/vending_product/R, mob/user)

	if (!R || R.amount < 1)
		return

	if((!allowed(usr)) && !emagged && scan_id)	//For SECURE VENDING MACHINES YEAH
		to_chat(usr, "<span class='warning'>Access denied.</span>")	//Unless emagged of course)
		if(exclusive_screen)
			cut_overlays()
			addtimer(CALLBACK(src, PROC_REF(add_screen_overlay)), deny_time ? deny_time : 15)
		add_screen_overlay(deny = TRUE)
		addtimer(CALLBACK(src, TYPE_PROC_REF(/atom, cut_overlay), screen_overlays["[icon_state]-deny"]), deny_time ? deny_time : 15)
		set_light(initial(light_range), initial(light_power), COLOR_RED_LIGHT)
		addtimer(CALLBACK(src, PROC_REF(reset_light)), deny_time ? deny_time : 15)
		return
	src.vend_ready = 0 //One thing at a time!!
	src.status_message = "Vending..."
	src.status_error = 0

	if (R.category & CAT_COIN)
		if(!coin)
			to_chat(user, SPAN_NOTICE("You need a coin to vend this item."))
			return

		if(coin.string_attached)
			if(prob(50))
				to_chat(user, SPAN_NOTICE("You successfully pull the coin out before \the [src] could swallow it!"))
			else
				to_chat(user, SPAN_WARNING("You weren't able to pull the coin out fast enough, and the machine ate it!"))
				QDEL_NULL(coin)
		else
			QDEL_NULL(coin)

		visible_message(SPAN_NOTICE("\The [src] putters to life, coughing out its 'premium' item after a moment."))
		playsound(loc, 'sound/items/poster_being_created.ogg', 50, 1)

		R.amount--
		SStgui.update_uis(src)

		if(!coin)
			categories &= ~CAT_COIN

	else
		R.amount--
		SStgui.update_uis(src)

	if(((src.last_reply + (src.vend_delay + 200)) <= world.time) && src.vend_reply)
		spawn(0)
			src.speak(src.vend_reply)
			src.last_reply = world.time

	use_power_oneoff(vend_power_usage)	//actuators and stuff
	if (src.icon_vend) //Show the vending animation if needed
		flick(src.icon_vend,src)
	playsound(src.loc, vending_sound, 100, 1)
	intent_message(MACHINE_SOUND)
	addtimer(CALLBACK(src, PROC_REF(vend_product), R, user), vend_delay)

/obj/machinery/vending/proc/vend_product(var/datum/data/vending_product/R, mob/user)

	var/vending_usr_dir = get_dir(src, user)
	var/obj/vended = new R.product_path(get_step(src, vending_usr_dir))
	vended_product_post(vended)
	if(Adjacent(user))
		user.put_in_hands(vended)
	src.status_message = ""
	src.status_error = 0
	src.vend_ready = 1
	currently_vending = null
	SStgui.update_uis(src)
	if(istype(vended,/obj/item/reagent_containers/))
		var/obj/item/reagent_containers/RC = vended
		if(RC.reagents)
			switch(temperature_setting)
				if(-1)
					use_power_oneoff(RC.reagents.set_temperature(cooling_temperature))
				if(1)
					use_power_oneoff(RC.reagents.set_temperature(heating_temperature))

/// To be overriden if vended out products need any post-processing, setting its vars.
/// Called by `vend_product`.
/// `vended` is the item that is being vended out.
/obj/machinery/vending/proc/vended_product_post(var/obj/vended)
	return

/obj/machinery/vending/proc/stock(var/datum/data/vending_product/R, var/mob/user)

	to_chat(user, "<span class='notice'>You insert \the [R.product_name] in the product receptor.</span>")
	R.amount++

	SStgui.update_uis(src)

/obj/machinery/vending/process()
	if(stat & (BROKEN|NOPOWER))
		return

	if(!src.active)
		return

	if(src.seconds_electrified > 0)
		src.seconds_electrified--

	//Pitch to the people!  Really sell it!
	if(((src.last_slogan + src.slogan_delay) <= world.time) && (src.slogan_list.len > 0) && (!src.shut_up) && prob(5))
		var/slogan = pick(src.slogan_list)
		src.speak(slogan)
		src.last_slogan = world.time

	if(src.shoot_inventory && prob(shoot_inventory_chance))
		src.throw_item()

	return

/obj/machinery/vending/proc/speak(var/message)
	if(stat & NOPOWER)
		return

	if (!message)
		return

	for(var/mob/O in hearers(src, null))
		O.show_message("<span class='game say'><span class='name'>\The [src]</span> beeps, \"[message]\"</span>",2)
	return

/obj/machinery/vending/power_change()
	..()
	if(!anchored)
		stat |= NOPOWER
	if(stat & BROKEN)
		icon_state = "[initial(icon_state)]-broken"
		cut_overlays()
		set_light(0)
	else if(!(stat & NOPOWER))
		icon_state = initial(icon_state)
		add_screen_overlay()
	else
		icon_state = "[initial(icon_state)]-off"
		cut_overlays()
		set_light(0)

//Oh no we're malfunctioning!  Dump out some product and break.
/obj/machinery/vending/proc/malfunction()
	for(var/datum/data/vending_product/R in src.product_records)
		if (R.amount <= 0) //Try to use a record that actually has something to dump.
			continue
		var/dump_path = R.product_path
		if (!dump_path)
			continue

		while(R.amount>0)
			new dump_path(get_random_turf_in_range(src, 1, 1, TRUE))
			R.amount--
			SStgui.update_uis(src)
		break

	stat |= BROKEN
	src.icon_state = "[initial(icon_state)]-broken"
	return

//Somebody cut an important wire and now we're following a new definition of "pitch."
/obj/machinery/vending/proc/throw_item()
	var/obj/item/throw_item = null
	var/mob/living/target = locate() in view(7,src)
	if(!target)
		return 0

	for(var/datum/data/vending_product/R in shuffle(product_records))
		if (R.amount <= 0) //Try to use a record that actually has something to dump.
			continue
		var/dump_path = R.product_path
		if (!dump_path)
			continue

		R.amount--
		SStgui.update_uis(src)
		throw_item = new dump_path(src.loc)
		break
	if(!throw_item)
		return FALSE
	intent_message(MACHINE_SOUND)
	throw_item.vendor_action(src)
	INVOKE_ASYNC(throw_item, TYPE_PROC_REF(/atom/movable, throw_at), target, rand(3, 10), rand(1, 3), src)
	src.visible_message("<span class='warning'>[src] launches [throw_item.name] at [target.name]!</span>")
	return 1

// screens go over the lighting layer, so googly eyes go under them
/obj/machinery/vending/can_attach_sticker(var/mob/user, var/obj/item/sticker/S)
	to_chat(user, SPAN_WARNING("\The [src]'s non-stick surface prevents you from attaching a sticker to it!"))
	return FALSE
