/obj/item/device/electronic_assembly
	name = "electronic assembly"
	desc = "It's a case, for building small electronics with."
	w_class = WEIGHT_CLASS_SMALL
	icon = 'icons/obj/assemblies/electronic_setups.dmi'
	icon_state = "setup_small"
	item_flags = ITEM_FLAG_NO_BLUDGEON
	var/max_components = IC_COMPONENTS_BASE
	var/max_complexity = IC_COMPLEXITY_BASE
	var/opened = 0
	var/can_anchor = FALSE // If true, wrenching it will anchor it.
	var/obj/item/cell/device/battery // Internal cell which most circuits need to work.
	var/detail_color = COLOR_ASSEMBLY_BLACK
	var/obj/item/card/id/access_card

/obj/item/device/electronic_assembly/implant
	name = "electronic implant"
	icon_state = "setup_implant"
	desc = "It's a case, for building very tiny electronics with."
	w_class = WEIGHT_CLASS_TINY
	max_components = IC_COMPONENTS_BASE / 2
	max_complexity = IC_COMPLEXITY_BASE / 2
	var/obj/item/implant/integrated_circuit/implant = null

/obj/item/device/electronic_assembly/Initialize(mapload, printed = FALSE)
	. = ..()
	if (!printed)
		battery = new(src)
	START_PROCESSING(SSelectronics, src)
	access_card = new /obj/item/card/id(src)

/obj/item/device/electronic_assembly/Destroy()
	QDEL_NULL(battery)
	STOP_PROCESSING(SSelectronics, src)
	QDEL_NULL(access_card)
	return ..()

/obj/item/device/electronic_assembly/Collide(atom/AM)
	var/collw = AM
	.=..()
	if((istype(collw, /obj/machinery/door/airlock) ||  istype(collw, /obj/machinery/door/window)) && (!isnull(access_card)))
		var/obj/machinery/door/D = collw
		if(D.check_access(access_card))
			D.open()

/obj/item/device/electronic_assembly/process()
	handle_idle_power()

/obj/item/device/electronic_assembly/proc/handle_idle_power()
	// First we generate power.
	for(var/obj/item/integrated_circuit/passive/power/P in contents)
		P.make_energy()

	// Now spend it.
	for(var/obj/item/integrated_circuit/IC in contents)
		if(IC.power_draw_idle && !draw_power(IC.power_draw_idle))
			IC.power_fail()

/obj/item/device/electronic_assembly/implant/update_icon()
	..()
	implant.icon_state = icon_state

/obj/item/device/electronic_assembly/implant/ui_host()
	return implant

/obj/item/device/electronic_assembly/proc/resolve_ui_host()
	return src

/obj/item/device/electronic_assembly/implant/resolve_ui_host()
	return implant

/obj/item/device/electronic_assembly/proc/check_interactivity(mob/user)
	if(!CanInteract(user, GLOB.physical_state))
		return 0
	return 1

/obj/item/device/electronic_assembly/interact(mob/user)
	if(!check_interactivity(user))
		return

	var/total_parts = 0
	var/total_complexity = 0
	for(var/obj/item/integrated_circuit/part in contents)
		total_parts += part.size
		total_complexity = total_complexity + part.complexity
	var/list/HTML = list()

	HTML += "<br><a href='byond://?src=[REF(src)]'>Refresh</a>  |  "
	HTML += "<a href='byond://?src=[REF(src)];rename=1'>Rename</a><br>"
	HTML += "[total_parts]/[max_components] ([round((total_parts / max_components) * 100, 0.1)]%) space taken up in the assembly.<br>"
	HTML += "[total_complexity]/[max_complexity] ([round((total_complexity / max_complexity) * 100, 0.1)]%) maximum complexity.<br>"
	if(battery)
		HTML += "[round(battery.charge, 0.1)]/[battery.maxcharge] ([round(battery.percent(), 0.1)]%) cell charge. <a href='byond://?src=[REF(src)];remove_cell=1'>Remove</a>"
	else
		HTML += SPAN_DANGER("No powercell detected!")
	HTML += "<br><br>"
	HTML += "Components:<hr>"
	HTML += "Built in:<br>"


//Put removable circuits in separate categories from non-removable
	for(var/obj/item/integrated_circuit/circuit in contents)
		if(!circuit.removable)
			HTML += "<a href='byond://?src=[REF(circuit)];examine=1;from_assembly=1>[circuit.displayed_name]</a> | "
			HTML += "<a href='byond://?src=[REF(circuit)];rename=1;from_assembly=1>Rename</a> | "
			HTML += "<a href='byond://?src=[REF(circuit)];scan=1;from_assembly=1>Scan with Debugger</a> | "
			HTML += "<a href='byond://?src=[REF(circuit)];bottom=[REF(circuit)];from_assembly=1>Move to Bottom</a>"
			HTML += "<br>"

	HTML += "<hr>"
	HTML += "Removable:<br>"

	for(var/obj/item/integrated_circuit/circuit in contents)
		if(circuit.removable)
			HTML += "<a href='byond://?src=[REF(circuit)];examine=1;from_assembly=1>[circuit.displayed_name]</a> | "
			HTML += "<a href='byond://?src=[REF(circuit)];rename=1;from_assembly=1>Rename</a> | "
			HTML += "<a href='byond://?src=[REF(circuit)];scan=1;from_assembly=1>Scan with Debugger</a> | "
			HTML += "<a href='byond://?src=[REF(circuit)];remove=1;from_assembly=1>Remove</a> | "
			HTML += "<a href='byond://?src=[REF(circuit)];bottom=[REF(circuit)];from_assembly=1>Move to Bottom</a>"
			HTML += "<br>"

	var/datum/browser/B = new(user, "assembly-[REF(src)]", name, 600, 400)
	B.set_content(HTML.Join())
	B.open(FALSE)

