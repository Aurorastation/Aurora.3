// IPC limbs.
/obj/item/organ/external/head/ipc
	dislocated = -1
	can_intake_reagents = 0
	vital = 1 //because it is now hosting the posibrain
	max_damage = 50 //made same as arm, since it is not vital
	min_broken_damage = 30
	encased = null

/obj/item/organ/external/head/ipc/New()
	robotize("Hephaestus Integrated Limb")
	..()

/obj/item/organ/external/chest/ipc
	dislocated = -1
	encased = null
/obj/item/organ/external/chest/ipc/New()
	robotize("Hephaestus Integrated Limb")
	..()

/obj/item/organ/external/groin/ipc
	dislocated = -1
/obj/item/organ/external/groin/ipc/New()
	robotize("Hephaestus Integrated Limb")
	..()

/obj/item/organ/external/arm/ipc
	dislocated = -1
/obj/item/organ/external/arm/ipc/New()
	robotize("Hephaestus Integrated Limb")
	..()

/obj/item/organ/external/arm/right/ipc
	dislocated = -1
/obj/item/organ/external/arm/right/ipc/New()
	robotize("Hephaestus Integrated Limb")
	..()

/obj/item/organ/external/leg/ipc
	dislocated = -1
/obj/item/organ/external/leg/ipc/New()
	robotize("Hephaestus Integrated Limb")
	..()

/obj/item/organ/external/leg/right/ipc
	dislocated = -1
/obj/item/organ/external/leg/right/ipc/New()
	robotize("Hephaestus Integrated Limb")
	..()

/obj/item/organ/external/foot/ipc
	dislocated = -1
/obj/item/organ/external/foot/ipc/New()
	robotize("Hephaestus Integrated Limb")
	..()

/obj/item/organ/external/foot/right/ipc
	dislocated = -1
/obj/item/organ/external/foot/right/ipc/New()
	robotize("Hephaestus Integrated Limb")
	..()

/obj/item/organ/external/hand/ipc
	dislocated = -1
/obj/item/organ/external/hand/ipc/New()
	robotize("Hephaestus Integrated Limb")
	..()

/obj/item/organ/external/hand/right/ipc
	dislocated = -1
/obj/item/organ/external/hand/right/ipc/New()
	robotize("Hephaestus Integrated Limb")
	..()

/obj/item/organ/cell
	name = "microbattery"
	desc = "A small, powerful cell for use in fully prosthetic bodies."
	icon = 'icons/obj/power.dmi'
	icon_state = "scell"
	organ_tag = "cell"
	parent_organ = "chest"
	vital = 1

/obj/item/organ/cell/New()
	robotize()
	..()

/obj/item/organ/cell/replaced()
	..()
	// This is very ghetto way of rebooting an IPC. TODO better way.
	if(owner && owner.stat == DEAD)
		owner.stat = 0
		owner.visible_message("<span class='danger'>\The [owner] twitches visibly!</span>")

/obj/item/organ/optical_sensor
	name = "optical sensor"
	organ_tag = "optics"
	parent_organ = "head"
	icon = 'icons/obj/robot_component.dmi'
	icon_state = "camera"
	dead_icon = "camera_broken"

/obj/item/organ/optical_sensor/New()
	robotize()
	..()

/obj/item/organ/ipc_tag
	name = "identification tag"
	organ_tag = "ipc tag"
	parent_organ = "groin"
	icon = 'icons/obj/telescience.dmi'
	icon_state = "gps-c"
	dead_icon = "gps-c"

/obj/item/organ/ipc_tag/New()
	robotize()
	..()

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
	..()

	var/mob/living/holder_mob = loc
	if(istype(holder_mob))
		holder_mob.drop_from_inventory(src)
	qdel(src)

/obj/item/organ/mmi_holder/New()
	..()
	// This is very ghetto way of rebooting an IPC. TODO better way.
	spawn(1)
		if(owner && owner.stat == DEAD)
			owner.stat = 0
			owner.visible_message("<span class='danger'>\The [owner] twitches visibly!</span>")

/obj/item/organ/mmi_holder/posibrain/New()
	robotize()
	stored_mmi = new /obj/item/device/mmi/digital/posibrain(src)
	..()
	spawn(1)
		if(owner)
			stored_mmi.name = "positronic brain ([owner.name])"
			stored_mmi.brainmob.real_name = owner.name
			stored_mmi.brainmob.name = stored_mmi.brainmob.real_name
			stored_mmi.icon_state = "posibrain-occupied"
			update_from_mmi()
		else
			stored_mmi.loc = get_turf(src)
			qdel(src)


//terminator organs

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

/obj/item/organ/data/New()
	robotize()
	..()

/obj/item/organ/cell/terminator
	name = "shielded microbattery"
	desc = "A small, powerful cell for use in fully prosthetic bodies. Equipped with a Faraday shield."
	icon = 'icons/obj/power.dmi'
	icon_state = "scell"
	organ_tag = "shielded cell"
	parent_organ = "chest"
	vital = 1
	emp_coeff = 0.1

/obj/item/organ/cell/New()
	robotize()
	..()

