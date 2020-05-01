// Attempts to install the hardware into appropriate slot.
/obj/item/modular_computer/proc/try_install_component(var/mob/living/user, var/obj/item/computer_hardware/H, var/found = FALSE)
	// "USB" flash drive.
	if(istype(H, /obj/item/computer_hardware/hard_drive/portable))
		if(portable_drive)
			to_chat(user, SPAN_WARNING("\The [src]'s portable drive slot is already occupied by \the [portable_drive]."))
			return
		found = TRUE
		portable_drive = H
	else if(istype(H, /obj/item/computer_hardware/hard_drive))
		if(hard_drive)
			to_chat(user, SPAN_WARNING("\The [src]'s hard drive slot is already occupied by \the [hard_drive]."))
			return
		found = TRUE
		hard_drive = H
	else if(istype(H, /obj/item/computer_hardware/network_card))
		if(network_card)
			to_chat(user, SPAN_WARNING("\The [src]'s network card slot is already occupied by \the [network_card]."))
			return
		found = TRUE
		network_card = H
	else if(istype(H, /obj/item/computer_hardware/nano_printer))
		if(nano_printer)
			to_chat(user, SPAN_WARNING("\The [src]'s nano printer slot is already occupied by \the [nano_printer]."))
			return
		found = TRUE
		nano_printer = H
	else if(istype(H, /obj/item/computer_hardware/card_slot))
		if(card_slot)
			to_chat(user, SPAN_WARNING("\The [src]'s card slot is already occupied by \the [card_slot]."))
			return
		found = TRUE
		card_slot = H
	else if(istype(H, /obj/item/computer_hardware/battery_module))
		if(battery_module)
			to_chat(user, SPAN_WARNING("\The [src]'s battery slot is already occupied by \the [battery_module]."))
			return
		found = TRUE
		battery_module = H
	else if(istype(H, /obj/item/computer_hardware/processor_unit))
		if(processor_unit)
			to_chat(user, SPAN_WARNING("\The [src]'s processor slot is already occupied by \the [processor_unit]."))
			return
		found = TRUE
		processor_unit = H
	else if(istype(H, /obj/item/computer_hardware/ai_slot))
		if(ai_slot)
			to_chat(user, SPAN_WARNING("\The [src]'s intellicard slot is already occupied by \the [ai_slot]."))
			return
		found = TRUE
		ai_slot = H
	else if(istype(H, /obj/item/computer_hardware/tesla_link))
		if(tesla_link)
			to_chat(user, SPAN_WARNING("\The [src]'s tesla link slot is already occupied by \the [tesla_link]."))
			return
		found = TRUE
		tesla_link = H
	if(found)
		to_chat(user, SPAN_NOTICE("You install \the [H] into \the [src]."))
		H.parent_computer = src
		user.drop_from_inventory(H, src)
		update_icon()

// Uninstalls component. Found and Critical vars may be passed by parent types, if they have additional hardware.
/obj/item/modular_computer/proc/uninstall_component(var/mob/living/user, var/obj/item/computer_hardware/H, var/found = FALSE, var/critical = FALSE, var/put_in_hands = FALSE)
	if(portable_drive == H)
		portable_drive = null
		found = TRUE
	else if(hard_drive == H)
		hard_drive = null
		found = TRUE
		critical = TRUE
	else if(network_card == H)
		network_card = null
		found = TRUE
	else if(nano_printer == H)
		nano_printer = null
		found = TRUE
	else if(card_slot == H)
		card_slot = null
		found = TRUE
	else if(battery_module == H)
		battery_module = null
		found = TRUE
	else if(processor_unit == H)
		processor_unit = null
		found = TRUE
		critical = 1
	else if(ai_slot == H)
		ai_slot = null
		found = TRUE
	else if(tesla_link == H)
		tesla_link = null
		found = TRUE

	if(found)
		if(user)
			to_chat(user, SPAN_NOTICE("You remove \the [H] from \the [src]."))
		H.forceMove(get_turf(src))
		if(put_in_hands)
			user.put_in_hands(H)
		H.parent_computer = null
		update_icon()
		if(critical && enabled)
			to_chat(user, SPAN_WARNING("\The [src]'s screen freezes for few seconds and then displays, \"HARDWARE ERROR: Critical component disconnected. Please verify component connection and reboot the device. If the problem persists contact technical support for assistance.\"."))
			shutdown_computer()


// Checks all hardware pieces to determine if name matches, if yes, returns the hardware piece, otherwise returns null
/obj/item/modular_computer/proc/find_hardware_by_name(var/name)
	if(portable_drive && (initial(portable_drive.name) == name))
		return portable_drive
	if(hard_drive && (initial(hard_drive.name) == name))
		return hard_drive
	if(network_card && (initial(network_card.name) == name))
		return network_card
	if(nano_printer && (initial(nano_printer.name) == name))
		return nano_printer
	if(card_slot && (initial(card_slot.name) == name))
		return card_slot
	if(battery_module && (initial(battery_module.name) == name))
		return battery_module
	if(processor_unit && (initial(processor_unit.name) == name))
		return processor_unit
	if(ai_slot && (initial(ai_slot.name) == name))
		return ai_slot
	if(tesla_link && (initial(tesla_link.name) == name))
		return tesla_link
	return null

// Returns list of all components
/obj/item/modular_computer/proc/get_all_components()
	var/list/all_components = list()
	if(hard_drive)
		all_components.Add(hard_drive)
	if(network_card)
		all_components.Add(network_card)
	if(portable_drive)
		all_components.Add(portable_drive)
	if(nano_printer)
		all_components.Add(nano_printer)
	if(card_slot)
		all_components.Add(card_slot)
	if(battery_module)
		all_components.Add(battery_module)
	if(processor_unit)
		all_components.Add(processor_unit)
	if(ai_slot)
		all_components.Add(ai_slot)
	if(tesla_link)
		all_components.Add(tesla_link)
	return all_components