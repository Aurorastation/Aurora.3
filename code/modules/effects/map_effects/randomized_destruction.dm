/// An effect that chooses random turfs in an area, then calls `ex_act` on them. Useful for mapping randomized destruction!
ABSTRACT_TYPE(/obj/effect/map_effect/randomized_destruction)
	name = "randomized destruction"

	/// Amount of turfs that will be selected for destruction, randomized between its halved value (rand(max_turf_amount / 2, max_turf_amount))
	var/max_turf_amount

	/// Weighted assoc list that determines the destruction severity per picked turf, candidate is picked by `pick_weight()`
	// we can't use integer numbers as a key, because Byond will flatten them and make this a regular list instead of assoc list
	// we can't use defines like "[SEVERE_DESTRUCTION]" = 1 either without handling this in a proc, because non-constant. This shit is so ass
	var/list/severity = list(
		"1" = 1, // Severe destruction
		"2" = 1, // Moderate
		"3" = 1, // Mild
	)

	var/static/list/ignored_atoms = typecacheof(list(
		/obj/effect,
		/obj/machinery/computer,
		/obj/machinery/hologram,
		/obj/machinery/atmospherics/pipe/tank,
		/obj/machinery/atmospherics/unary,
		/obj/machinery/embedded_controller,
		/obj/machinery/airlock_sensor,
		/obj/machinery/access_button,
		/obj/machinery/shipsensors,
		/obj/machinery/iff_beacon,

	))

/obj/effect/map_effect/randomized_destruction/Initialize(mapload)
	. = ..()
	if(mapload)
		addtimer(CALLBACK(src, PROC_REF(start_destruction)), 3 MINUTES)
		return

	start_destruction()

/obj/effect/map_effect/randomized_destruction/proc/start_destruction()
	var/area/A = get_area(src)
	var/list/turf_pool = get_area_turfs(A)
	var/list/picked_turfs = list()
	for(var/i in 0 to round(rand(max_turf_amount / 2, max_turf_amount)))
		picked_turfs += pick_n_take(turf_pool)

	var/chosen_severity
	for(var/turf/T in picked_turfs)
		chosen_severity = text2num(pick_weight(severity)) // severity value that'll also affect every applicaple atom in turfs content
		for(var/atom/thing in T.contents)
			if(is_type_in_typecache(thing, ignored_atoms))
				continue
			thing.ex_act(chosen_severity)
		T.ex_act(chosen_severity)

	qdel(src) // I did my part, goodbye world

// ---- Subtypes

// Mild impact
ABSTRACT_TYPE(/obj/effect/map_effect/randomized_destruction/mild)
	severity = list(
		"1" = 0, // Severe		0%
		"2" = 1, // Moderate	25%
		"3" = 3, // Mild		75%
	)

/obj/effect/map_effect/randomized_destruction/mild/low_range
	name = "randomized destruction, mild impact low range"
	icon_state = "rand_dest_mild_low"
	max_turf_amount = 20

/obj/effect/map_effect/randomized_destruction/mild/high_range
	name = "randomized destruction, mild impact high range"
	icon_state = "rand_dest_mild_high"
	max_turf_amount = 60

// Severe impact
ABSTRACT_TYPE(/obj/effect/map_effect/randomized_destruction/severe)
	severity = list(
		"1" = 2, // Severe		10%
		"2" = 9, // Moderate	45%
		"3" = 9, // Mild		45%
	)

/obj/effect/map_effect/randomized_destruction/severe/low_range
	name = "randomized destruction, severe impact low range"
	icon_state = "rand_dest_severe_low"
	max_turf_amount = 20

/obj/effect/map_effect/randomized_destruction/severe/high_range
	name = "randomized destruction, severe impact high range"
	icon_state = "rand_dest_severe_high"
	max_turf_amount = 60
