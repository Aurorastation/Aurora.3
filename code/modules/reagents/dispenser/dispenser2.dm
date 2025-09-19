/obj/machinery/chemical_dispenser
	name = "chemical dispenser"
	icon = 'icons/obj/chemical.dmi'
	icon_state = "dispenser"
	clicksound = /singleton/sound_category/button_sound
	idle_power_usage = 100
	density = TRUE
	anchored = TRUE
	manufacturer = "zenghu"

	/// Icon state when used.
	var/icon_state_active = "dispenser_active"
	/// Set to a list of types to spawn one of each on New().
	var/list/spawn_cartridges
	/// Associative, label -> cartridge.
	var/list/cartridges = list()
	///Current container.
	var/obj/item/reagent_containers/container
	/// Name of the dispenser on the UI.
	var/ui_title = "Chemical Dispenser"
	/// If set to FALSE, will only accept beakers.
	var/accept_drinking = FALSE
	/// Amount dispensed.
	var/amount = 30
	/// Preset amounts to dispense.
	var/list/preset_dispense_amounts = list(5, 10, 15, 20, 30, 40)
	/// If the user can select the amount to dispense.
	var/can_select_dispense_amount = TRUE
	/// For containers we don't want people to shove into the chem machine. Like buckets.
	var/list/forbidden_containers = list(/obj/item/reagent_containers/glass/bucket)
	/// Allow these cans/glasses/condiment bottles but forbid ACTUAL food.
	var/list/drink_accepted = list(/obj/item/reagent_containers/food/drinks, /obj/item/reagent_containers/food/condiment)

/obj/machinery/chemical_dispenser/feedback_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "It has [cartridges.len] cartridges installed, and has space for [DISPENSER_MAX_CARTRIDGES - cartridges.len] more."

/obj/machinery/chemical_dispenser/Initialize()
	. = ..()
	if(spawn_cartridges)
		for(var/type in spawn_cartridges)
			add_cartridge(new type(src))

/obj/machinery/chemical_dispenser/proc/add_cartridge(obj/item/reagent_containers/chem_disp_cartridge/C, mob/user)
	if(!istype(C))
		if(user)
			to_chat(user, SPAN_WARNING("[C] will not fit in [src]!"))
		return

	if(cartridges.len >= DISPENSER_MAX_CARTRIDGES)
		if(user)
			to_chat(user, SPAN_WARNING("[src] does not have any slots open for [C] to fit into!"))
		return

	if(!C.label)
		if(user)
			to_chat(user, SPAN_WARNING("[C] does not have a label!"))
		return

	if(cartridges[C.label])
		if(user)
			to_chat(user, SPAN_WARNING("[src] already contains a cartridge with that label!"))
		return

	if(user)
		user.drop_from_inventory(C,src)
		to_chat(user, SPAN_NOTICE("You add [C] to [src]."))
	else
		C.forceMove(src)

	cartridges[C.label] = C
	sortTim(cartridges, GLOBAL_PROC_REF(cmp_text_asc))
	SStgui.update_uis(src)

/obj/machinery/chemical_dispenser/proc/remove_cartridge(label)
	. = cartridges[label]
	cartridges -= label
	SStgui.update_uis(src)

/obj/machinery/chemical_dispenser/proc/eject()
	if(container && usr)
		var/obj/item/reagent_containers/B = container
		if(!use_check_and_message(usr))
			usr.put_in_hands(B, TRUE)
		else
			B.loc = get_turf(src)
		container = null
		if(icon_state_active)
			icon_state = initial(icon_state)
		return TRUE

/obj/machinery/chemical_dispenser/AltClick(mob/user)
	if(use_check_and_message(usr))
		eject()

