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
