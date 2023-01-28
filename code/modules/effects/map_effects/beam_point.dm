var/global/list/all_beam_points

// Creates and manages a beam attached to itself and another beam_point.
// You can do cool things with these such as moving the beam_point to move the beam, turning them on and off on a timer, triggered by external input, and more.
/obj/effect/map_effect/beam_point
	name = "beam point"
	icon_state = "beam_point"

	// General variables.
	var/list/my_beams = list() // Instances of beams. Deleting one will kill the beam.
	var/id = "A" // Two beam_points must share the same ID to be connected to each other.
	var/max_beams = 10 // How many concurrent beams to seperate beam_points to have at once. Set to zero to only act as targets for other beam_points.
	var/seek_range = 7 // How far to look for an end beam_point when not having a beam. Defaults to screen height/width. Make sure this is below beam_max_distance.

	// Controls how and when the beam is created.
	var/make_beams_on_init = FALSE
	var/use_timer = FALSE // Sadly not the /tg/ timers.
	var/list/on_duration = list(2 SECONDS, 2 SECONDS, 2 SECONDS) // How long the beam should stay on for, if use_timer is true. Alternates between each duration in the list.
	var/list/off_duration = list(3 SECONDS, 0.5 SECOND, 0.5 SECOND) // How long it should stay off for. List length is not needed to be the same as on_duration.
	var/timer_on_index = 1 // Index to use for on_duration list.
	var/timer_off_index = 1// Ditto, for off_duration list.
	var/initial_delay = 0 // How long to wait before first turning on the beam, to sync beam times or create a specific pattern.
	var/beam_creation_sound = null // Optional sound played when one or more beams are created.
	var/beam_destruction_sound = null // Optional sound played when a beam is destroyed.

	// Beam datum arguments.
	var/beam_icon = 'icons/effects/beam.dmi' // Icon file to use for beam visuals.
	var/beam_icon_state = "b_beam" // Icon state to use for visuals.
	var/beam_time = -1 // How long the beam lasts. By default it will last forever until destroyed.
	var/beam_max_distance = 10 // If the beam is farther than this, it will be destroyed. Make sure it's higher than seek_range.
	var/beam_type = /obj/effect/ebeam // The type of beam. Default has no special properties. Some others may do things like hurt things touching it.
	var/beam_sleep_time = 3 // How often the beam updates visually. Suggested to leave this alone, 3 is already fast.

/obj/effect/map_effect/beam_point/Initialize()
	LAZYADD(all_beam_points, src)
	if(make_beams_on_init)
		create_beams()
	if(use_timer)
		addtimer(CALLBACK(src, PROC_REF(handle_beam_timer)), initial_delay)
	return ..()

/obj/effect/map_effect/beam_point/Destroy()
	destroy_all_beams()
	use_timer = FALSE
	LAZYREMOVE(all_beam_points, src)
	return ..()

// This is the top level proc to make the magic happen.
/obj/effect/map_effect/beam_point/proc/create_beams()
	if(length(my_beams) >= max_beams)
		return
	var/beams_to_fill = max_beams - length(my_beams)
	for(var/i = 1 to beams_to_fill)
		var/obj/effect/map_effect/beam_point/point = seek_beam_point()
		if(!point)
			break // No more points could be found, no point checking repeatively.
		build_beam(point)

// Finds a suitable beam point.
/obj/effect/map_effect/beam_point/proc/seek_beam_point()
	for(var/obj/effect/map_effect/beam_point/point in all_beam_points)
		if(id != point.id)
			continue // Not linked together by ID.
		if(has_active_beam(point))
			continue // Already got one.
		if(point.z != src.z)
			continue // Not on same z-level. get_dist() ignores z-levels by design according to docs.
		if(get_dist(src, point) > seek_range)
			continue // Too far.
		return point

// Checks if the two points have an active beam between them.
// Used to make sure two points don't have more than one beam.
/obj/effect/map_effect/beam_point/proc/has_active_beam(var/obj/effect/map_effect/beam_point/them)
	// First, check our beams.
	for(var/datum/beam/B in my_beams)
		if(B.target == them)
			return TRUE
		if(B.origin == them) // This shouldn't be needed unless the beam gets built backwards but why not.
			return TRUE

	// Now check theirs, to see if they have a beam on us.
	for(var/datum/beam/B in them.my_beams)
		if(B.target == src)
			return TRUE
		if(B.origin == src) // Same story as above.
			return TRUE

	return FALSE

/obj/effect/map_effect/beam_point/proc/build_beam(var/atom/beam_target)
	if(!beam_target)
		log_debug("[src] ([src.type] \[[x],[y],[z]\]) failed to build its beam due to not having a target.")
		return FALSE

	var/datum/beam/new_beam = Beam(beam_target, beam_icon_state, beam_icon, beam_time, beam_max_distance, beam_type, beam_sleep_time)
	if (!istype(new_beam))
		return FALSE
	my_beams += new_beam
	if(beam_creation_sound)
		playsound(src, beam_creation_sound, 70, 1)

	return TRUE

/obj/effect/map_effect/beam_point/proc/destroy_beam(var/datum/beam/B)
	if(!B)
		log_debug("[src] ([src.type] \[[x],[y],[z]\]) was asked to destroy a beam that does not exist.")
		return FALSE

	if(!(B in my_beams))
		log_debug("[src] ([src.type] \[[x],[y],[z]\]) was asked to destroy a beam it did not own.")
		return FALSE

	my_beams -= B
	qdel(B)
	if(beam_destruction_sound)
		playsound(src, beam_destruction_sound, 70, 1)

	return TRUE

/obj/effect/map_effect/beam_point/proc/destroy_all_beams()
	for(var/datum/beam/B in my_beams)
		destroy_beam(B)
	return TRUE

// This code makes me sad.
/obj/effect/map_effect/beam_point/proc/handle_beam_timer()
	if(!use_timer || QDELETED(src))
		return

	if(length(my_beams)) // Currently on.
		destroy_all_beams()
		color = "#FF0000"

		timer_off_index++
		if(timer_off_index > off_duration.len)
			timer_off_index = 1

		addtimer(CALLBACK(src, PROC_REF(handle_beam_timer)), off_duration[timer_off_index])

	else // Currently off.
		// If nobody's around, keep the beams off to avoid wasteful beam process(), if they have one.
		if(!always_run && !check_for_player_proximity(src, proximity_needed, ignore_ghosts, ignore_afk))
			addtimer(CALLBACK(src, PROC_REF(handle_beam_timer)), retry_delay)
			return

		create_beams()
		color = "#00FF00"

		timer_on_index++
		if(timer_on_index > on_duration.len)
			timer_on_index = 1

		addtimer(CALLBACK(src, PROC_REF(handle_beam_timer)), on_duration[timer_on_index])


// Subtypes to use in maps and adminbuse.
// Remember, beam_points ONLY connect to other beam_points with the same id variable.

// Creates the beam when instantiated and stays on until told otherwise.
/obj/effect/map_effect/beam_point/instant
	make_beams_on_init = TRUE

// Turns on and off on a timer.
/obj/effect/map_effect/beam_point/timer
	use_timer = TRUE

// Is only a target for other beams to connect to.
/obj/effect/map_effect/beam_point/end
	max_beams = 0

// Can only have one beam.
/obj/effect/map_effect/beam_point/mono
	make_beams_on_init = TRUE
	max_beams = 1
