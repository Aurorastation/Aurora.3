//There has to be a better way to define this shit. ~ Z
//can't equip anything
/mob/living/carbon/alien/attack_ui(slot_id)
	return

/mob/living/carbon/alien/default_hurt_interaction(mob/user)
	. = ..()
	if(.) return

	var/damage = rand(1, 9)
	if (prob(90))
		if ((user.mutations & HULK))
			damage += 5
			spawn(0)
				Paralyse(1)
				step_away(src,user,15)
				sleep(3)
				step_away(src,user,15)
		playsound(loc, SFX_PUNCH, 25, 1, -1)
		for(var/mob/O in viewers(src, null))
			if ((O.client && !( O.blinded )))
				O.show_message(SPAN_DANGER("[user] has punched [src]!"), 1)
		if (damage > 4.9)
			Weaken(rand(10,15))
			for(var/mob/O in viewers(user, null))
				if ((O.client && !( O.blinded )))
					O.show_message(SPAN_DANGER("[user] has weakened [src]!"), 1,
									SPAN_WARNING(" You hear someone fall."), 2)

		adjustBruteLoss(damage)
		updatehealth()
	else
		playsound(loc, SFX_PUNCH_MISS, 25, 1, -1)
		for(var/mob/O in viewers(src, null))
			if ((O.client && !( O.blinded )))
				O.show_message(SPAN_DANGER("[user] has attempted to punch [src]!"), 1)
