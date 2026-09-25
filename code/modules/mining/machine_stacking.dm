/**********************Mineral stacking unit console**************************/

/obj/structure/machinery/mineral/stacking_unit_console
	name = "stacking machine console"
	desc = "This console allows you to set the max stack size for the stacking machine, as well as letting you eject stacks manually."
	icon = 'icons/obj/machinery/wall/terminals.dmi'
	icon_state = "production_console"
	density = FALSE
	anchored = TRUE
	var/obj/structure/machinery/mineral/stacking_machine/machine
	idle_power_usage = 15
	active_power_usage = 50

	component_types = list(
		/obj/item/circuitboard/stacking_console,
		/obj/item/stock_parts/scanning_module,
		/obj/item/stock_parts/console_screen
	)

/obj/structure/machinery/mineral/stacking_unit_console/Initialize(mapload, d, populate_components)
	..()
	var/mutable_appearance/screen_overlay = mutable_appearance(icon, "production_console-screen", plane = ABOVE_LIGHTING_PLANE)
	AddOverlays(screen_overlay)
	set_light(1.4, 1, COLOR_CYAN)
	return INITIALIZE_HINT_LATELOAD

/obj/structure/machinery/mineral/stacking_unit_console/LateInitialize()
	. = ..()
	setup_machine(null)

/obj/structure/machinery/mineral/stacking_unit_console/Destroy()
	if(machine)
		machine.console = null
	return ..()

/obj/structure/machinery/mineral/stacking_unit_console/proc/setup_machine(mob/user)
	if(!machine)
		var/area/machine_area = get_area(src)
		var/best_distance = INFINITY
		for(var/obj/structure/machinery/mineral/stacking_machine/checked_machine in SSmachinery.machinery)
			if(id)
				if(checked_machine.id == id)
					machine = checked_machine
			else if(!checked_machine.console && machine_area == get_area(checked_machine) && get_dist_euclidian(checked_machine, src) < best_distance)
				machine = checked_machine
				best_distance = get_dist_euclidian(checked_machine, src)
		if(machine)
			machine.console = src
		else if(user)
			to_chat(user, SPAN_WARNING("ERROR: Linked machine not found!"))

	return machine

/obj/structure/machinery/mineral/stacking_unit_console/attackby(obj/item/attacking_item, mob/user)
	if(default_deconstruction_screwdriver(user, attacking_item))
		return
	if(default_deconstruction_crowbar(user, attacking_item))
		return
	if(default_part_replacement(user, attacking_item))
		return
	return ..()

/obj/structure/machinery/mineral/stacking_unit_console/attack_hand(mob/user)
	add_fingerprint(user)
	ui_interact(user)

/obj/structure/machinery/mineral/stacking_unit_console/ui_interact(mob/user, datum/tgui/ui)
	if(!setup_machine(user))
		return
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "StackingMachine", "Stacking Machine")
		ui.open()

/obj/structure/machinery/mineral/stacking_unit_console/ui_data(mob/user)
	if(!machine)
		return list()
	var/list/data = list(
		"stack_amt" = machine.stack_amt,
		"contents" = list()
	)
	for(var/stacktype in machine.stack_storage)
		if(machine.stack_storage[stacktype] > 0)
			data["contents"] += list(list(
				"path" = "[stacktype]",
				"name" = machine.stack_paths[stacktype],
				"amount" = machine.stack_storage[stacktype]
			))
	return data

/obj/structure/machinery/mineral/stacking_unit_console/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	if(!machine)
		return

	switch(action)
		if("change_stack")
			var/choice = tgui_input_list(usr, "What would you like to set the stack amount to?", "Stacking", list(1,5,10,20,50))
			if(!choice)
				return TRUE
			machine.stack_amt = choice
			return TRUE

		if("release_stack")
			var/stacktype = text2path(params["path"])
			if(!stacktype || !machine.stack_paths[stacktype])
				return
			if(machine.stack_storage[stacktype] > 0)
				var/obj/item/stack/material/new_stack = new stacktype(machine.output_turf)
				new_stack.amount = machine.stack_storage[stacktype]
				machine.stack_storage[stacktype] = 0
				return TRUE

/**********************Mineral stacking unit**************************/


/obj/structure/machinery/mineral/stacking_machine
	name = "stacking machine"
	desc = "A machine which takes loose stacks of finished sheets and packs them together into one easily transportable sheet."
	icon = 'icons/obj/machinery/mining_machines.dmi'
	icon_state = "stacker"
	density = TRUE
	anchored = TRUE
	is_processing_machine = TRUE
	var/obj/structure/machinery/mineral/stacking_unit_console/console
	var/list/stack_storage = list()
	var/list/stack_paths = list()
	var/stack_amt = 50 // Amount to stack before releasing
	idle_power_usage = 15
	active_power_usage = 50

	component_types = list(
		/obj/item/circuitboard/stacking_machine,
		/obj/item/stock_parts/manipulator = 2
	)

/obj/structure/machinery/mineral/stacking_machine/Initialize()
	. = ..()

	for(var/stacktype in subtypesof(/obj/item/stack/material) - typesof(/obj/item/stack/material/cyborg))
		var/obj/item/stack/stack_item = stacktype
		stack_storage[stacktype] = 0
		stack_paths[stacktype] = capitalize(initial(stack_item.name))

	setup_io()

/obj/structure/machinery/mineral/stacking_machine/Destroy()
	if(console)
		console.machine = null
	return ..()

/obj/structure/machinery/mineral/stacking_machine/attackby(obj/item/attacking_item, mob/user)
	if(default_deconstruction_screwdriver(user, attacking_item))
		return
	if(default_deconstruction_crowbar(user, attacking_item))
		return
	if(default_part_replacement(user, attacking_item))
		return
	return ..()

/obj/structure/machinery/mineral/stacking_machine/process()
	if(!console)
		return
	if(stat & BROKEN)
		return
	if(stat & NOPOWER)
		return

	if(output_turf && input_turf)
		for(var/obj/item/item in input_turf)
			if(!item)
				return
			var/obj/item/stack/stack_item = item
			if(istype(stack_item) && stack_storage[stack_item.type] != null)
				stack_storage[stack_item.type] += stack_item.amount
				qdel(stack_item)
			else
				item.forceMove(output_turf)

	//Output amounts that are past stack_amt.
	for(var/sheet in stack_storage)
		if(stack_storage[sheet] >= stack_amt)
			new sheet(output_turf, stack_amt)
			stack_storage[sheet] -= stack_amt
			intent_message(MACHINE_SOUND)
