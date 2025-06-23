/obj/machinery/r_n_d/protolathe
	name = "protolathe"
	desc = "An upgraded variant of a common Autolathe, this can only be operated via a nearby RnD console, but can manufacture cutting edge technology, provided it has the design and the correct materials."
	icon_state = "protolathe"
	atom_flags = ATOM_FLAG_OPEN_CONTAINER

	idle_power_usage = 30 WATTS
	active_power_usage = 25 KILO WATTS

	var/max_material_storage = 100000
	var/list/materials = list(DEFAULT_WALL_MATERIAL = 0, MATERIAL_GLASS = 0, MATERIAL_GOLD = 0, MATERIAL_SILVER = 0, MATERIAL_PHORON = 0, MATERIAL_URANIUM = 0, MATERIAL_DIAMOND = 0)

	/**
	 * A `/list` of enqueued `/datum/design` to be printed, processed in the queue
	 */
	var/list/datum/design/queue = list()

	/**
	 * How much efficient (or inefficient) the protolathe is at manufacturing things
	 */
	var/mat_efficiency = 1

	/**
	 * The production speed of this specific protolathe, a factor
	 */
	var/production_speed = 1

	///The timer id for the build callback, if we're building something
	var/build_callback_timer

	component_types = list(
		/obj/item/circuitboard/protolathe,
		/obj/item/stock_parts/matter_bin = 2,
		/obj/item/stock_parts/manipulator = 2,
		/obj/item/reagent_containers/glass/beaker = 2
	)

///Returns the total of all the stored materials
/obj/machinery/r_n_d/protolathe/proc/TotalMaterials()
	var/t = 0
	for(var/f in materials)
		t += materials[f]
	return t

/obj/machinery/r_n_d/protolathe/RefreshParts()
	// Adjust reagent container volume to match combined volume of the inserted beakers
	var/T = 0
	for(var/obj/item/reagent_containers/glass/G in component_parts)
		T += G.reagents.maximum_volume
	create_reagents(T)
	// Transfer all reagents from the beakers to internal reagent container
	for(var/obj/item/reagent_containers/glass/G in component_parts)
		G.reagents.trans_to_obj(src, G.reagents.total_volume)

	// Adjust material storage capacity to scale with matter bin rating
	max_material_storage = 0
	for(var/obj/item/stock_parts/matter_bin/M in component_parts)
		max_material_storage += M.rating * 75000

	// Adjust production speed to increase with manipulator rating
	T = 0
	for(var/obj/item/stock_parts/manipulator/M in component_parts)
		T += M.rating
	mat_efficiency = 1 - (T - 2) / 8
	production_speed = T / 2
	update_icon()

/obj/machinery/r_n_d/protolathe/dismantle()
	for(var/obj/I in component_parts)
		if(istype(I, /obj/item/reagent_containers/glass/beaker))
			reagents.trans_to_obj(I, reagents.total_volume)
	for(var/f in materials)
		if(materials[f] >= SHEET_MATERIAL_AMOUNT)
			var/path = getMaterialType(f)
			if(path)
				var/obj/item/stack/S = new path(loc)
				S.amount = round(materials[f] / SHEET_MATERIAL_AMOUNT)
	..()

/obj/machinery/r_n_d/protolathe/power_change()
	. = ..()
	update_icon()

/obj/machinery/r_n_d/protolathe/update_icon()
	ClearOverlays()
	if(panel_open)
		AddOverlays("[icon_state]_panel")
	if(!(stat & (NOPOWER|BROKEN)))
		AddOverlays(emissive_appearance(icon, "[icon_state]_lights"))
		AddOverlays("[icon_state]_lights")
	if(build_callback_timer)
		AddOverlays("[icon_state]_working")
		AddOverlays(emissive_appearance(icon, "[icon_state]_lights_working"))
		AddOverlays("[icon_state]_lights_working")

/obj/machinery/r_n_d/protolathe/attackby(obj/item/attacking_item, mob/user)
	if(build_callback_timer)
		to_chat(user, SPAN_NOTICE("\The [src] is busy. Please wait for completion of previous operation."))
		return 1
	if(default_deconstruction_screwdriver(user, attacking_item))
		if(linked_console)
			linked_console.linked_lathe = null
			linked_console = null
		return
	if(default_deconstruction_crowbar(user, attacking_item))
		return
	if(default_part_replacement(user, attacking_item))
		return
	if(attacking_item.is_open_container())
		return 1
	if(panel_open)
		to_chat(user, SPAN_NOTICE("You can't load \the [src] while it's opened."))
		return 1
	if(!linked_console)
		to_chat(user, SPAN_NOTICE("The [src] must be linked to an R&D console first!"))
		return 1
	if(!istype(attacking_item, /obj/item/stack/material))
		to_chat(user, SPAN_NOTICE("You cannot insert this item into \the [src]!"))
		return 1
	if(stat)
		return 1

	if(TotalMaterials() + SHEET_MATERIAL_AMOUNT > max_material_storage)
		to_chat(user, SPAN_NOTICE("The [src]'s material bin is full. Please remove material before adding more."))
		return 1

	var/obj/item/stack/material/stack = attacking_item
	if(!stack.default_type)
		to_chat(user, SPAN_WARNING("This stack cannot be used!"))
		return

	var/max_value = min(stack.get_amount(), round((max_material_storage - TotalMaterials()) / SHEET_MATERIAL_AMOUNT))
	var/amount = tgui_input_number(user, "How many sheets do you want to add?", "Add sheets", min(10, max_value), max_value = max_value, min_value = 1, round_value = TRUE)

	if(!attacking_item)
		return
	if(!Adjacent(user))
		to_chat(user, SPAN_NOTICE("The [src] is too far away for you to insert this."))
		return
	if(amount <= 0)//No negative numbers, no nulls
		return

	var/mutable_appearance/M = mutable_appearance(icon, "material_insertion")
	M.color = stack.material.icon_colour
	//first play the insertion animation
	flick_overlay_view(M, 1 SECONDS)

	//now play the progress bar animation
	flick_overlay_view(mutable_appearance(icon, "protolathe_progress"), 1 SECONDS)

	//Use some power and add the materials
	use_power_oneoff(max(1000, (SHEET_MATERIAL_AMOUNT * amount / 10)))
	if(do_after(user, 1.6 SECONDS))
		if(stack.use(amount))
			if(amount>1)
				to_chat(user, SPAN_NOTICE("You add [amount] [stack.material.sheet_plural_name] of [stack.material.name] to \the [src]."))
			else
				to_chat(user, SPAN_NOTICE("You add [amount] [stack.material.sheet_singular_name] of [stack.material.name] to \the [src]."))
			materials[stack.default_type] += amount * SHEET_MATERIAL_AMOUNT

			//In case there's things queued up, we run the queue handler
			handle_queue()

	//Give an update on the UIs
	updateUsrDialog()
	if(linked_console)
		linked_console.updateUsrDialog()

