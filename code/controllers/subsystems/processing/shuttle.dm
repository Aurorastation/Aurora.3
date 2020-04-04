var/datum/controller/subsystem/processing/shuttle/SSshuttle

/datum/controller/subsystem/processing/shuttle
	name = "Shuttle"
	wait = 2 SECONDS
	flags = 0
	priority = SS_PRIORITY_SHUTTLE
	init_order = SS_INIT_MISC                    //Should be initialized after all maploading is over and atoms are initialized, to ensure that landmarks have been initialized.

	var/list/shuttles = list()                   //maps shuttle tags to shuttle datums, so that they can be looked up.
	var/list/process_shuttles = list()           //simple list of shuttles, for processing
	var/list/registered_shuttle_landmarks = list()
	var/last_landmark_registration_time
	var/list/docking_registry = list()           //Docking controller tag -> docking controller program, mostly for init purposes.
	var/list/shuttle_areas = list()              //All the areas of all shuttles.

	var/list/shuttles_to_initialize = list()     //A queue for shuttles to initialize at the appropriate time.
	var/block_queue = TRUE

	var/tmp/list/working_shuttles

/datum/controller/subsystem/processing/shuttle/New()
	NEW_SS_GLOBAL(SSshuttle)

/datum/controller/subsystem/processing/shuttle/Initialize()
	last_landmark_registration_time = world.time
	for(var/shuttle_type in subtypesof(/datum/shuttle)) // This accounts for most shuttles, though away maps can queue up more.
		var/datum/shuttle/shuttle = shuttle_type
		if(!(shuttle in current_map.map_shuttles))
			continue
		if(!initial(shuttle.defer_initialisation))
			LAZYDISTINCTADD(shuttles_to_initialize, shuttle_type)
	block_queue = FALSE
	clear_init_queue()
	. = ..()

/datum/controller/subsystem/processing/shuttle/fire(resumed = FALSE)
	if (!resumed)
		working_shuttles = process_shuttles.Copy()

	while(working_shuttles.len)
		var/datum/shuttle/shuttle = working_shuttles[working_shuttles.len]
		working_shuttles.len--
		if(shuttle.process_state && (shuttle.process(wait, times_fired, src) == PROCESS_KILL))
			process_shuttles -= shuttle

		if(TICK_CHECK)
			return

/datum/controller/subsystem/processing/shuttle/proc/clear_init_queue()
	if(block_queue)
		return
	initialize_shuttles()

/datum/controller/subsystem/processing/shuttle/proc/initialize_shuttles()
	var/list/shuttles_made = list()
	for(var/shuttle_type in shuttles_to_initialize)
		var/shuttle = initialize_shuttle(shuttle_type)
		if(shuttle)
			shuttles_made += shuttle
	shuttles_to_initialize = null

/datum/controller/subsystem/processing/shuttle/proc/register_landmark(shuttle_landmark_tag, obj/effect/shuttle_landmark/shuttle_landmark)
	if (registered_shuttle_landmarks[shuttle_landmark_tag])
		CRASH("Attempted to register shuttle landmark with tag [shuttle_landmark_tag], but it is already registered!")
	if (istype(shuttle_landmark))
		registered_shuttle_landmarks[shuttle_landmark_tag] = shuttle_landmark
		last_landmark_registration_time = world.time

/datum/controller/subsystem/processing/shuttle/proc/get_landmark(var/shuttle_landmark_tag)
	return registered_shuttle_landmarks[shuttle_landmark_tag]

/datum/controller/subsystem/processing/shuttle/proc/initialize_shuttle(var/shuttle_type)
	var/datum/shuttle/shuttle = shuttle_type
	if(initial(shuttle.category) != shuttle_type)
		shuttle = new shuttle()
		shuttle_areas |= shuttle.shuttle_area
		return shuttle
