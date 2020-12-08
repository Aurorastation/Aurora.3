/obj/machinery/vending
	name = "Vendomat"
	desc = "A generic vending machine."
	icon = 'icons/obj/vending.dmi'
	icon_state = "generic"
	layer = LAYER_STRUCTURE
	anchored = TRUE
	density = TRUE
	clicksound = /decl/sound_category/button_sound

	var/icon_vend //Icon_state when vending
	var/screen_overlay // Idle overlay
	var/deny_overlay // Denied overlay
	var/deny_time // How long the physical icon state lasts, used cut the deny overlay

	idle_power_usage = 10
	active_power_usage = 150

	// Vending-related
	var/vend_ready = TRUE
	var/vend_delay = 1 SECOND

	var/categories = CAT_NORMAL // Bitmask of cats we're currently showing
	var/datum/data/vending_product/currently_vending = null // What we're requesting payment for right now
	var/status_message = "" // Status screen messages like "insufficient funds", displayed in NanoUI
	var/status_error = FALSE // Set to 1 if status_message is an error

	/*
		Variables used to initialize the product list
		These are used for initialization only, and so are optional if
		product_records is specified
	*/
	var/list/products = list(
		CAT_NORMAL = list(),
		CAT_COIN = list(),
		CAT_HIDDEN = list()
	)
	var/list/prices = list() // Prices for each item, list(/type/path = price), items not in the list don't have a price.

	// List of vending_product items available. Datum: Amount
	var/list/product_records = list()

	// Variables used to initialize advertising
	var/product_slogans = "" // JSON of slogans
	var/product_ads = "" // JSON of ads

	// Stuff relating vocalizations
	var/advertising = FALSE
	var/vend_reply = "Have a NanoTrasen day!"
	var/last_reply = 0
	var/slogan_delay = 10 MINUTES

	// Things that can go wrong
	var/electrified = FALSE
	var/shoot_inventory = 0 //Fire items at customers! We're broken!

	// Access
	var/secure = TRUE
	var/obj/item/coin/coin
	var/datum/wires/vending/wires = null

	var/movable = TRUE	//if you can wrench the machine out of place
	var/refill_type = /obj/item/vending_refill
	var/restock_items = FALSE //If items can be restocked into the vending machine
	var/list/restock_blacklist = list() //Items that can not be restocked if restock_items is enabled
	var/randomize_qty = TRUE //If the number of items should be randomized
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
	light_power = 1

/obj/machinery/vending/Initialize(mapload)
	. = ..()
	wires = new(src)

	var/list/states = icon_states(icon)
	if("[icon_state]-screen" in states)
		screen_overlay = make_screen_overlay(icon, "[icon_state]-screen")
	if("[icon_state]-deny" in states)
		deny_overlay = make_screen_overlay(icon, "[icon_state]-deny")

	update_icon()
	build_inventory()
	power_change()

	return INITIALIZE_HINT_LATELOAD

/obj/machinery/vending/LateInitialize()
	v_asset = get_asset_datum(/datum/asset/spritesheet/vending)

/obj/machinery/vending/update_icon(var/deny = FALSE)
	if(deny)
		add_overlay(deny_overlay)
	else if(panel_open)
		add_overlay("[initial(icon_state)]-panel")
	else
		add_overlay(screen_overlay)
	reset_light()

/obj/machinery/vending/proc/reset_light()
	set_light(initial(light_range), initial(light_power), initial(light_color))

/obj/machinery/vending/proc/build_inventory()
	for(var/cat in products)
		var/list/current_category = products[cat]
		for(var/P in current_category)
			var/prod_price = prices[P] || 0
			var/datum/data/vending_product/product = SSmachinery.get_vend_datum(P, products[P], prod_price, cat)
			if(cat & CAT_NORMAL && randomize_qty)
				product_records[product] = rand(1, product.stock_amount)
			else
				product_records[product] = product.stock_amount

/obj/machinery/vending/Destroy()
	QDEL_NULL(wires)
	QDEL_NULL(coin)
	return ..()

/obj/machinery/vending/ex_act(severity)
	switch(severity)
		if(1)
			qdel(src)
		if(2)
			if(prob(50))
				qdel(src)
		if(3)
			if(prob(25))
				INVOKE_ASYNC(src, .proc/malfunction)

