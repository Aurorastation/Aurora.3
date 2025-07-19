/*///////////////Circuit Imprinter (By Darem)////////////////////////
	Used to print new circuit boards (for computers and similar systems) and AI modules. Each circuit board pattern are stored in
a /datum/desgin on the linked R&D console. You can then print them out in a fasion similar to a regular lathe. However, instead of
using metal and glass, it uses glass and reagents (usually sulphuric acid).
*/

/obj/machinery/r_n_d/circuit_imprinter
	name = "circuit imprinter"
	desc = "An advanced device that can only be operated via a nearby RnD console, it can print any circuitboard the user requests, provided it has the correct materials to do so."
	icon_state = "circuit_imprinter"
	atom_flags = ATOM_FLAG_OPEN_CONTAINER

	idle_power_usage = 30
	active_power_usage = 2500

	component_types = list(
		/obj/item/circuitboard/circuit_imprinter,
		/obj/item/stock_parts/matter_bin,
		/obj/item/stock_parts/manipulator,
		/obj/item/reagent_containers/glass/beaker = 2
	)

	var/max_material_storage = 75000
	var/list/materials = list(DEFAULT_WALL_MATERIAL = 0, MATERIAL_GLASS = 0, MATERIAL_GOLD = 0, MATERIAL_SILVER = 0, MATERIAL_PHORON = 0, MATERIAL_URANIUM = 0, MATERIAL_DIAMOND = 0)

	/**
	 * A `/list` of enqueued `/datum/design` to be printed, processed in the queue
	 */
	var/list/datum/design/queue = list()

	/**
	 * How much efficient (or inefficient) the circuit imprinter is at manufacturing circuit boards
	 */
	var/mat_efficiency = 1

	/**
	 * The production speed of this specific circuit imprinter, a factor
	 */
	var/production_speed = 1

	///Boolean, if to make the printer spawn its product in a neighboring turf dictated by dir
	var/product_offset = FALSE

	///The timer id for the build callback, if we're building something
	var/build_callback_timer


/obj/machinery/r_n_d/circuit_imprinter/upgrade_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "Upgraded <b>matter bins</b> will increase material storage capacity."
	. += "Upgraded <b>manipulators</b> will improve material use efficiency and increase fabrication speed."

/obj/machinery/r_n_d/circuit_imprinter/RefreshParts()
	..()
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
	mat_efficiency = 1 - (T - 1) / 4
	production_speed = T

/obj/machinery/r_n_d/circuit_imprinter/update_icon()
	if(panel_open)
		icon_state = "circuit_imprinter_t"
	else if(build_callback_timer)
		icon_state = "circuit_imprinter_ani"
	else
		icon_state = "circuit_imprinter"

/obj/machinery/r_n_d/circuit_imprinter/proc/TotalMaterials()
	var/t = 0
	for(var/f in materials)
		t += materials[f]
	return t

/obj/machinery/r_n_d/circuit_imprinter/dismantle()
	for(var/obj/I in component_parts)
		// This will distribute all reagents amongst the contained beakers
		if(istype(I, /obj/item/reagent_containers/glass/beaker))
			reagents.trans_to_obj(I, reagents.total_volume)
	for(var/f in materials)
		if(materials[f] >= SHEET_MATERIAL_AMOUNT)
			var/path = getMaterialType(f)
			if(path)
				var/obj/item/stack/S = new path(loc)
				S.amount = round(materials[f] / SHEET_MATERIAL_AMOUNT)
	..()

