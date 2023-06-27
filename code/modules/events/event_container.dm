#define ASSIGNMENT_ANY "Any"
#define ASSIGNMENT_AI "AI"
#define ASSIGNMENT_CYBORG "Cyborg"
#define ASSIGNMENT_ENGINEER "Engineer"
#define ASSIGNMENT_GARDENER "Gardener"
#define ASSIGNMENT_JANITOR "Janitor"
#define ASSIGNMENT_MEDICAL "Medical"
#define ASSIGNMENT_SCIENTIST "Scientist"
#define ASSIGNMENT_SECURITY "Security"
#define ASSIGNMENT_SURGEON "Surgeon"

var/global/list/severity_to_string = list(EVENT_LEVEL_MUNDANE = "Mundane", EVENT_LEVEL_MODERATE = "Moderate", EVENT_LEVEL_MAJOR = "Major")

/datum/event_container
	var/severity = -1
	var/delayed = 0
	var/delay_modifier = 1
	var/next_event_time = 0
	var/list/available_events
	var/list/last_event_time = list()
	var/datum/event_meta/next_event = null

	var/last_world_time = 0

/datum/event_container/process()
	if(!next_event_time)
		set_event_delay()

	if(delayed || !config.allow_random_events)
		next_event_time += (world.time - last_world_time)
	else if(world.time > next_event_time)
		start_event()

	last_world_time = world.time

/datum/event_container/proc/start_event()
	if(!next_event)	// If non-one has explicitly set an event, randomly pick one
		next_event = acquire_event()

	// Has an event been acquired?
	if(next_event)
		// Set when the event of this type was last fired, and prepare the next event start
		last_event_time[next_event] = world.time
		set_event_delay()
		next_event.enabled = !next_event.one_shot	// This event will no longer be available in the random rotation if one shot

		new next_event.event_type(next_event)	// Events are added and removed from the processing queue in their New/kill procs

		log_debug("Starting event '[next_event.name]' of severity [severity_to_string[severity]].")
		next_event = null						// When set to null, a random event will be selected next time
	else
		// If not, wait for one minute, instead of one tick, before checking again.
		next_event_time += (60 * 10)


/datum/event_container/proc/acquire_event()
	if(available_events.len == 0)
		return
	var/active_with_role = number_active_with_role()

	var/list/possible_events = list()
	for(var/datum/event_meta/EM in available_events)
		var/event_weight = get_weight(EM, active_with_role)
		if(event_weight)
			possible_events[EM] = event_weight

	if(possible_events.len == 0)
		return null

	// Select an event and remove it from the pool of available events
	var/picked_event = pickweight(possible_events)
	available_events -= picked_event
	return picked_event

/datum/event_container/proc/get_weight(var/datum/event_meta/EM, var/list/active_with_role)
	if(!EM.enabled)
		return 0

	var/weight = EM.get_weight(active_with_role)
	var/last_time = last_event_time[EM]
	if(last_time)
		var/time_passed = world.time - last_time
		var/weight_modifier = max(0, round((config.expected_round_length - time_passed) / 300))
		weight = weight - weight_modifier

	return weight

/datum/event_container/proc/set_event_delay()
	// If the next event time has not yet been set and we have a custom first time start
	if(next_event_time == 0 && config.event_first_run[severity])
		var/lower = config.event_first_run[severity]["lower"]
		var/upper = config.event_first_run[severity]["upper"]
		var/event_delay = rand(lower, upper)
		next_event_time = world.time + event_delay
	// Otherwise, follow the standard setup process
	else
		var/playercount_modifier = 1
		switch(player_list.len)
			if(0 to 10)
				playercount_modifier = 1.2
			if(11 to 15)
				playercount_modifier = 1.1
			if(16 to 25)
				playercount_modifier = 1
			if(26 to 35)
				playercount_modifier = 0.9
			if(36 to 100000)
				playercount_modifier = 0.8
		playercount_modifier = playercount_modifier * delay_modifier

		var/event_delay = rand(config.event_delay_lower[severity], config.event_delay_upper[severity]) * playercount_modifier
		next_event_time = world.time + event_delay

	log_debug("Next event of severity [severity_to_string[severity]] in [(next_event_time - world.time)/600] minutes.")

/datum/event_container/proc/SelectEvent()
	var/datum/event_meta/EM = input("Select an event to queue up.", "Event Selection", null) as null|anything in available_events
	if(!EM)
		return
	if(next_event)
		available_events += next_event
	available_events -= EM
	next_event = EM
	return EM

