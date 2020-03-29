/obj/item/integrated_circuit
	name = "integrated circuit"
	desc = "It's a tiny chip!  This one doesn't seem to do much, however."
	icon = 'icons/obj/assemblies/electronic_components.dmi'
	icon_state = "template"
	w_class = ITEMSIZE_TINY
	matter = list()				// To be filled later
	var/obj/item/device/electronic_assembly/assembly // Reference to the assembly holding this circuit, if any.
	var/extended_desc
	var/list/inputs
	var/list/inputs_default// Assoc list which will fill a pin with data upon creation.  e.g. "2" = 0 will set input pin 2 to equal 0 instead of null.
	var/list/outputs
	var/list/outputs_default// Ditto, for output.
	var/list/activators
	var/next_use = 0 				// Uses world.time
	var/complexity = 1 				// This acts as a limitation on building machines, more resource-intensive components cost more 'space'.
	var/size = 1					// This acts as a limitation on building machines, bigger components cost more 'space'. -1 for size 0
	var/cooldown_per_use = 1		// Circuits are limited in how many times they can be work()'d by this variable.
	var/ext_cooldown = 0			// Circuits are limited in how many times they can be work()'d with external world by this variable.
	var/power_draw_per_use = 0 		// How much power is drawn when work()'d.
	var/power_draw_idle = 0			// How much power is drawn when doing nothing.
	var/spawn_flags					// Used for world initializing, see the #defines above.
	var/action_flags = 0			// Used for telling circuits that can do certain actions from other circuits.
	var/category_text = "NO CATEGORY THIS IS A BUG"	// To show up on circuit printer, and perhaps other places.
	var/removable = TRUE 			// Determines if a circuit is removable from the assembly.
	var/displayed_name = ""

/*
	Integrated circuits are essentially modular machines.  Each circuit has a specific function, and combining them inside Electronic Assemblies allows
a creative player the means to solve many problems.  Circuits are held inside an electronic assembly, and are wired using special tools.
*/

/obj/item/integrated_circuit/examine(mob/user)
	. = ..()
	external_examine(user)

/obj/item/integrated_circuit/ShiftClick(mob/living/user)
	if(istype(user))
		interact(user)
	else
		..()

// This should be used when someone is examining while the case is opened.
/obj/item/integrated_circuit/proc/internal_examine(mob/user)
	any_examine(user)
	interact(user)

// This should be used when someone is examining from an 'outside' perspective, e.g. reading a screen or LED.
/obj/item/integrated_circuit/proc/external_examine(mob/user)
	any_examine(user)

/obj/item/integrated_circuit/proc/any_examine(mob/user)
	return

/obj/item/integrated_circuit/proc/attackby_react(var/atom/movable/A,mob/user)
	return

/obj/item/integrated_circuit/proc/sense(var/atom/movable/A,mob/user,prox)
	return

/obj/item/integrated_circuit/proc/check_interactivity(mob/user)
	if(assembly)
		return assembly.check_interactivity(user)
	else
		return CanUseTopic(user)

/obj/item/integrated_circuit/Initialize()
	displayed_name = name
	setup_io(inputs, /datum/integrated_io, inputs_default, IC_INPUT)
	inputs_default = null
	setup_io(outputs, /datum/integrated_io, outputs_default, IC_OUTPUT)
	outputs_default = null
	setup_io(activators, /datum/integrated_io/activate, null, IC_ACTIVATOR)
	if(!matter[DEFAULT_WALL_MATERIAL])
		matter[DEFAULT_WALL_MATERIAL] = w_class * SSelectronics.cost_multiplier // Default cost.
	. = ..()

/obj/item/integrated_circuit/proc/on_data_written() //Override this for special behaviour when new data gets pushed to the circuit.
	return

/obj/item/integrated_circuit/Destroy()
	QDEL_NULL_LIST(inputs)
	QDEL_NULL_LIST(outputs)
	QDEL_NULL_LIST(activators)
	//SScircuit_components.dequeue_component(src)
	. = ..()

/obj/item/integrated_circuit/emp_act(severity)
	for(var/k in 1 to LAZYLEN(inputs))
		var/datum/integrated_io/I = inputs[k]
		I.scramble()
	for(var/k in 1 to LAZYLEN(outputs))
		var/datum/integrated_io/O = outputs[k]
		O.scramble()
	for(var/k in 1 to LAZYLEN(activators))
		var/datum/integrated_io/activate/A = activators[k]
		A.scramble()


/obj/item/integrated_circuit/verb/rename_component()
	set name = "Rename Circuit"
	set category = "Object"
	set desc = "Rename your circuit, useful to stay organized."

	var/mob/M = usr
	if(!check_interactivity(M))
		return

	var/input = sanitizeName(input(M, "What do you want to name this?", "Rename", name) as null|text, allow_numbers = TRUE)
	if(check_interactivity(M))
		if(!input)
			input = name
		to_chat(M, "<span class='notice'>The circuit '[name]' is now labeled '[input]'.</span>")
		displayed_name = input

