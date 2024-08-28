/obj/machinery/fabricator
	name = "autolathe"
	desc = "A large device loaded with various item schematics. It produces common day to day items from a variety of materials."
	icon = 'icons/obj/machinery/fabricators/autolathe.dmi'
	icon_state = "autolathe"
	density = TRUE
	anchored = TRUE
	use_power = POWER_USE_IDLE
	idle_power_usage = 10
	active_power_usage = 2000
	clicksound = /singleton/sound_category/keyboard_sound
	clickvol = 30
	manufacturer = "hephaestus"

	/// What location to print to. Only used for mounted autolathes
	var/atom/print_loc

	/// Class of fabricator. Determines recipes loaded. See entires in [__fabricator_defines.dm]
	var/fabricator_class = FABRICATOR_CLASS_GENERAL
	/// List of stored materials.
	var/list/stored_material = list()
	/// List of material capacities. Should not be modified directly, use [var/list/base_storage_capacity] instead.
	var/list/storage_capacity = list()
	/// Base storage capacity, which is modified by default by the amount and tier of matter bins.
	var/list/base_storage_capacity = list(
		DEFAULT_WALL_MATERIAL = 25000,
		MATERIAL_ALUMINIUM = 25000,
		MATERIAL_GLASS = 12500,
		MATERIAL_PLASTIC = 12500
	)
	/// Current category to show for this fabricator
	var/show_category = "All"

	/// Status bitflags for the fabricator
	var/fab_status_flags = 0

	/// Current queue for this fabricator
	var/list/print_queue = list()
	/// What is currently printing in this fabricator
	var/datum/fabricator_build_order/currently_printing

	/// How efficient this fabricator uses materials. Modified by default by the amount and tier of manipulators
	var/mat_efficiency = 1
	/// What to multiply build times by. Modified by default by the amount and tier of manipulators
	var/build_time_multiplier = 1

	/// Snowflake for mounted autolathes
	var/does_flick = TRUE

	/// The fabricator's wires
	var/datum/wires/fabricator/wires

	component_types = list(
		/obj/item/circuitboard/autolathe,
		/obj/item/stock_parts/matter_bin = 3,
		/obj/item/stock_parts/manipulator,
		/obj/item/stock_parts/console_screen
	)

/obj/machinery/fabricator/Initialize()
	..()
	wires = new(src)
	print_loc = src
	stored_material = list()
	for(var/mat in base_storage_capacity)
		stored_material[mat] = 0

		// Update global type to string cache.
		if(!stored_substances_to_names[mat])
			if(ispath(mat, /material))
				var/material/mat_instance = mat
				mat_instance = SSmaterials.get_material_by_name(initial(mat_instance.name))
				if(istype(mat_instance))
					stored_substances_to_names[mat] = mat_instance.display_name
			else if(ispath(mat, /singleton/reagent))
				var/singleton/reagent/reg = mat
				stored_substances_to_names[mat] = initial(reg.name)

/obj/machinery/fabricator/Destroy()
	print_loc = null
	QDEL_NULL(currently_printing)
	QDEL_NULL(wires)

	QDEL_LIST(print_queue)

	return ..()

/obj/machinery/fabricator/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Autolathe", capitalize_first_letters(name))
		ui.open()

/obj/machinery/fabricator/ui_data(mob/user)
	. = ..()
	var/list/data = list()
	data["manufacturer"] = manufacturer
	data["disabled"] = (fab_status_flags & FAB_DISABLED)
	data["material_efficiency"] = mat_efficiency
	data["materials"] = list()
	data["categories"] = SSfabrication.get_categories(fabricator_class)|"All"
	data["build_time"] = currently_printing?.remaining_time
	for(var/material in stored_material)
		data["materials"] += list(list("material" = material, "stored" = stored_material[material], "max_capacity" = storage_capacity[material]))
	data["recipes"] = list()
	for(var/recipe in SSfabrication.get_recipes(fabricator_class))
		var/singleton/fabricator_recipe/R = recipe
		if(R.hack_only && !(fab_status_flags & FAB_HACKED))
			continue
		var/list/recipe_data = list()
		recipe_data["name"] = R.name
		recipe_data["recipe"] = R.type
		recipe_data["security_level"] = R.security_level ? capitalize(num2seclevel(R.security_level)) : "None"
		recipe_data["hack_only"] = R.hack_only
		recipe_data["enabled"] = can_print_item(R)
		var/list/resources = list()
		for(var/resource in R.resources)
			resources += "[R.resources[resource] * mat_efficiency] [resource]"
			recipe_data["sheets"] = stored_material[resource]/round(R.resources[resource]*mat_efficiency)
			recipe_data["can_make"] = !isnull(stored_material[resource]) && stored_material[resource] < round(R.resources[resource]*mat_efficiency)
		recipe_data["category"] = R.category
		recipe_data["resources"] = english_list(resources)
		recipe_data["build_time"] = (R.build_time / 10)
		recipe_data["max_sheets"] = null
		if(R.is_stack)
			var/obj/item/stack/R_stack = R.path
			recipe_data["max_sheets"] = initial(R_stack.max_amount)
		data["recipes"] += list(recipe_data)

	data["currently_printing"] = null
	if(currently_printing)
		data["currently_printing"] = "\ref[currently_printing]"
	data["queue"] = list()
	for(var/datum/fabricator_build_order/AR in print_queue)
		data["queue"] += list(
			list(
				"ref" = REF(AR),
				"order" = AR.target_recipe.name,
				"path" = AR.target_recipe.type,
				"multiplier" = AR.multiplier,
				"build_time" = AR.target_recipe.build_time,
				"progress" = AR.target_recipe.build_time - AR.remaining_time,
				"remaining_time" = AR.remaining_time
			)
		)
	return data

