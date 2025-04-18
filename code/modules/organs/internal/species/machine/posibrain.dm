/obj/item/organ/internal/machine/posibrain
	name = "positronic brain"
	desc = "A cube of shining metal, four inches to a side and covered in shallow grooves."
	organ_tag = BP_BRAIN
	parent_organ = BP_HEAD
	vital = TRUE
	robotic_sprite = FALSE

	/// The type of 'robotic brain'. Must be a subtype of /obj/item/device/mmi/digital.
	var/robotic_brain_type = /obj/item/device/mmi/digital/posibrain
	/// The stored MMI object.
	var/obj/item/device/mmi/stored_mmi

/obj/item/organ/internal/machine/posibrain/Initialize(mapload)
	stored_mmi = new robotic_brain_type(src)
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(setup_brain)), 30)
	if(species)
		set_max_damage(species.total_health)
	else
		set_max_damage(200)

/obj/item/organ/internal/machine/posibrain/proc/update_from_mmi()
	if(!stored_mmi)
		return

	name = stored_mmi.name
	desc = stored_mmi.desc
	icon = stored_mmi.icon
	icon_state = stored_mmi.icon_state

/obj/item/organ/internal/machine/posibrain/removed(var/mob/living/user)
	if(stored_mmi)
		stored_mmi.forceMove(get_turf(src))
		if(owner.mind)
			owner.mind.transfer_to(stored_mmi.brainmob)

	. = ..()

	var/mob/living/holder_mob = loc
	if(istype(holder_mob))
		holder_mob.drop_from_inventory(src)
	qdel(src)

/obj/item/organ/internal/machine/posibrain/proc/setup_brain()
	if(owner)
		stored_mmi.brainmob.real_name = owner.name
		stored_mmi.brainmob.name = stored_mmi.brainmob.real_name
		update_from_mmi()
	else
		stored_mmi.forceMove(get_turf(src))
		qdel(src)

/obj/item/organ/internal/machine/posibrain/circuit
	name = "robotic intelligence circuit"
	desc = "The pinnacle of artifical intelligence which can be achieved using classical computer science."
	robotic_brain_type = /obj/item/device/mmi/digital/robot

/obj/item/organ/internal/machine/posibrain/terminator
	name = BP_BRAIN
	organ_tag = BP_BRAIN
	parent_organ = BP_CHEST
	vital = TRUE
	emp_coeff = 0.1
