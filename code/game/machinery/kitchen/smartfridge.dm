/* SmartFridge.  Much todo
*/
/obj/machinery/smartfridge
	name = "\improper SmartFridge"
	icon = 'icons/obj/vending.dmi'
	icon_state = "smartfridge"
	layer = 2.9
	density = 1
	anchored = 1
	use_power = 1
	idle_power_usage = 5
	active_power_usage = 100
	flags = NOREACT
	var/global/max_n_of_items = 999 // Sorry but the BYOND infinite loop detector doesn't look things over 1000.
	var/icon_on = "smartfridge"
	var/icon_off = "smartfridge-off"
	var/icon_panel = "smartfridge-panel"
	var/item_quants = list()
	var/seconds_electrified = 0;
	var/shoot_inventory = 0
	var/locked = 0
	var/scan_id = 1
	var/is_secure = 0
	var/machineselect = 0

	var/cooling = 0 //Whether or not to vend products at the cooling temperature
	var/heating = 0 //Whether or not to vend products at the heating temperature
	var/cooling_temperature = T0C + 5 //Best temp for soda.
	var/heating_temperature = T0C + 57 //Best temp for coffee.

	component_types = list(
		/obj/item/circuitboard/smartfridge,
		/obj/item/stock_parts/manipulator,
		/obj/item/stock_parts/manipulator,
		/obj/item/stock_parts/manipulator
	)

	var/datum/wires/smartfridge/wires = null
	atmos_canpass = CANPASS_NEVER

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
		CHECK_TICK

	for(var/obj/item/reagent_containers/food/snacks/grown/g in contents)
		if(item_quants[g.name])
			item_quants[g.name]++
		else
			item_quants[g.name] = 1

/obj/machinery/smartfridge/Initialize()
	. = ..()
	if(is_secure)
		wires = new/datum/wires/smartfridge/secure(src)
	else
		wires = new/datum/wires/smartfridge(src)

/obj/machinery/smartfridge/Destroy()
	qdel(wires)
	wires = null
	return ..()

/obj/machinery/smartfridge/proc/accept_check(var/obj/item/O as obj)
	if(istype(O,/obj/item/reagent_containers/food/snacks/grown/) || istype(O,/obj/item/seeds/))
		return 1
	return 0

/obj/machinery/smartfridge/foodheater
	name = "\improper SmartHeater"
	desc = "To keep the food warm!"
	icon_state = "smartfridge_food"
	icon_on = "smartfridge_food"
	icon_off = "smartfridge_food-off"

/obj/machinery/smartfridge/foodheater/accept_check(var/obj/item/O as obj)
	if(istype(O,/obj/item/reagent_containers/food/snacks))
		return 1
	return 0

/obj/machinery/smartfridge/seeds
	name = "\improper MegaSeed Storage"
	desc = "When you need seeds fast!"
	icon = 'icons/obj/vending.dmi'
	icon_state = "nutrimat"
	icon_on = "nutrimat"
	icon_off = "nutrimat-off"

/obj/machinery/smartfridge/seeds/accept_check(var/obj/item/O as obj)
	if(istype(O,/obj/item/seeds/))
		return 1
	return 0

/obj/machinery/smartfridge/secure/extract
	name = "\improper Slime Extract Storage"
	desc = "A refrigerated storage unit for slime extracts"
	req_access = list(access_research)

/obj/machinery/smartfridge/secure/extract/Initialize()
	. = ..()
	new/obj/item/storage/bag/slimes(src)

/obj/machinery/smartfridge/secure/extract/accept_check(var/obj/item/O as obj)
	if(istype(O,/obj/item/slime_extract))
		return 1
	return 0

/obj/machinery/smartfridge/secure/medbay
	name = "\improper Refrigerated Chemical Storage"
	desc = "A refrigerated storage unit for storing medicine and chemicals."
	icon_state = "smartfridge" //To fix the icon in the map editor.
	icon_on = "smartfridge_chem"
	req_one_access = list(access_medical,access_pharmacy)

/obj/machinery/smartfridge/secure/medbay/accept_check(var/obj/item/O as obj)
	if(istype(O,/obj/item/reagent_containers/glass/))
		return 1
	if(istype(O,/obj/item/storage/pill_bottle/))
		return 1
	if(istype(O,/obj/item/reagent_containers/pill/))
		return 1
	if(istype(O,/obj/item/reagent_containers/inhaler))
		return 1
	if(istype(O,/obj/item/reagent_containers/personal_inhaler_cartridge	))
		return 1
	if(istype(O,/obj/item/reagent_containers/inhaler))
		return 1
	if(istype(O,/obj/item/reagent_containers/hypospray/autoinjector))
		return 1
	if(istype(O,/obj/item/personal_inhaler))
		return 1

	return 0

