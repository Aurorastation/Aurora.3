/datum/state_machine/weather
	expected_type = /obj/abstract/weather_system

/datum/state_machine/weather/choose_transition(list/valid_transitions)
	var/list/transitions = list()
	for(var/singleton/state_transition/weather/state_transition in valid_transitions)
		transitions[state_transition] = state_transition.likelihood_weighting
	if(length(transitions))
		return pick(transitions) //pickweight(transitions)
	return ..()

/datum/state_machine/weather/handle_next_transition(var/obj/abstract/weather_system/holder_instance, var/singleton/state_transition/chosen_transition)
	holder_instance.transitioning_weather = TRUE
	var/time_to_transition = (rand(1, 3) MINUTES) + (rand(-30, 30) SECONDS)
	SEND_GLOBAL_SIGNAL(COMSIG_GLOB_Z_WEATHER_CHANGE, holder_instance.z, chosen_transition, time_to_transition)
	addtimer(CALLBACK(src, PROC_REF(finalize_weather_transition), holder_instance, chosen_transition), time_to_transition)

/// Exits the old weather state, enters the new one, and finishes transitioning
/datum/state_machine/weather/proc/finalize_weather_transition(var/obj/abstract/weather_system/holder_instance, var/singleton/state_transition/chosen_transition)
	current_state.exited_state(holder_instance)
	current_state = chosen_transition.target
	current_state.entered_state(holder_instance)
	holder_instance.transitioning_weather = FALSE
