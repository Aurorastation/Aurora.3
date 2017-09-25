//////////////
// IPC limbs//
//////////////
/obj/item/organ/external/head/ipc
	dislocated = -1
	can_intake_reagents = 0
	encased = "support frame"

/obj/item/organ/external/head/ipc/Initialize()
	robotize("Hephaestus Integrated Limb")
	. = ..()

/obj/item/organ/external/chest/ipc
	dislocated = -1
	encased = "support frame"

/obj/item/organ/external/chest/ipc/Initialize()
	robotize("Hephaestus Integrated Limb")
	. = ..()

/obj/item/organ/external/groin/ipc
	dislocated = -1
	encased = "support frame"

/obj/item/organ/external/groin/ipc/Initialize()
	robotize("Hephaestus Integrated Limb")
	. = ..()

/obj/item/organ/external/arm/ipc
	dislocated = -1
	encased = "support frame"

/obj/item/organ/external/arm/ipc/Initialize()
	robotize("Hephaestus Integrated Limb")
	. = ..()

/obj/item/organ/external/arm/right/ipc
	dislocated = -1
	encased = "support frame"

/obj/item/organ/external/arm/right/ipc/Initialize()
	robotize("Hephaestus Integrated Limb")
	. = ..()

/obj/item/organ/external/leg/ipc
	dislocated = -1
	encased = "support frame"

/obj/item/organ/external/leg/ipc/Initialize()
	robotize("Hephaestus Integrated Limb")
	. = ..()

/obj/item/organ/external/leg/right/ipc
	dislocated = -1

/obj/item/organ/external/leg/right/ipc/Initialize()
	robotize("Hephaestus Integrated Limb")
	. = ..()

/obj/item/organ/external/foot/ipc
	dislocated = -1
	encased = "support frame"

/obj/item/organ/external/foot/ipc/Initialize()
	robotize("Hephaestus Integrated Limb")
	. = ..()

/obj/item/organ/external/foot/right/ipc
	dislocated = -1
	encased = "support frame"

/obj/item/organ/external/foot/right/ipc/Initialize()
	robotize("Hephaestus Integrated Limb")
	. = ..()

/obj/item/organ/external/hand/ipc
	dislocated = -1
	encased = "support frame"

/obj/item/organ/external/hand/ipc/Initialize()
	robotize("Hephaestus Integrated Limb")
	. = ..()

/obj/item/organ/external/hand/right/ipc
	dislocated = -1
	encased = "support frame"

/obj/item/organ/external/hand/right/ipc/Initialize()
	robotize("Hephaestus Integrated Limb")
	. = ..()

/obj/item/organ/cell
	name = "microbattery"
	desc = "A small, powerful cell for use in fully prosthetic bodies."
	icon = 'icons/obj/power.dmi'
	icon_state = "scell"
	organ_tag = "cell"
	parent_organ = "chest"
	vital = 1

/obj/item/organ/cell/Initialize()
	robotize()
	. = ..()

/obj/item/organ/cell/replaced()
	. = ..()
	// This is very ghetto way of rebooting an IPC. TODO better way.
	if(owner && owner.stat == DEAD)
		owner.stat = 0
		owner.visible_message("<span class='danger'>\The [owner] twitches visibly!</span>")

/obj/item/organ/eyes/optical_sensor
	name = "optical sensor"
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
		stored_mmi.loc = get_turf(src)
		if(owner.mind)
			owner.mind.transfer_to(stored_mmi.brainmob)
	. = ..()

	var/mob/living/holder_mob = loc
	if(istype(holder_mob))
		holder_mob.drop_from_inventory(src)
	qdel(src)

/obj/item/organ/mmi_holder/Initialize(mapload)
	. = ..()
	// This is very ghetto way of rebooting an IPC. TODO better way.
	if (!mapload)
		addtimer(CALLBACK(src, .proc/attempt_revive), 1)

/obj/item/organ/mmi_holder/proc/attempt_revive()
	if (owner && owner.stat == DEAD)
		owner.stat = 0
		owner.visible_message("<span class='danger'>\The [owner] twitches visibly!</span>")

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
		stored_mmi.loc = get_turf(src)
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

