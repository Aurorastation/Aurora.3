/singleton/psionic_power/nlom_eyes
	name = "Nlom Eyes"
	desc = "Roughly locate a mob on your z-level."
	icon_state = "tech_control"
	point_cost = 2
	ability_flags = PSI_FLAG_ANTAG
	spell_path = /obj/item/spell/nlom_eyes

/obj/item/spell/nlom_eyes
	name = "nlom eyes"
	desc = "Psionic drugs? No way."
	icon_state = "track"
	cast_methods = CAST_USE
	aspect = ASPECT_PSIONIC
	cooldown = 10
	psi_cost = 5
	/// The mob we are tracking.
	var/mob/living/tracked
	/// If we are tracking a mob.
	var/tracking = FALSE

/obj/item/spell/nlom_eyes/Destroy()
	tracked = null
	tracking = 0
	STOP_PROCESSING(SSprocessing, src)
	return ..()

/obj/item/spell/nlom_eyes/on_use_cast(mob/user)
	if(tracking)
		tracking = FALSE
		to_chat(user, SPAN_NOTICE("You stop looking in the Nlom for \the [tracked]'s whereabouts."))
		tracked = null
		STOP_PROCESSING(SSprocessing, src)
		icon_state = "track"
		return
	. = ..()
	if(!.)
		return

	var/list/mob_choices = list()
	for(var/mob/living/L in GLOB.mob_list)
		if(L == user)
			continue
		if(!L.is_psi_blocked(user))
			continue
		if(GET_Z(L) != GET_Z(user))
			continue
		mob_choices += L
	var/choice = tgui_input_list(user, "Decide who to track.", "Nlom Eyes", mob_choices)
	if(choice)
		tracked = choice
		tracking = TRUE
		START_PROCESSING(SSprocessing, src)

/obj/item/spell/track/process()
	if(!tracking)
		icon_state = "track"
		return

	if(!tracked)
		icon_state = "track_unknown"

	if(GET_Z(tracked) != GET_Z(owner))
		icon_state = "track_unknown"

	else
		set_dir(get_dir(src,get_turf(tracked)))
		switch(get_dist(src,get_turf(tracked)))
			if(0)
				icon_state = "track_direct"
			if(1 to 8)
				icon_state = "track_close"
			if(9 to 16)
				icon_state = "track_medium"
			if(16 to INFINITY)
				icon_state = "track_far"
