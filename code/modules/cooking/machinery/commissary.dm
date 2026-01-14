/obj/machinery/smartfridge/tradeshelf
	name = "cigarette shelf"
	desc = "A commercialized shelf for cigarettes and associated items."
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
	display_tiers = 5
	display_tier_amt = 3

/obj/machinery/smartfridge/tradeshelf/clothing
	name = "clothing shelf"
	desc = "A commercialized shelf for clothing and associated items."
	icon_state = "trade_clothes"
	contents_path = "-clothing"
	accepted_items = list(/obj/item/storage/backpack,
	/obj/item/storage/belt,
	/obj/item/clothing
	)
	display_tiers = 3
	display_tier_amt = 5

/obj/machinery/smartfridge/tradeshelf/food
	name = "food and drinks shelf"
	desc = "A commercialized shelf for food and drinks."
	icon_state = "trade_food"
	contents_path = "-edible"
	use_power = POWER_USE_IDLE
	idle_power_usage = 5
	active_power_usage = 100
	cooling = TRUE
	accepted_items = list(/obj/item/reagent_containers/food,
	/obj/item/storage/box/fancy/cookiesnack,
	/obj/item/storage/box/pineapple,
	/obj/item/storage/box/fancy/gum,
	/obj/item/storage/box/fancy/vkrexitaffy,
	/obj/item/clothing/mask/chewable/candy/lolli,
	/obj/item/storage/box/fancy/admints,
	/obj/item/storage/box/fancy/quick_microwave_pizza,
	/obj/item/reagent_containers/food/snacks/packaged_microwave_mac_and_cheeze,
	/obj/item/reagent_containers/food/snacks/packaged_microwave_fiery_mac_and_cheeze,
	/obj/item/storage/box/fancy/packaged_burger,
	/obj/item/storage/box/fancy/toptarts_strawberry,
	/obj/item/storage/box/fancy/toptarts_chocolate_peanutbutter,
	/obj/item/storage/box/fancy/toptarts_blueberry,
	/obj/item/storage/box/unique/donkpockets
	)
	display_tiers = 4
	display_tier_amt = 5

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
	/obj/item/melee/dinograbber,
	/obj/item/device/laser_pointer,
	/obj/item/deck,
	/obj/item/storage/pill_bottle/dice,
	/obj/item/pen,
	/obj/item/storage/stickersheet,
	/obj/item/gun/projectile/revolver/capgun,
	/obj/item/gun/bang,
	/obj/item/eightball,
	/obj/item/bikehorn
	)
	display_tiers = 4
	display_tier_amt = 5

/obj/machinery/smartfridge/tradeshelf/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/commissary_restrock))
		var/obj/item/commissary_restrock/P = attacking_item
		var/item_loaded = 0
		for(var/obj/G in P.contents)
			if(accept_check(G))
				if(length(contents) >= max_n_of_items)
					break
				P.remove_from_storage(G,src)
				item_quants[G.name]++
				item_loaded++
		if(item_loaded)
			user.visible_message("<b>[user]</b> loads [src] with [P].", SPAN_NOTICE("You load [src] with [P]."))
			if(length(P.contents) > 0)
				to_chat(user, SPAN_NOTICE("Some items are refused."))
			update_overlays()
		return TRUE
	. = ..()

// -------------------------------------------------
/obj/structure/cash_register/commissary
	var/machine_id = ""
	var/list/items = list()
	var/list/items_to_price = list()
	var/list/buying = list()
	var/new_item = ""
	var/new_price = 0
	var/sum = 0
	var/editmode = FALSE
	var/receipt = ""
	var/destinationact = "Operations"
	var/credit = 100
	storage_type = null

/obj/structure/cash_register/commissary/mechanics_hints(mob/user, distance, is_adjacent)
	. = list()
	. += "Alt click with a command id in hand, to gain command access."
	. += "Alt click with credits in hand, to deposit them."
	. += "Alt click while having operations access, to withdraw credits from it."
	. += "Items can be paid for with id cards, charge cards or physical credits, and a receipt will be printed."

/obj/structure/cash_register/commissary/Initialize()
	. = ..()
	machine_id = "[station_name()] Idris Quik-Pay Register #[SSeconomy.num_financial_terminals++]"

