/datum/rune/stun
	name = "incapacitation rune"
	desc = "This rune is used to deafen, silence, flash and confuse the unbelievers in a radius around us."
	rune_flags = HAS_SPECIAL_TALISMAN_ACTION

/datum/rune/stun/do_rune_action(mob/living/user, atom/movable/A)
	do_stun(user, A, 5, TRUE)

/datum/rune/stun/do_talisman_action(mob/living/user, atom/movable/A)
	do_stun(user, A, 3, FALSE)

/datum/rune/stun/proc/do_stun(mob/living/user, atom/movable/A, var/radius, var/is_rune)
	user.say("Fuu ma'jin!")
	for(var/mob/living/L in range(radius, get_turf(A)))
		if(iscultist(L))
			continue
		if(iscarbon(L))
			var/mob/living/carbon/C = L
			C.flash_eyes()
			if(C.stuttering < 1 && !(HULK in C.mutations))
				C.stuttering = 1
			C.Weaken(3)
			C.confused = 10
			C.Stun(3)
			C.silent += 15
			to_chat(C, SPAN_DANGER("The rune explodes in a bright flash!"))
			admin_attack_log(user, C, "Used a stun rune.", "Was victim of a stun rune.", "used a stun rune on")
		else if(issilicon(L))
			var/mob/living/silicon/S = L
			S.Weaken(5)
			S.flash_eyes()
			S.silent += 15
			to_chat(S, SPAN_DANGER("BZZZT... The rune has exploded in a bright flash!"))
			admin_attack_log(user, S, "Used a stun rune.", "Was victim of a stun rune.", "used a stun rune on")
	qdel(A)