/obj/item/integrated_circuit/ui_host()
	if(assembly)
		return assembly.resolve_ui_host()
	return ..()

/obj/item/integrated_circuit/interact(mob/user)
	. = ..()
	if(!check_interactivity(user))
		return

	var/datum/vueui/ui = SSvueui.get_open_ui(user, src)
	if(!ui)
		ui = new(user, src, "circuits-circuit", 655, 350, src.displayed_name)

	ui.open()

/obj/item/integrated_circuit/proc/set_ui_pininfo(type)
	var/list/pins = null
	if(type == IC_OUTPUT)
		pins = outputs
	else if(type == IC_INPUT)
		pins = inputs
	else if(type == IC_ACTIVATOR)
		pins = activators
	else
		return null
	
	var/list/result = list()
	result.Cut()
	for (var/i = 1 to LAZYLEN(pins))
		var/datum/integrated_io/io = get_pin_ref(type, i)
		var/list/pin_info = list("ref" = "\ref[io]", 
			"pin_type" = html_decode(io.display_pin_type()), 
			"name" = io.name, 
			"data" = html_decode(io.display_data(io.data)))

		if(LAZYLEN(io.linked))
			LAZYINITLIST(pin_info["linked"])
			for(var/k = 1 to LAZYLEN(io.linked))
				var/datum/integrated_io/linked = io.linked[k]
				// If an argument to Add is a list, then it adds the list's contents
				// Which means we need to put list into a list 
 				pin_info["linked"].Add(list(list("ref" = "\ref[linked]", 
					"name" = linked.name, 
					"holder" = "\ref[linked.holder]", 
					"holder_name" = linked.holder.displayed_name)))
					
		// In our case, we have a list that contains lists, so can't use VUEUI_SET_CHECK_LIST
		result.Add(list(pin_info))

	return result

/obj/item/integrated_circuit/vueui_data_change(var/list/data, var/mob/user, var/datum/vueui/ui)
	if(!data)
		. = data = list()

	LAZYINITLIST(data["inputs"])
	LAZYINITLIST(data["outputs"])
	LAZYINITLIST(data["activators"])

	// TODO: Find a way to properly invalidate to update data
	// Array length doesn't change, but linking circuits requires a refresh
	data["inputs"].Cut()
	data["inputs"].Add(set_ui_pininfo(IC_INPUT))

	data["outputs"].Cut()
	data["outputs"].Add(set_ui_pininfo(IC_OUTPUT))

	data["activators"].Cut()
	data["activators"].Add(set_ui_pininfo(IC_ACTIVATOR))

	// These variables can change
	VUEUI_SET_CHECK(data["size"], size, ., data)
	VUEUI_SET_CHECK(data["displayed_name"], displayed_name, ., data)
	VUEUI_SET_CHECK(data["ext_cooldown"], ext_cooldown, ., data)
	VUEUI_SET_CHECK(data["power_draw_idle"], power_draw_idle, ., data)
	VUEUI_SET_CHECK(data["power_draw_per_use"], power_draw_per_use, ., data)
	VUEUI_SET_CHECK(data["cooldown_per_use"], cooldown_per_use, ., data)
	// These ones shouldn't
	VUEUI_SET_CHECK_IFNOTSET(data["complexity"], complexity, ., data)
	VUEUI_SET_CHECK_IFNOTSET(data["extended_desc"], extended_desc, ., data)
	VUEUI_SET_CHECK_IFNOTSET(data["name"], name, ., data)
	VUEUI_SET_CHECK_IFNOTSET(data["desc"], desc, ., data)
	VUEUI_SET_CHECK_IFNOTSET(data["removable"], removable, ., data)
	VUEUI_SET_CHECK_IFNOTSET(data["component"], "\ref[src]", ., data)
	// Pretty sure this is needed, since one can't use functions for ranges in v-for
	VUEUI_SET_CHECK_IFNOTSET(data["info_size"], max(LAZYLEN(inputs), LAZYLEN(outputs), 1), ., data)
	if(assembly)
		VUEUI_SET_CHECK(data["assembly"], "\ref[assembly]", ., data)

/obj/item/integrated_circuit/proc/try_update_ui(var/datum/vueui/ui, user)
	if(!istype(ui))
		// UI was updated externally, for example, after sending data for the input circuits
		ui = SSvueui.get_open_ui(user, src)

	// NOTE: Statement above is not guaranteed to actually return valid UI
	if(istype(ui))
		// Constant updates for better experience.
		ui.check_for_change(TRUE)

