/**********************Mineral stacking unit console**************************/

/obj/machinery/mineral/stacking_unit_console
	name = "stacking machine console"
	icon = 'icons/obj/machines/mining_machines.dmi'
	icon_state = "console"
	density = FALSE
	anchored = TRUE
	var/obj/machinery/mineral/stacking_machine/machine
	use_power = 1
	idle_power_usage = 15
	active_power_usage = 50

/obj/machinery/mineral/stacking_unit_console/proc/setup_machine(mob/user)
	if(!machine)
		var/area/A = get_area(src)
		var/best_distance = INFINITY
		for(var/obj/machinery/mineral/stacking_machine/checked_machine in SSmachinery.all_machines)
			if(A == get_area(checked_machine) && get_dist_euclidian(checked_machine,src) < best_distance)
				machine = checked_machine
				best_distance = get_dist_euclidian(checked_machine,src)
		if(machine)
			machine.console = src
		else
			to_chat(user, SPAN_WARNING("ERROR: Linked machine not found!"))

	return machine

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
			var/obj/item/stack/material/S = new stacktype(get_turf(machine.output))
			S.amount = machine.stack_storage[stacktype]
			machine.stack_storage[stacktype] = 0
			return TRUE

	add_fingerprint(usr)

/**********************Mineral stacking unit**************************/


/obj/machinery/mineral/stacking_machine
	name = "stacking machine"
	icon = 'icons/obj/machines/mining_machines.dmi'
	icon_state = "stacker"
	density = TRUE
	anchored = TRUE
	var/obj/machinery/mineral/stacking_unit_console/console
	var/obj/machinery/mineral/input
	var/obj/machinery/mineral/output
	var/list/stack_storage = list()
	var/list/stack_paths = list()
	var/stack_amt = 50 // Amount to stack before releasing
	use_power = 1
	idle_power_usage = 15
	active_power_usage = 50

/obj/machinery/mineral/stacking_machine/Initialize()
	. = ..()

	for(var/stacktype in subtypesof(/obj/item/stack/material) - typesof(/obj/item/stack/material/cyborg))
		var/obj/item/stack/S = stacktype
		stack_storage[stacktype] = 0
		stack_paths[stacktype] = capitalize(initial(S.name))

	for(var/dir in cardinal)
		input = locate(/obj/machinery/mineral/input, get_step(src, dir))
		if(input)
			break

	for(var/dir in cardinal)
		output = locate(/obj/machinery/mineral/output, get_step(src, dir))
		if(output)
			break

/obj/machinery/mineral/stacking_machine/machinery_process()
	..()
	if(!console)
		return

	if(output && input)
		var/turf/T = get_turf(input)
		for(var/obj/item/O in T)
			if(!O)
				return
			var/obj/item/stack/S = O
			if(istype(S) && stack_storage[S.type] != null)
				stack_storage[S.type] += S.amount
				qdel(S)
			else
				O.forceMove(get_turf(output))

	//Output amounts that are past stack_amt.
	for(var/sheet in stack_storage)
		if(stack_storage[sheet] >= stack_amt)
			new sheet(get_turf(output), stack_amt)
			stack_storage[sheet] -= stack_amt
