/**********************Mineral stacking unit console**************************/

/obj/machinery/mineral/stacking_unit_console
	name = "stacking machine console"
	icon = 'icons/obj/machines/mining_machines.dmi'
	icon_state = "console"
	density = 1
	anchored = 1
	var/obj/machinery/mineral/stacking_machine/machine = null
	var/machinedir = NORTHEAST
	use_power = 1
	idle_power_usage = 15
	active_power_usage = 50

/obj/machinery/mineral/stacking_unit_console/Initialize()
	. = ..()
	src.machine = locate(/obj/machinery/mineral/stacking_machine, get_step(src, machinedir))
	if (machine)
		machine.console = src
	else
		return INITIALIZE_HINT_QDEL

/obj/machinery/mineral/stacking_unit_console/attack_hand(mob/user)
	add_fingerprint(user)
	ui_interact(user)

/obj/machinery/mineral/stacking_unit_console/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = 1, datum/topic_state/state = default_state)
	var/list/data = list(
		"stack_amt" = machine.stack_amt,
		"contents" = list()
	)
	for (var/stacktype in machine.stack_storage)
		if (machine.stack_storage[stacktype] > 0)
			data["contents"] += list(list(
				"path" = stacktype,
				"name" = machine.stack_paths[stacktype],
				"amount" = machine.stack_storage[stacktype]
			))

	ui = SSnanoui.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
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
		if (!stacktype || !machine.stack_paths[stacktype])
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
	density = 1
	anchored = 1.0
	var/obj/machinery/mineral/stacking_unit_console/console
	var/obj/machinery/mineral/input = null
	var/obj/machinery/mineral/output = null
	var/list/stack_storage = list()
	var/list/stack_paths = list()
	var/stack_amt = 50; // Amount to stack before releassing
	use_power = 1
	idle_power_usage = 15
	active_power_usage = 50

/obj/machinery/mineral/stacking_machine/Initialize()
	. = ..()

	for(var/stacktype in subtypesof(/obj/item/stack/material) - typesof(/obj/item/stack/material/cyborg))
		var/obj/item/stack/S = stacktype
		stack_storage[stacktype] = 0
		stack_paths[stacktype] = capitalize(initial(S.name))

	for (var/dir in cardinal)
		input = locate(/obj/machinery/mineral/input, get_step(src, dir))
		if(input)
			break

	for (var/dir in cardinal)
		output = locate(/obj/machinery/mineral/output, get_step(src, dir))
		if(output)
			break

/obj/machinery/mineral/stacking_machine/machinery_process()
	..()
	if(!console)
		log_debug("Stacking machine tried to process, but no console has linked itself to it.")
		qdel(src)
		return

	if (output && input)
		var/turf/T = get_turf(input)
		for(var/obj/item/O in T)
			if(!O) return
			if(istype(O, /obj/item/stack) && stack_storage[O.type] != null)
				stack_storage[O.type]++
				qdel(O)
			else
				O.forceMove(output.loc)

	//Output amounts that are past stack_amt.
	for(var/sheet in stack_storage)
		if(stack_storage[sheet] >= stack_amt)
			new sheet(get_turf(output), stack_amt)
			stack_storage[sheet] -= stack_amt
