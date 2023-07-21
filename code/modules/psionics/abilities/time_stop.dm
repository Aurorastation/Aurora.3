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

/obj/item/spell/time_stop/Destroy()
	for(var/mob/living/L in get_hearers_in_view(5, owner))
		if(L == owner)
			continue
		to_chat(L, SPAN_DANGER("Time around you returns to normal!"))
		L.stunned = 0
		L.silent = 0
	return ..()

/obj/item/spell/time_stop/on_use_cast(mob/user)
	. = ..()
	if(!.)
		return

	if(do_after(user, 1 SECOND))
		user.visible_message(SPAN_DANGER("<font size=4>[user] extends [user.get_pronoun("his")] arms to [user.get_pronoun("his")] sides!</font>"),
							SPAN_DANGER("You extend your arms to your side and crystallize the Nlom around you!"))
		time_stop(user)

/obj/item/spell/time_stop/proc/time_stop(mob/living/user)
	for(var/mob/living/L in get_hearers_in_view(5, user))
		if(L == user)
			continue
		to_chat(L, SPAN_DANGER("Time around you slows down to a crawl..."))
		L.AdjustStunned(5)
		L.silent += 30

	if(do_after(user, 1 SECOND))
		if(user.psi.spend_power(20))
			time_stop(user)
