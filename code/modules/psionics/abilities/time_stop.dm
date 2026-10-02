/singleton/psionic_power/time_stop
	name = "Time Stop"
	desc = "Freeze living beings around you in a 5x5 area. This ability is very expensive, so be careful."
	icon_state = "tech_control"
	point_cost = 2
	ability_flags = PSI_FLAG_ANTAG
	spell_path = /obj/item/spell/time_stop

/obj/item/spell/time_stop
	name = "nlom eyes"
	desc = "Psionic drugs? No way."
	icon_state = "track"
	cast_methods = CAST_USE
	aspect = ASPECT_PSIONIC
	cooldown = 10
	psi_cost = 30

/obj/item/spell/time_stop/on_use_cast(mob/user)
	. = ..()
	if(!.)
		return

	if(do_after(user, 1 SECOND))
		user.visible_message(SPAN_DANGER(FONT_HUGE("[user] extends [user.get_pronoun("his")] arms to [user.get_pronoun("his")] sides!")),
							SPAN_DANGER("You extend your arms to your side and crystallize the Nlom around you!"))
		for(var/mob/living/target in view(2, user))
			if(target == user)
				continue
			to_chat(target, SPAN_DANGER("Time around you slows down to a crawl..."))
			target.Stun(5)
			target.silent = max(target.silent, 5)
