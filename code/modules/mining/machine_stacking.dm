/**********************Mineral stacking unit console**************************/

/obj/machinery/mineralconsole/stacking_unit
	name = "stacking machine console"
	icon = 'icons/obj/machines/mining_machines.dmi'
	icon_state = "console"
	density = 0
	anchored = 1
	use_power = 1
	idle_power_usage = 15
	active_power_usage = 50
	component_types = list(
		/obj/item/weapon/circuitboard/stackerconsole
		)

/obj/machinery/mineralconsole/stacking_unit/proc/setup_machine(mob/user)
	if(!machine)
		var/obj/machinery/mineral/M
		for(var/obj/machinery/mineral/stacking_machine/checked_machine in orange(src))
			if(!M || get_dist_euclidian(src, checked_machine) < get_dist_euclidian(src, M))
				M = checked_machine
		if (M)
			LinkTo(M)
		else
			to_chat(user, "<span class='warning'>ERROR: Linked machine not found!</span>")

	return machine

/obj/machinery/mineralconsole/stacking_unit/attack_hand(mob/user)
	add_fingerprint(user)
	ui_interact(user)

/obj/machinery/mineralconsole/stacking_unit/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = 1, datum/topic_state/state = default_state)

	if(!setup_machine(user))
		return

	var/obj/machinery/mineral/stacking_machine/S = machine

	var/list/data = list(
		"stack_amt" = S.stack_amt,
		"contents" = list()
	)
	for (var/stacktype in S.stack_storage)
		if (S.stack_storage[stacktype] > 0)
			data["contents"] += list(list(
				"path" = stacktype,
				"name" = S.stack_paths[stacktype],
				"amount" = S.stack_storage[stacktype]
			))

	ui = SSnanoui.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "stacking_machine.tmpl", "Stacking Machine", 500, 400, state = state)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/mineralconsole/stacking_unit/Topic(href, href_list)
	if(..())
		return

	var/obj/machinery/mineral/stacking_machine/SM = machine

	if(href_list["change_stack"])
		var/choice = input("What would you like to set the stack amount to?") as null|anything in list(1,5,10,20,50)
		if(!choice)
			return TRUE
		SM.stack_amt = choice
		return TRUE

	if(href_list["release_stack"])
		var/stacktype = text2path(href_list["release_stack"])
		if (!stacktype || !SM.stack_paths[stacktype])
			return

		if(SM.stack_storage[stacktype] > 0)
			var/obj/item/stack/material/S = new stacktype(get_turf(SM.output))
			S.amount = SM.stack_storage[stacktype]
			SM.stack_storage[stacktype] = 0
			return TRUE

	add_fingerprint(usr)

/**********************Mineral stacking unit**************************/


/obj/machinery/mineral/stacking_machine
	name = "stacking machine"
	icon = 'icons/obj/machines/mining_machines.dmi'
	icon_state = "stacker"
	density = 1
	anchored = 1.0
	var/list/stack_storage = list()
	var/list/stack_paths = list()
	var/stack_amt = 50; // Amount to stack before releassing
	use_power = 1
	idle_power_usage = 15
	active_power_usage = 50
	component_types = list(
		/obj/item/weapon/circuitboard/stacker
		)

/obj/machinery/mineral/stacking_machine/Initialize()
	. = ..()

	for(var/stacktype in subtypesof(/obj/item/stack/material) - typesof(/obj/item/stack/material/cyborg))
		var/obj/item/stack/S = stacktype
		stack_storage[stacktype] = 0
		stack_paths[stacktype] = capitalize(initial(S.name))

	FindInOut()

/obj/machinery/mineral/stacking_machine/machinery_process()
	..()
	if(!console)
		return

	if (output && input)
		var/turf/T = get_turf(input)
		for(var/obj/item/O in T)
			if(!O) return
			var/obj/item/stack/S = O
			if(istype(S) && stack_storage[S.type] != null)
				stack_storage[S.type] += S.amount
				qdel(S)
			else
				O.forceMove(output.loc)

	//Output amounts that are past stack_amt.
	for(var/sheet in stack_storage)
		if(stack_storage[sheet] >= stack_amt)
			new sheet(get_turf(output), stack_amt)
			stack_storage[sheet] -= stack_amt

/obj/machinery/mineral/stacking_machine/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(default_deconstruction_screwdriver(user, W))
		return
	else if(default_deconstruction_crowbar(user, W))
		return