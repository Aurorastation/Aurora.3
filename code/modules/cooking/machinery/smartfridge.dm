/* SmartFridge.  Much todo
*/
/obj/machinery/smartfridge
	name = "\improper SmartFridge"
	icon = 'icons/obj/machinery/smartfridge.dmi'
	icon_state = "smartfridge"
	layer = 2.9
	density = 1
	anchored = 1
	idle_power_usage = 5
	active_power_usage = 100
	atom_flags = ATOM_FLAG_NO_REACT
	opacity = FALSE
	var/ui_sort_alphabetically = TRUE
	var/global/max_n_of_items = 999 // Sorry but the BYOND infinite loop detector doesn't look things over 1000.
	var/item_quants = list()
	var/seconds_electrified = 0;
	var/shoot_inventory = 0
	var/locked = 0
	var/scan_id = 1
	var/is_secure = 0
	var/machineselect = 0

	var/list/accepted_items = list(/obj/item/reagent_containers/food/snacks/grown, /obj/item/seeds)

	var/cooling = 0 //Whether or not to vend products at the cooling temperature
	var/heating = 0 //Whether or not to vend products at the heating temperature
	var/cooling_temperature = T0C + 5 //Best temp for soda.
	var/heating_temperature = T0C + 57 //Best temp for coffee.

	// what icon overlay to use to show its contents - set to NULL if no contents.
	var/contents_path = "-plant"

	component_types = list(
		/obj/item/circuitboard/smartfridge,
		/obj/item/stock_parts/manipulator,
		/obj/item/stock_parts/manipulator,
		/obj/item/stock_parts/manipulator
	)

	var/datum/wires/smartfridge/wires = null
	atmos_canpass = CANPASS_DENSITY

/obj/machinery/smartfridge/secure
	is_secure = 1

/obj/machinery/smartfridge/stocked
	var/list/starting_produce = list(
		"apple" = 24,
		"banana" = 24,
		"berry" = 24,
		"cabbage" = 24,
		"carrot" = 24,
		"chanterelle" = 16,
		"cherry" = 8,
		"chili" = 24,
		"cacao" = 8,
		"corn" = 24,
		"earthen-root" = 16,
		"eggplant" = 16,
		"garlic" = 8,
		"grape" = 8,
		"lemon" = 16,
		"lime" = 16,
		"Messa's tear" = 16,
		"dirt berries" = 16,
		"onion" = 24,
		"orange" = 24,
		"peanut" = 24,
		"plump helmet" = 24,
		"poppy" = 16,
		"potato" = 24,
		"pumpkin" = 16,
		"rice" = 24,
		"soybean" = 24,
		"tomato" = 24,
		"wheat" = 8,
		"watermelon" = 8,
		"white-beet" = 8,
		"dyn" = 24,
		"wulumunusha" = 24
	)

/obj/machinery/smartfridge/stocked/Initialize()
	. = ..()
	for(var/seed in starting_produce)
		var/produce_amount = starting_produce[seed]
		for(var/i in 1 to produce_amount)
			var/datum/seed/chosen_seed = SSplants.seeds[seed]
			if(chosen_seed)
				chosen_seed.spawn_seed(src)

	for(var/obj/item/reagent_containers/food/snacks/grown/g in contents)
		item_quants[g.name]++
	update_overlays()

/obj/machinery/smartfridge/Initialize()
	. = ..()
	if(is_secure)
		wires = new/datum/wires/smartfridge/secure(src)
	else
		wires = new(src)
	update_icon()

/obj/machinery/smartfridge/Destroy()
	qdel(wires)
	wires = null
	return ..()

/obj/machinery/smartfridge/proc/accept_check(var/obj/item/O)
	if(is_type_in_list(O, accepted_items))
		return TRUE
	return FALSE

/obj/machinery/smartfridge/foodheater
	name = "\improper SmartHeater"
	desc = "To keep the food warm!"
	contents_path = "-food"
	accepted_items = list(/obj/item/reagent_containers/food/snacks)

/obj/machinery/smartfridge/foodheater/abandoned
	// badly stocked, with trash, junk, etc
	desc = "Used to keep food nice and warm in the past, now it is all dirty, and doesn't look like it'll ever run again."
	use_power = 0

/obj/machinery/smartfridge/seeds
	name = "\improper MegaSeed Storage"
	desc = "When you need seeds fast!"
	icon = 'icons/obj/vending.dmi'
	icon_state = "nutrimat"
	opacity = TRUE
	contents_path = null
	accepted_items = list(/obj/item/seeds)

