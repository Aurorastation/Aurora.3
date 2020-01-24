/obj/effect/rune/summon_cultist/do_rune_action(mob/living/user)
	var/list/mob/living/carbon/cultists = list()
	for(var/datum/mind/H in cult.current_antagonists)
		if(istype(H.current, /mob/living/carbon))
			cultists += H.current

	var/list/mob/living/carbon/users = list()
	for(var/mob/living/carbon/C in orange(1, src))
		if(iscultist(C) && !C.stat)
			users += C

	if(users.len >= 3)
		var/mob/living/carbon/cultist = input("Choose the one who you want to summon", "Followers of Geometer") as null|anything in (cultists - user)
		if(!cultist)
			return fizzle(user)
		if(cultist == user) //just to be sure.
			return
		if(cultist.buckled || cultist.handcuffed || (!isturf(cultist.loc) && !istype(cultist.loc, /obj/structure/closet)))
			for(var/mob/C in users)
				to_chat(C, span("warning", "You cannot summon \the [cultist], for \his shackles of blood are strong."))
			return fizzle(user)
		cultist.forceMove(get_turf(src))
		cultist.lying = TRUE
		cultist.regenerate_icons()

		var/dam = round(25 / (users.len/2))	//More people around the rune less damage everyone takes. Minimum is 3 cultists

		for(var/mob/living/carbon/human/C in users)
			if(iscultist(C) && !C.stat)
				C.say("N'ath reth sh'yro eth d[pick("'","`")]rekkathnor!")
				C.take_overall_damage(dam, 0)
				if(users.len <= 4)				// You did the minimum, this is going to hurt more and we're going to stun you.
					C.apply_effect(rand(3,6), STUN)
					C.apply_effect(1, WEAKEN)
		user.visible_message("<span class='warning'>The rune disappears with a flash of red light, and in its place now a body lies.</span>", \
		"<span class='warning'>You are blinded by a flash of red light! After you're able to see again, you see that now instead of the rune there's a body.</span>", \
		"<span class='warning'>You hear a pop and smell ozone.</span>")
		qdel(src)
	return fizzle(user)