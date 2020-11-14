// Attempts to install the hardware into appropriate slot.
// TODO: handle PAIs
/obj/item/modular_computer/proc/install_component(var/mob/living/user, var/obj/item/computer_hardware/H)
	if(!istype(H))
		return FALSE

	if(hardware_by_slot(H.hw_type))
		to_chat(user, SPAN_WARNING("\The [src]'s [H.hw_type] slot is already occupied.'"))
		return FALSE

	if(H.hardware_size > max_hardware_size)
		to_chat(user, SPAN_WARNING("\The [src] cannot accept hardware of that size!"))
		return FALSE

	add_component(H, user)
	H.install_component(src)
	to_chat(user, SPAN_NOTICE("You install \the [H] into \the [src]."))
	update_icon()

	return TRUE

// Uninstalls component.
/obj/item/modular_computer/proc/uninstall_component(var/mob/living/user, var/obj/item/computer_hardware/H, var/put_in_hands = FALSE)
	if(!hardware_by_slot(H?.hw_type)) // what how
		return FALSE

	remove_component(H, user)
	H.uninstall_component(src)
	to_chat(user, SPAN_NOTICE("You remove \the [H] from \the [src]."))
	update_icon()
	if(H.critical && enabled)
		output_error("HARDWARE ERROR: Critical component disconnected. Please verify component connection and reboot the device.")
		shutdown_computer()

// Raw add/remove procs for hardware. Use install/uninstall above for anything user-facing.
/obj/item/modular_computer/proc/add_component(var/obj/item/computer_hardware/H, var/mob/living/user)
	if(!istype(H))
		return FALSE

	internal_components[H.hw_type] = H
	if(user)
		user.drop_from_inventory(H, src)

/obj/item/modular_computer/proc/remove_component(var/obj/item/computer_hardware/H, var/mob/living/user, var/put_in_hands = FALSE)
	if(!hardware_by_slot(H?.hw_type)) // what how
		return FALSE

	internal_components[H.hw_type] = null
	H.forceMove(get_turf(src))
	if(user && put_in_hands)
		user.put_in_hands(H)

// Checks currently installed components for the hw_type, returns either the hardware or null depending on if the component exists
/obj/item/modular_computer/proc/hardware_by_slot(var/slot)
	return internal_components[slot]

// Returns assoc. list of all components
/obj/item/modular_computer/proc/get_all_components()
	var/list/all_components = list()
	for(var/hw_type in internal_components)
		all_components += internal_components[hw_type]
	return all_components
