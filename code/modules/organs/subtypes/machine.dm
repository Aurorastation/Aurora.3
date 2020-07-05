//////////////
// IPC limbs//
//////////////
/obj/item/organ/external/head/ipc
	dislocated = -1
	can_intake_reagents = 0
	encased = "support frame"
	robotize_type = PROSTHETIC_IPC

/obj/item/organ/external/chest/ipc
	dislocated = -1
	encased = "support frame"
	robotize_type = PROSTHETIC_IPC

/obj/item/organ/external/groin/ipc
	dislocated = -1
	encased = "support frame"
	robotize_type = PROSTHETIC_IPC

/obj/item/organ/external/arm/ipc
	dislocated = -1
	encased = "support frame"
	robotize_type = PROSTHETIC_IPC

/obj/item/organ/external/arm/right/ipc
	dislocated = -1
	encased = "support frame"
	robotize_type = PROSTHETIC_IPC

/obj/item/organ/external/leg/ipc
	dislocated = -1
	encased = "support frame"
	robotize_type = PROSTHETIC_IPC

/obj/item/organ/external/leg/right/ipc
	dislocated = -1
	encased = "support frame"
	robotize_type = PROSTHETIC_IPC

/obj/item/organ/external/foot/ipc
	dislocated = -1
	encased = "support frame"
	robotize_type = PROSTHETIC_IPC

/obj/item/organ/external/foot/right/ipc
	dislocated = -1
	encased = "support frame"
	robotize_type = PROSTHETIC_IPC

/obj/item/organ/external/hand/ipc
	dislocated = -1
	encased = "support frame"
	robotize_type = PROSTHETIC_IPC

/obj/item/organ/external/hand/right/ipc
	dislocated = -1
	encased = "support frame"
	robotize_type = PROSTHETIC_IPC

/obj/item/organ/internal/cell
	name = "microbattery"
	desc = "A small, powerful cell for use in fully prosthetic bodies."
	icon = 'icons/obj/power.dmi'
	icon_state = "scell"
	organ_tag = "cell"
	parent_organ = BP_CHEST
	vital = 1
	var/emp_counter = 0

/obj/item/organ/internal/cell/Initialize()
	robotize()
	. = ..()

/obj/item/organ/internal/cell/process()
	..()
	if(emp_counter)
		emp_counter--

/obj/item/organ/internal/cell/emp_act(severity)
	emp_counter += 30/severity
	if(emp_counter >= 30)
		owner.Paralyse(emp_counter/6)
		to_chat(owner, "<span class='danger'>%#/ERR: Power leak detected!$%^/</span>")


/obj/item/organ/internal/surge
	name = "surge preventor"
	desc = "A small device that give immunity to EMP for few pulses."
	icon = 'icons/obj/robot_component.dmi'
	icon_state = "surge_ipc"
	organ_tag = "surge"
	parent_organ = BP_CHEST
	vital = 0
	var/surge_left = 0
	var/broken = 0

/obj/item/organ/internal/surge/Initialize()
	if(!surge_left && !broken)
		surge_left = rand(2, 5)
	robotize()
	. = ..()

/obj/item/organ/internal/surge/advanced
	name = "advanced surge preventor"
	var/max_charges = 5
	var/stage_ticker = 0
	var/stage_interval = 250

/obj/item/organ/internal/surge/advanced/process()
	..()

	if(!owner)
		return

	if(surge_left >= max_charges)
		return

	if(stage_ticker < stage_interval)
		stage_ticker += 2

	if(stage_ticker >= stage_interval)
		surge_left += 1
		stage_interval += 250

/obj/item/organ/internal/eyes/optical_sensor
	name = "optical sensor"
	singular_name = "optical sensor"
	organ_tag = "optics"
	icon = 'icons/obj/robot_component.dmi'
	icon_state = "camera"
	dead_icon = "camera_broken"

/obj/item/organ/internal/eyes/optical_sensor/Initialize()
	robotize()
	. = ..()

/obj/item/organ/internal/ipc_tag
	name = "identification tag"
	organ_tag = "ipc tag"
	parent_organ = BP_HEAD
	icon = 'icons/obj/ipc_utilities.dmi'
	icon_state = "ipc_tag"
	item_state = "ipc_tag"
	dead_icon = "ipc_tag_dead"
	contained_sprite = TRUE
	var/auto_generate = TRUE
	var/serial_number = ""
	var/ownership_info = IPC_OWNERSHIP_COMPANY
	var/citizenship_info = CITIZENSHIP_BIESEL

/obj/item/organ/internal/ipc_tag/Initialize()
	robotize()
	. = ..()

