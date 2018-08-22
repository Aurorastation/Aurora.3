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

/obj/item/organ/cell
	name = "microbattery"
	desc = "A small, powerful cell for use in fully prosthetic bodies."
	icon = 'icons/obj/power.dmi'
	icon_state = "scell"
	organ_tag = "cell"
	parent_organ = "chest"
	vital = 1
	var/emp_counter = 0

/obj/item/organ/cell/Initialize()
	robotize()
	. = ..()

/obj/item/organ/cell/process()
	..()
	if(emp_counter)
		emp_counter--

/obj/item/organ/cell/emp_act(severity)
	emp_counter += 30/severity
	if(emp_counter >= 30)
		owner.Paralyse(emp_counter/6)
		owner << "<span class='danger'>%#/ERR: Power leak detected!$%^/</span>"


/obj/item/organ/surge
	name = "surge preventor"
	desc = "A small device that give immunity to EMP for few pulses."
	icon = 'icons/obj/robot_component.dmi'
	icon_state = "surge_ipc"
	organ_tag = "surge"
	parent_organ = "chest"
	vital = 0
	var/surge_left = 0
	var/broken = 0

/obj/item/organ/surge/Initialize()
	if(!surge_left && !broken)
		surge_left = rand(1, 3)
	robotize()
	. = ..()


/obj/item/organ/eyes/optical_sensor
	name = "optical sensor"
	singular_name = "optical sensor"
	organ_tag = "optics"
	icon = 'icons/obj/robot_component.dmi'
	icon_state = "camera"
	dead_icon = "camera_broken"

/obj/item/organ/eyes/optical_sensor/Initialize()
	robotize()
	. = ..()

/obj/item/organ/ipc_tag
	name = "identification tag"
	organ_tag = "ipc tag"
	parent_organ = "head"
	icon = 'icons/obj/telescience.dmi'
	icon_state = "gps-c"
	dead_icon = "gps-c"

/obj/item/organ/ipc_tag/Initialize()
	robotize()
	. = ..()

// Used for an MMI or posibrain being installed into a human.
/obj/item/organ/mmi_holder
	name = "brain"
	organ_tag = "brain"
	parent_organ = "head"
	vital = 1
	var/obj/item/device/mmi/stored_mmi

/obj/item/organ/mmi_holder/proc/update_from_mmi()
	if(!stored_mmi)
		return
	name = stored_mmi.name
	desc = stored_mmi.desc
	icon = stored_mmi.icon
	icon_state = stored_mmi.icon_state

/obj/item/organ/mmi_holder/removed(var/mob/living/user)

	if(stored_mmi)
		stored_mmi.forceMove(get_turf(src))
		if(owner.mind)
			owner.mind.transfer_to(stored_mmi.brainmob)
	. = ..()

	var/mob/living/holder_mob = loc
	if(istype(holder_mob))
		holder_mob.drop_from_inventory(src)
	qdel(src)

/obj/item/organ/mmi_holder/posibrain/Initialize()
	robotize()
	stored_mmi = new /obj/item/device/mmi/digital/posibrain(src)
	. = ..()
	addtimer(CALLBACK(src, .proc/setup_brain), 1)

/obj/item/organ/mmi_holder/posibrain/proc/setup_brain()
	if(owner)
		stored_mmi.name = "positronic brain ([owner.name])"
		stored_mmi.brainmob.real_name = owner.name
		stored_mmi.brainmob.name = stored_mmi.brainmob.real_name
		stored_mmi.icon_state = "posibrain-occupied"
		update_from_mmi()
	else
		stored_mmi.forceMove(get_turf(src))
		qdel(src)

//////////////
//Terminator//
//////////////

/obj/item/organ/mmi_holder/posibrain/terminator
	name = "brain"
	organ_tag = "brain"
	parent_organ = "chest"
	vital = 1
	emp_coeff = 0.1

/obj/item/organ/data
	name = "data core"
	organ_tag = "data core"
	parent_organ = "groin"
	icon = 'icons/obj/cloning.dmi'
	icon_state = "harddisk"
	vital = 0
	emp_coeff = 0.1

/obj/item/organ/data/Initialize()
	robotize()
	. = ..()

/obj/item/organ/cell/terminator
	name = "shielded microbattery"
	desc = "A small, powerful cell for use in fully prosthetic bodies. Equipped with a Faraday shield."
	icon = 'icons/obj/power.dmi'
	icon_state = "scell"
	organ_tag = "shielded cell"
	parent_organ = "chest"
	vital = 1
	emp_coeff = 0.1

/obj/item/organ/cell/Initialize()
	robotize()
	. = ..()

/obj/item/organ/external/head/terminator
	dislocated = -1
	can_intake_reagents = 0
	encased = "reinforced support frame"
	emp_coeff = 0.5
	robotize_type = PROSTHETIC_HK

/obj/item/organ/eyes/optical_sensor/terminator
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