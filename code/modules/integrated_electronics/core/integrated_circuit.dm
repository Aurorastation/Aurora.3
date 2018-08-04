/*
	Integrated circuits are essentially modular machines.  Each circuit has a specific function, and combining them inside Electronic Assemblies allows
a creative player the means to solve many problems.  Circuits are held inside an electronic assembly, and are wired using special tools.
*/

/obj/item/integrated_circuit/examine(mob/user)
	interact(user)
	external_examine(user)
	. = ..()

// This should be used when someone is examining while the case is opened.
/obj/item/integrated_circuit/proc/internal_examine(mob/user)
	to_chat(user, "This board has [inputs.len] input pin\s, [outputs.len] output pin\s and [activators.len] activation pin\s.")
	for(var/datum/integrated_io/I in inputs)
		if(I.linked.len)
			to_chat(user, "The '[I]' is connected to [I.get_linked_to_desc()].")
	for(var/datum/integrated_io/O in outputs)
		if(O.linked.len)
			to_chat(user, "The '[O]' is connected to [O.get_linked_to_desc()].")
	for(var/datum/integrated_io/activate/A in activators)
		if(A.linked.len)
			to_chat(user, "The '[A]' is connected to [A.get_linked_to_desc()].")
	any_examine(user)
	interact(user)

// This should be used when someone is examining from an 'outside' perspective, e.g. reading a screen or LED.
/obj/item/integrated_circuit/proc/external_examine(mob/user)
	any_examine(user)

/obj/item/integrated_circuit/proc/any_examine(mob/user)
	return

/obj/item/integrated_circuit/Initialize()
	displayed_name = name
	if(!size)
		size = w_class
	if(size == -1)
		size = 0
	setup_io(inputs, /datum/integrated_io, inputs_default)
	setup_io(outputs, /datum/integrated_io, outputs_default)
	setup_io(activators, /datum/integrated_io/activate)
	. = ..()

/obj/item/integrated_circuit/proc/on_data_written() //Override this for special behaviour when new data gets pushed to the circuit.
	return

/obj/item/integrated_circuit/Destroy()
	for(var/datum/integrated_io/I in inputs)
		qdel(I)
	for(var/datum/integrated_io/O in outputs)
		qdel(O)
	for(var/datum/integrated_io/A in activators)
		qdel(A)
	. = ..()

/obj/item/integrated_circuit/ui_host()
	if(istype(src.loc, /obj/item/device/electronic_assembly))
		var/obj/item/device/electronic_assembly/assembly = loc
		return assembly.resolve_ui_host()
	return ..()

/obj/item/integrated_circuit/emp_act(severity)
	for(var/datum/integrated_io/io in inputs + outputs + activators)
		io.scramble()

/obj/item/integrated_circuit/proc/check_interactivity(mob/user)
	if(assembly)
		return assembly.check_interactivity(user)
	else if(!CanInteract(user, physical_state))
		return 0
	return 1

/obj/item/integrated_circuit/verb/rename_component()
	set name = "Rename Circuit"
	set category = "Object"
	set desc = "Rename your circuit, useful to stay organized."

	var/mob/M = usr
	if(!check_interactivity(M))
		return

	var/input = sanitizeSafe(input("What do you want to name the circuit?", "Rename", src.name) as null|text, MAX_NAME_LEN)
	if(src && input && assembly.check_interactivity(M))
		to_chat(M, "<span class='notice'>The circuit '[src.name]' is now labeled '[input]'.</span>")
		displayed_name = input