/obj/machinery/smartfridge/secure/extract
	name = "\improper Slime Extract Storage"
	desc = "A refrigerated storage unit for slime extracts"
	contents_path = "-slime"
	req_access = list(ACCESS_RESEARCH)
	accepted_items = list(/obj/item/slime_extract)

/obj/machinery/smartfridge/secure/extract/Initialize()
	. = ..()
	new/obj/item/storage/slimes(src)

/obj/machinery/smartfridge/secure/medbay
	name = "\improper Refrigerated Chemical Storage"
	desc = "A refrigerated storage unit for storing medicine and chemicals."
	contents_path = "-chem"
	req_one_access = list(ACCESS_MEDICAL,ACCESS_PHARMACY)
	accepted_items = list(/obj/item/reagent_containers/glass,
						/obj/item/storage/pill_bottle,
						/obj/item/reagent_containers/pill,
						/obj/item/reagent_containers/inhaler,
						/obj/item/reagent_containers/personal_inhaler_cartridge,
						/obj/item/reagent_containers/hypospray/autoinjector,
						/obj/item/personal_inhaler)

/obj/machinery/smartfridge/secure/virology
	name = "\improper Refrigerated Virus Storage"
	desc = "A refrigerated storage unit for storing viral material."
	contents_path = "-viro"
	req_access = list(ACCESS_VIROLOGY)
	accepted_items = list(/obj/item/reagent_containers/glass/beaker/vial)

/obj/machinery/smartfridge/chemistry
	name = "\improper Smart Chemical Storage"
	desc = "A refrigerated storage unit for medicine and chemical storage."
	contents_path = "-chem"
	accepted_items = list(/obj/item/reagent_containers/glass,
						/obj/item/storage/pill_bottle,
						/obj/item/reagent_containers/pill,
						/obj/item/reagent_containers/inhaler,
						/obj/item/reagent_containers/personal_inhaler_cartridge,
						/obj/item/reagent_containers/hypospray/autoinjector,
						/obj/item/personal_inhaler)

/obj/machinery/smartfridge/chemistry/virology
	name = "\improper Smart Virus Storage"
	desc = "A refrigerated storage unit for volatile sample storage."
	contents_path = "-viro"

/obj/machinery/smartfridge/drinks
	name = "\improper Drink Showcase"
	desc = "A refrigerated storage unit for tasty tasty alcohol."
	contents_path = "-drink"
	cooling = TRUE
	accepted_items = list(/obj/item/reagent_containers/glass,
						/obj/item/reagent_containers/food/drinks,
						/obj/item/reagent_containers/food/condiment)

/obj/machinery/smartfridge/drying_rack
	name = "\improper Drying Rack"
	desc = "A machine for drying plants."
	icon_state = "drying_rack"
	opacity = TRUE
	accepted_items = list(/obj/item/reagent_containers/food/snacks)
	contents_path = null

/obj/machinery/smartfridge/drying_rack/accept_check(var/obj/item/O)
	if(!..())
		return FALSE
	var/obj/item/reagent_containers/food/snacks/S = O
	if (S.dried_type)
		return TRUE

/obj/machinery/smartfridge/drying_rack/process()
	..()
	if(length(contents))
		dry()

/obj/machinery/smartfridge/drying_rack/proc/dry()
	for(var/obj/item/reagent_containers/food/snacks/S in contents)
		if(S.dry) continue
		var/old_name = S.name
		if(S.on_dry(src)) //Drying rack keeps the item but changes the name. This prevents pre-dried item lingering in the UI as vendable
			item_quants[S.name]++
			item_quants[old_name]--
	return

/obj/machinery/smartfridge/drying_rack/update_overlays()
	cut_overlays()
	if(length(contents))
		add_overlay("drying_rack_drying")
	var/list/shown_contents = contents - component_parts
	if(shown_contents.len)
		add_overlay("drying_rack_filled")

/obj/machinery/smartfridge/process()
	if(stat & (BROKEN|NOPOWER))
		seconds_electrified = 0
		return
	if(seconds_electrified > 0)
		seconds_electrified--
	if(shoot_inventory && prob(2))
		throw_item()
	if(!cooling && !heating)
		return
	var/mod = cooling ? -1 : 1
	for(var/obj/item/I in contents)
		if(!I.reagents)
			continue
		var/r_temperature = I.reagents.get_temperature()
		if(mod == 1 && r_temperature <= heating_temperature)
			continue
		else if(mod == -1 && r_temperature <= cooling_temperature)
			continue
		var/thermal_energy_change = 0
		if(mod == 1) //GOING UP
			thermal_energy_change = min(active_power_usage,I.reagents.get_thermal_energy_change(r_temperature,heating_temperature))
		else if (mod == -1) //GOING DOWN
			thermal_energy_change = max(-active_power_usage,I.reagents.get_thermal_energy_change(r_temperature,cooling_temperature))
		I.reagents.add_thermal_energy(thermal_energy_change)
		use_power_oneoff(active_power_usage)

