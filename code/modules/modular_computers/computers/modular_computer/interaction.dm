/obj/item/modular_computer/proc/eject_id()
	set name = "Eject ID"
	set category = "Object"
	set src in view(1)

	if(use_check_and_message(usr))
		return

	if(!card_slot)
		to_chat(usr, SPAN_WARNING("\The [src] does not have an ID card slot."))
		return

	if(!card_slot.stored_card)
		to_chat(usr, SPAN_WARNING("There is no card in \the [src]."))
		return

	if(active_program)
		active_program.event_idremoved(FALSE)

	for(var/datum/computer_file/program/P in idle_threads)
		P.event_idremoved(TRUE)

	card_slot.eject_id(usr)

	update_uis()
	to_chat(usr, SPAN_NOTICE("You remove the card from \the [src]."))


/obj/item/modular_computer/proc/eject_usb()
	set name = "Eject Portable Storage"
	set category = "Object"
	set src in view(1)

	if(use_check_and_message(usr))
		return

	if(!portable_drive)
		to_chat(usr, SPAN_WARNING("There is no portable drive connected to \the [src]."))
		return

	uninstall_component(usr, portable_drive, put_in_hands = TRUE)
	verbs -= /obj/item/modular_computer/proc/eject_usb
	update_uis()

/obj/item/modular_computer/proc/eject_item()
	set name = "Eject Stored Item"
	set category = "Object"
	set src in view(1)

	if(use_check_and_message(usr))
		return

	if(!card_slot)
		to_chat(usr, SPAN_WARNING("\The [src] does not have an ID card slot."))
		return

	if(!card_slot.stored_item)
		to_chat(usr, SPAN_WARNING("There is no item stored in \the [src]."))
		return

	var/I = card_slot.stored_item.name

	if(ishuman(usr))
		usr.put_in_hands(card_slot.stored_item)
	else
		card_slot.stored_item.forceMove(get_turf(src))

	card_slot.stored_item = null
	update_uis()
	verbs -= /obj/item/modular_computer/proc/eject_item
	to_chat(usr, SPAN_NOTICE("You remove \the [I] from \the [src]."))

/obj/item/modular_computer/proc/eject_battery()
	set name = "Eject Battery"
	set category = "Object"
	set src in view(1)

	if(use_check_and_message(usr))
		return

	if(!battery_module)
		to_chat(usr, SPAN_WARNING("\The [src] doesn't have a battery installed."))
		return

	if(!battery_module.hotswappable)
		to_chat(usr, SPAN_WARNING("\The [src]'s battery isn't removable without tools!"))
		return

	uninstall_component(usr, battery_module, put_in_hands = TRUE)
	verbs -= /obj/item/modular_computer/proc/eject_battery
	update_uis()

/obj/item/modular_computer/proc/eject_ai()
	set name = "Eject AI Storage"
	set category = "Object"
	set src in view(1)

	if(use_check_and_message(usr))
		return

	if(!ai_slot)
		to_chat(usr, SPAN_WARNING("\The [src] doesn't have an intellicard slot."))
		return

	if(!ai_slot.stored_card)
		to_chat(usr, SPAN_WARNING("There is no intellicard connected to \the [src]."))
		return

	if(ishuman(usr))
		usr.put_in_hands(ai_slot.stored_card)
	else
		ai_slot.stored_card.forceMove(get_turf(src))
	ai_slot.stored_card = null
	ai_slot.update_power_usage()
	verbs -= /obj/item/modular_computer/proc/eject_ai
	update_uis()

/obj/item/modular_computer/proc/eject_personal_ai()
	set name = "Eject Personal AI"
	set category = "Object"
	set src in view(1)

	if(use_check_and_message(usr))
		return

	if(!personal_ai)
		to_chat(usr, SPAN_WARNING("There is no personal AI connected to \the [src]."))
		return

	uninstall_component(usr, personal_ai, put_in_hands = TRUE)
	verbs -= /obj/item/modular_computer/proc/eject_personal_ai
	update_uis()

