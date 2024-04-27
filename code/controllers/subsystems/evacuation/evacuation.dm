var/datum/evacuation_controller/evacuation_controller

/datum/evacuation_controller

	var/name = "generic evac controller"
	var/state = EVAC_IDLE
	var/deny
	var/recall
	var/auto_recall_time
	var/evacuation_type = TRANSFER_CREW

	var/evac_prep_delay =   10 MINUTES
	var/evac_launch_delay =  3 MINUTES
	var/evac_transit_delay = 2 MINUTES

	var/autotransfer_prep_additional_delay = 0 MINUTES
	var/emergency_prep_additional_delay = 0 MINUTES
	var/transfer_prep_additional_delay = 0 MINUTES
	var/force_time = 0 MINUTES
	var/wait_for_force = FALSE 	//If the evac is waiting to be forced

	var/evac_cooldown_time
	var/evac_called_at
	var/evac_no_return
	var/evac_ready_time
	var/evac_launch_time
	var/evac_arrival_time

	var/list/evacuation_predicates = list()

	var/list/evacuation_options = list()

	var/datum/announcement/priority/evac_waiting =  new(0)
	var/datum/announcement/priority/evac_called =   new(0)
	var/datum/announcement/priority/evac_recalled = new(0)

/datum/evacuation_controller/proc/auto_recall(var/_recall)
	recall = _recall

/datum/evacuation_controller/proc/set_up()
	return

/datum/evacuation_controller/proc/get_cooldown_message()
	return "An evacuation cannot be called at this time. Please wait another [round((evac_cooldown_time-world.time)/600)] minute\s before trying again."

/datum/evacuation_controller/proc/add_can_call_predicate(var/datum/evacuation_predicate/esp)
	if(esp in evacuation_predicates)
		CRASH("[esp] has already been added as an evacuation predicate")
	evacuation_predicates += esp

/datum/evacuation_controller/proc/call_evacuation(var/mob/user, var/_evac_type, var/forced, var/skip_announce, var/autotransfer)
	if(state != EVAC_IDLE)
		return FALSE

	if(!can_evacuate(user, forced))
		return FALSE

	evacuation_type = _evac_type

	var/evac_prep_delay_multiplier = 1
	if(SSticker.mode)
		evac_prep_delay_multiplier = SSticker.mode.shuttle_delay

	var/additional_delay
	if(_evac_type == TRANSFER_EMERGENCY)
		additional_delay = emergency_prep_additional_delay
	else if(autotransfer)
		additional_delay = autotransfer_prep_additional_delay
	else
		additional_delay = transfer_prep_additional_delay

	evac_called_at =    world.time
	evac_no_return =    evac_called_at +    round(evac_prep_delay/2) + additional_delay
	evac_ready_time =   evac_called_at +    (evac_prep_delay*evac_prep_delay_multiplier) + additional_delay
	evac_launch_time =  evac_ready_time +   evac_launch_delay
	evac_arrival_time = evac_launch_time +  evac_transit_delay

	var/evac_range = round((evac_launch_time - evac_called_at)/3)
	auto_recall_time =  rand(evac_called_at + evac_range, evac_launch_time - evac_range)

	state = EVAC_PREPPING
	switch(evacuation_type)
		if(TRANSFER_EMERGENCY)
			for(var/area/A in GLOB.all_areas)
				if(istype(A, /area/hallway))
					A.readyalert()
			if(!skip_announce)
				priority_announcement.Announce(replacetext(replacetext(SSatlas.current_map.emergency_shuttle_called_message, "%dock%", "[SSatlas.current_map.dock_name]"),  "%ETA%", "[round(get_eta()/60)] minute\s"), new_sound = 'sound/AI/emergency_shuttle_called_message.ogg')
		if(TRANSFER_CREW)
			if(!skip_announce)
				priority_announcement.Announce(replacetext(replacetext(SSatlas.current_map.shuttle_called_message, "%dock%", "[SSatlas.current_map.dock_name]"),  "%ETA%", "[round(get_eta()/60)] minute\s"), new_sound = 'sound/AI/shuttle_called_message.ogg')
		if(TRANSFER_JUMP)
			if(!skip_announce)
				priority_announcement.Announce(replacetext(replacetext(SSatlas.current_map.bluespace_called_message, "%dock%", "[SSatlas.current_map.dock_name]"),  "%ETA%", "[round(get_eta()/60)] minute\s"), new_sound = 'sound/AI/bluespace_jump_called.ogg')
	return TRUE

