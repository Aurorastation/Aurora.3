/singleton/psionic_power/focus
	name = "Focus"
	desc = "Activate this spell in your hand to generate five units of synaptizine in your bloodstream."
	icon_state = "tech_phaseshift"
	point_cost = 1
	ability_flags = PSI_FLAG_EVENT
	spell_path = /obj/item/spell/focus

/obj/item/spell/focus
	name = "focus"
	desc = "Psionic drugs? No way."
	icon_state = "blink"
	cast_methods = CAST_USE
	aspect = ASPECT_PSIONIC
	cooldown = 50
	psi_cost = 20

/obj/item/spell/focus/on_use_cast(mob/user)
	if(!ishuman(user))
		return
	. = ..()
	if(!.)
		return
	var/mob/living/carbon/human/H = user
	if(do_after(user, 1 SECOND))
		to_chat(H, SPAN_WARNING("A calm rush envelops your mind.."))
		H.reagents.add_reagent(/singleton/reagent/synaptizine, 5)
		H.update_canmove()