/obj/machinery/vending/emag_act(var/remaining_charges, var/mob/user)
	if(!emagged)
		emagged = TRUE
		to_chat(user, SPAN_NOTICE("You short out the ID scanner on \the [src]!"))
		return TRUE

/obj/machinery/vending/proc/get_stock(var/datum/data/vending_product/VP)
	return product_records[VP]

/obj/machinery/vending/proc/get_price(var/datum/data/vending_product/VP)
	return prices[VP.product_path] || 0

/obj/machinery/vending/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/device/debugger))
		if(advertising != initial(advertising))
			to_chat(user, SPAN_WARNING("[icon2html(W, user)][W]: \"Software error detected. Rectifying.\""))
			if(do_after(user, 10 SECONDS / W.toolspeed, act_target = src))
				to_chat(user, SPAN_NOTICE("[icon2html(W, user)][W]: \"Solution found. Fix applied.\""))
				advertising != initial(advertising)
		else
			to_chat(user, SPAN_NOTICE("[icon2html(W, user)][W]: \"No issues detected. Have a NanoTrasen day!\""))

	var/obj/item/card/id/I = W.GetID()
	var/datum/money_account/vendor_account = SSeconomy.get_department_account("Vendor")

	if(currently_vending && length(prices) && (istype(I) || istype(W, /obj/item/spacecash)))
		if(!istype(vendor_account) || vendor_account.suspended)
			visible_message(SPAN_WARNING("[icon2html(src, viewers(get_turf(src)))]: \"Payment account could not be reached. Contact customer support.\""))

		if(get_stock(currently_vending) < 1)
			visible_message(SPAN_WARNING("[icon2html(src, viewers(get_turf(src)))]: \"Out of stock.\""))
			status_error = TRUE
			playsound(loc, 'sound/machines/buzz-two.ogg', 35, 1)
			currently_vending = null
			return

		if(pay(W, user))
			vend(currently_vending, user)
		SSvueui.check_uis_for_change(src)
		return

	if(default_deconstruction_screwdriver(user, W))
		return

	if((W.ismultitool() || W.iswirecutter()) && panel_open)
		attack_hand(user)
		return

	if(istype(W, /obj/item/coin))
		if(!length(products[CAT_COIN]))
			to_chat(user, SPAN_WARNING("It doesn't seem like there's a coin slot on this vending machine..."))
			return

		user.drop_from_inventory(W, src)
		coin = W
		categories |= CAT_COIN
		to_chat(user, SPAN_NOTICE("You insert \the [W] into \the [src]."))
		SSvueui.check_uis_for_change(src)
		return

	if(W.iswrench() && movable)
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		playsound(loc, W.usesound, 100, 1)
		user.visible_message("[SPAN_BOLD(user)] begins [anchored ? "un" : ""]securing \the [src] from the [density ? "floor" : "wall"].",\
								SPAN_NOTICE("You start [anchored ? "un" : ""]securing \the [src] from the [density ? "floor" : "wall"]."))

		if(!do_after(user, 20/W.toolspeed) || !src)
			return

		user.visible_message("[SPAN_BOLD(user)] [anchored ? "un" : ""]secures \the [src] from the [density ? "floor" : "wall"].",\
								SPAN_NOTICE("You start [anchored ? "un" : ""]secures \the [src] from the [density ? "floor" : "wall"]."))
		anchored = !anchored
		power_change()
		return

	if(istype(W, /obj/item/vending_refill))
		if(!panel_open)
			to_chat(user, SPAN_WARNING("You must open \the [src]'s maintenance panel first!'"))
			return

		var/obj/item/vending_refill/VR = W
		if(!VR.charges)
			to_chat(user, SPAN_WARNING("\The [VR] is depleted!"))
			return
		if(!istype(VR, refill_type))
			to_chat(user, SPAN_WARNING("\The [VR] isn't compatible with this type of vendor!"))
			return

		VR.restock_inventory(src)
		SSvueui.check_uis_for_change(src)
		return

	..()

