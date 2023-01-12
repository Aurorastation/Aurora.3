/datum/rune/stun
	name = "incapacitation rune"
	desc = "This rune is used to deafen, silence, flash and confuse the unbelievers in a radius around us."
	rune_flags = HAS_SPECIAL_TALISMAN_ACTION

/datum/rune/stun/do_rune_action(mob/living/user, atom/movable/A)
	do_stun(user, A, 5, TRUE)

/datum/rune/stun/do_talisman_action(mob/living/user, atom/movable/A)
	do_stun(user, A, 3, FALSE)

/datum/rune/stun/proc/do_stun(mob/living/user, atom/movable/A, radius, is_rune)
	user.say("Fuu ma'jin!")
	for(var/mob/living/L in viewers(radius, get_turf(A)))
		if(iscultist(L))
			continue
		if(iscarbon(L))
			L.stuttering = TRUE
			L.confused = 10
			L.Weaken(3)
			L.Stun(3)
		else if(issilicon(L))
			L.Weaken(5)

		to_chat(L, SPAN_DANGER("The rune explodes in a bright flash!"))
		L.flash_act()
		L.silent += 15
		admin_attack_log(user, L, "Used a stun rune.", "Was victim of a stun rune.", "used a stun rune on")

	qdel(A)