/obj/structure/cash_register/commissary/AltClick(var/mob/user)
	var/item = user.get_active_hand()
	var/obj/item/card/id/I = item
	if(istype(I) && (ACCESS_HEADS in I.access))
		if(ACCESS_HEADS in I.access)
			editmode = TRUE
			to_chat(user, SPAN_NOTICE("Command access granted."))
			SStgui.update_uis(src)
		return
	if(istype(item, /obj/item/spacecash) && !istype(item, /obj/item/spacecash/ewallet))
		var/obj/item/spacecash/cashmoney = item
		credit += cashmoney.worth
		user.drop_from_inventory(cashmoney,get_turf(src))
		visible_message("\The [user] inserts some credits into \the [src]." )
		qdel(cashmoney)
		return
	I = user.GetIdCard()
	if(istype(I) && (ACCESS_CARGO in I.access))
		var/price_guess = text2num(sanitizeSafe( tgui_input_text(user, "How much do you wish to withdraw? Remaining cash: [credit]", "QuikPay", 0, 10), 10))
		if(isnull(price_guess) || price_guess == 0)
			return
		price_guess = max(0, round(price_guess, 0.01))
		if(credit >= price_guess)
			spawn_money(price_guess, loc, user)
			credit -= price_guess
		visible_message("\The [user] remove some credits from \the [src]." )
		return

/obj/structure/cash_register/commissary/proc/print_receipt()
	var/obj/item/paper/R = new(loc)
	var/receiptname = "Receipt: [machine_id]"
	R.set_content_unsafe(receiptname, receipt, sum)

	//stamp the paper
	var/image/stampoverlay = image('icons/obj/bureaucracy.dmi')
	stampoverlay.icon_state = "paper_stamp-cent"
	if(!R.stamped)
		R.stamped = new
	R.stamped += /obj/item/stamp
	R.AddOverlays(stampoverlay)
	R.stamps += "<HR><i>This paper has been stamped by the Idris Quik-Pay Register.</i>"
	usr.put_in_any_hand_if_possible(R)

/obj/structure/cash_register/commissary/attackby(obj/item/attacking_item, mob/user)
	if(sum == 0)
		return
	if (istype(attacking_item, /obj/item/spacecash/ewallet))
		card_pay(attacking_item, user)
		return
	else if (istype(attacking_item, /obj/item/card/id))
		ID_pay(attacking_item, user)
		return
	else if(istype(attacking_item, /obj/item/spacecash))
		cash_pay(attacking_item, user)
		return

/obj/structure/cash_register/commissary/proc/cash_pay(obj/item/spacecash/cashmoney, mob/user)
	var/transaction_amount = sum
	if(transaction_amount > cashmoney.worth)
		to_chat(user, SPAN_WARNING("[icon2html(cashmoney, user)] That is not enough money."))
		return 0
	if(istype(cashmoney, /obj/item/spacecash/bundle))
		visible_message(SPAN_INFO("\The [user] inserts some cash into \the [src]."))
		var/obj/item/spacecash/bundle/cashmoney_bundle = cashmoney
		cashmoney_bundle.worth -= transaction_amount

		if(cashmoney_bundle.worth <= 0)
			usr.drop_from_inventory(cashmoney_bundle,get_turf(src))
			qdel(cashmoney_bundle)
		else
			cashmoney_bundle.update_icon()
	else
		visible_message(SPAN_INFO("\The [user] inserts a bill into \the [src]."))
		var/left = cashmoney.worth - transaction_amount
		user.drop_from_inventory(cashmoney,get_turf(src))
		qdel(cashmoney)

		if(left)
			spawn_money(left, get_turf(user), user)
	credit += transaction_amount
	print_receipt()
	clear_order()
	return 1

/obj/structure/cash_register/commissary/proc/ID_pay(obj/item/attacking_item, mob/user)
	var/obj/item/card/id/I = attacking_item.GetID()
	var/transaction_amount = sum
	var/transaction_purpose = "[destinationact] Payment"
	var/transaction_terminal = machine_id

	var/transaction = SSeconomy.transfer_money(I.associated_account_number, SSeconomy.get_department_account(destinationact)?.account_number,transaction_purpose,transaction_terminal,transaction_amount,null,usr)

	if(transaction)
		to_chat(user, SPAN_NOTICE("[icon2html(src, user)]<span class='warning'>[transaction].</span>"))
	else
		playsound(src, 'sound/machines/chime.ogg', 50, 1)
		visible_message(SPAN_NOTICE("[icon2html(src, viewers(get_turf(src)))] \The [src] chimes."))
		visible_message("\The [user] swipes a card on \the [src]." )
		print_receipt()
		sum = 0
		receipt = ""
		to_chat(user, SPAN_NOTICE("Transaction completed, please return to the home screen."))
		clear_order()