/obj/item/modular_computer/AltClick(var/mob/user)
	if(use_check_and_message(user, 32))
		return

	if(!card_slot)
		to_chat(user, SPAN_WARNING("\The [src] does not have an ID card slot."))
		return

	if(card_slot.stored_card)
		eject_id()
	else if(card_slot.stored_item)
		eject_item()
	else
		to_chat(user, SPAN_WARNING("\The [src] does not have a card or item stored in the card slot."))

/obj/item/modular_computer/attack(mob/living/M, mob/living/user, var/sound_scan)
	if(scan_mode == SCANNER_MEDICAL)
		health_scan_mob(M, user, TRUE, sound_scan = sound_scan)

/obj/item/modular_computer/afterattack(atom/A, mob/user, proximity_flag, click_parameters)
	. = ..()
	if(!proximity_flag)
		return
	if(scan_mode == SCANNER_REAGENT)
		if(!isobj(A) || isnull(A.reagents))
			return
		var/reagents_length = LAZYLEN(A.reagents.reagent_volumes)
		if(reagents_length)
			to_chat(user, SPAN_NOTICE("[reagents_length] chemical agent[reagents_length > 1 ? "s" : ""] found."))
			for(var/_re in A.reagents.reagent_volumes)
				var/decl/reagent/re = decls_repository.get_decl(_re)
				to_chat(user, SPAN_NOTICE("    [re.name]"))
		else
			to_chat(user, SPAN_NOTICE("No active chemical agents found in [A]."))

	else if(scan_mode == SCANNER_GAS)
		analyze_gases(A, user)

/obj/item/modular_computer/attack_ghost(var/mob/abstract/observer/user)
	if(enabled)
		ui_interact(user)
	else if(check_rights(R_ADMIN, 0, user))
		var/response = alert(user, "This computer is turned off. Would you like to turn it on?", "Admin Override", "Yes", "No")
		if(response == "Yes")
			turn_on(user)

/obj/item/modular_computer/attack_hand(var/mob/user)
	if(anchored)
		return attack_self(user)
	return ..()

/obj/item/modular_computer/attack_ai(var/mob/user)
	if(!ai_can_interact(user))
		return
	if(anchored)
		return attack_self(user)
	return ..()

// pai can take a look, but they cannot interact with the UI
/obj/item/modular_computer/attack_pai(mob/user)
	return attack_self(user)

// On-click handling. Turns on the computer if it's off and opens the GUI.
/obj/item/modular_computer/attack_self(mob/user)
	if(enabled && screen_on)
		ui_interact(user)
	else if(!enabled && screen_on)
		turn_on(user)

