/**********************Mineral stacking unit console**************************/

/obj/machinery/mineral/stacking_unit_console
	name = "stacking machine console"
	desc = "This console allows you to set the max stack size for the stacking machine, as well as letting you eject stacks manually."
	icon = 'icons/obj/terminals.dmi'
	icon_state = "production_console"
	density = FALSE
	anchored = TRUE
	var/obj/machinery/mineral/stacking_machine/machine
	idle_power_usage = 15
	active_power_usage = 50

	component_types = list(
		/obj/item/circuitboard/stacking_console,
		/obj/item/stock_parts/scanning_module,
		/obj/item/stock_parts/console_screen
	)

/obj/machinery/mineral/stacking_unit_console/Initialize(mapload, d, populate_components)
	..()
	var/mutable_appearance/screen_overlay = mutable_appearance(icon, "production_console-screen", EFFECTS_ABOVE_LIGHTING_LAYER)
	add_overlay(screen_overlay)
	set_light(1.4, 1, COLOR_CYAN)
	return INITIALIZE_HINT_LATELOAD

/obj/machinery/mineral/stacking_unit_console/LateInitialize()
	setup_machine(null)

/obj/machinery/mineral/stacking_unit_console/Destroy()
	if(machine)
		machine.console = null
	return ..()

/obj/machinery/mineral/stacking_unit_console/proc/setup_machine(mob/user)
	if(!machine)
		var/area/A = get_area(src)
		var/best_distance = INFINITY
		for(var/obj/machinery/mineral/stacking_machine/checked_machine in SSmachinery.machinery)
			if(id)
				if(checked_machine.id == id)
					machine = checked_machine
			else if(!checked_machine.console && A == get_area(checked_machine) && get_dist_euclidian(checked_machine, src) < best_distance)
				machine = checked_machine
				best_distance = get_dist_euclidian(checked_machine, src)
		if(machine)
			machine.console = src
		else if(user)
			to_chat(user, SPAN_WARNING("ERROR: Linked machine not found!"))

	return machine

/obj/machinery/mineral/stacking_unit_console/attackby(obj/item/I, mob/user)
	if(default_deconstruction_screwdriver(user, I))
		return
	if(default_deconstruction_crowbar(user, I))
		return
	if(default_part_replacement(user, I))
		return
	return ..()

/obj/machinery/mineral/stacking_unit_console/attack_hand(mob/user)
	add_fingerprint(user)
	ui_interact(user)

/obj/machinery/mineral/stacking_unit_console/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = 1, datum/topic_state/state = default_state)
	if(!setup_machine(user))
		return

	var/list/data = list(
		"stack_amt" = machine.stack_amt,
		"contents" = list()
	)
	for(var/stacktype in machine.stack_storage)
		if(machine.stack_storage[stacktype] > 0)
			data["contents"] += list(list(
				"path" = stacktype,
				"name" = machine.stack_paths[stacktype],
				"amount" = machine.stack_storage[stacktype]
			))

	ui = SSnanoui.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "stacking_machine.tmpl", "Stacking Machine", 500, 400, state = state)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/mineral/stacking_unit_console/Topic(href, href_list)
	if(..())
		return

	if(href_list["change_stack"])
		var/choice = input("What would you like to set the stack amount to?") as null|anything in list(1,5,10,20,50)
		if(!choice)
			return TRUE
		machine.stack_amt = choice
		return TRUE

	if(href_list["release_stack"])
		var/stacktype = text2path(href_list["release_stack"])
		if(!stacktype || !machine.stack_paths[stacktype])
			return

		if(machine.stack_storage[stacktype] > 0)
			var/obj/item/stack/material/S = new stacktype(machine.output)
			S.amount = machine.stack_storage[stacktype]
			machine.stack_storage[stacktype] = 0
			return TRUE

	add_fingerprint(usr)

/**********************Mineral stacking unit**************************/


/obj/machinery/mineral/stacking_machine
	name = "stacking machine"
	desc = "A machine which takes loose stacks of finished sheets and packs them together into one easily transportable sheet."
	icon = 'icons/obj/machinery/mining_machines.dmi'
	icon_state = "stacker"
	density = TRUE
	anchored = TRUE
	var/obj/machinery/mineral/stacking_unit_console/console
	var/obj/machinery/mineral/input
	var/obj/machinery/mineral/output
	var/list/stack_storage = list()
	var/list/stack_paths = list()
	var/stack_amt = 50 // Amount to stack before releasing
	idle_power_usage = 15
	active_power_usage = 50

	component_types = list(
		/obj/item/circuitboard/stacking_machine,
		/obj/item/stock_parts/manipulator = 2
	)

/obj/machinery/mineral/stacking_machine/Initialize()
	. = ..()

	for(var/stacktype in subtypesof(/obj/item/stack/material) - typesof(/obj/item/stack/material/cyborg))
		var/obj/item/stack/S = stacktype
		stack_storage[stacktype] = 0
		stack_paths[stacktype] = capitalize(initial(S.name))

	//Locate our output and input machinery.
	for(var/dir in cardinal)
		var/input_spot = locate(/obj/machinery/mineral/input, get_step(src, dir))
		if(input_spot)
			input = get_turf(input_spot) // thought of qdeling the spots here, but it's useful when rebuilding a destroyed machine
			break
	for(var/dir in cardinal)
		var/output_spot = locate(/obj/machinery/mineral/output, get_step(src, dir))
		if(output)
			output = get_turf(output_spot)
			break

	if(!input)
		input = get_step(src, reverse_dir[dir])
	if(!output)
		output = get_step(src, dir)

/obj/machinery/mineral/stacking_machine/Destroy()
	if(console)
		console.machine = null
	return ..()

/obj/machinery/mineral/stacking_machine/attackby(obj/item/I, mob/user)
	if(default_deconstruction_screwdriver(user, I))
		return
	if(default_deconstruction_crowbar(user, I))
		return
	if(default_part_replacement(user, I))
		return
	return ..()

/obj/machinery/mineral/stacking_machine/process()
	if(!console)
		return
	if(stat & BROKEN)
		return
	if(stat & NOPOWER)
		return

	if(output && input)
		for(var/obj/item/O in input)
			if(!O)
				return
			var/obj/item/stack/S = O
			if(istype(S) && stack_storage[S.type] != null)
				stack_storage[S.type] += S.amount
				qdel(S)
			else
				O.forceMove(output)

	//Output amounts that are past stack_amt.
	for(var/sheet in stack_storage)
		if(stack_storage[sheet] >= stack_amt)
			new sheet(output, stack_amt)
			stack_storage[sheet] -= stack_amt
			intent_message(MACHINE_SOUND)
