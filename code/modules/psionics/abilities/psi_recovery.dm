/singleton/psionic_power/psi_recovery
	name = "Psionic Recovery"
	desc = "Activate in hand to regenerate psi-stamina."
	icon_state = "swarm_zeropoint"
	point_cost = 0
	ability_flags = PSI_FLAG_FOUNDATIONAL
	spell_path = /obj/item/spell/psi_recovery

/obj/item/spell/psi_recovery
	name = "psionic recovery"
	desc = "It's an aura recharge."
	icon_state = "generic"
	cast_methods = CAST_USE
	aspect = ASPECT_PSIONIC
	cooldown = 5
	psi_cost = 0

/obj/item/spell/psi_recovery/on_use_cast(mob/user)
	. = ..()
	if(!.)
		return
	if(!isliving(user))
		return

	var/mob/living/L = user
	L.visible_message(SPAN_NOTICE("[user] puts [user.get_pronoun("his")] hands together and focuses..."),
					SPAN_NOTICE("You put your hands together and begin focusing on recovering your psionic energy..."))
	psi_recovery(user)

/obj/item/spell/psi_recovery/proc/psi_recovery(mob/user)
	var/mob/living/L = user
	if(do_after(user, 0.5 SECONDS))
		L.psi.stamina = min(L.psi.max_stamina, L.psi.stamina + rand(1,3))
		if(L.psi.stamina >= L.psi.max_stamina)
			to_chat(user, SPAN_NOTICE("You've recovered all your psionic energy."))
			return TRUE
		psi_recovery(user)
