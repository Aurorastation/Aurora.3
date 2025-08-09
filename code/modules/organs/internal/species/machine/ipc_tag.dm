/obj/item/organ/internal/machine/ipc_tag
	name = "identification tag"
	organ_tag = BP_IPCTAG
	parent_organ = BP_HEAD
	icon = 'icons/obj/ipc_utilities.dmi'
	icon_state = "ipc_tag"
	item_state = "ipc_tag"
	dead_icon = "ipc_tag_dead"
	contained_sprite = TRUE
	robotic_sprite = FALSE
	var/auto_generate = TRUE
	var/serial_number = ""
	var/ownership_info = IPC_OWNERSHIP_COMPANY
	var/citizenship_info = CITIZENSHIP_NONE

/obj/item/organ/internal/machine/ipc_tag/get_examine_text(mob/user, distance, is_adjacent, infix, suffix)
	. = ..()
	. += SPAN_NOTICE("Serial Autogeneration: [auto_generate ? "Yes" : "No"]")
	. += SPAN_NOTICE("Serial Number: [serial_number]")
	. += SPAN_NOTICE("Ownership Info: [ownership_info]")
	. += SPAN_NOTICE("Citizenship Info: [citizenship_info]")

/obj/item/organ/internal/machine/ipc_tag/get_diagnostics_info()
	return "S/N: [serial_number] | OWN: [ownership_info] | CTZ: [citizenship_info]"

/obj/item/organ/internal/machine/ipc_tag/high_integrity_damage(integrity)
	. = ..()
	if(get_integrity_damage_probability())
		serial_number = Gibberish(serial_number, rand(1, get_integrity_damage_probability()))

/obj/item/organ/internal/machine/ipc_tag/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/ipc_tag_scanner))
		if(src.loc != user)
			to_chat(user, SPAN_WARNING("You can't scan \the [src] if it's not on your person!"))
			return
		var/obj/item/ipc_tag_scanner/S = attacking_item
		if(!S.powered)
			to_chat(user, SPAN_WARNING("\The [src] reads, \"Scanning failure, please submit scanner for repairs.\""))
			return
		if(!S.hacked)
			examinate(user, src)
		else
			user.visible_message(SPAN_WARNING("\The [user] starts fiddling with \the [src]..."), SPAN_NOTICE("You start fiddling with \the [src]..."))
			if(do_after(user, 30, src))
				if(src.loc != user)
					to_chat(user, SPAN_WARNING("You can only modify \the [src] if it's on your person!"))
					return

				var/static/list/modification_options = list("Serial Number", "Ownership Status", "Citizenship")
				var/choice = tgui_input_list(user, "How do you want to modify the IPC tag?", "IPC Tag Modification", modification_options)
				switch(choice)

					if("Serial Number")
						var/serial_selection = tgui_input_list(user, "In what way do you want to modify the serial number?","Serial Number Selection",
																list("Auto Generation", "Manual Input", "Cancel"), default = "Cancel")
						if(serial_selection != "Cancel")
							if(serial_selection == "Auto Generation")
								var/auto_generation_choice = tgui_input_list(user, "Do you wish for the IPC tag to automatically generate its serial number based on the IPCs name?", "Serial Autogeneration",
																			list("Yes", "No"), "No")
								if(auto_generation_choice == "Yes")
									auto_generate = TRUE
								else
									auto_generate = FALSE

							if(serial_selection == "Manual Input")
								var/new_serial = tgui_input_text(user, "What do you wish for the new serial number to be? (Limit of 12 characters)", "Serial Number Modification", serial_number, 12)
								new_serial = uppertext(dd_limittext(new_serial, 12))
								if(new_serial)
									serial_number = new_serial
									auto_generate = FALSE

					if("Ownership Status")
						var/static/list/ownership_options = list(IPC_OWNERSHIP_COMPANY, IPC_OWNERSHIP_PRIVATE, IPC_OWNERSHIP_SELF)
						var/new_ownership = tgui_input_list(user, "What do you wish for the new ownership status to be?", "Ownership Status Modification", ownership_options)
						if(new_ownership)
							ownership_info = new_ownership

					if("Citizenship")
						var/datum/citizenship/citizenship = tgui_input_list(user, "What do you wish for the new citizenship setting to be?", "Citizenship Setting Modification", SSrecords.citizenships)
						if(citizenship)
							citizenship_info = citizenship
	else
		..()

/obj/item/organ/internal/machine/ipc_tag/proc/modify_tag_data(var/can_be_untagged = FALSE)
	if(!owner || owner.stat)
		return
	if(can_be_untagged)
		var/untagged = tgui_alert(owner, "Do you wish to remove your tag? This is highly illegal in most nations!", "Untagged IPC", list("Remove Tag", "Keep Tag"))
		if(untagged == "Remove Tag")
			to_chat(owner, SPAN_WARNING("You are now an untagged synthetic - don't get caught!"))
			qdel(src)
			return
	var/new_ownership = tgui_input_list(owner, "Choose an ownership status for your IPC tag.", "Tag Ownership", list(IPC_OWNERSHIP_COMPANY, IPC_OWNERSHIP_PRIVATE, IPC_OWNERSHIP_SELF))
	if(!new_ownership)
		return
	ownership_info = new_ownership
	if(ownership_info == IPC_OWNERSHIP_SELF) //Owned IPCs don't have citizenship
		var/new_citizenship = tgui_input_list(owner, "Choose a citizenship for your IPC tag.", "Tag Citizenship", CITIZENSHIPS_ALL_IPC)
		if(!new_citizenship)
			return
		citizenship_info = new_citizenship
	else
		citizenship_info = CITIZENSHIP_NONE
	var/new_serial = tgui_input_text(owner, "Choose a serial number for your IPC tag, or leave blank for a random one.", "Serial Number")
	if(!new_serial)
		serial_number = uppertext(dd_limittext(md5(owner.real_name), 12))
	else
		serial_number = uppertext(dd_limittext(new_serial, 12))
	to_chat(owner, SPAN_NOTICE("IPC tag data has been updated."))
