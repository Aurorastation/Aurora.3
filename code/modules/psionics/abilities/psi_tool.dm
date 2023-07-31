/singleton/psionic_power/psi_tool
	name = "Psi-Tool"
	desc = "Create a psionic tool that can change into a screwdriver, crowbar, wrench or wirecutters."
	icon_state = "psitool"
	point_cost = 1
	ability_flags = PSI_FLAG_ANTAG
	spell_path = /obj/item/spell/psi_tool

/obj/item/spell/psi_tool
	name = "psi-tool"
	icon_state = "generic"
	cast_methods = CAST_INNATE
	aspect = ASPECT_PSIONIC
	cooldown = 10
	psi_cost = 5

/obj/item/spell/psi_tool/on_innate_cast(mob/user)
	if(!ishuman(user))
		return
	. = ..()
	if(!.)
		return

	var/mob/living/carbon/human/H = user

	var/obj/item/psychic_power/tinker/PT = new(user)
	if(H.put_in_any_hand_if_possible(PT))
		qdel(src)
		return TRUE
	else
		to_chat(H, SPAN_WARNING("You need an empty hand for this!"))
		return FALSE