/obj/machinery/chemical_dispenser/attackby(obj/item/attacking_item, mob/user)
	if(attacking_item.iswrench())
		to_chat(user, SPAN_NOTICE("You begin to [anchored ? "un" : ""]fasten [src]."))
		if(attacking_item.use_tool(src, user, 20, volume = 50))
			user.visible_message(
				SPAN_NOTICE("[user] [anchored ? "un" : ""]fastens [src]."),
				SPAN_NOTICE("You have [anchored ? "un" : ""]fastened [src]."),
				"You hear a ratchet.")
			anchored = !anchored
		else
			to_chat(user, SPAN_NOTICE("You decide not to [anchored ? "un" : ""]fasten [src]."))

	else if(istype(attacking_item, /obj/item/reagent_containers/chem_disp_cartridge))
		add_cartridge(attacking_item, user)

	else if(attacking_item.isscrewdriver())
		var/label = tgui_input_list(user, "Which cartridge would you like to remove?", "Chemical Dispenser", cartridges)
		if(!label)
			return
		var/obj/item/reagent_containers/chem_disp_cartridge/C = remove_cartridge(label)
		if(C)
			to_chat(user, SPAN_NOTICE("You remove [C] from [src]."))
			C.forceMove(loc)

	else if(istype(attacking_item, /obj/item/reagent_containers/glass) || is_type_in_list(attacking_item, drink_accepted))
		if(container)
			to_chat(user, SPAN_WARNING("There is already \a [container] on [src]!"))
			return

		var/obj/item/reagent_containers/RC = attacking_item

		if(is_type_in_list(RC, forbidden_containers))
			to_chat(user, SPAN_WARNING("There's no way to fit [RC] into \the [src]!"))
			return

		if(!accept_drinking && is_type_in_list(RC, drink_accepted))
			to_chat(user, SPAN_WARNING("This machine only accepts beakers!"))
			return

		if(!RC.is_open_container())
			to_chat(user, SPAN_WARNING("You don't see how [src] could dispense reagents into [RC]."))
			return

		container =  RC
		user.drop_from_inventory(RC,src)
		to_chat(user, SPAN_NOTICE("You set [RC] on [src]."))
		SStgui.update_uis(src)
		if(icon_state_active)
			icon_state = icon_state_active

	else
		return ..()

/obj/machinery/chemical_dispenser/ui_data(mob/user)
	var/list/data =  list()

	data["manufacturer"] = manufacturer
	data["amount"] = amount
	data["preset_dispense_amounts"] = preset_dispense_amounts
	data["can_select_dispense_amount"] = can_select_dispense_amount
	data["accept_drinking"] = accept_drinking
	data["is_beaker_loaded"] = !!container
	data["beaker_max_volume"] = container?.reagents?.maximum_volume
	data["beaker_current_volume"] = container?.reagents?.total_volume
	var/list/beakerD = list()
	for(var/_R in container?.reagents?.reagent_volumes)
		var/singleton/reagent/R = GET_SINGLETON(_R)
		beakerD += list(list("name" = R.name, "volume" = REAGENT_VOLUME(container.reagents, _R)))
	data["beaker_contents"] = beakerD
	var/list/chemicals = list()
	for(var/label in cartridges)
		var/obj/item/reagent_containers/chem_disp_cartridge/C = cartridges[label]
		chemicals += list(list("label" = label, "amount" = C.reagents.total_volume))
	data["chemicals"] = chemicals
	return data

/obj/machinery/chemical_dispenser/ui_interact(mob/user, var/datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ChemicalDispenser", ui_title, 400, 680)
		ui.open()

/obj/machinery/chemical_dispenser/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("amount")
			amount = round(text2num(params["amount"]), 1) // round to nearest 1
			amount = between(amount, 1, container?.reagents?.maximum_volume || 120) // Since the user can actually type the commands himself, some sanity checking
			. = TRUE

		if("dispense")
			var/label = params["dispense"]
			if(cartridges[label] && container?.is_open_container())
				var/obj/item/reagent_containers/chem_disp_cartridge/C = cartridges[label]
				playsound(src.loc, 'sound/machines/reagent_dispense.ogg', 25, 1)
				C.reagents.trans_to(container, amount)
				. = TRUE

		if("ejectBeaker")
			if(eject())
				. = TRUE

	add_fingerprint(usr)

/obj/machinery/chemical_dispenser/ui_status(mob/user, datum/ui_state/state)
	if(!operable())
		return UI_DISABLED

	. = ..()

/obj/machinery/chemical_dispenser/attack_ai(mob/user as mob)
	if(!ai_can_interact(user))
		return
	ui_interact(user)

/obj/machinery/chemical_dispenser/attack_hand(mob/user as mob)
	ui_interact(user)
