/obj/effect/rune/stun
	can_talisman = TRUE

/obj/effect/rune/stun/do_rune_action(mob/living/user)
	user.say("Fuu ma[pick("'","`")]jin!")

	var/radius = 7
	var/is_rune = TRUE
	if(!istype(src,/obj/effect/rune))
		radius = 2
		is_rune = FALSE

	for(var/mob/living/L in range(radius, src))
		if(iscultist(L))
			continue
		if(iscarbon(L))
			var/mob/living/carbon/C = L
			flick("e_flash", C.flash)
			if(C.stuttering < 1 && (!(HULK in C.mutations)))
				C.stuttering = 1
			if(is_rune)
				C.Weaken(3)
			C.Stun(3)
			C.silent += 15
			C.show_message("<span class='danger'>The rune explodes in a bright flash.</span>", 3)
			admin_attack_log(user, C, "Used a stun rune.", "Was victim of a stun rune.", "used a stun rune on")
		else if(issilicon(L))
			var/mob/living/silicon/S = L
			S.Weaken(5)
			flick("e_flash", S.flash)
			S.silent += 15
			S.show_message("<span class='danger'>BZZZT... The rune has exploded in a bright flash.</span>", 3)
			admin_attack_log(user, S, "Used a stun rune.", "Was victim of a stun rune.", "used a stun rune on")
	qdel(src)