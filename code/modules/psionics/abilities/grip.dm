/singleton/psionic_power/grip
	name = "Grip"
	desc = "Grip a victim with psionic energy. You can squeeze your grip to crush them."
	icon_state = "ling_bioelectrogenesis"
	point_cost = 3
	ability_flags = PSI_FLAG_ANTAG
	spell_path = /obj/item/spell/grip

/obj/item/spell/grip
	name = "stasis"
	desc = "General Kenobi..."
	icon_state = "blink"
	cast_methods = CAST_RANGED|CAST_USE
	aspect = ASPECT_PSIONIC
	cooldown = 15
	psi_cost = 5
	var/mob/living/victim

/obj/item/spell/grip/Destroy()
	victim.captured = FALSE
	victim.update_canmove()
	victim = null
	return ..()

/obj/item/spell/grip/on_use_cast(mob/user, bypass_psi_check)
	if(!victim)
		to_chat(user, SPAN_WARNING("You need to grip someone first!"))
		return
	. = ..()
	if(!.)
		return
	user.visible_message(SPAN_WARNING("[user] squeezes [user.get_pronoun("his")] hand!"), SPAN_WARNING("You squeeze your hand to tighten the psionic force around [victim]."))
	to_chat(victim, SPAN_DANGER("<font size=4>You are crushed by an invisible force!</font>"))
	victim.apply_damage(30, DAMAGE_BRUTE, armor_pen = 30, damage_flags = DAMAGE_FLAG_DISPERSED)

/obj/item/spell/grip/on_ranged_cast(atom/hit_atom, mob/user, bypass_psi_check)
	if(!isliving(hit_atom))
		return
	if(victim)
		to_chat(user, SPAN_WARNING("You can't target more than one person with this!"))
		return
	. = ..()
	if(!.)
		return
	var/mob/living/M = hit_atom
	user.visible_message(SPAN_DANGER("[user] extends [user.get_pronoun("his")] arm and makes a grab motion towards [M]!"),
						SPAN_DANGER("You extend your arm and grab [M] with your psionic energy!"))
	to_chat(M, SPAN_DANGER("<font size=4>You feel an invisible force tighten around you!</font>"))
	M.captured = TRUE
	M.update_canmove()
	victim = M