/obj/machinery/smartfridge/power_change()
	..()
	if(!anchored)
		stat |= NOPOWER
	update_icon()

/obj/machinery/smartfridge/update_icon()
	if(stat & (BROKEN|NOPOWER))
		icon_state = "[initial(icon_state)]-off"
	else
		icon_state = "[initial(icon_state)]"
	update_overlays()

/obj/machinery/smartfridge/proc/update_overlays()
	cut_overlays()
	if(panel_open)
		add_overlay("[initial(icon_state)]-panel")
	var/list/shown_contents = contents - component_parts
	if(contents_path && shown_contents.len > 0)
		var/contents_icon_state
		switch(shown_contents.len)
			if(1 to 25)
				contents_icon_state = "-1"
			if(26 to 50)
				contents_icon_state = "-2"
			if(50 to INFINITY)
				contents_icon_state = "-3"
		add_overlay("[initial(icon_state)][contents_path][contents_icon_state]")
	add_overlay("[initial(icon_state)]-glass[(stat & BROKEN) ? "-broken" : ""]")

/*******************
*   Item Adding
********************/

/obj/machinery/smartfridge/attackby(obj/item/attacking_item, mob/user)
	if(attacking_item.isscrewdriver())
		panel_open = !panel_open
		user.visible_message("\The [user] [panel_open ? "opens" : "closes"] the maintenance panel of \the [src].",
							"You [panel_open ? "open" : "close"] the maintenance panel of \the [src].")
		update_icon()
		return

	if(attacking_item.iswrench())
		anchored = !anchored
		user.visible_message("\The [user] [anchored ? "secures" : "unsecures"] the bolts holding \the [src] to the floor.",
								"You [anchored ? "secure" : "unsecure"] the bolts holding \the [src] to the floor.")
		attacking_item.play_tool_sound(get_turf(src), 50)
		power_change()
		return

	if(attacking_item.ismultitool() || attacking_item.iswirecutter())
		if(panel_open)
			switch(input(user, "What would you like to select?", "Machine Debug Software") as null|anything in list("SmartHeater", "MegaSeed Storage", "Slime Extract Storage", "Refrigerated Chemical Storage", "Refrigerated Virus Storage", "Drink Showcase", "Drying Rack"))
				if("SmartHeater")
					new /obj/machinery/smartfridge/foodheater(loc)
					qdel(src)

				if("MegaSeed Storage")
					new /obj/machinery/smartfridge/seeds(loc)
					qdel(src)

				if("Slime Extract Storage")
					new /obj/machinery/smartfridge/secure/extract(loc)
					qdel(src)

				if("Refrigerated Chemical Storage")
					new /obj/machinery/smartfridge/secure/medbay(loc)
					qdel(src)

				if("Refrigerated Virus Storage")
					new /obj/machinery/smartfridge/secure/virology(loc)
					qdel(src)

				if("Drink Showcase")
					new /obj/machinery/smartfridge/drinks(loc)
					qdel(src)

				if("Drying Rack")
					new /obj/machinery/smartfridge/drying_rack(loc)
					qdel(src)


			attack_hand(user)
		return

	if(stat & NOPOWER)
		to_chat(user, SPAN_NOTICE("[src] is unpowered and useless."))
		return

	if(accept_check(attacking_item))
		if(length(contents) >= max_n_of_items)
			to_chat(user, SPAN_NOTICE("[src] is full."))
			return TRUE
		user.remove_from_mob(attacking_item)
		attacking_item.forceMove(src)
		item_quants[attacking_item.name]++
		user.visible_message("<b>[user]</b> adds \a [attacking_item] to [src].", SPAN_NOTICE("You add [attacking_item] to [src]."))
		update_overlays()
		return

	if(istype(attacking_item, /obj/item/storage))
		var/obj/item/storage/P = attacking_item
		var/plants_loaded = 0
		for(var/obj/G in P.contents)
			if(accept_check(G))
				if(length(contents) >= max_n_of_items)
					break
				P.remove_from_storage(G,src)
				item_quants[G.name]++
				plants_loaded++
		if(plants_loaded)
			user.visible_message("<b>[user]</b> loads [src] with [P].", SPAN_NOTICE("You load [src] with [P]."))
			if(length(P.contents) > 0)
				to_chat(user, SPAN_NOTICE("Some items are refused."))
			update_overlays()
		return TRUE
	to_chat(user, SPAN_NOTICE("[src] smartly refuses [attacking_item]."))
	return TRUE