/obj/item/integrated_circuit/interact(mob/user)
	if(!check_interactivity(user))
		return

	var/window_height = 350
	var/window_width = 600
	var/table_edge_width = "30%"
	var/table_middle_width = "40%"

	var/list/HTML = list(
		"<div align='center'>",
		"<table border='1' style='undefined;table-layout: fixed; width: 80%'>",
		"<br><a href='?src=\ref[src];return=1'>Return to Assembly</a>",
		"<br><a href='?src=\ref[src];'>Refresh</a>  |  ",
		"<a href='?src=\ref[src];rename=1'>Rename</a>  |  ",
		"<a href='?src=\ref[src];scan=1'>Scan with Device</a>  |  "
	)
	if(src.removable)
		HTML += "<a href='?src=\ref[src];remove=1'>Remove</a><br>"

	HTML += "<colgroup>"
	HTML += "<col style='width: [table_edge_width]'>"
	HTML += "<col style='width: [table_middle_width]'>"
	HTML += "<col style='width: [table_edge_width]'>"
	HTML += "</colgroup>"

	var/column_width = 3
	var/row_height = max(inputs.len, outputs.len, 1)

	for(var/i = 1 to row_height)
		HTML += "<tr>"
		for(var/j = 1 to column_width)
			var/datum/integrated_io/io = null
			var/words = list()
			var/height = 1
			switch(j)
				if(1)
					io = get_pin_ref(IC_INPUT, i)
					if(io)
						words += "<b><a href=?src=\ref[src];pin_name=1;pin=\ref[io]>[io.display_pin_type()] [io.name]</a> <a href=?src=\ref[src];pin_data=1;pin=\ref[io]>[io.display_data(io.data)]</a></b><br>"
						if(io.linked.len)
							for(var/datum/integrated_io/linked in io.linked)
								words += "<a href=?src=\ref[src];pin_unwire=1;pin=\ref[io];link=\ref[linked]>[linked.name]</a> \
								@ <a href=?src=\ref[linked.holder];examine=1;>[linked.holder.displayed_name]</a><br>"

						if(outputs.len > inputs.len)
							height = 1
				if(2)
					if(i == 1)
						words += "[src.displayed_name]<br>[src.name != src.displayed_name ? "([src.name])":""]<hr>[src.desc]"
						height = row_height
					else
						continue
				if(3)
					io = get_pin_ref(IC_OUTPUT, i)
					if(io)
						words += "<b><a href=?src=\ref[src];pin_name=1;pin=\ref[io]>[io.display_pin_type()] [io.name]</a> <a href=?src=\ref[src];pin_data=1;pin=\ref[io]>[io.display_data(io.data)]</a></b><br>"
						if(io.linked.len)
							for(var/datum/integrated_io/linked in io.linked)
								words += "<a href=?src=\ref[src];pin_unwire=1;pin=\ref[io];link=\ref[linked]>[linked.name]</a> \
								@ <a href=?src=\ref[linked.holder];examine=1;>[linked.holder.displayed_name]</a><br>"

						if(inputs.len > outputs.len)
							height = 1
			HTML += "<td align='center' rowspan='[height]'>[jointext(words, null)]</td>"
		HTML += "</tr>"

	for(var/activator in activators)
		var/datum/integrated_io/io = activator
		var/words = list(
			"<b><a href=?src=\ref[src];pin_name=1;pin=\ref[io]><span class='bad'>[io.name]</span></a> <a href=?src=\ref[src];pin_data=1;pin=\ref[io]><span class='bad'>[io.data?"\<PULSE OUT\>":"\<PULSE IN\>"]</span></a></b><br>"
		)

		if(io.linked.len)
			for(var/datum/integrated_io/linked in io.linked)
				words += "<a href=?src=\ref[src];pin_unwire=1;pin=\ref[io];link=\ref[linked]><span class='bad'>[linked.name]</span></a> \
				@ <a href=?src=\ref[linked.holder];examine=1;><span class='bad'>[linked.holder.displayed_name]</span></a><br>"

		HTML += "<tr>"
		HTML += "<td colspan='3' align='center'>[jointext(words, null)]</td>"
		HTML += "</tr>"

	HTML += "</table>"
	HTML += "</div>"

//	HTML += "<br><font color='33CC33'>Meta Variables;</font>" // If more meta vars get introduced, uncomment this.
//	HTML += "<br>"

	HTML += "<br><span class='highlight'>Complexity: [complexity]</span>"
	if(power_draw_idle)
		HTML += "<br><span class='highlight'>Power Draw: [power_draw_idle] W (Idle)</span>"
	if(power_draw_per_use)
		HTML += "<br><span class='highlight'>Power Draw: [power_draw_per_use] W (Active)</span>" // Borgcode says that powercells' checked_use() takes joules as input.
	HTML += "<br><span class='highlight'>[extended_desc]</span>"

	var/datum/browser/B = new(user, assembly ? "assembly-\ref[assembly]" : "circuit-\ref[src]", (displayed_name && displayed_name != name) ? "[displayed_name] ([name])" : name, window_width, window_height)
	B.set_content(HTML.Join())
	B.open()