/obj/item/organ/external/head/terminator
	dislocated = -1
	can_intake_reagents = 0
	vital = 0
	max_damage = 50 //made same as arm, since it is not vital
	min_broken_damage = 30
	encased = null
	emp_coeff = 0.5

/obj/item/organ/optical_sensorterminator
	name = "optical sensor"
	organ_tag = "optics"
	parent_organ = "head"
	icon = 'icons/obj/robot_component.dmi'
	icon_state = "camera"
	dead_icon = "camera_broken"
	emp_coeff = 0.5

/obj/item/organ/optical_sensor/terminator/New()
	robotize()
	..()


/obj/item/organ/external/head/terminator/New()
	robotize("Hephaestus Vulcanite Limb")
	..()

/obj/item/organ/external/chest/terminator
	dislocated = -1
	encased = null
	emp_coeff = 0.5

/obj/item/organ/external/chest/terminator/New()
	robotize("Hephaestus Vulcanite Limb")
	..()

/obj/item/organ/external/groin/terminator
	dislocated = -1
	emp_coeff = 0.5

/obj/item/organ/external/groin/terminator/New()
	robotize("Hephaestus Vulcanite Limb")
	..()

/obj/item/organ/external/arm/terminator
	dislocated = -1
	emp_coeff = 0.5

/obj/item/organ/external/arm/terminator/New()
	robotize("Hephaestus Vulcanite Limb")
	..()

/obj/item/organ/external/arm/right/terminator
	dislocated = -1
	emp_coeff = 0.5

/obj/item/organ/external/arm/right/terminator/New()
	robotize("Hephaestus Vulcanite Limb")
	..()

/obj/item/organ/external/leg/terminator
	dislocated = -1
	emp_coeff = 0.5

/obj/item/organ/external/leg/terminator/New()
	robotize("Hephaestus Vulcanite Limb")
	..()

/obj/item/organ/external/leg/right/terminator
	dislocated = -1
	emp_coeff = 0.5

/obj/item/organ/external/leg/right/terminator/New()
	robotize("Hephaestus Vulcanite Limb")
	..()

/obj/item/organ/external/foot/terminator
	dislocated = -1
	emp_coeff = 0.5

/obj/item/organ/external/foot/terminator/New()
	robotize("Hephaestus Vulcanite Limb")
	..()

/obj/item/organ/external/foot/right/terminator
	dislocated = -1
	emp_coeff = 0.5

/obj/item/organ/external/foot/right/terminator/New()
	robotize("Hephaestus Vulcanite Limb")
	..()

/obj/item/organ/external/hand/terminator
	dislocated = -1
	emp_coeff = 0.5

/obj/item/organ/external/hand/terminator/New()
	robotize("Hephaestus Vulcanite Limb")
	..()

/obj/item/organ/external/hand/right/terminator
	dislocated = -1
	emp_coeff = 0.5

/obj/item/organ/external/hand/right/terminator/New()
	robotize("Hephaestus Vulcanite Limb")
	..()

/obj/item/organ/external/head/industrial
	dislocated = -1
	can_intake_reagents = 0
	vital = 0
	max_damage = 50 //made same as arm, since it is not vital
	min_broken_damage = 30
	encased = null

/obj/item/organ/external/head/industrial/New()
	robotize("Hephaestus Industrial Limb")
	..()

/obj/item/organ/external/chest/industrial
	dislocated = -1
	encased = null
/obj/item/organ/external/chest/industrial/New()
	robotize("Hephaestus Industrial Limb")
	..()

/obj/item/organ/external/groin/industrial
	dislocated = -1
/obj/item/organ/external/groin/industrial/New()
	robotize("Hephaestus Industrial Limb")
	..()

/obj/item/organ/external/arm/industrial
	dislocated = -1
/obj/item/organ/external/arm/industrial/New()
	robotize("Hephaestus Industrial Limb")
	..()

/obj/item/organ/external/arm/right/industrial
	dislocated = -1
/obj/item/organ/external/arm/right/industrial/New()
	robotize("Hephaestus Industrial Limb")
	..()

/obj/item/organ/external/leg/industrial
	dislocated = -1
/obj/item/organ/external/leg/industrial/New()
	robotize("Hephaestus Industrial Limb")
	..()

/obj/item/organ/external/leg/right/industrial
	dislocated = -1
/obj/item/organ/external/leg/right/industrial/New()
	robotize("Hephaestus Industrial Limb")
	..()

/obj/item/organ/external/foot/industrial
	dislocated = -1
/obj/item/organ/external/foot/industrial/New()
	robotize("Hephaestus Industrial Limb")
	..()

/obj/item/organ/external/foot/right/industrial
	dislocated = -1
/obj/item/organ/external/foot/right/industrial/New()
	robotize("Hephaestus Industrial Limb")
	..()

/obj/item/organ/external/hand/industrial
	dislocated = -1
/obj/item/organ/external/hand/industrial/New()
	robotize("Hephaestus Industrial Limb")
	..()

/obj/item/organ/external/hand/right/industrial
	dislocated = -1
/obj/item/organ/external/hand/right/industrial/New()
	robotize("Hephaestus Industrial Limb")
	..()