/obj/machinery/fabricator/attackby(obj/item/attacking_item, mob/user)
	if(fab_status_flags & FAB_BUSY)
		to_chat(user, SPAN_NOTICE("\The [src] is busy. Please wait for the completion of previous operation."))
		return TRUE

	if(default_deconstruction_screwdriver(user, attacking_item))
		SStgui.update_uis(src)
		return TRUE
	if(default_deconstruction_crowbar(user, attacking_item))
		return TRUE
	if(default_part_replacement(user, attacking_item))
		return TRUE

	if(stat)
		return TRUE

	if(panel_open)
		//Don't eat multitools or wirecutters used on an open lathe.
		if(attacking_item.ismultitool() || attacking_item.iswirecutter())
			if(panel_open)
				wires.interact(user)
			else
				to_chat(user, SPAN_WARNING("\The [src]'s wires aren't exposed."))
			return TRUE

	if(attacking_item.loc != user && !istype(attacking_item, /obj/item/stack))
		return FALSE

	if(is_robot_module(attacking_item))
		return FALSE

	load_lathe(attacking_item, user)
	return TRUE

/obj/machinery/fabricator/attack_hand(mob/user)
	user.set_machine(src)
	ui_interact(user)

///
/obj/machinery/fabricator/proc/is_functioning()
	. = use_power != POWER_USE_OFF && !(fab_status_flags & FAB_DISABLED)

/obj/machinery/fabricator/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	usr.set_machine(src)
	add_fingerprint(usr)

	playsound(src, /singleton/sound_category/keyboard_sound, 50)

	if(action == "make")
		var/multiplier = text2num(params["multiplier"])
		var/singleton/fabricator_recipe/R = GET_SINGLETON(text2path(params["recipe"]))
		if(!istype(R))
			CRASH("Unknown recipe given! [R], param is [params["recipe"]].")

		intent_message(MACHINE_SOUND)

		try_queue_build(R, multiplier)

		. = TRUE

	if(action == "remove")
		var/datum/fabricator_build_order/order = locate(params["ref"])
		try_cancel_build(order)
		. = TRUE

/obj/machinery/fabricator/process(seconds_per_tick)
	..()
	if(use_power == POWER_USE_ACTIVE && (fab_status_flags & FAB_BUSY))
		update_current_build(seconds_per_tick)

/obj/machinery/fabricator/update_icon()
	ClearOverlays()
	if(panel_open)
		AddOverlays("[icon_state]_panel")
	if(currently_printing)
		AddOverlays(emissive_appearance(icon, "[icon_state]_lights_working"))
		AddOverlays("[icon_state]_lights_working")
		AddOverlays("[icon_state]_process")
	else if (powered())
		AddOverlays(emissive_appearance(icon, "[icon_state]_lights"))
		AddOverlays("[icon_state]_lights")

/obj/machinery/fabricator/proc/remove_mat_overlay(mat_overlay)
	CutOverlays(mat_overlay)
	update_icon()

//Updates overall lathe storage size.
/obj/machinery/fabricator/RefreshParts()
	..()
	var/mb_rating = 0
	var/man_rating = 0
	for(var/obj/item/stock_parts/matter_bin/MB in component_parts)
		mb_rating += MB.rating
	for(var/obj/item/stock_parts/manipulator/M in component_parts)
		man_rating += M.rating
	for(var/mat in base_storage_capacity)
		storage_capacity[mat] = mb_rating * base_storage_capacity[mat]
	mat_efficiency = 1.1 - man_rating * 0.1 // Normally, price is 1.25 the amount of material, so this shouldn't go higher than 0.8. Maximum rating of parts is 3
	build_time_multiplier = initial(build_time_multiplier) * man_rating

/obj/machinery/fabricator/dismantle()
	for(var/mat in stored_material)
		var/material/M = SSmaterials.get_material_by_name(mat)
		if(!istype(M))
			continue
		var/obj/item/stack/material/S = new M.stack_type(get_turf(src))
		if(stored_material[mat] > S.perunit)
			S.amount = round(stored_material[mat] / S.perunit)
		else
			qdel(S)
	..()
	return TRUE

/obj/machinery/fabricator/mounted
	name = "\improper mounted autolathe"
	density = FALSE
	anchored = FALSE
	idle_power_usage = FALSE
	active_power_usage = FALSE
	interact_offline = TRUE
	does_flick = FALSE

/obj/machinery/fabricator/mounted/ui_state(mob/user)
	return GLOB.heavy_vehicle_state