/obj/item/integrated_circuit/Topic(href, href_list, state = interactive_state)
	if(!check_interactivity(usr))
		return
	if (assembly && !assembly.opened)
		to_chat(usr, "<span class='warning'>\The [assembly] is not open!</span>")
		return
	if(..())
		return 1

	var/update = 1
	var/obj/item/device/electronic_assembly/A = src.assembly
	var/update_to_assembly = 0
	var/datum/integrated_io/pin = locate(href_list["pin"]) in inputs + outputs + activators
	var/datum/integrated_io/linked = null
	if(href_list["link"])
		linked = locate(href_list["link"]) in pin.linked

	var/obj/held_item = usr.get_active_hand()

	if(href_list["rename"])
		rename_component(usr)
		if(href_list["from_assembly"])
			update = 0
			var/obj/item/device/electronic_assembly/ea = loc
			if(istype(ea))
				ea.interact(usr)

	if(href_list["pin_name"])
		if (!istype(held_item, /obj/item/device/multitool) || !allow_multitool)
			href_list["wire"] = 1
		else
			var/obj/item/device/multitool/M = held_item
			M.wire(pin,usr)

	if(href_list["pin_data"])
		if (!istype(held_item, /obj/item/device/multitool) || !allow_multitool)
			href_list["wire"] = 1

		else
			var/datum/integrated_io/io = pin
			io.ask_for_pin_data(usr) // The pins themselves will determine how to ask for data, and will validate the data.

	if(href_list["pin_unwire"])
		if (!istype(held_item, /obj/item/device/multitool) || !allow_multitool)
			href_list["wire"] = 1
		else
			var/obj/item/device/multitool/M = held_item
			M.unwire(pin, linked, usr)

	if(href_list["wire"])
		if(istype(held_item, /obj/item/device/integrated_electronics/wirer))
			var/obj/item/device/integrated_electronics/wirer/wirer = held_item
			if(linked)
				wirer.wire(linked, usr)
			else if(pin)
				wirer.wire(pin, usr)

		else if(istype(held_item, /obj/item/device/integrated_electronics/debugger))
			var/obj/item/device/integrated_electronics/debugger/debugger = held_item
			if(pin)
				debugger.write_data(pin, usr)
		else
			to_chat(usr, "<span class='warning'>You can't do a whole lot without the proper tools.</span>")

	if(href_list["examine"])
		var/obj/item/integrated_circuit/examined
		if(href_list["examined"])
			examined = href_list["examined"]
		else
			examined = src
		examined.interact(usr)
		update = 0

	if(href_list["bottom"])
		var/obj/item/integrated_circuit/circuit = locate(href_list["bottom"]) in src.assembly.contents
		var/assy = circuit.assembly
		if(!circuit)
			return
		circuit.loc = null
		circuit.forceMove(assy)
		. = 1
		update_to_assembly = 1

	if(href_list["scan"])
		if(istype(held_item, /obj/item/device/integrated_electronics/debugger))
			var/obj/item/device/integrated_electronics/debugger/D = held_item
			if(D.accepting_refs)
				D.afterattack(src, usr, TRUE)
			else
				to_chat(usr, "<span class='warning'>The Debugger's 'ref scanner' needs to be on.</span>")
		else
			to_chat(usr, "<span class='warning'>You need a multitool/debugger set to 'ref' mode to do that.</span>")

	if(href_list["return"])
		if(A)
			update_to_assembly = 1
			usr << browse(null, "window=circuit-\ref[src]")
		else
			to_chat(usr, "<span class='warning'>This circuit is not in an assembly!</span>")

	if(href_list["remove"])
		if(!A)
			to_chat(usr, "<span class='warning'>This circuit is not in an assembly!</span>")
			return
		if(!removable)
			to_chat(usr, "<span class='warning'>\The [src] seems to be permanently attached to the case.</span>")
			return
		var/obj/item/device/electronic_assembly/ea = loc
		disconnect_all()
		var/turf/T = get_turf(src)
		forceMove(T)
		assembly = null
		playsound(T, 'sound/items/Crowbar.ogg', 50, 1)
		to_chat(usr, "<span class='notice'>You pop \the [src] out of the case, and slide it out.</span>")

		if(istype(ea))
			ea.interact(usr)
		update = 0
		return

	if(update)
		if(istype(A) && update_to_assembly)
			A.interact(usr)
		else
			interact(usr) // To refresh the UI.

/obj/item/integrated_circuit/proc/push_data()
	for(var/datum/integrated_io/O in outputs)
		O.push_data()

/obj/item/integrated_circuit/proc/pull_data()
	for(var/datum/integrated_io/I in inputs)
		I.push_data()

/obj/item/integrated_circuit/proc/draw_idle_power()
	if(assembly)
		return assembly.draw_power(power_draw_idle)

// Override this for special behaviour when there's no power left.
/obj/item/integrated_circuit/proc/power_fail()
	return

// Returns true if there's enough power to work().
/obj/item/integrated_circuit/proc/check_power()
	if(!assembly)
		return FALSE // Not in an assembly, therefore no power.
	if(assembly.draw_power(power_draw_per_use))
		return TRUE // Battery has enough.
	return FALSE // Not enough power.

/obj/item/integrated_circuit/proc/check_then_do_work(ignore_power = FALSE)
	if(world.time < next_use) 	// All intergrated circuits have an internal cooldown, to protect from spam.
		return
	if(power_draw_per_use && !ignore_power)
		if(!check_power())
			power_fail()
			return
	next_use = world.time + cooldown_per_use
	do_work()

/obj/item/integrated_circuit/proc/do_work()
	return

/obj/item/integrated_circuit/proc/disconnect_all()
	for(var/datum/integrated_io/I in inputs)
		I.disconnect()
	for(var/datum/integrated_io/O in outputs)
		O.disconnect()
	for(var/datum/integrated_io/activate/A in activators)
		A.disconnect()