// Returns how many characters are currently active (not logged out, not AFK for more than 10 minutes) with a specific role.
// Note that this isn't sorted by department, because e.g. having a roboticist shouldn't make meteors spawn.
/proc/number_active_with_role()
	var/list/active_with_role = list()
	active_with_role["Engineer"] = 0
	active_with_role["Medical"] = 0
	active_with_role["Surgeon"] = 0
	active_with_role["Security"] = 0
	active_with_role["Scientist"] = 0
	active_with_role["AI"] = 0
	active_with_role["Cyborg"] = 0
	active_with_role["Janitor"] = 0
	active_with_role["Gardener"] = 0

	for(var/mob/M in player_list)
		if(!M.mind || !M.client || M.client.is_afk(10 MINUTES)) // longer than 10 minutes AFK counts them as inactive
			continue

		active_with_role["Any"]++

		if(istype(M, /mob/living/silicon/robot))
			var/mob/living/silicon/robot/R = M
			if(R.module)
				if(istype(R.module, /obj/item/robot_module/engineering))
					active_with_role["Engineer"]++
				else if(istype(R.module, /obj/item/robot_module/medical))
					active_with_role["Medical"]++
				else if(istype(R.module, /obj/item/robot_module/research))
					active_with_role["Scientist"]++

		if(M.mind.assigned_role in engineering_positions)
			active_with_role["Engineer"]++

		if(M.mind.assigned_role in medical_positions)
			active_with_role["Medical"]++
			if(M.mind.assigned_role == "Surgeon")
				active_with_role["Surgeon"]++

		if(M.mind.assigned_role in security_positions)
			active_with_role["Security"]++

		if(M.mind.assigned_role in science_positions)
			active_with_role["Scientist"]++

		if(M.mind.assigned_role == "AI")
			active_with_role["AI"]++

		if(M.mind.assigned_role == "Cyborg")
			active_with_role["Cyborg"]++

		if(M.mind.assigned_role == "Janitor")
			active_with_role["Janitor"]++

		if(M.mind.assigned_role == "Gardener")
			active_with_role["Gardener"]++

	return active_with_role

// Severity Level, Event Name, Event Type, Base Weight, Role Weight(s), One Shot (TRUE/FALSE), Min Weight, Max Weight. Last two only used if set and non-zero.
// Role weight(s) is per active role, so (1 role = role weight * 1), (4 roles active = role weight * 4).
/datum/event_container/mundane
	severity = EVENT_LEVEL_MUNDANE
	available_events = list(
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Nothing",						/datum/event/nothing,				120),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "APC Damage",					/datum/event/apc_damage,			20, 	list(ASSIGNMENT_ENGINEER = 15)),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Brand Intelligence",			/datum/event/brand_intelligence,	0, 		list(ASSIGNMENT_ENGINEER = 5), TRUE),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Camera Damage",					/datum/event/camera_damage,			20, 	list(ASSIGNMENT_ENGINEER = 10)),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Economic News",					/datum/event/economic_event,		300),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Cozmozoan Migration",			/datum/event/carp_migration/cozmo,	60),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Money Hacker",					/datum/event/money_hacker, 			10),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Money Lotto",					/datum/event/money_lotto, 			0, 		list(ASSIGNMENT_ANY = 1), TRUE, 5, 15),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Mundane News", 					/datum/event/mundane_news, 			300),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Wallrot",						/datum/event/wallrot, 				75,		list(ASSIGNMENT_ENGINEER = 5, ASSIGNMENT_GARDENER = 20)),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Clogged Vents",					/datum/event/vent_clog, 			55),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "False Alarm",					/datum/event/false_alarm, 			100),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Supply Drop",					/datum/event/supply_drop, 			80),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "CCIA General Notice",			/datum/event/ccia_general_notice, 	300),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Mundane Vermin Infestation",	/datum/event/infestation, 			60,		list(ASSIGNMENT_JANITOR = 15, ASSIGNMENT_SECURITY = 15, ASSIGNMENT_MEDICAL = 15)),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Drone Malfunction",				/datum/event/rogue_maint_drones,	10,		list(ASSIGNMENT_ENGINEER = 30)),
		new /datum/event_meta(EVENT_LEVEL_MUNDANE, "Visitor", 						/datum/event/visitor,				50, is_one_shot = TRUE)
	)