/obj/machinery/smartfridge/secure/virology
	name = "\improper Refrigerated Virus Storage"
	desc = "A refrigerated storage unit for storing viral material."
	req_access = list(access_virology)
	icon_state = "smartfridge_virology"
	icon_on = "smartfridge_virology"
	icon_off = "smartfridge_virology-off"

/obj/machinery/smartfridge/secure/virology/accept_check(var/obj/item/O as obj)
	if(istype(O,/obj/item/reagent_containers/glass/beaker/vial/))
		return 1
	if(istype(O,/obj/item/virusdish/))
		return 1
	return 0

/obj/machinery/smartfridge/chemistry
	name = "\improper Smart Chemical Storage"
	desc = "A refrigerated storage unit for medicine and chemical storage."

/obj/machinery/smartfridge/chemistry/accept_check(var/obj/item/O as obj)
	if(istype(O,/obj/item/storage/pill_bottle) || istype(O,/obj/item/reagent_containers))
		return 1
	return 0

/obj/machinery/smartfridge/chemistry/virology
	name = "\improper Smart Virus Storage"
	desc = "A refrigerated storage unit for volatile sample storage."


/obj/machinery/smartfridge/drinks
	name = "\improper Drink Showcase"
	desc = "A refrigerated storage unit for tasty tasty alcohol."
	cooling = TRUE

/obj/machinery/smartfridge/drinks/accept_check(var/obj/item/O as obj)
	if(istype(O,/obj/item/reagent_containers/glass) || istype(O,/obj/item/reagent_containers/food/drinks) || istype(O,/obj/item/reagent_containers/food/condiment))
		return 1

/obj/machinery/smartfridge/drying_rack
	name = "\improper Drying Rack"
	desc = "A machine for drying plants."

/obj/machinery/smartfridge/drying_rack/accept_check(var/obj/item/O as obj)
	if(istype(O, /obj/item/reagent_containers/food/snacks/))
		var/obj/item/reagent_containers/food/snacks/S = O
		if (S.dried_type)
			return 1
	return 0

/obj/machinery/smartfridge/drying_rack/machinery_process()
	..()
	if (contents.len)
		dry()

/obj/machinery/smartfridge/drying_rack/proc/dry()
	for(var/obj/item/reagent_containers/food/snacks/S in contents)
		if(S.dry) continue
		if(S.dried_type == S.type)
			S.dry = 1
			item_quants[S.name]--
			S.name = "dried [S.name]"
			S.color = "#AAAAAA"
			S.forceMove(loc)
		else
			var/D = S.dried_type
			new D(loc)
			item_quants[S.name]--
			qdel(S)
		return
	return

/obj/machinery/smartfridge/machinery_process()
	if(stat & (BROKEN|NOPOWER))
		return
	if(src.seconds_electrified > 0)
		src.seconds_electrified--
	if(src.shoot_inventory && prob(2))
		src.throw_item()
	if(cooling || heating)

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
			use_power(active_power_usage)



/obj/machinery/smartfridge/power_change()
	var/old_stat = stat
	..()
	if(old_stat != stat)
		update_icon()

/obj/machinery/smartfridge/update_icon()
	if(stat & (BROKEN|NOPOWER))
		icon_state = icon_off
	else
		icon_state = icon_on

/*******************
*   Item Adding
********************/

