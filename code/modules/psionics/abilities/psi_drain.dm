/singleton/psionic_power/psi_drain
	name = "Psi-Drain"
	desc = "Destroy a living being's Zona Bovinae. This will make them psionically deaf."
	icon_state = "gen_project"
	point_cost = 0
	ability_flags = PSI_FLAG_APEX
	minimum_rank = PSI_RANK_APEX
	spell_path = /obj/item/spell/psi_drain

/obj/item/spell/psi_drain
	name = "psi-drain"
	icon_state = "chain_lightning"
	cast_methods = CAST_MELEE|CAST_RANGED
	aspect = ASPECT_PSIONIC
	cooldown = 10
	psi_cost = 5

/obj/item/spell/psi_drain/on_melee_cast(atom/hit_atom, mob/living/user, def_zone)
	if(!isliving(hit_atom))
		return
	var/mob/living/L = hit_atom
	if(!L.has_zona_bovinae())
		to_chat(user, SPAN_WARNING("This being doesn't have a Zona Bovinae."))
		return
	. = ..()
	if(!.)
		return
	psi_drain(L, user)

/obj/item/spell/psi_drain/on_ranged_cast(atom/hit_atom, mob/user, bypass_psi_check)
	if(!isliving(hit_atom))
		return
	var/mob/living/L = hit_atom
	if(!L.has_zona_bovinae())
		to_chat(user, SPAN_WARNING("This being doesn't have a Zona Bovinae."))
		return
	. = ..()
	if(!.)
		return
	psi_drain(L, user)

/obj/item/spell/psi_drain/proc/psi_drain(mob/living/L, mob/living/user)
	user.visible_message(SPAN_DANGER("[user] squeezes [user.get_pronoun("his")] hand at [L]!"), SPAN_DANGER("You squeeze your hand at [L] and siphon [L.get_pronoun("his")] psionic energy!"))
	var/psi_taken = min(user.psi.max_stamina, rand(10, 25))
	if(L.psi)
		L.psi.spend_power(psi_taken)
	else
		L.adjustHalLoss(psi_taken * 1.5)
		L.flash_pain(psi_taken * 1.5)
	playsound(get_turf(user), 'sound/effects/psi/power_evoke.ogg', 100)
	to_chat(L, SPAN_DANGER("You feel a headache split apart your mind!"))
