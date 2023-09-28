/singleton/psionic_power/psi_suppression
	name = "Psionic Suppression"
	desc = "Hold in one of your hands to make yourself invisible to Psi-Search."
	icon_state = "tech_shield"
	point_cost = 1
	ability_flags = PSI_FLAG_CANON
	spell_path = /obj/item/spell/psi_suppression

/obj/item/spell/psi_suppression
	name = "psionic suppression"
	icon_state = "generic"
	cast_methods = CAST_INNATE
	aspect = ASPECT_PSIONIC
	psi_cost = 5

/obj/item/spell/psi_suppression/Destroy()
	to_chat(owner, SPAN_NOTICE("You are no longer hidden from Psi-Search."))
	REMOVE_TRAIT(owner, TRAIT_PSIONIC_SUPPRESSION, TRAIT_SOURCE_PSIONICS)
	return ..()

/obj/item/spell/psi_suppression/on_innate_cast(mob/user)
	. = ..()
	if(!.)
		return

	to_chat(user, SPAN_NOTICE("You are now hidden from Psi-Search."))
	ADD_TRAIT(user, TRAIT_PSIONIC_SUPPRESSION, TRAIT_SOURCE_PSIONICS)
