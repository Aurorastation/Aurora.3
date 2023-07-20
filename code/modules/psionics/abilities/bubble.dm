/singleton/psionic_power/bubble
	name = "Bubble"
	desc = "Create a protective bubble around you that removes your need to breathe or wear voidsuits in EVA."
	icon_state = "tech_condensation"
	point_cost = 1
	ability_flags = PSI_FLAG_ANTAG
	spell_path = /obj/item/spell/bubble

/obj/item/spell/bubble
	name = "bubble"
	icon_state = "shield"
	cast_methods = CAST_INNATE
	aspect = ASPECT_PSIONIC
	cooldown = 10
	psi_cost = 10

/obj/item/spell/bubble/Destroy()
	REMOVE_TRAIT(owner, TRAIT_NO_BREATHE, TRAIT_SOURCE_PSIONICS)
	return ..()

/obj/item/spell/bubble/on_innate_cast(mob/user)
	if(!ishuman(user))
		return
	. = ..()
	if(!.)
		return

	var/mob/living/carbon/human/H = user
	H.visible_message(SPAN_NOTICE("A protective bubble forms around [H]."), SPAN_NOTICE("You form a protective bubble around yourself."))
	ADD_TRAIT(H, TRAIT_NO_BREATHE, TRAIT_SOURCE_PSIONICS)