/**
 * Adds a design to the queue
 *
 * * design_to_add: The design to add
 */
/obj/machinery/r_n_d/protolathe/proc/addToQueue(datum/design/design_to_add)
	queue += design_to_add

	//Wake up, we have things to do
	handle_queue()

/**
 * Removes a design from the queue
 *
 * * index: The index of the design to remove
 */
/obj/machinery/r_n_d/protolathe/proc/removeFromQueue(index)
	queue.Cut(index, index + 1)

	//Wake up, we have things to do
	handle_queue()

/**
 * Handle the construction queue
 */
/obj/machinery/r_n_d/protolathe/proc/handle_queue()

	//No work to do or already busy, stop
	if(!length(queue) || build_callback_timer)
		update_icon()
		return

	//If there's no power, there's no building
	if(stat & NOPOWER)
		queue = list()
		update_icon()
		return

	//Get the first design in the queue
	var/datum/design/D = queue[1]

	//If we can build it, process the request
	if(canBuild(D))
		build_callback_timer = addtimer(CALLBACK(src, PROC_REF(build), D), (D.time / production_speed), TIMER_UNIQUE)
		removeFromQueue(1)

	else
		visible_message(SPAN_NOTICE("[icon2html(src, viewers(get_turf(src)))] \The [src] flashes: Insufficient materials: [getLackingMaterials(D)]."))

	update_icon()


/**
 * Checks if the protolathe can build the given design
 *
 * * design_to_check: The design to check
 *
 * Returns `TRUE` if the design can be built, `FALSE` otherwise
 */
/obj/machinery/r_n_d/protolathe/proc/canBuild(datum/design/design_to_check)
	for(var/M in design_to_check.materials)
		if(materials[M] < design_to_check.materials[M])
			return FALSE

	for(var/C in design_to_check.chemicals)
		if(!reagents.has_reagent(C, design_to_check.chemicals[C]))
			return FALSE

	return TRUE

/**
 * Get what materials (chemicals included) are lacking from being able to build the given design
 *
 * * design_to_check: The design to check
 *
 * Returns a string of the materials that are missing
 */
/obj/machinery/r_n_d/protolathe/proc/getLackingMaterials(var/datum/design/design_to_check)
	var/ret = ""
	for(var/M in design_to_check.materials)
		if(materials[M] < design_to_check.materials[M])
			if(ret != "")
				ret += ", "
			ret += "[design_to_check.materials[M] - materials[M]] [M]"
	for(var/C in design_to_check.chemicals)
		if(!reagents.has_reagent(C, design_to_check.chemicals[C]))
			var/singleton/reagent/R = GET_SINGLETON(C)
			if(ret != "")
				ret += ", "
			ret += "[R.name]"
	return ret

/**
 * Builds the given design, assuming all the necessary conditions are met
 *
 * * design_to_build: The design to build
 */
/obj/machinery/r_n_d/protolathe/proc/build(datum/design/design_to_build)
	//Consume some power
	var/power = active_power_usage
	for(var/M in design_to_build.materials)
		power += round(design_to_build.materials[M] / 2)
	power = max(active_power_usage, power)
	use_power_oneoff(power)

	//Consume the materials
	for(var/M in design_to_build.materials)
		materials[M] = max(0, materials[M] - design_to_build.materials[M] * mat_efficiency)
	for(var/C in design_to_build.chemicals)
		reagents.remove_reagent(C, design_to_build.chemicals[C] * mat_efficiency)

	intent_message(MACHINE_SOUND)

	if(design_to_build.build_path)
		var/obj/new_item = design_to_build.Fabricate(src, src)
		new_item.forceMove(loc)
		if(mat_efficiency != 1) // No matter out of nowhere
			if(new_item.matter && new_item.matter.len > 0)
				for(var/i in new_item.matter)
					new_item.matter[i] = new_item.matter[i] * mat_efficiency

	if(linked_console)
		linked_console.updateUsrDialog()

	//We finished building, clear the timer
	build_callback_timer = null

	//Do the queue handling for the next item, or to stop
	handle_queue()
