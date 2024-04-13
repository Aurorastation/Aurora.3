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
	var/selected_z = 0
	var/list/names_to_guns = list()
	var/list/names_to_entries = list()

/obj/machinery/computer/ship/targeting/terminal
	name = "targeting systems terminal"
	desc = "A targeting systems terminal using Zavodskoi software."
	icon = 'icons/obj/machinery/modular_terminal.dmi'
	icon_screen = "hostile"
	icon_keyboard = "red_key"
	is_connected = TRUE
	has_off_keyboards = TRUE
	can_pass_under = FALSE
	light_power_on = 1

/obj/machinery/computer/ship/targeting/Initialize()
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/machinery/computer/ship/targeting/LateInitialize()
	if(SSatlas.current_map.use_overmap && !linked)
		var/my_sector = GLOB.map_sectors["[z]"]
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
		ui = new(user, src, "Gunnery", "Ajax Targeting Console", 400, 525)
		ui.open()

/obj/machinery/computer/ship/targeting/ui_data(mob/user)
	var/list/data = list()
	data["guns"] = list()
	data["selected_entrypoint"] = selected_entrypoint
	data["mobile_platform"] = cannon ? cannon.mobile_platform : null
	if(data["mobile_platform"])
		data["platform_direction"] = platform_direction
		data["platform_directions"] = list("NORTH", "NORTHEAST", "EAST", "SOUTHEAST", "SOUTH", "SOUTHWEST", "WEST", "NORTHWEST")
	if(linked.targeting)
		for(var/obj/machinery/ship_weapon/SW in linked.ship_weapons)
			if(!SW.special_firing_mechanism)
				data["guns"] += list(get_gun_data(SW))
		data["targeting"] = list(
			"name" = linked.targeting.name,
			"shiptype" = linked.targeting.shiptype,
			"distance" = get_dist(linked, linked.targeting)
		)
		data["show_z_list"] = FALSE
		data["selected_z"] = selected_z
		if(istype(linked.targeting, /obj/effect/overmap/visitable))
			var/obj/effect/overmap/visitable/V = linked.targeting
			if(length(V.map_z) > 1)
				data["show_z_list"] = TRUE
				if(length(V.map_z) > 1)
					var/list/string_z_levels = list()
					for(var/z in V.map_z)
						string_z_levels += "[z]"
					data["z_levels"] = string_z_levels
				else
					selected_z = 0
					data["selected_z"] = 0
			var/obj/effect/entry_point = selected_entrypoint
			if(istype(entry_point) && entry_point.z)
				data["entry_point_map_image"] = SSholomap.minimaps_scan_base64[entry_point.z]
				data["entry_point_x"] = entry_point.x
				data["entry_point_y"] = entry_point.y
		data["entry_points"] = copy_entrypoints(selected_z)
		if(cannon)
			data["cannon"] = get_gun_data(cannon);
	else
		data["targeting"] = null
	return data

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
				LM = selected_entrypoint
			var/result = cannon.firing_command(linked.targeting, LM, platform_direction ? text2dir(platform_direction) : 0)
			if(isliving(usr) && !isAI(usr) && usr.Adjacent(src))
				visible_message(SPAN_WARNING("[usr] presses the fire button!"))
				playsound(src, 'sound/machines/compbeep1.ogg', 60)
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
			var/our_entrypoint = params["entrypoint"]
			if(our_entrypoint == SHIP_HAZARD_TARGET)
				selected_entrypoint = our_entrypoint
			else
				selected_entrypoint = names_to_entries[our_entrypoint]
			. = TRUE

		if("select_gun")
			if(!params["gun"])
				return
			var/gun_name = lowertext(params["gun"])
			for(var/obj/machinery/ship_weapon/SW in linked.ship_weapons)
				if(lowertext(SW.name) == gun_name)
					cannon = SW
					. = TRUE

		if("select_z")
			if(!params["z"])
				return
			selected_z = text2num(params["z"])
			. = TRUE

		if("platform_direction")
			if(!params["dir"])
				return
			platform_direction = text2num(params["dir"])
			. = TRUE

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
	)

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