// Severity Level, Event Name, Event Type, Base Weight, Role Weight(s), One Shot (TRUE/FALSE), Min Weight, Max Weight. Last two only used if set and non-zero.
// Role weight(s) is per active role, so (1 role = role weight * 1), (4 roles active = role weight * 4).
/datum/event_container/moderate
	severity = EVENT_LEVEL_MODERATE
	available_events = list(
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Nothing",							/datum/event/nothing,						200),
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Appendicitis", 					/datum/event/spontaneous_appendicitis, 		0,		list(ASSIGNMENT_SURGEON = 25)),
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Communication Blackout",			/datum/event/communications_blackout,		100),
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Electrical Storm",					/datum/event/electrical_storm, 				50,		list(ASSIGNMENT_ENGINEER = 15, ASSIGNMENT_JANITOR = 20)),
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Gravity Failure",					/datum/event/gravity,	 					100),
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Ion Storm",						/datum/event/ionstorm, 						0,		list(ASSIGNMENT_AI = 45, ASSIGNMENT_CYBORG = 25, ASSIGNMENT_ENGINEER = 6, ASSIGNMENT_SCIENTIST = 6)),
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Prison Break",						/datum/event/prison_break,					0,		list(ASSIGNMENT_SECURITY = 15, ASSIGNMENT_CYBORG = 20), TRUE),
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Containment Error - Xenobiology",	/datum/event/prison_break/xenobiology,		0,		list(ASSIGNMENT_SCIENTIST = 15, ASSIGNMENT_CYBORG = 20), TRUE),
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Containment Error - Bridge",		/datum/event/prison_break/bridge,			0,		list(ASSIGNMENT_ENGINEER = 15, ASSIGNMENT_CYBORG = 20), TRUE),
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Radiation Storm",					/datum/event/radiation_storm, 				100,	list(ASSIGNMENT_MEDICAL = 20)),
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Random Antagonist",				/datum/event/random_antag,		 			0,		list(ASSIGNMENT_ANY = 1, ASSIGNMENT_SECURITY = 1), FALSE, 10, 125, list("Extended")),
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Rogue Drones",						/datum/event/rogue_drone, 					15,		list(ASSIGNMENT_SECURITY = 15)),
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Moderate Spider Infestation",		/datum/event/spider_infestation/moderate,	50,		list(ASSIGNMENT_SECURITY = 10)),
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Moderate Vermin Infestation",		/datum/event/infestation/moderate, 			30,		list(ASSIGNMENT_JANITOR = 15, ASSIGNMENT_SECURITY = 15, ASSIGNMENT_MEDICAL = 10)),
		new /datum/event_meta(EVENT_LEVEL_MODERATE, "Drone Uprising",					/datum/event/rogue_maint_drones,			25,		list(ASSIGNMENT_ENGINEER = 30))
	)

// Severity Level, Event Name, Event Type, Base Weight, Role Weight(s), One Shot (TRUE/FALSE), Min Weight, Max Weight. Last two only used if set and non-zero.
// Role weight(s) is per active role, so (1 role = role weight * 1), (4 roles active = role weight * 4).
/datum/event_container/major
	severity = EVENT_LEVEL_MAJOR
	available_events = list(
		new /datum/event_meta(EVENT_LEVEL_MAJOR,	"Nothing",					/datum/event/nothing,					135),
		new /datum/event_meta(EVENT_LEVEL_MAJOR,	"Blob",						/datum/event/blob, 						0,		list(ASSIGNMENT_ENGINEER = 10), TRUE, minimum_job_requirement_list = list("Engineer" = 2), pop_needed = 10),
		new /datum/event_meta(EVENT_LEVEL_MAJOR,	"Space Vines",				/datum/event/spacevine, 				0,		list(ASSIGNMENT_ANY = 1, ASSIGNMENT_ENGINEER = 10, ASSIGNMENT_GARDENER = 20), TRUE),
		new /datum/event_meta(EVENT_LEVEL_MAJOR,	"Spider Infestation",		/datum/event/spider_infestation,		25,	 	list(ASSIGNMENT_SECURITY = 10, ASSIGNMENT_MEDICAL = 5), TRUE),
		new /datum/event_meta(EVENT_LEVEL_MAJOR,	"Major Vermin Infestation",	/datum/event/infestation/major, 		15,		list(ASSIGNMENT_SECURITY = 15, ASSIGNMENT_MEDICAL = 5)),
		new /datum/event_meta(EVENT_LEVEL_MAJOR,	"Drone Revolution",			/datum/event/rogue_maint_drones,		0,		list(ASSIGNMENT_ENGINEER = 10, ASSIGNMENT_MEDICAL = 5, ASSIGNMENT_SECURITY = 5))
	)

#undef ASSIGNMENT_ANY
#undef ASSIGNMENT_AI
#undef ASSIGNMENT_CYBORG
#undef ASSIGNMENT_ENGINEER
#undef ASSIGNMENT_GARDENER
#undef ASSIGNMENT_JANITOR
#undef ASSIGNMENT_MEDICAL
#undef ASSIGNMENT_SCIENTIST
#undef ASSIGNMENT_SECURITY
#undef ASSIGNMENT_SURGEON