/obj/item/organ/eyes/optical_sensor/terminator
	emp_coeff = 0.5

/obj/item/organ/external/head/terminator/Initialize()
	robotize("Hephaestus Vulcanite Limb")
	. = ..()

/obj/item/organ/external/chest/terminator
	dislocated = -1
	encased = "reinforced support frame"
	emp_coeff = 0.5

/obj/item/organ/external/chest/terminator/Initialize()
	robotize("Hephaestus Vulcanite Limb")
	. = ..()

/obj/item/organ/external/groin/terminator
	dislocated = -1
	encased = "reinforced support frame"
	emp_coeff = 0.5

/obj/item/organ/external/groin/terminator/Initialize()
	robotize("Hephaestus Vulcanite Limb")
	. = ..()

/obj/item/organ/external/arm/terminator
	dislocated = -1
	encased = "reinforced support frame"
	emp_coeff = 0.5

/obj/item/organ/external/arm/terminator/Initialize()
	robotize("Hephaestus Vulcanite Limb")
	. = ..()

/obj/item/organ/external/arm/right/terminator
	dislocated = -1
	encased = "reinforced support frame"
	emp_coeff = 0.5

/obj/item/organ/external/arm/right/terminator/Initialize()
	robotize("Hephaestus Vulcanite Limb")
	. = ..()

/obj/item/organ/external/leg/terminator
	dislocated = -1
	encased = "reinforced support frame"
	emp_coeff = 0.5

/obj/item/organ/external/leg/terminator/Initialize()
	robotize("Hephaestus Vulcanite Limb")
	. = ..()

/obj/item/organ/external/leg/right/terminator
	dislocated = -1
	encased = "reinforced support frame"
	emp_coeff = 0.5

/obj/item/organ/external/leg/right/terminator/Initialize()
	robotize("Hephaestus Vulcanite Limb")
	. = ..()

/obj/item/organ/external/foot/terminator
	dislocated = -1
	encased = "reinforced support frame"
	emp_coeff = 0.5

/obj/item/organ/external/foot/terminator/Initialize()
	robotize("Hephaestus Vulcanite Limb")
	. = ..()

/obj/item/organ/external/foot/right/terminator
	dislocated = -1
	encased = "reinforced support frame"
	emp_coeff = 0.5

/obj/item/organ/external/foot/right/terminator/Initialize()
	robotize("Hephaestus Vulcanite Limb")
	. = ..()

/obj/item/organ/external/hand/terminator
	dislocated = -1
	encased = "reinforced support frame"
	emp_coeff = 0.5

/obj/item/organ/external/hand/terminator/Initialize()
	robotize("Hephaestus Vulcanite Limb")
	. = ..()

/obj/item/organ/external/hand/right/terminator
	dislocated = -1
	encased = "reinforced support frame"
	emp_coeff = 0.5

/obj/item/organ/external/hand/right/terminator/Initialize()
	robotize("Hephaestus Vulcanite Limb")
	. = ..()

//////////////
//Industrial//
//////////////

/obj/item/organ/external/head/industrial
	dislocated = -1
	can_intake_reagents = 0
	encased = "support frame"

/obj/item/organ/external/head/industrial/Initialize()
	robotize("Hephaestus Industrial Limb")
	. = ..()

/obj/item/organ/external/chest/industrial
	dislocated = -1
	encased = "support frame"

/obj/item/organ/external/chest/industrial/Initialize()
	robotize("Hephaestus Industrial Limb")
	. = ..()

/obj/item/organ/external/groin/industrial
	dislocated = -1
	encased = "support frame"

/obj/item/organ/external/groin/industrial/Initialize()
	robotize("Hephaestus Industrial Limb")
	. = ..()

/obj/item/organ/external/arm/industrial
	dislocated = -1
	encased = "support frame"

/obj/item/organ/external/arm/industrial/Initialize()
	robotize("Hephaestus Industrial Limb")
	. = ..()

/obj/item/organ/external/arm/right/industrial
	dislocated = -1
	encased = "support frame"

