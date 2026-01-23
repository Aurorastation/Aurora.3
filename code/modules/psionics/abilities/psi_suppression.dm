/singleton/psionic_power/psi_suppression
	name = "Psionic Suppression"
	desc = "Activate to toggle passive mind-shielding on yourself. While active, you cannot send or receive telepathic messages, and you are nearly impossible to detect as psychic."
	icon_state = "tech_shield"
	point_cost = 1
	ability_flags = PSI_FLAG_CANON
	spell_path = /obj/item/spell/psi_suppression

/obj/item/spell/psi_suppression
	name = "psionic suppression"
	icon_state = "generic"
	item_icons = null
	cast_methods = CAST_INNATE
	aspect = ASPECT_PSIONIC
	psi_cost = 5

/obj/item/spell/psi_suppression/on_innate_cast(mob/user)
	. = ..()
	if(!.)
		return

	var/suppression_comp = user.GetComponent(PsiSuppressionComponent)
	if (suppression_comp)
		to_chat(user, SPAN_NOTICE("You are no longer suppressing your psi-signature!"))
		qdel(suppression_comp)
		qdel(src)
		return

	to_chat(user, SPAN_NOTICE("You are now suppressing your psi-signature!"))
	user.AddComponent(PsiSuppressionComponent)
	qdel(src)
