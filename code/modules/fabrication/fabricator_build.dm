/obj/machinery/fabricator/proc/update_current_build(spend_time)

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

/obj/machinery/fabricator/proc/start_building()
	if(!(fab_status_flags & FAB_BUSY) && is_functioning())
		fab_status_flags |= FAB_BUSY
		update_use_power(POWER_USE_ACTIVE)
		update_icon()

/obj/machinery/fabricator/proc/stop_building()
	if(fab_status_flags & FAB_BUSY)
		fab_status_flags &= ~FAB_BUSY
		update_use_power(POWER_USE_IDLE)
		update_icon()

/obj/machinery/fabricator/proc/get_next_build()
	currently_printing = null
	if(length(print_queue))
		currently_printing = print_queue[1]
		start_building()
	else
		stop_building()
	updateUsrDialog()

/obj/machinery/fabricator/proc/try_queue_build(singleton/fabricator_recipe/recipe, multiplier)

	// Do some basic sanity checking.
	if(!is_functioning() || !istype(recipe) || !(recipe in SSfabrication.get_recipes(fabricator_class)))
		return

	multiplier = sanitize_integer(multiplier, 1, 100, 1)
	if(!ispath(recipe.path, /obj/item/stack) && multiplier > 1)
		multiplier = 1

	// Check if sufficient resources exist.
	for(var/material in recipe.resources)
		if(stored_material[material] < round(recipe.resources[material] * mat_efficiency) * multiplier)
			return

	// Generate and track a new order.
	var/datum/fabricator_build_order/order = new
	order.remaining_time = recipe.build_time * multiplier
	order.target_recipe = recipe
	order.multiplier = multiplier
	print_queue += order

	// Remove/earmark resources.
	for(var/material in recipe.resources)
		var/removed_mat = round(recipe.resources[material] * mat_efficiency) * multiplier
		stored_material[material] = max(0, stored_material[material] - removed_mat)
		order.earmarked_materials[material] = removed_mat

	if(!currently_printing)
		get_next_build()
	else
		start_building()

/obj/machinery/fabricator/proc/try_cancel_build(datum/fabricator_build_order/order)
	if(istype(order) && currently_printing != order && is_functioning())
		if(order in print_queue)
			// Refund some mats.
			for(var/mat in order.earmarked_materials)
				stored_material[mat] = min(stored_material[mat] + (order.earmarked_materials[mat] * 0.9), storage_capacity[mat])
			print_queue -= order
		qdel(order)
