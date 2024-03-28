#define EVAC_OPT_ABANDON_SHIP "abandon_ship"
#define EVAC_OPT_BLUESPACE_JUMP "bluespace_jump"
#define EVAC_OPT_CREW_TRANSFER "crew_transfer"
#define EVAC_OPT_CANCEL_ABANDON_SHIP "cancel_abandon_ship"
#define EVAC_OPT_CANCEL_BLUESPACE_JUMP "cancel_bluespace_jump"
#define EVAC_OPT_CANCEL_CREW_TRANSFER "cancel_crew_transfer"

// Apparently, emergency_evacuation --> "abandon ship" and !emergency_evacuation --> "bluespace jump"
// That stuff should be moved to the evacuation option datums but someone can do that later
/datum/evacuation_controller/starship
	name = "escape pod controller"

	transfer_prep_additional_delay     = 0 MINUTES
	autotransfer_prep_additional_delay = 0 MINUTES
	emergency_prep_additional_delay    = 0 MINUTES

	evacuation_options = list(
		EVAC_OPT_ABANDON_SHIP = new /datum/evacuation_option/abandon_ship(),
		EVAC_OPT_BLUESPACE_JUMP = new /datum/evacuation_option/bluespace_jump(),
		EVAC_OPT_CREW_TRANSFER = new /datum/evacuation_option/crew_transfer(),
		EVAC_OPT_CANCEL_ABANDON_SHIP = new /datum/evacuation_option/cancel_abandon_ship(),
		EVAC_OPT_CANCEL_BLUESPACE_JUMP = new /datum/evacuation_option/cancel_bluespace_jump(),
		EVAC_OPT_CANCEL_CREW_TRANSFER = new /datum/evacuation_option/cancel_crew_transfer()
	)

/datum/evacuation_controller/starship/finish_preparing_evac()
	. = ..()
	// Arm the escape pods.
	if(evacuation_type == TRANSFER_EMERGENCY)
		for (var/datum/shuttle/autodock/ferry/escape_pod/pod in escape_pods)
			if (pod.arming_controller)
				pod.arming_controller.arm()

/datum/evacuation_controller/starship/launch_evacuation()

	state = EVAC_IN_TRANSIT

	switch(evacuation_type)
		if("evacuation")
			// Abandon Ship
			for(var/datum/shuttle/autodock/ferry/escape_pod/pod in escape_pods) // Launch the pods!
				if(!pod.arming_controller || pod.arming_controller.armed)
					pod.move_time = (evac_transit_delay/10)
					pod.launch(src)

			priority_announcement.Announce(replacetext(replacetext(SSatlas.current_map.emergency_shuttle_leaving_dock, "%dock_name%", "[SSatlas.current_map.dock_name]"),  "%ETA%", "[round(get_eta()/60,1)] minute\s"))
		if(TRANSFER_JUMP)
			// Bluespace Jump
			priority_announcement.Announce(replacetext(replacetext(SSatlas.current_map.bluespace_leaving_dock, "%dock_name%", "[SSatlas.current_map.dock_name]"),  "%ETA%", "[round(get_eta()/60,1)] minute\s"))
			SetUniversalState(/datum/universal_state/bluespace_jump, arguments=list(SSatlas.current_map.station_levels))
		if(TRANSFER_CREW)
			priority_announcement.Announce(replacetext(replacetext(SSatlas.current_map.shuttle_leaving_dock, "%dock_name%", "[SSatlas.current_map.dock_name]"),  "%ETA%", "[round(get_eta()/60,1)] minute\s"))

/datum/evacuation_controller/starship/finish_evacuation()
	..()
	if(evacuation_type == TRANSFER_JUMP) //bluespace jump
		SetUniversalState(/datum/universal_state) //clear jump state

/datum/evacuation_controller/starship/available_evac_options()
	if (is_on_cooldown())
		return list()
	if (is_idle())
		return list(evacuation_options[EVAC_OPT_BLUESPACE_JUMP], evacuation_options[EVAC_OPT_ABANDON_SHIP])
	if (is_evacuating())
		switch(evacuation_type)
			if(TRANSFER_EMERGENCY)
				return list(evacuation_options[EVAC_OPT_CANCEL_ABANDON_SHIP])
			if(TRANSFER_JUMP)
				return list(evacuation_options[EVAC_OPT_CANCEL_BLUESPACE_JUMP])
			if(TRANSFER_CREW)
				return list(evacuation_options[EVAC_OPT_CANCEL_CREW_TRANSFER])

/datum/evacuation_option/abandon_ship
	option_text = "Abandon spacecraft"
	option_desc = "abandon the spacecraft"
	option_target = EVAC_OPT_ABANDON_SHIP
	needs_syscontrol = TRUE
	silicon_allowed = TRUE
	abandon_ship = TRUE

