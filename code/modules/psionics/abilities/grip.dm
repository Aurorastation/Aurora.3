/singleton/psionic_power/grip
	name = "Grip"
	desc = "Grip a victim with psionic energy. You can squeeze your grip to crush them. Drop your spell to undo the stasis."
	icon_state = "ling_bioelectrogenesis"
	point_cost = 3
	ability_flags = PSI_FLAG_ANTAG
	spell_path = /obj/item/spell/grip

/obj/item/spell/grip
	name = "grip"
	desc = "General Kenobi..."
	icon_state = "blink"
	cast_methods = CAST_RANGED|CAST_USE
	aspect = ASPECT_PSIONIC
	cooldown = 20
	psi_cost = 10
	var/next_squeeze_time = 0
	var/mob/living/victim

/obj/item/spell/grip/Destroy()
	if(victim)
		victim.SetStunned(0)
		victim.update_canmove()
	victim = null

	. = ..()

/obj/item/spell/grip/on_use_cast(mob/user, bypass_psi_check)
	if(!victim)
		to_chat(user, SPAN_WARNING("You need to grip someone first!"))
		return
	if(world.time < next_squeeze_time)
		return
	var/rangecheck = length(get_line(user, victim))
	if(!length(get_line(user, victim)) || rangecheck > 8)
		to_chat(user, SPAN_WARNING("You need to have direct line of sight to your target!"))
		return
	. = ..()
	if(!.)
		return

	if(!is_in_sight(user, victim))
		to_chat(user, SPAN_WARNING("You don't have a direct line of sight to \the [victim]!"))
		return

	user.visible_message(SPAN_WARNING("[user] squeezes [user.get_pronoun("his")] hand!"), SPAN_WARNING("You squeeze your hand to tighten the psionic force around [victim]."))
	log_and_message_admins("[key_name(owner)] has psionically crushed [victim]", owner, get_turf(owner))
	to_chat(victim, SPAN_DANGER(FONT_HUGE("You are crushed by an invisible force!")))
	victim.apply_damage(20, DAMAGE_BRUTE, armor_pen = 15, def_zone = BP_HEAD)
	victim.SetStunned(2)
	apply_cooldown(user)
	next_squeeze_time = world.time + 2 SECONDS

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

	if(!is_in_sight(user, M))
		to_chat(user, SPAN_WARNING("You don't have a direct line of sight to \the [M]!"))
		return

	user.visible_message(SPAN_DANGER("[user] extends [user.get_pronoun("his")] arm and makes a grab motion towards [M]!"),
						SPAN_DANGER("You extend your arm and grab [M] with your psionic energy!"))
	to_chat(M, SPAN_DANGER("You feel an invisible force tighten around you!"))
	victim = M