/obj/machinery/vending/MouseDrop_T(obj/item/I, mob/user)
	if(!istype(I))
		return

	if(!restock_items)
		to_chat(user, SPAN_WARNING("\The [src] cannot be restocked manually!"))
		return

	if(is_type_in_list(I.type, restock_blacklist))
		to_chat(user, SPAN_WARNING("\The [src] does not accept manual restocks for [src]."))
		return

	stock(I, user)
	return

/obj/machinery/vending/proc/pay(var/obj/item/P, mob/user)
	if(!is_type_in_list(P, list(/obj/item/card/id, /obj/item/spacecash)))
		return

	var/obj/item/card/id/I = P.GetID()
	var/datum/money_account/vendor_account = SSeconomy.get_department_account("Vendor")

	if(istype(I))
		// Paying via ID.
		visible_message(SPAN_INFO("\The [user] swipes \the [I] through \the [src]."))
		playsound(loc, 'sound/machines/id_swipe.ogg', 50, 1)

		if(istype(I, /obj/item/card/id/bst))
			return TRUE

		var/datum/money_account/customer_account = SSeconomy.get_account(I.associated_account_number)

		if(!customer_account)
			status_message = "Error: Unable to access account. Please contact technical support if problem persists."
			status_error = TRUE
			return FALSE

		if(customer_account.suspended)
			status_message = "Error: Account suspended. Please contact your payment services provider for more information."
			status_error = TRUE
			return FALSE

		if(customer_account.security_level > 0)
			var/attempt_pin = input(user, "Enter PIN", "Vendor Transaction") as num
			customer_account = SSeconomy.attempt_account_access(I.associated_account_number, attempt_pin, 2)

			if(!customer_account)
				status_message = "Error: Incorrect credentials."
				status_error = TRUE
				return FALSE

		if(currently_vending.product_price > customer_account.money)
			status_message = "Error: Insufficient funds."
			status_error = TRUE
			return FALSE

		customer_account.money -= currently_vending.product_price

		SSeconomy.charge_to_account(I.associated_account_number, "[vendor_account.owner_name] (via [name])", "Purchase of [currently_vending.product_name]", name, currently_vending.product_price)
		SSeconomy.charge_to_account(vendor_account.account_number, "[customer_account.owner_name]", "Purchase of [currently_vending.product_name]", name, -currently_vending.product_price)

	else
		// Paying via cash or charge card.
		var/obj/item/spacecash/C = P
		if(istype(C, /obj/item/spacecash/ewallet))
			// Charge card
			var/obj/item/spacecash/ewallet/W = C
			visible_message(SPAN_INFO("\The [user] swipes \the [W] through \the [src]."))
			playsound(loc, 'sound/machines/id_swipe.ogg', 50, 1)
			if(currently_vending.product_price > W.worth)
				status_message = "Error: Insufficient funds."
				status_error = TRUE
				return FALSE
			else
				W.worth -= currently_vending.product_price
				SSeconomy.charge_to_account(vendor_account.account_number, "[W.owner_name] (chargecard)", "Purchase of [currently_vending.product_name]", name, -currently_vending.product_price)
				return TRUE

		else
			// Cold, hard cash.
			if(currently_vending.product_price > C.worth)
				to_chat(user, SPAN_WARNING("[icon2html(C, user)] That's not enough money."))
				return FALSE

			if(istype(C, /obj/item/spacecash/bundle))
				visible_message(SPAN_INFO("\The [user] inserts some cash into \the [src]."))
				C.worth -= currently_vending.product_price

				if(C.worth <= 0)
					user.drop_from_inventory(C, get_turf(src))
					qdel(C)
				else
					C.update_icon()
			else
				// Bills require weird chicanery because they're static bills.
				// Enjoy the 2000s-era shitcode.
				visible_message(SPAN_INFO("\The [user] inserts a bill into \the [src]."))
				var/remaining = C.worth - currently_vending.product_price
				user.drop_from_inventory(C, get_turf(src))
				qdel(C)

				if(remaining)
					spawn_money(remaining, get_turf(user), user)

			SSeconomy.charge_to_account(vendor_account.account_number, "Cash", "Purchase of [currently_vending.product_name]", name, -currently_vending.product_price)
			return TRUE

/obj/machinery/vending/attack_ai(mob/user)
	if(!ai_can_interact(user))
		return
	attack_hand(user)