/obj/item/integrated_circuit/Topic(href, href_list, state = interactive_state)
	if(..())
		return 1

	var/datum/vueui/ui = href_list["vueui"]

	. = TOPIC_HANDLED
	var/obj/held_item = usr.get_active_hand()
	if(href_list["pin"] && assembly)
		var/datum/integrated_io/pin = locate(href_list["pin"]) in inputs + outputs + activators
		if(pin)
			var/datum/integrated_io/linked
			var/success = TRUE
			if(href_list["link"])
				linked = locate(href_list["link"]) in pin.linked

			if(istype(held_item, /obj/item/device/integrated_electronics))
				pin.handle_wire(linked, held_item, href_list["act"], usr)
				. = TOPIC_REFRESH
			else
				to_chat(usr, "<span class='warning'>You can't do a whole lot without the proper tools.</span>")
				success = FALSE
			if(success && assembly)
				assembly.add_allowed_scanner(usr.ckey)

	else if(href_list["scan"])
		if(istype(held_item, /obj/item/device/integrated_electronics/debugger))
			var/obj/item/device/integrated_electronics/debugger/D = held_item
			if(D.accepting_refs)
				D.afterattack(src, usr, TRUE)
				. = TOPIC_REFRESH
			else
				to_chat(usr, "<span class='warning'>The debugger's 'ref scanner' needs to be on.</span>")
		else
			to_chat(usr, "<span class='warning'>You need a debugger set to 'ref' mode to do that.</span>")

	else if(href_list["refresh"])
		internal_examine(usr)
	else if(href_list["return"] && assembly)
		assembly.interact(usr)
	else if(href_list["examine"] && assembly)
		internal_examine(usr)

	else if(href_list["rename"])
		rename_component(usr)
		// We might be renaming from an assembly, update it's UI
		// TODO: Move the update on rename part to the asssembly itself
		if(assembly)
			assembly.try_update_ui(null, usr)
		. = TOPIC_REFRESH

	else if(href_list["remove"] && assembly)
		assembly.try_remove_component(src, usr)
		. = TOPIC_REFRESH

	if(. == TOPIC_REFRESH)
		try_update_ui(ui, usr)
		internal_examine(usr)

/obj/item/integrated_circuit/proc/interact_with_assembly(var/mob/user)
	if(assembly)
		assembly.interact(user)
		if(assembly.opened)
			interact(user)

/obj/item/integrated_circuit/proc/push_data()
	for(var/k in 1 to LAZYLEN(outputs))
		var/datum/integrated_io/O = outputs[k]
		O.push_data()

/obj/item/integrated_circuit/proc/pull_data()
	for(var/k in 1 to LAZYLEN(inputs))
		var/datum/integrated_io/I = inputs[k]
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
	if(power_draw_per_use == 0)
		return TRUE // No need to draw power if it's not needed. Also, can't reliably check for 0 power draw
	if(assembly.draw_power(power_draw_per_use))
		return TRUE // Battery has enough.
	return FALSE // Not enough power.

/obj/item/integrated_circuit/proc/check_then_do_work(ord, var/ignore_power = FALSE)
	if(world.time < next_use) 	// All intergrated circuits have an internal cooldown, to protect from spam.
		return FALSE
	if(assembly && ext_cooldown && (world.time < assembly.ext_next_use)) 	// Some circuits have external cooldown, to protect from spam.
		return FALSE
	if(power_draw_per_use && !ignore_power)
		if(!check_power())
			power_fail()
			return FALSE
	next_use = world.time + cooldown_per_use
	if(assembly)
		assembly.ext_next_use = world.time + ext_cooldown
	do_work(ord)
	return TRUE

/obj/item/integrated_circuit/proc/do_work(ord)
	return

/obj/item/integrated_circuit/proc/disconnect_all()
	var/datum/integrated_io/I

	for(var/i in inputs)
		I = i
		I.disconnect_all()

	for(var/i in outputs)
		I = i
		I.disconnect_all()

	for(var/i in activators)
		I = i
		I.disconnect_all()

/obj/item/integrated_circuit/proc/get_object()
	// If the component is located in an assembly, let assembly determine it.
	if(assembly)
		return assembly.get_object()
	else
		return src	// If not, the component is acting on its own.


// Checks if the target object is reachable. Useful for various manipulators and manipulator-like objects.
/obj/item/integrated_circuit/proc/check_target(atom/target, exclude_contents = FALSE, exclude_components = FALSE, exclude_self = FALSE)
	if(!target)
		return FALSE

	var/atom/movable/acting_object = get_object()

	if(exclude_self && target == acting_object)
		return FALSE

	if(exclude_components && assembly)
		if(target in assembly.assembly_components)
			return FALSE

		if(target == assembly.battery)
			return FALSE

	if(target.Adjacent(acting_object) && isturf(target.loc))
		return TRUE

	if(!exclude_contents && (target in acting_object.GetAllContents()))
		return TRUE

	if(target in acting_object.loc)
		return TRUE

	return FALSE

/obj/item/integrated_circuit/proc/added_to_assembly(var/obj/item/device/electronic_assembly/assembly)
	return

/obj/item/integrated_circuit/proc/removed_from_assembly(var/obj/item/device/electronic_assembly/assembly)
	return

/obj/item/integrated_circuit/proc/on_anchored()
	return

/obj/item/integrated_circuit/proc/on_unanchored()
	return