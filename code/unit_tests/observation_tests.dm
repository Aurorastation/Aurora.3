/proc/is_listening_to_movement(var/atom/movable/listening_to, var/mob/abstract/ghost/listener)
	if(!listener.orbiting)
		return FALSE

	var/list/procs = (listener.orbiting.tracker._signal_procs ||= list())
	var/list/target_procs = (procs[listening_to] ||= list())
	var/exists = target_procs[COMSIG_MOVABLE_MOVED]
	return exists

/datum/unit_test/observation
	name = "OBSERVATION template"
	groups = list("generic")

	async = 0

/datum/unit_test/observation/moved_observer_shall_register_on_follow
	name = "OBSERVATION: Moved - Observer Shall Register on Follow"
	groups = list("generic")

/datum/unit_test/observation/moved_observer_shall_register_on_follow/start_test()
	var/turf/T = locate(20,20,1)
	var/mob/living/carbon/human/H = new(T)
	var/mob/abstract/ghost/observer/O = new(T)

	O.ManualFollow(H)
	if(is_listening_to_movement(H, O))
		TEST_PASS("The observer is now following the mob.")
	else
		TEST_FAIL("The observer is not following the mob.")

	qdel(H)
	qdel(O)
	return 1

/datum/unit_test/observation/moved_observer_shall_unregister_on_nofollow
	name = "OBSERVATION: Moved - Observer Shall Unregister on NoFollow"
	groups = list("generic")

/datum/unit_test/observation/moved_observer_shall_unregister_on_nofollow/start_test()
	var/turf/T = locate(20,20,1)
	var/mob/living/carbon/human/H = new(T)
	var/mob/abstract/ghost/observer/O = new(T)

	O.ManualFollow(H)
	QDEL_NULL(O.orbiting)
	if(!is_listening_to_movement(H, O))
		TEST_PASS("The observer is no longer following the mob.")
	else
		TEST_FAIL("The observer is still following the mob.")

	qdel(H)
	qdel(O)
	return 1