/obj/structure/cash_register/commissary/proc/card_pay(obj/item/attacking_item, mob/user)
	var/obj/item/spacecash/ewallet/E = attacking_item
	var/transaction_amount = sum
	var/transaction_purpose = "[destinationact] Payment"
	var/transaction_terminal = machine_id

	if(transaction_amount <= E.worth)
		SSeconomy.charge_to_account(SSeconomy.get_department_account(destinationact)?.account_number, E.owner_name, transaction_purpose, transaction_terminal, transaction_amount)
		E.worth -= transaction_amount

		visible_message("\The [user] swipes a card on \the [src]." )
		playsound(src, 'sound/machines/chime.ogg', 50, 1)
		src.audible_message(SPAN_NOTICE("[icon2html(src, viewers(get_turf(src)))] \The [src] chimes."))
		print_receipt()
		sum = 0
		receipt = ""
		to_chat(user, SPAN_NOTICE("Transaction completed, please return to the home screen."))
		clear_order()
	else if (transaction_amount > E.worth)
		to_chat(user, SPAN_WARNING("[icon2html(src, user)]\The [E] doesn't have that much money!"))
	return

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
			var/index = 0
			for(var/list/L in buying)
				index++
				if(L["name"] == params["removal"])
					if(L["amount"] > 1)
						L["amount"]--
					else
						buying.Cut(index, index+1)
			. = TRUE

		if("confirm")
			for(var/list/bought_item in buying)
				var/item_name = bought_item["name"]
				var/item_amount = bought_item["amount"]
				var/item_price = items_to_price[item_name]

				receipt += "<b>[item_name]</b>: x[item_amount] at [item_price]cr each<br>"
				sum += item_price * item_amount
			receipt += "<b>Total:</b> [sum]cr<br>"
			playsound(src, 'sound/machines/ping.ogg', 25, 1)
			audible_message(SPAN_NOTICE("[icon2html(src, viewers(get_turf(src)))] \The [src] pings."))
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

			var/dest = tgui_input_list(usr, "What account would you like to select?", "Destination Account", assoc_to_keys(SSeconomy.department_accounts))
			if(!dest)
				return FALSE
			destinationact = dest
			return TRUE

/obj/structure/cash_register/commissary/proc/clear_order()
	buying.Cut()
	sum = 0
	receipt = ""

/obj/item/commissary_restrock
	name = "commissary cigarette restock"
	w_class = WEIGHT_CLASS_NORMAL
	var/starts_with = list(
		/obj/item/storage/box/fancy/cigarettes/pra = 3,
		/obj/item/storage/box/fancy/cigarettes/dpra = 3,
		/obj/item/storage/box/fancy/cigarettes/nka = 3,
		/obj/item/storage/box/fancy/cigarettes/federation = 3,
		/obj/item/storage/box/fancy/cigarettes/dyn = 3,
		/obj/item/storage/box/fancy/cigarettes/oracle = 3,
		/obj/item/storage/box/fancy/cigarettes/koko = 3,
		/obj/item/storage/chewables/rollable = 3,
		/obj/item/storage/chewables/rollable/unathi = 3,
		/obj/item/storage/chewables/rollable/fine = 3,
		/obj/item/storage/chewables/rollable/nico = 3,
		/obj/item/storage/chewables/rollable/oracle = 3,
		/obj/item/storage/chewables/rollable/vedamor = 3,
		/obj/item/storage/chewables/tobacco/bad = 3,
		/obj/item/storage/chewables/tobacco/fine = 3,
		/obj/item/storage/chewables/tobacco/federation = 3,
		/obj/item/storage/chewables/tobacco/dyn = 3,
		/obj/item/storage/chewables/tobacco/koko = 3,
		/obj/item/storage/chewables/oracle = 3,
		/obj/item/storage/box/fancy/cigpaper = 3,
		/obj/item/storage/box/fancy/cigpaper/fine = 3,
		/obj/item/storage/box/fancy/matches = 10,
		/obj/item/flame/lighter/random = 4,
		/obj/item/clothing/mask/smokable/ecig/util = 3,
		/obj/item/reagent_containers/ecig_cartridge/med_nicotine = 2,
		/obj/item/reagent_containers/ecig_cartridge/high_nicotine = 2,
		/obj/item/reagent_containers/ecig_cartridge/orange = 2,
		/obj/item/reagent_containers/ecig_cartridge/watermelon = 2,
		/obj/item/reagent_containers/ecig_cartridge/grape = 2
	)