/obj/item/device/electronic_assembly/Topic(href, href_list[])
	if(..())
		return 1
	if(!opened)
		to_chat(usr, SPAN_WARNING("\The [src] is not open!"))
		return

	if(href_list["rename"])
		rename(usr)

	if(href_list["remove_cell"])
		if(!battery)
			to_chat(usr, SPAN_WARNING("There's no power cell to remove from \the [src]."))
		else
			var/turf/T = get_turf(src)
			battery.forceMove(T)
			playsound(T, 'sound/items/crowbar_pry.ogg', 50, 1)
			to_chat(usr, SPAN_NOTICE("You pull \the [battery] out of \the [src]'s power supply."))
			battery = null

	interact(usr) // To refresh the UI.

/obj/item/device/electronic_assembly/verb/rename()
	set name = "Rename Circuit"
	set category = "Object"
	set desc = "Rename your circuit, useful to stay organized."
	set src in usr

	var/mob/M = usr
	if(!check_interactivity(M))
		return null

	var/input = sanitizeSafe(input("What do you want to name this?", "Rename", src.name) as null|text, MAX_NAME_LEN)
	if(src && input)
		to_chat(M, SPAN_NOTICE("The machine now has a label reading '[input]'."))
		name = input
		return input
	return null

/obj/item/device/electronic_assembly/proc/can_move()
	return FALSE

/obj/item/device/electronic_assembly/update_icon()
	if(opened)
		icon_state = "[initial(icon_state)]-open"
	else
		icon_state = initial(icon_state)
	ClearOverlays()
	if(detail_color == COLOR_ASSEMBLY_BLACK) //Black colored overlay looks almost but not exactly like the base sprite, so just cut the overlay and avoid it looking kinda off.
		return
	var/image/detail_overlay = image('icons/obj/assemblies/electronic_setups.dmi', "[icon_state]-color")
	detail_overlay.color = detail_color
	AddOverlays(detail_overlay)

/obj/item/device/electronic_assembly/GetAccess()
	. = list()
	for(var/obj/item/integrated_circuit/part in contents)
		. |= part.GetAccess()

/obj/item/device/electronic_assembly/get_examine_text(mob/user, distance, is_adjacent, infix, suffix)
	. = ..()
	if(distance <= 1)
		for(var/obj/item/integrated_circuit/IC in contents)
			. += IC.external_examine(user)
		if(opened)
			interact(user)

/obj/item/device/electronic_assembly/proc/get_part_complexity()
	. = 0
	for(var/obj/item/integrated_circuit/part in contents)
		. += part.complexity

/obj/item/device/electronic_assembly/proc/get_part_size()
	. = 0
	for(var/obj/item/integrated_circuit/part in contents)
		. += part.size

// Returns true if the circuit made it inside.
/obj/item/device/electronic_assembly/proc/add_circuit(obj/item/integrated_circuit/IC, mob/user)
	if(!opened)
		to_chat(user, SPAN_WARNING("\The [src] isn't opened, so you can't put anything inside.  Try using a crowbar."))
		return FALSE

	if(IC.w_class > w_class)
		to_chat(user, SPAN_WARNING("\The [IC] is way too big to fit into \the [src]."))
		return FALSE

	var/total_part_size = get_part_size()
	var/total_complexity = get_part_complexity()

	if((total_part_size + IC.size) > max_components)
		to_chat(user, SPAN_WARNING("You can't seem to add the '[IC.name]', as there's insufficient space."))
		return FALSE
	if((total_complexity + IC.complexity) > max_complexity)
		to_chat(user, SPAN_WARNING("You can't seem to add the '[IC.name]', since this setup's too complicated for the case."))
		return FALSE

	if(!IC.forceMove(src))
		return FALSE

	IC.assembly = src

	return TRUE

// Non-interactive version of above that always succeeds, intended for build-in circuits that get added on assembly initialization.
/obj/item/device/electronic_assembly/proc/force_add_circuit(var/obj/item/integrated_circuit/IC)
	IC.forceMove(src)
	IC.assembly = src

/obj/item/device/electronic_assembly/afterattack(atom/target, mob/user, proximity)
	for(var/obj/item/integrated_circuit/input/sensor/S in contents)
		S.sense(target, user)

