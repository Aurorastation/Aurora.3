/*
 * core/device.dm
 * Base device support for electronics-related items that are not themselves circuit assemblies.
 */

/obj/item/assembly/electronic_assembly
	name = "electronic device"
	desc = "A case for building electronics that can attach to other small devices."
	icon_state = "setup_device"
	// Whether the assembly panel is open for direct circuit access.
	var/opened = 0

	var/obj/item/electronic_assembly/device/EA

/obj/item/assembly/electronic_assembly/Initialize()
	. = ..()
	EA = new(src)
	EA.holder = src

/obj/item/assembly/electronic_assembly/Destroy()
	EA.holder = null
	QDEL_NULL(EA)

	. = ..()

/obj/item/assembly/electronic_assembly/attackby(obj/item/attacking_item, mob/user)
	if (attacking_item.tool_behaviour == TOOL_CROWBAR)
		toggle_open(user)
	else if (opened)
		EA.attackby(attacking_item, user)
	else
		..()

/obj/item/assembly/electronic_assembly/proc/toggle_open(mob/user)
	playsound(get_turf(src), 'sound/items/crowbar_pry.ogg', 50, 1)
	opened = !opened
	EA.opened = opened
	to_chat(user, SPAN_NOTICE("You [opened ? "open" : "close"] \the [src]."))
	secured = 1
	update_icon()

/obj/item/assembly/electronic_assembly/update_icon()
	if(EA)
		icon_state = initial(icon_state)
	else
		icon_state = "[initial(icon_state)]0"
	if(opened)
		icon_state = "[icon_state]-open"

/obj/item/assembly/electronic_assembly/attack_self(mob/user as mob)
	if(EA)
		EA.attack_self(user)

//Called when another assembly acts on this one, var/radio will determine where it came from for wire calcs
/obj/item/assembly/electronic_assembly/pulsed(radio = 0)
	if(EA)
		for(var/obj/item/integrated_circuit/built_in/device_input/I in EA.contents)
			I.do_work()

/obj/item/assembly/electronic_assembly/examine(mob/user, distance, is_adjacent, infix, suffix, show_extended)
	. = ..()
	if(EA)
		for(var/obj/item/integrated_circuit/IC in EA.contents)
			IC.external_examine(user)

/obj/item/assembly/electronic_assembly/verb/toggle()
	set src in usr
	set category = "Object"
	set name = "Open/Close Device Assembly"
	set desc = "Opens or closes the device assembly."

	toggle_open(usr)

/obj/item/electronic_assembly
	var/max_components_device = 16
	var/max_complexity_device = 42

/obj/item/electronic_assembly/device
	name = "electronic device"
	icon_state = "setup_device"
	desc = "A tiny electronic device designed to attach to other devices."
	w_class = WEIGHT_CLASS_TINY
	max_components = /obj/item/electronic_assembly::max_components_device
	max_complexity = /obj/item/electronic_assembly::max_complexity_device

	var/obj/item/assembly/electronic_assembly/holder
	var/obj/item/integrated_circuit/built_in/device_input/input
	var/obj/item/integrated_circuit/built_in/device_output/output


/obj/item/electronic_assembly/device/Initialize()
	. = ..()

	src.input = new(src)
	src.output = new(src)

	src.input.assembly = src
	src.output.assembly = src

/obj/item/electronic_assembly/device/Destroy()
	src.holder = null

	src.input.assembly = null
	src.output.assembly = null

	QDEL_NULL(src.input)
	QDEL_NULL(src.output)

	. = ..()

/obj/item/electronic_assembly/device/check_interactivity(mob/user)
	if(!CanInteract(user, state = GLOB.deep_inventory_state))
		return 0
	return 1