/obj/item/commissary_restrock/food
	name = "commissary food restock"
	starts_with = list(
		/obj/item/reagent_containers/food/snacks/chips =6,
		/obj/item/reagent_containers/food/snacks/no_raisin = 6,
		/obj/item/storage/box/pineapple = 4,
		/obj/item/reagent_containers/food/snacks/chocolatebar = 6,
		/obj/item/reagent_containers/food/snacks/whitechocolate/wrapped = 6,
		/obj/item/storage/box/fancy/cookiesnack = 6,
		/obj/item/storage/box/fancy/gum = 4,
		/obj/item/storage/box/fancy/vkrexitaffy = 5,
		/obj/item/clothing/mask/chewable/candy/lolli = 8,
		/obj/item/storage/box/fancy/admints = 4,
		/obj/item/reagent_containers/food/snacks/adhomian_can = 2,
		/obj/item/reagent_containers/food/snacks/ricetub = 2,
		/obj/item/reagent_containers/food/snacks/riceball = 4,
		/obj/item/reagent_containers/food/snacks/seaweed = 5,
		/obj/item/reagent_containers/food/snacks/algaechips = 2,
		/obj/item/storage/box/fancy/quick_microwave_pizza = 3,
		/obj/item/storage/box/fancy/quick_microwave_pizza/olive = 3,
		/obj/item/storage/box/fancy/quick_microwave_pizza/pepperoni = 3,
		/obj/item/storage/box/fancy/quick_microwave_pizza/district6 = 3,
		/obj/item/reagent_containers/food/snacks/packaged_microwave_mac_and_cheeze = 3,
		/obj/item/reagent_containers/food/snacks/packaged_microwave_fiery_mac_and_cheeze = 3,
		/obj/item/storage/box/fancy/packaged_burger = 3,
		/obj/item/reagent_containers/food/snacks/quick_curry = 3,
		/obj/item/reagent_containers/food/snacks/hv_dinner = 3,
		/obj/item/storage/box/fancy/toptarts_strawberry = 3,
		/obj/item/storage/box/fancy/toptarts_chocolate_peanutbutter = 3,
		/obj/item/storage/box/fancy/toptarts_blueberry = 3,
		/obj/item/storage/box/unique/donkpockets = 3
	)

/obj/item/commissary_restrock/drink
	name = "commissary drink restock"
	starts_with = list(
		/obj/item/reagent_containers/food/drinks/cans/cola = 5,
		/obj/item/reagent_containers/food/drinks/cans/diet_cola = 5,
		/obj/item/reagent_containers/food/drinks/cans/space_mountain_wind = 5,
		/obj/item/reagent_containers/food/drinks/cans/dr_gibb = 5,
		/obj/item/reagent_containers/food/drinks/cans/root_beer = 5,
		/obj/item/reagent_containers/food/drinks/cans/starkist = 5,
		/obj/item/reagent_containers/food/drinks/waterbottle = 5,
		/obj/item/reagent_containers/food/drinks/cans/dyn = 5,
		/obj/item/reagent_containers/food/drinks/cans/space_up = 5,
		/obj/item/reagent_containers/food/drinks/cans/iced_tea = 5,
		/obj/item/reagent_containers/food/drinks/cans/grape_juice = 5,
		/obj/item/reagent_containers/food/drinks/cans/peach_soda = 5,
		/obj/item/reagent_containers/food/drinks/cans/beetle_milk = 5,
		/obj/item/reagent_containers/food/drinks/cans/hrozamal_soda = 5,
		/obj/item/reagent_containers/food/drinks/carton/small/milk = 5,
		/obj/item/reagent_containers/food/drinks/carton/small/milk/choco = 5,
		/obj/item/reagent_containers/food/drinks/carton/small/milk/strawberry = 5,
		/obj/item/reagent_containers/food/drinks/cans/melon_soda = 5,
		/obj/item/reagent_containers/food/drinks/zobo = 5
	)

/obj/item/commissary_restrock/Initialize(mapload, ...)
	. = ..()
	fill()

/obj/item/commissary_restrock/proc/fill()
	if(LAZYLEN(starts_with))
		for(var/t in starts_with)
			if(!ispath(t))
				crash_with("[t] in [src]'s starts_with list is not a path!")
				continue
			for(var/i=0, i<starts_with[t], i++)
				new t(src)
	return

/obj/item/commissary_restrock/proc/remove_from_storage(obj/item/W, atom/new_location)
	if(!istype(W))
		return FALSE

	if(new_location)
		W.forceMove(new_location)
	else
		W.forceMove(get_turf(src))

	W.on_exit_storage(src)
	update_icon()
	return TRUE

/obj/structure/closet/crate/commissary
	name = "commissary crate"
	desc = "A crate packed with boxes of various goods. Handle with care!"

/obj/structure/closet/crate/commissary/fill()
	new /obj/item/commissary_restrock(src)
	new /obj/item/commissary_restrock/food(src)
	new /obj/item/commissary_restrock/drink(src)