/obj/machinery/smartfridge/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(O.isscrewdriver())
		panel_open = !panel_open
		user.visible_message("[user] [panel_open ? "opens" : "closes"] the maintenance panel of \the [src].", "You [panel_open ? "open" : "close"] the maintenance panel of \the [src].")
		cut_overlays()
		if(panel_open)
			add_overlay(icon_panel)
		SSnanoui.update_uis(src)
		return

	if(O.ismultitool()||O.iswirecutter())
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
		to_chat(user, "<span class='notice'>\The [src] is unpowered and useless.</span>")
		return

	if(accept_check(O))
		if(contents.len >= max_n_of_items)
			to_chat(user, "<span class='notice'>\The [src] is full.</span>")
			return 1
		else
			user.remove_from_mob(O)
			O.forceMove(src)
			if(item_quants[O.name])
				item_quants[O.name]++
			else
				item_quants[O.name] = 1
			user.visible_message("<span class='notice'>[user] has added \the [O] to \the [src].</span>", "<span class='notice'>You add \the [O] to \the [src].</span>")

			SSnanoui.update_uis(src)
			return

	if(istype(O, /obj/item/storage/bag) || istype(O, /obj/item/storage/box/produce))
		var/obj/item/storage/P = O
		var/plants_loaded = 0
		for(var/obj/G in P.contents)
			if(accept_check(G))
				if(contents.len >= max_n_of_items)
					to_chat(user, "<span class='notice'>\The [src] is full.</span>")
					return 1
				else
					P.remove_from_storage(G,src)
					if(item_quants[G.name])
						item_quants[G.name]++
					else
						item_quants[G.name] = 1
					plants_loaded++
		if(plants_loaded)

			user.visible_message("<span class='notice'>[user] loads \the [src] with \the [P].</span>", "<span class='notice'>You load \the [src] with \the [P].</span>")
			if(P.contents.len > 0)
				to_chat(user, "<span class='notice'>Some items are refused.</span>")

		SSnanoui.update_uis(src)

	else
		to_chat(user, "<span class='notice'>\The [src] smartly refuses [O].</span>")
		return 1

/obj/machinery/smartfridge/secure/emag_act(var/remaining_charges, var/mob/user)
	if(!emagged)
		emagged = 1
		locked = -1
		to_chat(user, "You short out the product lock on [src].")
		return 1

/obj/machinery/smartfridge/attack_ai(mob/user as mob)
	attack_hand(user)

/obj/machinery/smartfridge/attack_hand(mob/user as mob)
	if(stat & (NOPOWER|BROKEN))
		return
	wires.Interact(user)
	ui_interact(user)

/*******************
*   SmartFridge Menu
********************/

/obj/machinery/smartfridge/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	user.set_machine(src)

	var/data[0]
	data["contents"] = null
	data["electrified"] = seconds_electrified > 0
	data["shoot_inventory"] = shoot_inventory
	data["locked"] = locked
	data["secure"] = is_secure

	var/list/items[0]
	for (var/i=1 to length(item_quants))
		var/K = item_quants[i]
		var/count = item_quants[K]
		if(count > 0)
			items.Add(list(list("display_name" = html_encode(capitalize(K)), "vend" = i, "quantity" = count)))

	if(items.len > 0)
		data["contents"] = items

	ui = SSnanoui.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "smartfridge.tmpl", src.name, 400, 500)
		ui.set_initial_data(data)
		ui.open()

/obj/machinery/smartfridge/Topic(href, href_list)
	if(..()) return 0

	var/mob/user = usr
	var/datum/nanoui/ui = SSnanoui.get_open_ui(user, src, "main")

	src.add_fingerprint(user)

	if(href_list["close"])
		user.unset_machine()
		ui.close()
		return 0

	if(href_list["vendItem"])
		var/index = text2num(href_list["vendItem"])
		var/amount = text2num(href_list["amount"])
		var/K = item_quants[index]
		var/count = item_quants[K]

		// Sanity check, there are probably ways to press the button when it shouldn't be possible.
		if(count > 0)
			item_quants[K] = max(count - amount, 0)

			var/i = amount
			for(var/obj/O in contents)
				if(O.name == K)
					O.forceMove(loc)
					i--
					if(i <= 0)
						return 1

		return 1
	return 0

/obj/machinery/smartfridge/proc/throw_item()
	var/obj/throw_item = null
	var/mob/living/target = locate() in view(7,src)
	if(!target)
		return 0

	for (var/O in item_quants)
		if(item_quants[O] <= 0) //Try to use a record that actually has something to dump.
			continue

		item_quants[O]--
		for(var/obj/T in contents)
			if(T.name == O)
				T.forceMove(src.loc)
				throw_item = T
				break
		break
	if(!throw_item)
		return 0
	spawn(0)
		throw_item.throw_at(target,16,3,src)
	src.visible_message("<span class='warning'>[src] launches [throw_item.name] at [target.name]!</span>")
	return 1

/************************
*   Secure SmartFridges
*************************/

/obj/machinery/smartfridge/secure/Topic(href, href_list)
	if(stat & (NOPOWER|BROKEN)) return 0
	if(usr.contents.Find(src) || (in_range(src, usr) && istype(loc, /turf)))
		if(!allowed(usr) && !emagged && locked != -1 && href_list["vendItem"])
			to_chat(usr, "<span class='warning'>Access denied.</span>")
			return 0
	return ..()
