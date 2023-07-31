/singleton/psionic_power/psi_sword
	name = "Psi-Sword"
	desc = "Create a psionic sword."
	icon_state = "psiblade"
	point_cost = 3
	ability_flags = PSI_FLAG_ANTAG
	spell_path = /obj/item/spell/psi_sword

/obj/item/spell/psi_sword
	name = "psi-tool"
	icon_state = "generic"
	cast_methods = CAST_INNATE
	aspect = ASPECT_PSIONIC
	cooldown = 10
	psi_cost = 5

/obj/item/spell/psi_sword/on_innate_cast(mob/user)
	if(!ishuman(user))
		return
	. = ..()
	if(!.)
		return

	var/mob/living/carbon/human/H = user

	var/obj/item/psychic_power/psiblade/PT = new(user)
	if(H.put_in_any_hand_if_possible(PT))
		qdel(src)
		return TRUE
	else
		to_chat(H, SPAN_WARNING("You need an empty hand for this!"))
		return FALSE
