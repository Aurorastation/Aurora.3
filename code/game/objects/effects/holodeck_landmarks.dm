ABSTRACT_TYPE(/obj/effect/landmark/holodeck)
	name = "holodeck landmark"

	/// The computer our landmark is linked to
	var/obj/machinery/computer/holodeck_control/console

/obj/effect/landmark/holodeck/Destroy()
	console = null
	return ..()

/// Sets up the landmark to work with the provided console
/obj/effect/landmark/holodeck/proc/initialize_holodeck_landmark(var/obj/machinery/computer/holodeck_control/set_console)
	console = set_console
	console.holodeck_landmarks += src

/// Gets called by the console configured above every machine tick as long as the console as active
/obj/effect/landmark/holodeck/proc/handle_process(seconds_per_tick)
	return


/obj/effect/landmark/holodeck/atmos_test
	name = "atmospheric test start"

/obj/effect/landmark/holodeck/atmos_test/initialize_holodeck_landmark(var/obj/machinery/computer/holodeck_control/set_console)
	. = ..()

	var/turf/turf = get_turf(src)
	spark(turf, 2, GLOB.alldirs)
	if(turf)
		turf.temperature = 5000
		turf.hotspot_expose(50000,50000,1)


/obj/effect/landmark/holodeck/holocarp_spawn
	name = "holocarp spawn"

/obj/effect/landmark/holodeck/holocarp_spawn/initialize_holodeck_landmark(var/obj/machinery/computer/holodeck_control/set_console)
	. = ..()

	console.holographic_mobs += new /mob/living/simple_animal/hostile/carp/holodeck(loc)


/obj/effect/landmark/holodeck/holocarp_spawn_random
	name = "holocarp spawn random"

/obj/effect/landmark/holodeck/holocarp_spawn_random/initialize_holodeck_landmark(var/obj/machinery/computer/holodeck_control/set_console)
	. = ..()

	if(prob(4)) // With 4 spawn points, carp should only appear 15% of the time.
		console.holographic_mobs += new /mob/living/simple_animal/hostile/carp/holodeck(loc)


/obj/effect/landmark/holodeck/holocarp_spawn_pain
	name = "holocarp spawn pain"
	var/mob/pain_carp

/obj/effect/landmark/holodeck/holocarp_spawn_pain/Destroy()
	QDEL_NULL(pain_carp)
	return ..()

/// Handles spawning in space carp on initialize and process
/obj/effect/landmark/holodeck/holocarp_spawn_pain/proc/spawn_pain_carp()
	pain_carp = new /mob/living/simple_animal/hostile/carp/holodeck/pain(loc)
	console.holographic_mobs += pain_carp

/obj/effect/landmark/holodeck/holocarp_spawn_pain/initialize_holodeck_landmark(var/obj/machinery/computer/holodeck_control/set_console)
	. = ..()

	spawn_pain_carp()

/obj/effect/landmark/holodeck/holocarp_spawn_pain/handle_process(seconds_per_tick)
	. = ..()

	if(QDELETED(pain_carp))
		spawn_pain_carp()


/obj/effect/landmark/holodeck/penguin_spawn_random
	name = "penguin spawn random"

/obj/effect/landmark/holodeck/penguin_spawn_random/initialize_holodeck_landmark(var/obj/machinery/computer/holodeck_control/set_console)
	. = ..()

	if(prob(50))
		console.holographic_mobs += new /mob/living/simple_animal/penguin/holodeck(loc)
	else
		console.holographic_mobs += new /mob/living/simple_animal/penguin/holodeck/baby(loc)


/obj/effect/landmark/holodeck/penguin_spawn_emperor
	name = "penguin spawn emperor"

/obj/effect/landmark/holodeck/penguin_spawn_emperor/initialize_holodeck_landmark(var/obj/machinery/computer/holodeck_control/set_console)
	. = ..()

	console.holographic_mobs += new /mob/living/simple_animal/penguin/holodeck/emperor(loc)


/obj/effect/landmark/holodeck/animal_baby_random
	name = "animal baby random"

/obj/effect/landmark/holodeck/animal_baby_random/initialize_holodeck_landmark(var/obj/machinery/computer/holodeck_control/set_console)
	. = ..()

	if(prob(50))
		console.holographic_mobs += new /mob/living/simple_animal/corgi/puppy/holodeck(loc)
	else
		console.holographic_mobs += new /mob/living/simple_animal/cat/kitten/holodeck(loc)
