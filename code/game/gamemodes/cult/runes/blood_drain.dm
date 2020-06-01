/obj/effect/rune/blood_drain
	can_talisman = TRUE

/obj/effect/rune/blood_drain/do_rune_action(mob/living/user)
	var/drain
	for(var/obj/effect/rune/blood_drain/R in rune_list)
		for(var/mob/living/carbon/D in get_turf(R))
			if(D.stat != DEAD)
				admin_attack_log(user, D, "Used a blood drain rune.", "Was victim of a blood drain rune.", "used a blood drain rune on")
				var/bdrain = rand(1, 25)
				to_chat(D, SPAN_WARNING("You feel weakened."))
				D.take_overall_damage(bdrain, 0)
				drain += bdrain
	if(!drain)
		return fizzle(user)
	user.say("Yu[pick("'","`")]gular faras desdae. Havas mithum javara. Umathar uf'kal thenar!")
	user.visible_message(SPAN_DANGER("Blood flows from the rune into [user]!"), \
	SPAN_DANGER("The blood starts flowing from the rune and into your frail body. You feel... empowered."), \
	SPAN_WARNING("You hear a liquid flowing."))
	playsound(user, 'sound/magic/enter_blood.ogg', 100, 1)

	if(user.bhunger)
		user.bhunger = max(user.bhunger-2*drain,0)
	if(drain >= 50)
		user.visible_message(SPAN_DANGER("[user]'s eyes give off an eerie red glow!"), \
		SPAN_DANGER("...but it wasn't nearly enough. You crave, crave for more. The hunger consumes you from within."), \
		SPAN_WARNING("You hear a heartbeat."))
		user.bhunger += drain
		while(user.bhunger)
			user.bhunger--
			sleep(50)
			user.take_overall_damage(3, 0)
		return
	user.heal_organ_damage(drain%5, 0)
	drain-=drain%5
	while(drain)
		drain -= 5
		sleep(2)
		user.heal_organ_damage(5, 0)
	return TRUE