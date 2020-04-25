/obj/item/organ/internal/diona/process()
	return

/obj/item/organ/internal/diona/strata
	name = "neural strata"
	parent_organ = BP_CHEST
	organ_tag = "neural strata"


/obj/item/organ/internal/diona/bladder
	name = "gas bladder"
	parent_organ = BP_HEAD
	organ_tag = "gas bladder"

/obj/item/organ/internal/diona/polyp
	name = "polyp segment"
	parent_organ = BP_GROIN
	organ_tag = "polyp segment"

/obj/item/organ/internal/diona/ligament
	name = "anchoring ligament"
	parent_organ = BP_GROIN
	organ_tag = "anchoring ligament"

/obj/item/organ/internal/diona
	name = "diona nymph"
	icon = 'icons/mob/diona.dmi'
	icon_state = "nymph"
	organ_tag = "special" // Turns into a nymph instantly, no transplanting possible.

/obj/item/organ/internal/diona/removed(var/mob/living/user)
	var/mob/living/carbon/human/H = owner
	..()
	if(!istype(H) || !H.organs || !H.organs.len)
		H.death()

// These are different to the standard diona organs as they have a purpose in other
// species (absorbing radiation and light respectively)
/obj/item/organ/internal/diona/nutrients
	name = "nutrient channel"
	parent_organ = BP_CHEST
	organ_tag = "nutrient channel"
	icon = 'icons/mob/npc/alien.dmi'
	icon_state = "claw"

/obj/item/organ/internal/diona/nutrients/removed()
	return

/obj/item/organ/internal/diona/node
	name = "response node"
	parent_organ = BP_HEAD
	organ_tag = "response node"
	icon = 'icons/mob/npc/alien.dmi'
	icon_state = "claw"

/obj/item/organ/internal/diona/node/removed()
	return

/obj/item/organ/internal/stomach/diona
	name = "digestion chamber"
	should_process_alcohol = FALSE
	icon = 'icons/mob/npc/alien.dmi'
	icon_state = "chitin"