/datum/evacuation_controller/proc/cancel_evacuation()
	if(!can_cancel())
		return FALSE

	evac_cooldown_time = world.time + (world.time - evac_called_at)
	state = EVAC_COOLDOWN

	evac_ready_time =   null
	evac_arrival_time = null
	evac_no_return =    null
	evac_called_at =    null
	evac_launch_time =  null
	auto_recall_time =  null

	switch(evacuation_type)
		if(TRANSFER_EMERGENCY)
			evac_recalled.Announce(SSatlas.current_map.emergency_shuttle_recall_message, new_sound = 'sound/AI/emergency_shuttle_recall_message.ogg')
			for(var/area/A in GLOB.all_areas)
				if(istype(A, /area/hallway))
					A.readyreset()
		if(TRANSFER_JUMP)
			priority_announcement.Announce(SSatlas.current_map.bluespace_recall_message, new_sound = 'sound/AI/bluespace_jump_recalled.ogg')
		if(TRANSFER_CREW)
			priority_announcement.Announce(SSatlas.current_map.shuttle_recall_message, new_sound = 'sound/AI/shuttle_recall_message.ogg')

	return TRUE

/datum/evacuation_controller/proc/finish_preparing_evac()
	state = EVAC_LAUNCHING

	var/estimated_time = round(get_eta()/60,1)

	switch(evacuation_type)
		if(TRANSFER_EMERGENCY)
			evac_waiting.Announce(replacetext(SSatlas.current_map.emergency_shuttle_docked_message, "%ETA%", "[estimated_time] minute\s"), new_sound = sound('sound/AI/emergency_shuttle_docked.ogg'))
		if(TRANSFER_JUMP)
			priority_announcement.Announce(replacetext(replacetext(SSatlas.current_map.bluespace_docked_message, "%dock%", "[SSatlas.current_map.dock_name]"), "%ETA%", "[estimated_time] minute\s"), new_sound = sound('sound/AI/bluespace_jump_docked.ogg'))
		if(TRANSFER_CREW)
			priority_announcement.Announce(replacetext(replacetext(SSatlas.current_map.shuttle_docked_message, "%dock%", "[SSatlas.current_map.dock_name]"), "%ETA%", "[estimated_time] minute\s"), new_sound = sound('sound/AI/shuttle_docked_message.ogg'))

/datum/evacuation_controller/proc/launch_evacuation()
	if(waiting_to_leave())
		return

	state = EVAC_IN_TRANSIT

	switch(evacuation_type)
		if(TRANSFER_EMERGENCY)
			priority_announcement.Announce(replacetext(replacetext(SSatlas.current_map.emergency_shuttle_leaving_dock, "%dock%", "[SSatlas.current_map.dock_name]"),  "%ETA%", "[round(get_eta()/60,1)] minute\s"), new_sound = sound('sound/AI/emergency_shuttle_leaving_dock.ogg'))
		if(TRANSFER_JUMP)
			priority_announcement.Announce(replacetext(replacetext(SSatlas.current_map.bluespace_leaving_dock, "%dock%", "[SSatlas.current_map.dock_name]"),  "%ETA%", "[round(get_eta()/60,1)] minute\s"), new_sound = sound('sound/AI/bluespace_jump_leaving.ogg'))
		if(TRANSFER_CREW)
			priority_announcement.Announce(replacetext(replacetext(SSatlas.current_map.shuttle_leaving_dock, "%dock%", "[SSatlas.current_map.dock_name]"),  "%ETA%", "[round(get_eta()/60,1)] minute\s"), new_sound = sound('sound/AI/shuttle_leaving_dock.ogg'))

	return TRUE

/datum/evacuation_controller/proc/finish_evacuation()
	state = EVAC_COMPLETE

/datum/evacuation_controller/process()
	if(state == EVAC_PREPPING && recall && world.time >= auto_recall_time)
		cancel_evacuation()
		return

	if(state == EVAC_PREPPING)
		if(world.time >= evac_ready_time)
			finish_preparing_evac()
	else if(state == EVAC_LAUNCHING)
		if(world.time >= evac_launch_time)
			launch_evacuation()
	else if(state == EVAC_IN_TRANSIT)
		if(world.time >= evac_arrival_time)
			finish_evacuation()
	else if(state == EVAC_COOLDOWN)
		if(world.time >= evac_cooldown_time)
			state = EVAC_IDLE

/datum/evacuation_controller/proc/available_evac_options()
	return list()

/datum/evacuation_controller/proc/handle_evac_option(var/option_target, var/mob/user)
	var/datum/evacuation_option/selected = evacuation_options[option_target]
	if (!isnull(selected) && istype(selected))
		selected.execute(user)

/datum/evacuation_controller/proc/get_evac_option(var/option_target)
	return null

/datum/evacuation_controller/proc/should_call_autotransfer_vote()
	return (state == EVAC_IDLE)