/obj/item/organ/external/arm/right/industrial/Initialize()
	robotize("Hephaestus Industrial Limb")
	. = ..()

/obj/item/organ/external/leg/industrial
	dislocated = -1
	encased = "support frame"

/obj/item/organ/external/leg/industrial/Initialize()
	robotize("Hephaestus Industrial Limb")
	. = ..()

/obj/item/organ/external/leg/right/industrial
	dislocated = -1
	encased = "support frame"

/obj/item/organ/external/leg/right/industrial/Initialize()
	robotize("Hephaestus Industrial Limb")
	. = ..()

/obj/item/organ/external/foot/industrial
	dislocated = -1
	encased = "support frame"

/obj/item/organ/external/foot/industrial/Initialize()
	robotize("Hephaestus Industrial Limb")
	. = ..()

/obj/item/organ/external/foot/right/industrial
	dislocated = -1
	encased = "support frame"

/obj/item/organ/external/foot/right/industrial/Initialize()
	robotize("Hephaestus Industrial Limb")
	. = ..()

/obj/item/organ/external/hand/industrial
	dislocated = -1
	encased = "support frame"

/obj/item/organ/external/hand/industrial/Initialize()
	robotize("Hephaestus Industrial Limb")
	. = ..()

/obj/item/organ/external/hand/right/industrial
	dislocated = -1
	encased = "support frame"

/obj/item/organ/external/hand/right/industrial/Initialize()
	robotize("Hephaestus Industrial Limb")
	. = ..()

///////////////
//Shell limbs//
///////////////

/obj/item/organ/external/head/shell
	dislocated = -1
	can_intake_reagents = 0
	encased = "support frame"
	force_skintone = TRUE

/obj/item/organ/external/head/shell/Initialize()
	robotize("Human Synthskin")
	. = ..()

/obj/item/organ/external/chest/shell
	dislocated = -1
	encased = "support frame"
	force_skintone = TRUE


/obj/item/organ/external/chest/shell/Initialize()
	robotize("Human Synthskin")
	. = ..()

/obj/item/organ/external/groin/shell
	dislocated = -1
	encased = "support frame"
	force_skintone = TRUE

/obj/item/organ/external/groin/shell/Initialize()
	robotize("Human Synthskin")
	. = ..()

/obj/item/organ/external/arm/shell
	dislocated = -1
	encased = "support frame"
	force_skintone = TRUE

/obj/item/organ/external/arm/shell/Initialize()
	robotize("Human Synthskin")
	. = ..()

/obj/item/organ/external/arm/right/shell
	dislocated = -1
	encased = "support frame"
	force_skintone = TRUE

/obj/item/organ/external/arm/right/shell/Initialize()
	robotize("Human Synthskin")
	. = ..()

/obj/item/organ/external/leg/shell
	dislocated = -1
	encased = "support frame"
	force_skintone = TRUE

/obj/item/organ/external/leg/shell/Initialize()
	robotize("Human Synthskin")
	. = ..()

/obj/item/organ/external/leg/right/shell
	dislocated = -1
	encased = "support frame"
	force_skintone = TRUE

/obj/item/organ/external/leg/right/shell/Initialize()
	robotize("Human Synthskin")
	. = ..()

/obj/item/organ/external/foot/shell
	dislocated = -1
	encased = "support frame"
	force_skintone = TRUE

/obj/item/organ/external/foot/shell/Initialize()
	robotize("Human Synthskin")
	. = ..()

/obj/item/organ/external/foot/right/shell
	dislocated = -1
	encased = "support frame"
	force_skintone = TRUE

/obj/item/organ/external/foot/right/shell/Initialize()
	robotize("Human Synthskin")
	. = ..()

/obj/item/organ/external/hand/shell
	dislocated = -1
	encased = "support frame"
	force_skintone = TRUE

/obj/item/organ/external/hand/shell/Initialize()
	robotize("Human Synthskin")
	. = ..()

/obj/item/organ/external/hand/right/shell
	dislocated = -1
	encased = "support frame"
	force_skintone = TRUE

/obj/item/organ/external/hand/right/shell/Initialize()
	robotize("Human Synthskin")
	. = ..()