/obj/machinery/smartfridge/secure/emag_act(var/remaining_charges, var/mob/user)
	if(emagged)
		return FALSE
	emagged = 1
	locked = -1
	to_chat(user, SPAN_NOTICE("You short out the product lock on [src]."))
	return TRUE

/obj/machinery/smartfridge/attack_ai(mob/user)
	if(!ai_can_interact(user))
		return
	attack_hand(user)

/obj/machinery/smartfridge/attack_hand(mob/user)
	if(stat & (NOPOWER|BROKEN))
		return
	wires.interact(user)
	ui_interact(user)

/*******************
*   SmartFridge Menu
********************/

/obj/machinery/smartfridge/ui_interact(mob/user, var/datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "SmartFridge", name, 400, 500)
		ui.open()

/obj/machinery/smartfridge/ui_data(mob/user)
	var/list/data = list()

	data["contents"] = null
	data["electrified"] = seconds_electrified > 0
	data["shoot_inventory"] = shoot_inventory
	data["locked"] = locked
	data["secure"] = is_secure
	data["sort_alphabetically"] = ui_sort_alphabetically

	var/list/items = list()
	for (var/i = 1 to length(item_quants))
		var/K = item_quants[i]
		var/count = item_quants[K]
		if(count > 0)
			items.Add(list(list("display_name" = html_encode(capitalize(K)), "vend" = i, "quantity" = count)))

	if(length(items) > 0)
		data["contents"] = items
	return data

/obj/machinery/smartfridge/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	add_fingerprint(usr)

	switch(action)
		if("vendItem")
			var/index = text2num(params["vendItem"])
			var/amount = text2num(params["amount"])
			var/K = item_quants[index]
			var/count = item_quants[K]

			// Sanity check, there are probably ways to press the button when it shouldn't be possible.
			if(count > 0 && anchored)
				item_quants[K] = max(count - amount, 0)

				var/i = amount
				for(var/obj/O in contents)
					if(O.name == K)
						if(Adjacent(usr))
							usr.put_in_hands(O)
						else
							O.forceMove(loc)
						i--
						update_overlays()
						if(i <= 0)
							break
		if("switch_sort_alphabetically")
			ui_sort_alphabetically = !ui_sort_alphabetically

	. = TRUE

/obj/machinery/smartfridge/proc/throw_item()
	var/obj/throw_item = null
	var/mob/living/target = locate() in view(7,src)
	if(!target)
		return FALSE

	for (var/O in item_quants)
		if(item_quants[O] <= 0) //Try to use a record that actually has something to dump.
			continue

		item_quants[O]--
		for(var/obj/T in contents)
			if(T.name == O)
				T.forceMove(loc)
				throw_item = T
				break
		break
	if(!throw_item)
		return FALSE
	spawn(0)
		throw_item.throw_at(target,16,3,src)
	visible_message(SPAN_DANGER("[src] launches [throw_item.name] at [target.name]!"))
	return TRUE

/************************
*   Secure SmartFridges
*************************/

/obj/machinery/smartfridge/secure/Topic(href, href_list)
	if(stat & (NOPOWER|BROKEN) || !anchored) return FALSE
	if(usr.contents.Find(src) || (in_range(src, usr) && isturf(loc)))
		if(!allowed(usr) && !emagged && locked != -1 && href_list["vendItem"])
			to_chat(usr, SPAN_WARNING("Access denied."))
			return FALSE
	return ..()

// Konyang

/obj/machinery/smartfridge/foodheater/buffet
	name = "buffet trays"
	icon = 'icons/obj/structure/urban/restaurant.dmi'
	icon_state = "buffet"
	contents_path = null

/obj/machinery/smartfridge/foodheater/buffet/Initialize()
	. = ..()
	contents_path = "[rand(1, 4)]" // overriding the update icon anyway, so this var is free.

/obj/machinery/smartfridge/foodheater/buffet/update_icon()
	if(stat & (BROKEN|NOPOWER))
		icon_state = "[initial(icon_state)]"
	else
		icon_state = "[initial(icon_state)][contents_path]"
