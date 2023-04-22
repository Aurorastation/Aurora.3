/obj/machinery/computer/ship/targeting
	name = "targeting systems console"
	desc = "A targeting systems console using Zavodskoi software."
	icon_screen = "teleport"
	icon_keyboard = "teal_key"
	light_color = LIGHT_COLOR_CYAN
	circuit = /obj/item/circuitboard/ship/targeting
	var/obj/machinery/ship_weapon/cannon
	var/selected_entrypoint
	var/platform_direction
	var/list/names_to_guns = list()
	var/list/names_to_entries = list()

/obj/machinery/computer/ship/targeting/Initialize()
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/machinery/computer/ship/targeting/LateInitialize()
	if(current_map.use_overmap && !linked)
		var/my_sector = map_sectors["[z]"]
		if(istype(my_sector, /obj/effect/overmap/visitable))
			attempt_hook_up(my_sector)

/obj/machinery/computer/ship/targeting/Destroy()
	cannon = null
	names_to_guns.Cut()
	names_to_entries.Cut()
	return ..()

/obj/machinery/computer/ship/targeting/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Gunnery", "Ajax Targeting Console", 400, 650)
		ui.open()

/obj/machinery/computer/ship/targeting/ui_data(mob/user)
	var/list/data = list()
	data["guns"] = list()
	data["selected_entrypoint"] = selected_entrypoint
	if(linked.targeting)
		for(var/obj/machinery/ship_weapon/SW in linked.ship_weapons)
			data["guns"] += list(get_gun_data(SW))
		data["targeting"] = list(
			"name" = linked.targeting.name,
			"shiptype" = linked.targeting.shiptype,
			"distance" = get_dist(linked, linked.targeting)
		)
		data["show_z_list"] = FALSE
		data["selected_z"] = 0
		if(istype(linked.targeting, /obj/effect/overmap/visitable))
			var/obj/effect/overmap/visitable/V = linked.targeting
			if(length(V.map_z) > 1)
				data["show_z_list"] = TRUE
		data["entry_points"] = copy_entrypoints(data["selected_z"])
		if(cannon)
			data["cannon"] = get_gun_data(cannon);
	else
		data["targeting"] = null
	return data

/obj/machinery/computer/ship/targeting/proc/get_gun_data(var/obj/machinery/ship_weapon/SW)
	var/ammo_status = length(SW.ammunition) ? "Loaded, [length(SW.ammunition)] shots" : "Unloaded"
	var/obj/item/ship_ammunition/SA
	if(length(SW.ammunition))
		SA = SW.ammunition[1]
	. = list(
		"name" = SW.name,
		"caliber" = SW.caliber,
		"ammunition" = ammo_status,
		"ammunition_type" = capitalize_first_letters(SA ? SA.impact_type : "None Loaded")
	);

/*/obj/machinery/computer/ship/targeting/ui_data(mob/user)
	build_gun_lists()
	var/list/data = list()
	if(!cannon)
		var/cannon_name = names_to_guns[1]
		cannon = names_to_guns[cannon_name]
		data["status"] = cannon.stat ? "MALFUNCTIONING" : "OK"
		data["ammunition"] = length(cannon.ammunition) ? "Loaded, [length(cannon.ammunition)] shots" : "Unloaded"
		data["caliber"] = cannon.caliber
	data["new_ship_weapon"] = capitalize_first_letters(cannon.weapon_id)
	data["entry_points"] = list()
	data["entry_point"] = null
	data["show_z_list"] = FALSE
	data["mobile_platform"] = FALSE
	data["platform_direction"] = 0
	data["selected_z"] = 0
	data["power"] = stat & (NOPOWER|BROKEN) ? FALSE : TRUE
	data["linked"] = linked ? TRUE : FALSE

	if(linked)
		data["is_targeting"] = linked.targeting ? TRUE : FALSE
		data["ship_weapons"] = list()
		for(var/name in names_to_guns)
			data["ship_weapons"] += name //Literally do not even ask me why the FUCK this is needed. I have ZERO, **ZERO** FUCKING CLUE why
										 //this piece of shit UI takes a linked list and AUTOMATICALLY decides it wants to read the fucking linked objects
										 //instead of the actual elements of the list.
		if(data["new_ship_weapon"])
			var/new_cannon = data["new_ship_weapon"]
			cannon = names_to_guns[new_cannon]
		if(cannon)
			data["status"] = cannon.stat ? "Unresponsive" : "OK"
			var/ammunition_type = null
			if(length(cannon.ammunition))
				var/obj/item/ship_ammunition/SA = cannon.ammunition[1]
				ammunition_type = capitalize_first_letters(SA.impact_type)
			data["ammunition"] = length(cannon.ammunition) ? "[ammunition_type] Loaded, [length(cannon.ammunition)] shot(s) left" : "Unloaded"
			data["caliber"] = cannon.caliber
			if(cannon.mobile_platform)
				data["mobile_platform"] = TRUE
				data["directions"] = list("NORTH", "NORTHEAST", "EAST", "SOUTHEAST", "SOUTH", "SOUTHWEST", "WEST", "NORTHWEST")
				platform_direction = data["platform_direction"]
		if(linked.targeting)
			data["target"] = ""
			if(istype(linked.targeting, /obj/effect/overmap/visitable))
				var/obj/effect/overmap/visitable/V = linked.targeting
				if(V.class && V.designation)
					data["target"] = "[V.class] [V.designation]"
				else
					data["target"] = capitalize_first_letters(linked.targeting.name)
				if(length(V.map_z) > 1)
					data["show_z_list"] = TRUE
					data["z_levels"] = V.map_z.Copy()
				else
					data["selected_z"] = 0
			else
				data["target"] = capitalize_first_letters(linked.targeting.name)
			data["dist"] = get_dist(linked, linked.targeting)
			data["entry_points"] = copy_entrypoints(data["selected_z"])
			if(data["entry_point"])
				selected_entrypoint = data["entry_point"]
	return data*/