/obj/machinery/vending/attack_hand(mob/user)
	if(stat & (BROKEN|NOPOWER))
		return

	if(electrified)
		shock(user, 100)
		return

	if(panel_open)
		wires.Interact(user)
	else
		ui_interact(user)

// VueUI implementation of vending machines.
/obj/machinery/vending/ui_interact(mob/user, var/datum/topic_state/state = default_state)
	user.set_machine(src)

	var/datum/vueui/ui = SSvueui.get_open_ui(user, src)
	if(!ui)
		ui = new(user, src, "machinery-vending", 425, 500, capitalize(name), state=state)

	ui.open(v_asset)

/obj/machinery/vending/vueui_data_change(list/data, mob/user, datum/vueui/ui)
	LAZYINITLIST(data)
	LAZYINITLIST(data["products"])

	VUEUI_SET_CHECK_IFNOTSET(data["ui_size"], ui_size, ., data)

	if(currently_vending || !vend_ready)
		data["mode"] = 1
		data["sel_key"] = sel_key
		data["sel_name"] = capitalize_first_letters(strip_improper(currently_vending.product_name))
		data["sel_price"] = get_price(currently_vending)
		data["sel_icon"] = v_asset.icon_tag(ckey("[currently_vending.product_path]"), FALSE)
		data["message"] = status_message
		data["message_err"] = status_error
	else
		data["mode"] = 0
		data["sel_key"] = 0
		data["sel_name"] = 0
		data["sel_price"] = 0
		data["sel_icon"] = 0
		data["message"] = ""
		data["message_err"] = 0

	if(!(LAZYLEN(data["products"])) || LAZYLEN(data["products"]) != LAZYLEN(product_records))
		data["products"] = list()
		for(var/datum/data/vending_product/I in product_records)
			if(!(I.category & categories))
				continue

			var/i_ref = "\ref[I]"
			var/product_name = capitalize_first_letters(strip_improper(I.product_name))
			var/icon_tag = v_asset.icon_tag(ckey("[I.product_path]"), FALSE)

			LAZYINITLIST(data["products"][i_ref])
			VUEUI_SET_CHECK(data["products"][i_ref]["ref"], "\ref[I]", ., data)
			VUEUI_SET_CHECK(data["products"][i_ref]["name"], product_name, ., data)
			VUEUI_SET_CHECK(data["products"][i_ref]["price"], get_price(I), ., data)
			VUEUI_SET_CHECK(data["products"][i_ref]["amount"], get_stock(I), ., data)
			VUEUI_SET_CHECK(data["products"][i_ref]["icon_tag"], icon_tag, ., data)

	else if(sel_key)
		var/datum/data/vending_product/V = locate(sel_key) in product_records
		if(istype(V))
			VUEUI_SET_CHECK(data["products"][sel_key]["amount"], get_stock(V), ., data)

	if(coin)
		data["coin"] = coin.name
	else
		data["coin"] = null

	if(panel_open)
		data["panel"] = 1
		data["speaker"] = advertising ? 1 : 0
	else
		data["panel"] = 0

	return data

/obj/machinery/vending/proc/vend_access(mob/user)
	if(!secure || emagged || allowed(user))
		return TRUE
	to_chat(user, SPAN_WARNING("Access denied."))
	if(exclusive_screen)
		cut_overlays()
	update_icon(TRUE)
	set_light(initial(light_range), initial(light_power), COLOR_RED_LIGHT)
	addtimer(CALLBACK(src, /atom/.proc/update_icon), deny_time ? deny_time : 15)

/obj/machinery/vending/Topic(href, href_list)
	if(stat & BROKEN|NOPOWER)
		return
	if(..())
		return

	var/datum/money_account/vendor_account = SSeconomy.get_department_account("Vendor")

	if(use_check_and_message(usr))
		return

	if(href_list["vendItem"])
		if(!vend_ready || currently_vending)
			return

		if(!vend_access(usr))
			return

		sel_key = href_list["vendItem"]
		var/datum/data/vending_product/P = locate(sel_key) in product_records

		if(!istype(P) || !(P.category & categories))
			return

		if(P.product_price <= 0)
			currently_vending = P
			vend(P, usr)
		else if(issilicon(usr))
			to_chat(usr, SPAN_DANGER("Stationbound unit detected. Stationbounds may not complete this transaction. Please alert an available supervisor."))
			return
		else
			currently_vending = P
			if(!vendor_account || vendor_account.suspended)
				status_message = "This machine is currently unable to process transactions due to problems with the associated account."
				status_error = TRUE
			else
				status_message = "Please swipe a card or insert cash to pay for the requested item."
				status_error = FALSE

	else if(href_list["cancelpurchase"] || href_list["reset"])
		currently_vending = null
		vend_ready = TRUE

	else if(href_list["togglevoice"] && panel_open)
		advertising = !advertising

	add_fingerprint(usr)
	SSvueui.check_uis_for_change(src)