/obj/item/organ/internal/ipc_tag/examine(mob/user)
	..()
	to_chat(user, SPAN_NOTICE("Serial Autogeneration: [auto_generate ? "Yes" : "No"]"))
	to_chat(user, SPAN_NOTICE("Serial Number: [serial_number]"))
	to_chat(user, SPAN_NOTICE("Ownership Info: [ownership_info]"))
	to_chat(user, SPAN_NOTICE("Citizenship Info: [citizenship_info]"))

/obj/item/organ/internal/ipc_tag/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/ipc_tag_scanner))
		if(src.loc != user)
			to_chat(user, SPAN_WARNING("You can't scan \the [src] if it's not on your person!"))
			return
		var/obj/item/ipc_tag_scanner/S = W
		if(!S.powered)
			to_chat(user, SPAN_WARNING("\The [src] reads, \"Scanning failure, please submit scanner for repairs.\""))
			return
		if(!S.hacked)
			user.examinate(src)
		else
			user.visible_message(SPAN_WARNING("\The [user] starts fiddling with \the [src]..."), SPAN_NOTICE("You start fiddling with \the [src]..."))
			if(do_after(user, 30, TRUE, src))
				if(src.loc != user)
					to_chat(user, SPAN_WARNING("You can only modify \the [src] if it's on your person!"))
					return
				var/static/list/modification_options = list("Serial Number", "Ownership Status", "Citizenship")
				var/choice = input(user, "How do you want to modify the IPC tag?", "IPC Tag Modification") as null|anything in modification_options
				if(choice)
					if(choice == "Serial Number")
						var/serial_selection = alert(user, "In what way do you want to modify the serial number?", "Serial Number Selection", "Auto Generation", "Manual Input", "Cancel")
						if(serial_selection != "Cancel")
							if(serial_selection == "Auto Generation")
								var/auto_generation_choice = alert(user, "Do you wish for the IPC tag to automatically generate its serial number based on the IPCs name?", "Serial Autogeneration", "Yes", "No")
								if(auto_generation_choice == "Yes")
									auto_generate = TRUE
								else
									auto_generate = FALSE
							if(serial_selection == "Manual Input")
								var/new_serial = input(user, "What do you wish for the new serial number to be? (Limit of 12 characters)", "Serial Number Modification", serial_number) as text|null
								new_serial = uppertext(dd_limittext(new_serial, 12))
								if(new_serial)
									serial_number = new_serial
									auto_generate = FALSE
					if(choice == "Ownership Status")
						var/static/list/ownership_options = list(IPC_OWNERSHIP_COMPANY, IPC_OWNERSHIP_PRIVATE, IPC_OWNERSHIP_SELF)
						var/new_ownership = input(user, "What do you wish for the new ownership status to be?", "Ownership Status Modification") as null|anything in ownership_options
						if(new_ownership)
							ownership_info = new_ownership
					if(choice == "Citizenship")
						var/datum/citizenship/citizenship = input(user, "What do you wish for the new citizenship setting to be?", "Citizenship Setting Modification") as null|anything in SSrecords.citizenships
						if(citizenship)
							citizenship_info = citizenship
	else
		..()

// Used for an MMI or posibrain being installed into a human.
/obj/item/organ/internal/mmi_holder
	name = "brain"
	organ_tag = BP_BRAIN
	parent_organ = BP_HEAD
	vital = 1
	var/obj/item/device/mmi/stored_mmi

/obj/item/organ/internal/mmi_holder/proc/update_from_mmi()
	if(!stored_mmi)
		return
	name = stored_mmi.name
	desc = stored_mmi.desc
	icon = stored_mmi.icon
	icon_state = stored_mmi.icon_state

/obj/item/organ/internal/mmi_holder/removed(var/mob/living/user)

	if(stored_mmi)
		stored_mmi.forceMove(get_turf(src))
		if(owner.mind)
			owner.mind.transfer_to(stored_mmi.brainmob)
	. = ..()

	var/mob/living/holder_mob = loc
	if(istype(holder_mob))
		holder_mob.drop_from_inventory(src)
	qdel(src)

/obj/item/organ/internal/mmi_holder/posibrain/Initialize()
	robotize()
	stored_mmi = new /obj/item/device/mmi/digital/posibrain(src)
	. = ..()
	addtimer(CALLBACK(src, .proc/setup_brain), 1)

/obj/item/organ/internal/mmi_holder/posibrain/proc/setup_brain()
	if(owner)
		stored_mmi.name = "positronic brain ([owner.name])"
		stored_mmi.brainmob.real_name = owner.name
		stored_mmi.brainmob.name = stored_mmi.brainmob.real_name
		stored_mmi.icon_state = "posibrain-occupied"
		update_from_mmi()
	else
		stored_mmi.forceMove(get_turf(src))
		qdel(src)

