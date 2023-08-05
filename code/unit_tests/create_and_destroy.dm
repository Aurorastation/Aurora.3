///Delete one of every type, sleep a while, then check to see if anything has gone fucky
/datum/unit_test/create_and_destroy
	name = "Create and Destroy Test"
	var/result = null

// var/datum/running_create_and_destroy = FALSE
/datum/unit_test/create_and_destroy/start_test()
	//We'll spawn everything here
	var/turf/spawn_at = locate()

	/*
	 * EXCLUSIONS FROM THE TEST
	 *
	 * This is to be used when there's no other possible way to make this test work, to exclude a specific path from being scrutinized
	 * by this unit test.
	 *
	 * Any and all additions should be heavily scrutinized, this test exists to try to catch issues and bypassing it, barring the
	 * most extenous circumstances, is NOT preferable, and should only be resorted to for when all the other options are exhausted.
	 */

	// Specific paths excluded
	var/list/ignore = list(
		//Never meant to be created, errors out the ass for mobcode reasons
		/mob/living/carbon,
		/atom/movable/typing_indicator,
		//Internal organs
		/obj/item/organ/external,
		// Requires an organ to init, so would not work here without snowflake code
		/obj/item/device/augment_implanter,
		// Wants to be put in hand on creation, so would not work here
		/obj/item/device/radiojammer/improvised,
		// Requires a path of some sort to init
		/obj/item/storage/bag/stockparts_box/telecomms,
		// Paint fails on init, probably not because of us, whoever wrote the chemistry of it have probably also eat the leaded one
		/obj/item/reagent_containers/glass/paint,
		// Probably not our fault too
		/obj/item/reagent_containers/pill/pouch_pill,
		// Cannot exist alone, as it's cut from a plant, and the update without a plant source fails
		/obj/item/seeds/cutting,

		/obj/item/reagent_crystal,

		/obj/machinery/portable_atmospherics/hydroponics/soil/invisible,

		// Requires an operating table
		/obj/machinery/computer/operating,

		// Requires to pick an output at init
		/obj/machinery/appliance/mixer/,

		// Requires an AI
		/obj/machinery/ai_powersupply,

		// Requires a player
		/obj/screen/new_player/selection/join_game,

		// Requires to make a sound based on client pref in the announcement
		/obj/effect/portal/revenant,

		// Wants a master
		/obj/effect/beam/i_beam,

		// Wants a master
		/obj/effect/dummy/chameleon,

		// Wants a parent
		/obj/effect/plastic_explosive,
		/obj/effect/temp_visual/incorporeal_mech,

		/obj/effect/liquid,

		// Generates EMP logs without a source
		/obj/effect/temporary_effect/pulse/pulsar,

		/obj/effect/mineral,

		/obj/structure/largecrate/animal,

		/obj/turbolift_map_holder,

		/atom/movable/afterimage,

		/mob/living/announcer,

		/mob/abstract/dview,

		/obj/structure/mech_wreckage/powerloader,

		// Sleeps in init
		/mob/living/carbon/human/terminator,

		// Mysterious failure in init, with gcdelete -1
		/mob/living/carbon/human/terminator,

		/obj/spellbutton,

		/obj/screen/click_catcher,
		/obj/screen/new_player/selection/polls,

	)

	// Paths and all the subpaths excluded

	//Needs a holodeck area linked to it which is not guarenteed to exist and technically is supposed to have a 1:1 relationship with computer anyway.
	ignore += typesof(/obj/machinery/computer/HolodeckControl)

	// Spells require an owner, which would not work here
	ignore += typesof(/obj/item/spell)

	// Groins fail for all subspecies
	ignore += typesof(/obj/item/organ/external/groin)

	ignore += typesof(/obj/item/organ/internal)

	// The grab objects, could never work here
	ignore += typesof(/obj/item/grab)

	// Robot modules, requires a robot
	ignore += typesof(/obj/item/robot_module)

	// Requires a shuttle
	ignore += typesof(/obj/machinery/computer/shuttle_control)

	// Requires a weapon attached
	ignore += typesof(/obj/machinery/ammunition_loader)

	// Requires others of its components at init
	ignore += typesof(/obj/machinery/gravity_generator/main/station)

	// Requires an owner's client
	ignore += typesof(/obj/screen/psi)

	// Requires material on creation
	ignore += typesof(/obj/effect/overlay/burnt_wall)

	ignore += typesof(/obj/random)

	// Map effects fuckery
	ignore += typesof(/obj/effect/map_effect)
	ignore += typesof(/obj/effect/shuttle_landmark)
	ignore += typesof(/obj/effect/overmap/visitable)
	ignore += typesof(/obj/effect/mazegen)
	ignore += typesof(/obj/effect/ghostspawpoint)


	ignore += typesof(/obj/turbolift_map_holder)
	ignore += typesof(/atom/movable/z_observer)
	ignore += typesof(/stat_rig_module)
	ignore += typesof(/mob/living/silicon)
	ignore += typesof(/obj/structure/ship_weapon_dummy)
	ignore += typesof(/turf/simulated/floor/beach/water)
	ignore += typesof(/mob/living/heavy_vehicle)
	ignore += typesof(/obj/singularity/narsie)
	ignore += typesof(/obj/screen/ability)

	// Requires something in icon update or runtimes
	ignore += typesof(/obj/item/gun/energy/gun/nuclear)

	// do_spread sleeps and tries to addtimer after the src is qdeleted
	ignore += typesof(/obj/effect/plant)

	/*
	 * END EXCLUSIONS OF THE TEST
	 */

	var/list/cached_contents = spawn_at.contents.Copy()
	var/original_turf_type = spawn_at.type
	var/original_baseturf = islist(spawn_at.baseturf) ? spawn_at.baseturf:Copy() : spawn_at.baseturf
	var/original_baseturf_count = length(original_baseturf)

	// /datum/running_create_and_destroy = TRUE
	for(var/type_path in typesof(/atom/movable, /turf) - ignore) //No areas please

		TEST_DEBUG("[name]: now creating and destroying: [type_path]")

		if(ispath(type_path, /turf))
			spawn_at.ChangeTurf(type_path)
			//We change it back to prevent baseturfs stacking and hitting the limit
			spawn_at.ChangeTurf(original_turf_type)
			if(original_baseturf_count != length(spawn_at.baseturf))
				TEST_FAIL("[type_path] changed the amount of baseturfs from [original_baseturf_count] to [length(spawn_at.baseturf)]; [english_list(original_baseturf)] to [islist(spawn_at.baseturf) ? english_list(spawn_at.baseturf) : spawn_at.baseturf]")
			// 	//Warn if it changes again
				original_baseturf = islist(spawn_at.baseturf) ? spawn_at.baseturf:Copy() : spawn_at.baseturf
				original_baseturf_count = length(original_baseturf)
		else
			var/atom/creation = new type_path(spawn_at)
			if(QDELETED(creation))
				continue
			//Go all in
			qdel(creation, force = TRUE)
			//This will hold a ref to the last thing we process unless we set it to null
			//Yes byond is fucking sinful
			creation = null

		//There's a lot of stuff that either spawns stuff in on create, or removes stuff on destroy. Let's cut it all out so things are easier to deal with
		var/list/to_del = spawn_at.contents - cached_contents
		if(length(to_del))
			for(var/atom/to_kill in to_del)
				qdel(to_kill)

	//Hell code, we're bound to have ended the round somehow so let's stop if from ending while we work
	SSticker.delay_end = TRUE
	//Clear it, just in case
	cached_contents.Cut()

	//Now that we've qdel'd everything, let's sleep until the gc has processed all the shit we care about
	var/time_needed = SSgarbage.collection_timeout
	var/start_time = world.time
	var/garbage_queue_processed = FALSE

	sleep(time_needed)
	while(!garbage_queue_processed)
		var/list/queue_to_check = SSgarbage.queue
		//How the hell did you manage to empty this? Good job!
		if(!length(queue_to_check))
			garbage_queue_processed = TRUE
			break

		//Pull out the time we deld at
		var/qdeld_at = SSgarbage.queue[queue_to_check[1]]
		//If we've found a packet that got del'd later then we finished, then all our shit has been processed
		if(qdeld_at > start_time)
			garbage_queue_processed = TRUE
			break

		if(world.time > start_time + time_needed + 30 MINUTES) //If this gets us gitbanned I'm going to laugh so hard
			result = TEST_FAIL("Something has gone horribly wrong, the garbage queue has been processing for well over 30 minutes. What the hell did you do")
			break

		//Immediately fire the gc right after
		SSgarbage.next_fire = 1
		//Unless you've seriously fucked up, queue processing shouldn't take "that" long. Let her run for a bit, see if anything's changed
		sleep(20 SECONDS)

	//Alright, time to see if anything messed up
	var/list/cache_for_sonic_speed = SSgarbage.didntgc
	for(var/path in typesof(/atom/movable, /turf) - ignore)
		var/times = cache_for_sonic_speed[path]
		if(times)
			result = TEST_FAIL("[path] hard deleted [times] times.")

	cache_for_sonic_speed = SSatoms.BadInitializeCalls
	for(var/path in cache_for_sonic_speed)
		var/fails = cache_for_sonic_speed[path]
		if(fails & BAD_INIT_NO_HINT)
			result = TEST_FAIL("[path] didn't return an Initialize hint")
		if(fails & BAD_INIT_QDEL_BEFORE)
			result = TEST_FAIL("[path] qdel'd in New()")
		if(fails & BAD_INIT_SLEPT)
			result = TEST_FAIL("[path] slept during Initialize()")

	SSticker.delay_end = FALSE
	//This shouldn't be needed, but let's be polite
	SSgarbage.collection_timeout = initial(SSgarbage.collection_timeout)

	return result ? result : TEST_PASS("All paths are created and destroyed successfully, without hard deletions or other unwanted behaviors")
