/obj/effect/rune/stun
	can_talisman = TRUE

/obj/effect/rune/stun/do_rune_action(mob/living/user, obj/O = src)
	user.say("Fuu ma[pick("'","`")]jin!")

	var/radius = 5
	var/is_rune = TRUE
	if(!istype(O, /obj/effect/rune))
		radius = 2
		is_rune = FALSE

	for(var/mob/living/L in range(radius, O))
		if(iscultist(L))
			continue
		if(iscarbon(L))
			var/mob/living/carbon/C = L
			flick("e_flash", C.flash)
			if(C.stuttering < 1 && !HULK in C.mutations)
				C.stuttering = 1
			if(is_rune)
				C.Weaken(3)
			C.confused = 10
			C.Stun(3)
			C.silent += 15
			to_chat(C, span("danger", "The rune explodes in a bright flash!"))
			admin_attack_log(user, C, "Used a stun rune.", "Was victim of a stun rune.", "used a stun rune on")
		else if(issilicon(L))
			var/mob/living/silicon/S = L
			S.Weaken(5)
			flick("e_flash", S.flash)
			S.silent += 15
			to_chat(S, span("danger", "BZZZT... The rune has exploded in a bright flash!"))
			admin_attack_log(user, S, "Used a stun rune.", "Was victim of a stun rune.", "used a stun rune on")
	qdel(O)
