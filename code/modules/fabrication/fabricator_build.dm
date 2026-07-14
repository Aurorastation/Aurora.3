///Processes the current build, incrementing its remaining time and handling removing it from the print queue
/obj/structure/machinery/fabricator/proc/update_current_build(spend_time)

	if(!istype(currently_printing) || !is_functioning())
		return

	// Decrement our current build timer.
	currently_printing.remaining_time -= max(1, max(1, spend_time SECONDS * build_time_multiplier))
	if(currently_printing.remaining_time > 0)
		return

	// Print the item.
	var/obj/item/I = new currently_printing.target_recipe.path(get_turf(print_loc))
	I.Created()
	if(currently_printing.multiplier > 1 && istype(I, /obj/item/stack))
		var/obj/item/stack/S = I
		S.amount = currently_printing.multiplier
	print_queue -= currently_printing
	QDEL_NULL(currently_printing)
	get_next_build()
	update_icon()

/obj/structure/machinery/fabricator/proc/start_building()
	if(!(fab_status_flags & FAB_BUSY) && is_functioning())
		//Start the fabricator's looping sound
		if (fabricator_looping_sound == null)
			fabricator_looping_sound = new fabricating_sound_loop(src)
			fabricator_looping_sound.start()
		fab_status_flags |= FAB_BUSY
		update_use_power(POWER_USE_ACTIVE)
		update_icon()

/obj/structure/machinery/fabricator/proc/stop_building()
	fabricator_looping_sound.stop()
	QDEL_NULL(fabricator_looping_sound)
	if(fab_status_flags & FAB_BUSY)
		fab_status_flags &= ~FAB_BUSY
		update_use_power(POWER_USE_IDLE)
		update_icon()
		STOP_PROCESSING_MACHINE(src, MACHINERY_PROCESS_SELF)

/obj/structure/machinery/fabricator/proc/get_next_build()
	currently_printing = null
	if(length(print_queue))
		currently_printing = print_queue[1]
		start_building()
	else
		stop_building()
	SStgui.update_uis(src)

///Tries to build the next item in the fabricator's queue
/obj/structure/machinery/fabricator/proc/try_queue_build(singleton/fabricator_recipe/recipe, multiplier)

	// Do some basic sanity checking.
	if(!is_functioning() || !istype(recipe) || !(recipe in SSfabrication.get_recipes(fabricator_class)) || !can_print_item(recipe))
		return

	multiplier = sanitize_integer(multiplier, 1, 100, 1)
	if(!ispath(recipe.path, /obj/item/stack) && multiplier > 1)
		multiplier = 1

	normalize_material_storage()
	SSmaterials.normalize_material_amounts(recipe.resources)

	// Check if sufficient resources exist.
	for(var/material in recipe.resources)
		var/material_path = SSmaterials.material_to_path(material, FALSE)
		if(!material_path || isnull(stored_material[material_path]) || stored_material[material_path] < round(recipe.resources[material] * mat_efficiency) * multiplier)
			return

	// Generate and track a new order.
	var/datum/fabricator_build_order/order = new
	order.remaining_time = recipe.build_time * multiplier
	order.target_recipe = recipe
	order.multiplier = multiplier
	print_queue += order

	// Remove/earmark resources.
	for(var/material in recipe.resources)
		var/material_path = SSmaterials.material_to_path(material, FALSE)
		var/removed_mat = round(recipe.resources[material] * mat_efficiency) * multiplier
		SSmaterials.remove_material_amount(stored_material, material_path, removed_mat)
		order.earmarked_materials[material_path] = removed_mat

	if(!currently_printing)
		get_next_build()
	else
		start_building()

///Tries to cancel the build order
/obj/structure/machinery/fabricator/proc/try_cancel_build(datum/fabricator_build_order/order)
	if(istype(order) && currently_printing != order && is_functioning())
		if(order in print_queue)
			normalize_material_storage()
			SSmaterials.normalize_material_amounts(order.earmarked_materials)
			// Refund some mats.
			for(var/mat in order.earmarked_materials)
				var/material_path = SSmaterials.material_to_path(mat, FALSE)
				if(!material_path || isnull(stored_material[material_path]) || isnull(storage_capacity[material_path]))
					continue
				stored_material[material_path] = min(stored_material[material_path] + (order.earmarked_materials[mat] * 0.9), storage_capacity[material_path])
			print_queue -= order
		qdel(order)
		return TRUE
	return FALSE

///Determines whether the recipe is valid to print in this fabricator. Checks for hacked status and ship security levels.
/obj/structure/machinery/fabricator/proc/can_print_item(singleton/fabricator_recipe/recipe)
	var/ship_security_level = seclevel2num(get_security_level())
	var/is_on_ship = is_station_level(z) // since ship security levels are global FOR NOW, we'll ignore the alert check for offship fabricators

	if(!(fab_status_flags & FAB_HACKED))
		if(recipe.hack_only)
			return FALSE
		else if(is_on_ship && ship_security_level < recipe.security_level)
			return FALSE

	return TRUE