/obj/item/organ/internal/mmi_holder/circuit/Initialize()
	robotize()
	stored_mmi = new /obj/item/device/mmi/digital/robot(src)
	. = ..()
	addtimer(CALLBACK(src, .proc/setup_brain), 1)

/obj/item/organ/internal/mmi_holder/circuit/proc/setup_brain()
	if(owner)
		stored_mmi.name = "robotic intelligence circuit ([owner.name])"
		stored_mmi.brainmob.real_name = owner.name
		stored_mmi.brainmob.name = stored_mmi.brainmob.real_name
		update_from_mmi()
	else
		stored_mmi.forceMove(get_turf(src))
		qdel(src)

//////////////
//Terminator//
//////////////

/obj/item/organ/internal/mmi_holder/posibrain/terminator
	name = BP_BRAIN
	organ_tag = BP_BRAIN
	parent_organ = BP_CHEST
	vital = 1
	emp_coeff = 0.1

/obj/item/organ/internal/data
	name = "data core"
	organ_tag = "data core"
	parent_organ = BP_GROIN
	icon = 'icons/obj/cloning.dmi'
	icon_state = "harddisk"
	vital = 0
	emp_coeff = 0.1

/obj/item/organ/internal/data/Initialize()
	robotize()
	. = ..()

/obj/item/organ/internal/cell/terminator
	name = "shielded microbattery"
	desc = "A small, powerful cell for use in fully prosthetic bodies. Equipped with a Faraday shield."
	icon = 'icons/obj/power.dmi'
	icon_state = "scell"
	organ_tag = "shielded cell"
	parent_organ = BP_CHEST
	vital = 1
	emp_coeff = 0.1

/obj/item/organ/internal/cell/Initialize()
	robotize()
	. = ..()

/obj/item/organ/external/head/terminator
	dislocated = -1
	can_intake_reagents = 0
	encased = "reinforced support frame"
	emp_coeff = 0.5
	robotize_type = PROSTHETIC_HK

/obj/item/organ/internal/eyes/optical_sensor/terminator
	emp_coeff = 0.5

/obj/item/organ/external/chest/terminator
	dislocated = -1
	encased = "reinforced support frame"
	emp_coeff = 0.5
	robotize_type = PROSTHETIC_HK

/obj/item/organ/external/groin/terminator
	dislocated = -1
	encased = "reinforced support frame"
	emp_coeff = 0.5
	robotize_type = PROSTHETIC_HK

/obj/item/organ/external/arm/terminator
	dislocated = -1
	encased = "reinforced support frame"
	emp_coeff = 0.5
	robotize_type = PROSTHETIC_HK

/obj/item/organ/external/arm/right/terminator
	dislocated = -1
	encased = "reinforced support frame"
	emp_coeff = 0.5
	robotize_type = PROSTHETIC_HK

/obj/item/organ/external/leg/terminator
	dislocated = -1
	encased = "reinforced support frame"
	emp_coeff = 0.5
	robotize_type = PROSTHETIC_HK

/obj/item/organ/external/leg/right/terminator
	dislocated = -1
	encased = "reinforced support frame"
	emp_coeff = 0.5
	robotize_type = PROSTHETIC_HK

/obj/item/organ/external/foot/terminator
	dislocated = -1
	encased = "reinforced support frame"
	emp_coeff = 0.5
	robotize_type = PROSTHETIC_HK

/obj/item/organ/external/foot/right/terminator
	dislocated = -1
	encased = "reinforced support frame"
	emp_coeff = 0.5
	robotize_type = PROSTHETIC_HK

/obj/item/organ/external/hand/terminator
	dislocated = -1
	encased = "reinforced support frame"
	emp_coeff = 0.5
	robotize_type = PROSTHETIC_HK

/obj/item/organ/external/hand/right/terminator
	dislocated = -1
	encased = "reinforced support frame"
	emp_coeff = 0.5
	robotize_type = PROSTHETIC_HK

//////////////
//Industrial//
//////////////

/obj/item/organ/external/head/industrial
	dislocated = -1
	can_intake_reagents = 0
	encased = "support frame"
	robotize_type = PROSTHETIC_IND

/obj/item/organ/external/chest/industrial
	dislocated = -1
	encased = "support frame"
	robotize_type = PROSTHETIC_IND

/obj/item/organ/external/groin/industrial
	dislocated = -1
	encased = "support frame"
	robotize_type = PROSTHETIC_IND

/obj/item/organ/external/arm/industrial
	dislocated = -1
	encased = "support frame"
	robotize_type = PROSTHETIC_IND