/obj/machinery/r_n_d/circuit_imprinter/attackby(obj/item/attacking_item, mob/user)
	//No touch the machine while it's working!
	if(build_callback_timer)
		to_chat(user, SPAN_NOTICE("\The [src] is busy. Please wait for completion of previous operation."))
		return 1

	if(default_deconstruction_screwdriver(user, attacking_item))
		if(linked_console)
			linked_console.linked_imprinter = null
			linked_console = null
		return

	if(default_deconstruction_crowbar(user, attacking_item))
		return

	if(default_part_replacement(user, attacking_item))
		return

	if(panel_open)
		to_chat(user, SPAN_NOTICE("You can't load \the [src] while it's opened."))
		return 1

	if(!linked_console)
		to_chat(user, "\The [src] must be linked to an R&D console first.")
		return 1

	if(attacking_item.is_open_container())
		return 0

	if(!istype(attacking_item, /obj/item/stack/material))
		to_chat(user, SPAN_NOTICE("You cannot insert this item into \the [src]!"))
		return 1

	if(stat)
		return 1


	if(TotalMaterials() + SHEET_MATERIAL_AMOUNT > max_material_storage)
		to_chat(user, SPAN_NOTICE("\The [src]'s material bin is full. Please remove material before adding more."))
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
		to_chat(user, SPAN_NOTICE("\The [src] is too far away for you to insert this."))
		return
	if(amount <= 0)//No negative numbers
		return

	use_power_oneoff(max(1000, (SHEET_MATERIAL_AMOUNT * amount / 10)))
	if(do_after(user, 16))
		if(stack.use(amount))
			to_chat(user, SPAN_NOTICE("You add [amount] sheets to \the [src]."))
			materials[stack.default_type] += amount * SHEET_MATERIAL_AMOUNT

			//In case there's things queued up, we run the queue handler
			handle_queue()

	updateUsrDialog()

/**
 * Adds a design to the queue
 *
 * * design_to_add: The design to add
 */
/obj/machinery/r_n_d/circuit_imprinter/proc/addToQueue(datum/design/design_to_add)
	queue += design_to_add

	//Wake up, we have things to do
	handle_queue()


/**
 * Removes a design from the queue
 *
 * * index: The index of the design to remove
 */
/obj/machinery/r_n_d/circuit_imprinter/proc/removeFromQueue(index)
	queue.Cut(index, index + 1)

	//Wake up, we have things to do
	handle_queue()


/**
 * Handle the construction queue
 */
/obj/machinery/r_n_d/circuit_imprinter/proc/handle_queue()
	//No work to do or already busy, stop
	if(!length(queue) || build_callback_timer)
		update_icon()
		return

	//If there's no power, there's no building
	if(stat & NOPOWER)
		queue = list()
		return

	//Get the first design in the queue
	var/datum/design/D = queue[1]

	//If we can build it, process the request
	if(canBuild(D))
		build_callback_timer = addtimer(CALLBACK(src, PROC_REF(build), D), (D.time / production_speed), TIMER_UNIQUE)
		removeFromQueue(1)

	else
		visible_message(SPAN_NOTICE("[icon2html(src, viewers(get_turf(src)))] \The [src] flashes: insufficient materials: [getLackingMaterials(D)]."))

	update_icon()

/**
 * Checks if the protolathe can build the given design
 *
 * * design_to_check: The design to check
 *
 * Returns `TRUE` if the design can be built, `FALSE` otherwise
 */
/obj/machinery/r_n_d/circuit_imprinter/proc/canBuild(datum/design/design_to_check)
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
/obj/machinery/r_n_d/circuit_imprinter/proc/getLackingMaterials(datum/design/design_to_check)
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
/obj/machinery/r_n_d/circuit_imprinter/proc/build(datum/design/design_to_build)
	//Consume some power
	var/power = active_power_usage
	for(var/M in design_to_build.materials)
		power += round(design_to_build.materials[M] / 5)
	power = max(active_power_usage, power)
	use_power_oneoff(power)

	//Consume the materials
	for(var/M in design_to_build.materials)
		materials[M] = max(0, materials[M] - design_to_build.materials[M] * mat_efficiency)

	for(var/C in design_to_build.chemicals)
		reagents.remove_reagent(C, design_to_build.chemicals[C] * mat_efficiency)

	if(design_to_build.build_path)
		var/obj/new_item = design_to_build.Fabricate(src, src)
		if(product_offset)
			new_item.forceMove(get_step(src, dir))
		else
			new_item.forceMove(src.loc)
		if(mat_efficiency != 1) // No matter out of nowhere
			if(new_item.matter && new_item.matter.len > 0)
				for(var/i in new_item.matter)
					new_item.matter[i] = new_item.matter[i] * mat_efficiency

	//We finished building, clear the timer
	build_callback_timer = null

	//Do the queue handling for the next item, or to stop
	handle_queue()


/obj/machinery/r_n_d/circuit_imprinter/is_open_container()
	. = ..()

	//This is to recheck the queue when acid is added to the reagent container that we have
	//yes this should be done with signals, we don't have those signals yet
	//cope
	addtimer(CALLBACK(src, PROC_REF(handle_queue)), 1 SECOND, TIMER_UNIQUE)