/obj/item/device/electronic_assembly/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/integrated_circuit))
		if(!user.unEquip(attacking_item))
			return FALSE

		if(add_circuit(attacking_item, user))
			to_chat(user, SPAN_NOTICE("You slide \the [attacking_item] inside \the [src]."))
			playsound(get_turf(src), 'sound/items/Deconstruct.ogg', 50, 1)
			interact(user)
			return TRUE

	else if(attacking_item.iswrench() && can_anchor)
		attacking_item.play_tool_sound(get_turf(src), 50)
		anchored = !anchored
		if(anchored)
			on_anchored()
		else
			on_unanchored()
		user.visible_message("[user] has wrenched [src]'s anchoring bolts [anchored ? "into" : "out of"] place.", "You wrench [src]'s anchoring bolts [anchored ? "into" : "out of"] place.", "You hear the sound of a ratcheting wrench turning.")
		return TRUE

	else if(attacking_item.iscrowbar())
		attacking_item.play_tool_sound(get_turf(src), 50)
		opened = !opened
		to_chat(user, SPAN_NOTICE("You [opened ? "open" : "close"] \the [src]."))
		update_icon()
		return TRUE

	else if(istype(attacking_item, /obj/item/device/integrated_electronics/wirer) || istype(attacking_item, /obj/item/device/integrated_electronics/debugger) || attacking_item.ismultitool() || attacking_item.isscrewdriver())
		if(opened)
			interact(user)
		else
			to_chat(user, SPAN_WARNING("\The [src] isn't open, so you can't fiddle with the internal components.  \
			Try using a crowbar."))

		return TRUE

	else if(istype(attacking_item, /obj/item/cell/device))
		if(!opened)
			to_chat(user, SPAN_WARNING("\The [src] isn't open, so you can't put anything inside.  Try using a crowbar."))
			for(var/obj/item/integrated_circuit/input/S in contents)
				S.attackby_react(attacking_item,user,user.a_intent)
			return FALSE

		if(battery)
			to_chat(user, SPAN_WARNING("\The [src] already has \a [battery] inside.  Remove it first if you want to replace it."))
			for(var/obj/item/integrated_circuit/input/S in contents)
				S.attackby_react(attacking_item,user,user.a_intent)
			return FALSE

		var/obj/item/cell/device/cell = attacking_item
		user.drop_from_inventory(cell,src)
		battery = cell
		playsound(get_turf(src), 'sound/items/Deconstruct.ogg', 50, 1)
		to_chat(user, SPAN_NOTICE("You slot \the [cell] inside \the [src]'s power supply."))
		interact(user)
		return TRUE
	else if(istype(attacking_item, /obj/item/device/integrated_electronics/detailer))
		var/obj/item/device/integrated_electronics/detailer/D = attacking_item
		detail_color = D.detail_color
		update_icon()
		return TRUE

	else
		for(var/obj/item/integrated_circuit/insert_slot/S in contents)  //Attempt to insert the item into any contained insert_slots
			if(S.insert(attacking_item, user))
				return TRUE
		for(var/obj/item/integrated_circuit/input/S in contents) // Attempt to swipe on scanners
			if(S.attackby_react(attacking_item,user,user.a_intent))
				return TRUE
		return ..()

/obj/item/device/electronic_assembly/attack_self(mob/user)
	if(!check_interactivity(user))
		return
	if(opened)
		interact(user)

	var/list/input_selection = list()
	var/list/available_inputs = list()
	for(var/obj/item/integrated_circuit/input/input in contents)
		if(input.can_be_asked_input)
			available_inputs.Add(input)
			var/i = 0
			for(var/obj/item/integrated_circuit/s in available_inputs)
				if(s.name == input.name && s.displayed_name == input.displayed_name && s != input)
					i++
			var/disp_name= "[input.displayed_name] \[[input.name]\]"
			if(i)
				disp_name += " ([i+1])"
			input_selection.Add(disp_name)

	var/obj/item/integrated_circuit/input/choice
	if(available_inputs)
		var/selection = tgui_input_list(user, "What do you want to interact with?", "Interaction", input_selection)
		if(selection)
			var/index = input_selection.Find(selection)
			choice = available_inputs[index]

	if(choice)
		choice.ask_for_input(user)

/obj/item/device/electronic_assembly/emp_act(severity)
	. = ..()

	for(var/atom/movable/AM in contents)
		AM.emp_act(severity)

// Returns true if power was successfully drawn.
/obj/item/device/electronic_assembly/proc/draw_power(amount)
	if(battery && battery.checked_use(amount * CELLRATE))
		return TRUE
	return FALSE

// Ditto for giving.
/obj/item/device/electronic_assembly/proc/give_power(amount)
	if(battery && battery.give(amount * CELLRATE))
		return TRUE
	return FALSE

/obj/item/device/electronic_assembly/proc/on_anchored()
	for(var/obj/item/integrated_circuit/IC in contents)
		IC.on_anchored()

/obj/item/device/electronic_assembly/proc/on_unanchored()
	for(var/obj/item/integrated_circuit/IC in contents)
		IC.on_unanchored()