/obj/item/organ/external/arm/right/industrial
	dislocated = -1
	encased = "support frame"
	robotize_type = PROSTHETIC_IND

/obj/item/organ/external/leg/industrial
	dislocated = -1
	encased = "support frame"
	robotize_type = PROSTHETIC_IND

/obj/item/organ/external/leg/right/industrial
	dislocated = -1
	encased = "support frame"
	robotize_type = PROSTHETIC_IND

/obj/item/organ/external/foot/industrial
	dislocated = -1
	encased = "support frame"
	robotize_type = PROSTHETIC_IND

/obj/item/organ/external/foot/right/industrial
	dislocated = -1
	encased = "support frame"
	robotize_type = PROSTHETIC_IND

/obj/item/organ/external/hand/industrial
	dislocated = -1
	encased = "support frame"
	robotize_type = PROSTHETIC_IND

/obj/item/organ/external/hand/right/industrial
	dislocated = -1
	encased = "support frame"
	robotize_type = PROSTHETIC_IND

///////////////
//Shell limbs//
///////////////

/obj/item/organ/external/head/shell
	dislocated = -1
	can_intake_reagents = 0
	encased = "support frame"
	force_skintone = TRUE
	robotize_type = PROSTHETIC_SYNTHSKIN

/obj/item/organ/external/chest/shell
	dislocated = -1
	encased = "support frame"
	force_skintone = TRUE
	robotize_type = PROSTHETIC_SYNTHSKIN

/obj/item/organ/external/groin/shell
	dislocated = -1
	encased = "support frame"
	force_skintone = TRUE
	robotize_type = PROSTHETIC_SYNTHSKIN

/obj/item/organ/external/arm/shell
	dislocated = -1
	encased = "support frame"
	force_skintone = TRUE
	robotize_type = PROSTHETIC_SYNTHSKIN

/obj/item/organ/external/arm/right/shell
	dislocated = -1
	encased = "support frame"
	force_skintone = TRUE
	robotize_type = PROSTHETIC_SYNTHSKIN

/obj/item/organ/external/leg/shell
	dislocated = -1
	encased = "support frame"
	force_skintone = TRUE
	robotize_type = PROSTHETIC_SYNTHSKIN

/obj/item/organ/external/leg/right/shell
	dislocated = -1
	encased = "support frame"
	force_skintone = TRUE
	robotize_type = PROSTHETIC_SYNTHSKIN

/obj/item/organ/external/foot/shell
	dislocated = -1
	encased = "support frame"
	force_skintone = TRUE
	robotize_type = PROSTHETIC_SYNTHSKIN

/obj/item/organ/external/foot/right/shell
	dislocated = -1
	encased = "support frame"
	force_skintone = TRUE
	robotize_type = PROSTHETIC_SYNTHSKIN

/obj/item/organ/external/hand/shell
	dislocated = -1
	encased = "support frame"
	force_skintone = TRUE
	robotize_type = PROSTHETIC_SYNTHSKIN

/obj/item/organ/external/hand/right/shell
	dislocated = -1
	encased = "support frame"
	force_skintone = TRUE
	robotize_type = PROSTHETIC_SYNTHSKIN

//unbranded

/obj/item/organ/external/head/unbranded
	dislocated = -1
	can_intake_reagents = 0
	encased = "support frame"
	robotize_type = "Unbranded"

/obj/item/organ/external/chest/unbranded
	dislocated = -1
	encased = "support frame"
	robotize_type = "Unbranded"

/obj/item/organ/external/groin/unbranded
	dislocated = -1
	encased = "support frame"
	robotize_type = "Unbranded"

/obj/item/organ/external/arm/unbranded
	dislocated = -1
	encased = "support frame"
	robotize_type = "Unbranded"

/obj/item/organ/external/arm/right/unbranded
	dislocated = -1
	encased = "support frame"
	robotize_type = "Unbranded"

/obj/item/organ/external/leg/unbranded
	dislocated = -1
	encased = "support frame"
	robotize_type = "Unbranded"

/obj/item/organ/external/leg/right/unbranded
	dislocated = -1
	encased = "support frame"
	robotize_type = "Unbranded"

/obj/item/organ/external/foot/unbranded
	dislocated = -1
	encased = "support frame"
	robotize_type = "Unbranded"

/obj/item/organ/external/foot/right/unbranded
	dislocated = -1
	encased = "support frame"
	robotize_type = "Unbranded"

/obj/item/organ/external/hand/unbranded
	dislocated = -1
	encased = "support frame"
	robotize_type = "Unbranded"

/obj/item/organ/external/hand/right/unbranded
	dislocated = -1
	encased = "support frame"
	robotize_type = "Unbranded"