/datum/evacuation_option/abandon_ship/execute(mob/user)
	if (!evacuation_controller)
		return
	if (evacuation_controller.deny)
		to_chat(user, "Unable to initiate escape procedures.")
		return
	if (evacuation_controller.is_on_cooldown())
		to_chat(user, evacuation_controller.get_cooldown_message())
		return
	if (evacuation_controller.is_evacuating())
		to_chat(user, "Escape procedures already in progress.")
		return
	if (evacuation_controller.call_evacuation(user, 1))
		log_and_message_admins("[user? key_name(user) : "Autotransfer"] has initiated abandonment of the spacecraft.")

/datum/evacuation_option/bluespace_jump
	option_text = "Initiate bluespace jump"
	option_desc = "initiate a bluespace jump"
	option_target = EVAC_OPT_BLUESPACE_JUMP
	needs_syscontrol = TRUE
	silicon_allowed = TRUE

/datum/evacuation_option/bluespace_jump/execute(mob/user)
	if (!evacuation_controller)
		return
	if (evacuation_controller.deny)
		to_chat(user, "Unable to initiate jump preparation.")
		return
	if (evacuation_controller.is_on_cooldown())
		to_chat(user, evacuation_controller.get_cooldown_message())
		return
	if (evacuation_controller.is_evacuating())
		to_chat(user, "Jump preparation already in progress.")
		return
	if (evacuation_controller.call_evacuation(user, 0))
		log_and_message_admins("[user? key_name(user) : "Autotransfer"] has initiated bluespace jump preparation.")

/datum/evacuation_option/crew_transfer
	option_text = "Initiate crew transfer"
	option_desc = "initiate a crew transfer"
	option_target = EVAC_OPT_CREW_TRANSFER
	needs_syscontrol = TRUE
	silicon_allowed = TRUE

/datum/evacuation_option/crew_transfer/execute(mob/user)
	if(!evacuation_controller)
		return
	if(evacuation_controller.deny)
		to_chat(user, "Unable to initiate crew transfer preparation.")
		return
	if(evacuation_controller.is_on_cooldown())
		to_chat(user, evacuation_controller.get_cooldown_message())
		return
	if(evacuation_controller.is_evacuating())
		to_chat(user, "Crew transfer preparation already in progress.")
		return
	if(evacuation_controller.call_evacuation(user, 0))
		log_and_message_admins("[user? key_name(user) : "Autotransfer"] has initiated crew transfer preparation.")

/datum/evacuation_option/cancel_abandon_ship
	option_text = "Cancel abandonment"
	option_desc = "cancel abandonment of the spacecraft"
	option_target = EVAC_OPT_CANCEL_ABANDON_SHIP
	needs_syscontrol = TRUE
	silicon_allowed = FALSE

/datum/evacuation_option/cancel_abandon_ship/execute(mob/user)
	if (evacuation_controller && evacuation_controller.cancel_evacuation())
		log_and_message_admins("[key_name(user)] has cancelled abandonment of the spacecraft.")

/datum/evacuation_option/cancel_bluespace_jump
	option_text = "Cancel bluespace jump"
	option_desc = "cancel the jump preparation"
	option_target = EVAC_OPT_CANCEL_BLUESPACE_JUMP
	needs_syscontrol = TRUE
	silicon_allowed = FALSE

/datum/evacuation_option/cancel_bluespace_jump/execute(mob/user)
	if (evacuation_controller && evacuation_controller.cancel_evacuation())
		log_and_message_admins("[key_name(user)] has cancelled the bluespace jump.")

/datum/evacuation_option/cancel_crew_transfer
	option_text = "Cancel crew transfer"
	option_desc = "cancel the crew transfer preparation"
	option_target = EVAC_OPT_CANCEL_BLUESPACE_JUMP
	needs_syscontrol = TRUE
	silicon_allowed = FALSE

/datum/evacuation_option/cancel_crew_transfer/execute(mob/user)
	if(evacuation_controller && evacuation_controller.cancel_evacuation())
		log_and_message_admins("[key_name(user)] has cancelled the crew transfer.")

/obj/screen/fullscreen/bluespace_overlay
	icon = 'icons/effects/effects.dmi'
	icon_state = "mfoam"
	screen_loc = "WEST,SOUTH to EAST,NORTH"
	color = "#ff9900"
	blend_mode = BLEND_SUBTRACT

#undef EVAC_OPT_ABANDON_SHIP
#undef EVAC_OPT_BLUESPACE_JUMP
#undef EVAC_OPT_CANCEL_ABANDON_SHIP
#undef EVAC_OPT_CANCEL_BLUESPACE_JUMP
