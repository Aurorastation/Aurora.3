/singleton/psionic_power/awaken
	name = "Awaken"
	desc = "Stimulate a living being's Zona Bovinae and bring them to Psionically Harmonious rank."
	icon_state = "tech_corona"
	point_cost = 0
	ability_flags = PSI_FLAG_APEX
	minimum_rank = PSI_RANK_APEX
	spell_path = /obj/item/spell/awaken

/obj/item/spell/awaken
	name = "awaken"
	icon_state = "energy_siphon_drain"
	cast_methods = CAST_MELEE
	aspect = ASPECT_PSIONIC
	cooldown = 20
	psi_cost = 100

/obj/item/spell/awaken/on_melee_cast(atom/hit_atom, mob/living/user, def_zone)
	if(!isliving(hit_atom))
		return
	var/mob/living/L = hit_atom
	if(!L.can_commune())
		to_chat(user, SPAN_WARNING("This being doesn't have a Zona Bovinae."))
		return
	if(L.psi && L.psi.get_rank() >= PSI_RANK_HARMONIOUS)
		to_chat(user, SPAN_WARNING("This wouldn't do anything on them."))
		return
	. = ..()
	if(!.)
		return
	user.visible_message(SPAN_DANGER("[user] grabs [L]'s head..."), SPAN_DANGER("You grab [L]'s head..."))
	if(do_mob(user, L, 5 SECONDS))
		L.set_psi_rank(PSI_RANK_HARMONIOUS)
		L.flash_pain(50)
		L.adjustHalLoss(20)
		playsound(get_turf(L), 'sound/effects/psi/power_feedback.ogg', 100)
		user.visible_message(SPAN_DANGER("[user] unleashes a psionic shock through [L]'s head!"),
							SPAN_DANGER("You unleash a psionic shock through [L]'s head, targeting their Zona Bovinae and stimulating it it."))
		to_chat(L, SPAN_HIGHDANGER("A large, painful shock courses through your head. You can see the weave of the universe... and manipulate it."))