/obj/item/modular_computer/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/card/tech_support))
		if(!can_reset)
			to_chat(user, SPAN_WARNING("You cannot reset this type of device."))
			return TRUE
		if(!enabled)
			to_chat(user, SPAN_WARNING("You cannot reset the device if it isn't powered on."))
			return TRUE
		if(!hard_drive)
			to_chat(user, SPAN_WARNING("You cannot reset a device that has no hard drive."))
			return TRUE
		enrolled = 0
		hard_drive.reset_drive()
		audible_message("[icon2html(src, viewers(get_turf(src)))] <b>[src]</b> pings, <span class='notice'>\"Enrollment status reset! Have a NanoTrasen day.\"</span>")
		return TRUE
	if(istype(W, /obj/item/card/id)) // ID Card, try to insert it.
		var/obj/item/card/id/I = W
		if(!card_slot)
			to_chat(user, SPAN_WARNING("You try to insert \the [I] into \the [src], but it does not have an ID card slot installed."))
			return TRUE

		user.drop_from_inventory(I, src)
		if(card_slot.stored_card)
			eject_id()

		card_slot.insert_id(I)
		update_uis()
		to_chat(user, SPAN_NOTICE("You insert \the [I] into \the [src]."))
		return TRUE
	if(is_type_in_list(W, card_slot?.allowed_items))
		if(!card_slot)
			to_chat(user, SPAN_WARNING("You try to insert \the [W] into \the [src], but it does not have an ID card slot installed."))
			return TRUE
		if(card_slot.stored_item)
			to_chat(user, SPAN_WARNING("You try to insert \the [W] into \the [src], but its storage slot is occupied."))
			return TRUE

		user.drop_from_inventory(W, src)
		card_slot.stored_item = W
		update_uis()
		verbs += /obj/item/modular_computer/proc/eject_item
		to_chat(user, SPAN_NOTICE("You insert \the [W] into \the [src]."))
		return TRUE
	if(istype(W, /obj/item/paper))
		if(!nano_printer)
			return TRUE
		nano_printer.attackby(W, user)
		return TRUE
	if(istype(W, /obj/item/aicard))
		if(ai_slot)
			ai_slot.attackby(W, user)
		return TRUE
	if(istype(W, /obj/item/computer_hardware))
		var/obj/item/computer_hardware/C = W
		if(C.hardware_size <= max_hardware_size)
			try_install_component(user, C)
		else
			to_chat(user, SPAN_WARNING("This component is too large for \the [src]."))
		return TRUE
	if(istype(W, /obj/item/device/paicard))
		try_install_component(user, W)
		return TRUE
	if(W.iswrench())
		var/list/components = get_all_components()
		if(components.len)
			to_chat(user, SPAN_WARNING("You have to remove all the components from \the [src] before disassembling it."))
			return TRUE
		to_chat(user, SPAN_NOTICE("You begin to disassemble \the [src]."))
		if(W.use_tool(src, user, 20, volume = 50))
			new /obj/item/stack/material/steel(get_turf(src), steel_sheet_cost)
			user.visible_message(SPAN_NOTICE("\The [user] disassembles \the [src]."), SPAN_NOTICE("You disassemble \the [src]."), SPAN_NOTICE("You hear a ratcheting noise."))
			qdel(src)
		return TRUE
	if(W.iswelder())
		var/obj/item/weldingtool/WT = W
		if(!WT.isOn())
			to_chat(user, SPAN_WARNING("\The [W] is off."))
			return TRUE

		if(!damage)
			to_chat(user, SPAN_WARNING("\The [src] does not require repairs."))
			return TRUE

		to_chat(user, SPAN_NOTICE("You begin repairing the damage to \the [src]..."))
		playsound(get_turf(src), 'sound/items/welder.ogg', 100, 1)
		if(WT.use(round(damage / 75)) && do_after(user, damage / 10))
			damage = 0
			to_chat(user, SPAN_NOTICE("You fully repair \the [src]."))
		update_icon()
		return TRUE

	if(W.isscrewdriver())
		var/list/all_components = get_all_components()
		if(!all_components.len)
			to_chat(user, SPAN_WARNING("This device doesn't have any components installed."))
			return TRUE

		var/obj/item/computer_hardware/choice = input(user, "Which component do you want to uninstall?", "Hardware Removal") as null|anything in all_components
		if(!choice)
			return TRUE
		if(!Adjacent(usr))
			return TRUE

		var/obj/item/computer_hardware/H = find_hardware_by_name(initial(choice.name))
		if(!H)
			return TRUE
		uninstall_component(user, H)
		return TRUE
	return ..()

/obj/item/modular_computer/MouseDrop(atom/over_object)
	var/mob/M = usr
	if(use_check_and_message(M))
		return
	if(istype(over_object, /obj/machinery/power/apc) && tesla_link)
		return over_object.attackby(src, M)
	if(!istype(over_object, /obj/screen) && !(over_object == src))
		return attack_self(M)

/obj/item/modular_computer/GetID()
	if(card_slot)
		return card_slot.stored_card

/obj/item/modular_computer/hear_talk(mob/M, text, verb, datum/language/speaking)
	if(Adjacent(M) && hard_drive)
		var/datum/computer_file/program/chat_client/P = hard_drive.find_file_by_name("ntnrc_client")
		if(!P || (P.program_state == PROGRAM_STATE_KILLED && P.service_state == PROGRAM_STATE_KILLED))
			return
		if(P.focused_conv)
			P.focused_conv.cl_send(P, text, M)