/obj/machinery/vending/proc/vend(datum/data/vending_product/P, mob/user)
	if(!P || get_stock(P) < 1 || !vend_access(user))
		return

	vend_ready = FALSE
	status_message = "Vending..."
	status_error = FALSE

	if(P.category & CAT_COIN)
		if(!coin)
			to_chat(user, SPAN_NOTICE("You need a coin to vend this item."))
			return

		if(coin.string_attached)
			if(prob(50))
				to_chat(user, SPAN_NOTICE("You successfully manage to pull the coin out before \the [src] could swallow it!"))
			else
				to_chat(user, SPAN_WARNING("You weren't fast enough to pull the coin out before \the [src] swallowed it!"))
				QDEL_NULL(coin)
		else
			QDEL_NULL(coin)

		if(!coin)
			categories &= ~CAT_COIN

		visible_message(SPAN_NOTICE("\The [src] putters to life, coughing out the 'premium' item after a moment."))
		playsound(loc, 'sound/items/poster_being_created.ogg', 50, 1)

	product_records[P]--
	SSvueui.check_uis_for_change(src)

	if(vend_reply && (last_reply + (vend_delay + 200)) <= world.time)
		last_reply = world.time
		INVOKE_ASYNC(src, .proc/state, vend_reply)

	use_power(active_power_usage)
	if(icon_vend)
		flick(icon_vend, src)
	playsound(loc, vending_sound, 100, 1)
	addtimer(CALLBACK(src, .proc/vend_product, P, user), vend_delay)

/obj/machinery/vending/proc/vend_product(var/datum/data/vending_product/P, mob/user)
	var/obj/vended = new P.product_path
	if(Adjacent(user))
		user.put_in_hands(vended)
	else
		vended.forceMove(get_step(src, get_dir(src, user)))

	status_message = ""
	status_error = FALSE
	vend_ready = TRUE
	currently_vending = null

	SSvueui.check_uis_for_change(src)

	if(istype(vended, /obj/item/reagent_containers))
		var/obj/item/reagent_containers/RC = vended
		if(RC.reagents)
		switch(temperature_setting)
			if(-1)
				use_power(RC.reagents.set_temperature(cooling_temperature))
			if(1)
				use_power(RC.reagents.set_temperature(heating_temperature))

/obj/machinery/vending/proc/stock(var/obj/item/I, mob/user)
	if(!istype(I))
		return

	for(var/datum/data/vending_product/P in product_records)
		if(P.product_path == I.type)
			to_chat(user, SPAN_NOTICE("You insert \the [I] into the product receptor."))
			product_records[P]++
			qdel(I)
			break

	if(I)
		to_chat(user, SPAN_WARNING("\The [src]'s product receptor rejects \the [I]."))

	SSvueui.check_uis_for_change(src)

/obj/machinery/vending/power_change()
	..()
	if(!anchored)
		stat |= NOPOWER
	if(!(stat & NOPOWER))
		icon_state = initial(icon_state)
		update_icon()
		return
	if(stat & BROKEN)
		icon_state = "[initial(icon_state)]-broken"
	else
		icon_state = "[initial(icon_state)]-off"
	cut_overlays()
	set_light(0)

/obj/machinery/vending/proc/malfunction()
	for(var/datum/data/vending_product/P in product_records)
		if(product_records[P] <= 0 || P.product_path)
			return

		while(product_records[P] > 0)
			new P.product_path(get_random_turf_in_range(src, 1, 1, TRUE))
			product_records[P]--
			SSvueui.check_uis_for_change(src)
		break

	stat |= BROKEN
	power_change()
