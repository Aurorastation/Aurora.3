/singleton/psionic_power/psi_stamina
	name = "Psi-Stamina Weave"
	desc = "Activate this spell in your hand to regenerate your psi-stamina a little bit."
	icon_state = "tech_mend_template"
	point_cost = 1
	ability_flags = PSI_FLAG_EVENT|PSI_FLAG_CANON
	spell_path = /obj/item/spell/psi_stamina

/obj/item/spell/psi_stamina
	name = "psi-stamina weave"
	desc = "Kind of like charging up your aura."
	icon_state = "generic"
	cast_methods = CAST_USE
	aspect = ASPECT_PSIONIC
	cooldown = 0
	psi_cost = 0

/obj/item/spell/psi_stamina/on_use_cast(mob/user)
	. = ..()
	if(.)
		if(do_after(user, 1 SECOND))
			to_chat(user, SPAN_NOTICE("You feel a bit more refreshed."))
			owner.psi.stamina = min(owner.psi.max_stamina, owner.psi.stamina + rand(2,5))
			if(owner.psi.stamina >= owner.psi.max_stamina)
				to_chat(user, SPAN_NOTICE("You're ready to go again!"))
				return TRUE
