// This borer is the worm that replaced the host's brain, not the brainworm latched onto a brain
/obj/item/organ/internal/borer
	name = "cortical borer"
	icon = 'icons/mob/npc/animal.dmi'
	icon_state = "brainslug"
	organ_tag = BP_BRAIN
	desc = "A disgusting space slug."
	parent_organ = BP_HEAD
	vital = TRUE

/obj/item/organ/internal/borer/removed(var/mob/living/user)
	..()

	var/mob/living/simple_animal/borer/B = owner.has_brain_worms()
	if(B)
		B.leave_host()
		B.ckey = owner.ckey

	qdel(src)

//VOX ORGANS.
/obj/item/organ/internal/stack
	name = "cortical stack"
	icon_state = "brain-prosthetic"
	organ_tag = "stack"
	parent_organ = BP_HEAD
	robotic = 2
	vital = 1
	var/backup_time = 0
	var/datum/mind/backup
	origin_tech = list(TECH_ENGINEERING = 5, TECH_DATA=3, TECH_BIO=3)

/obj/item/organ/internal/stack/process()
	if(owner && owner.stat != DEAD && !is_broken())
		backup_time = world.time
		if(owner.mind) backup = owner.mind

/obj/item/organ/internal/stack/vox
	name = "vox cortical stack"
	vital = 0