/obj/machinery/computer/ship/targeting/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	playsound(src, clicksound, clickvol)

	. = FALSE
	switch(action)
		if("fire")
			var/obj/effect/landmark/LM
			if(!selected_entrypoint)
				return
			if(!istype(linked.loc, /turf/unsimulated/map))
				to_chat(usr, SPAN_WARNING("The safeties are engaged! You need to be undocked in order to fire."))
				return
			if(selected_entrypoint == SHIP_HAZARD_TARGET || !selected_entrypoint)
				LM = null
			else
				LM = names_to_entries[selected_entrypoint]
			var/result = cannon.firing_command(linked.targeting, LM, platform_direction ? text2dir(platform_direction) : 0)
			if(isliving(usr) && !isAI(usr) && usr.Adjacent(src))
				visible_message(SPAN_WARNING("[usr] presses the fire button!"))
				playsound(src, 'sound/machines/compbeep1.ogg')
			switch(result)
				if(SHIP_GUN_ERROR_NO_AMMO)
					to_chat(usr, SPAN_WARNING("The console shows an error screen: the weapon isn't loaded!"))
				if(SHIP_GUN_FIRING_SUCCESSFUL)
					to_chat(usr, SPAN_WARNING("The console shows a positive message: firing sequence successful!"))
					log_and_message_admins("[usr] has fired [cannon] with target [linked.targeting] and entry point [LM]!", location = get_turf(usr))
					. = TRUE

		if("viewing")
			if(usr)
				viewing_overmap(usr) ? unlook(usr) : look(usr)
				. = TRUE

		if("select_entrypoint")
			if(!params["entrypoint"])
				return
			selected_entrypoint = params["entrypoint"]
			. = TRUE

		if("select_gun")
			if(!params["gun"])
				return
			var/gun_name = lowertext(params["gun"])
			for(var/obj/machinery/ship_weapon/SW in linked.ship_weapons)
				if(lowertext(SW.name) == gun_name)
					cannon = SW
					. = TRUE

/obj/machinery/computer/ship/targeting/proc/copy_entrypoints(var/z_level_filter = 0)
	. = list()
	if(istype(linked.targeting, /obj/effect/overmap/visitable))
		var/obj/effect/overmap/visitable/V = linked.targeting
		if(V.targeting_flags & TARGETING_FLAG_ENTRYPOINTS)
			for(var/obj/effect/O in V.entry_points)
				if(!z_level_filter || (z_level_filter && O.z == z_level_filter))
					. += capitalize_first_letters(O.name)
					names_to_entries[capitalize_first_letters(O.name)] = O
		if(V.targeting_flags & TARGETING_FLAG_GENERIC_WAYPOINTS)
			for(var/obj/effect/O in V.generic_waypoints)
				. += capitalize_first_letters(O.name)
				names_to_entries[capitalize_first_letters(O.name)] = O
		. = sortList(.)
	if(!length(.))
		. += SHIP_HAZARD_TARGET //No entrypoints == hazard
