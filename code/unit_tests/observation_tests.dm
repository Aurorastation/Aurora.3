/proc/is_listening_to_movement(var/atom/movable/listening_to, var/listener)
	return moved_event.is_listening(listening_to, listener)

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
	var/mob/abstract/observer/O = new(T)

	O.ManualFollow(H)
	if(is_listening_to_movement(H, O))
		TEST_PASS("The observer is now following the mob.")
	else
		TEST_FAIL("The observer is not following the mob.")

	QDEL_IN(H, 10 SECONDS)
	QDEL_IN(O, 10 SECONDS)
	return 1

/datum/unit_test/observation/moved_observer_shall_unregister_on_nofollow
	name = "OBSERVATION: Moved - Observer Shall Unregister on NoFollow"
	groups = list("generic")

/datum/unit_test/observation/moved_observer_shall_unregister_on_nofollow/start_test()
	var/turf/T = locate(20,20,1)
	var/mob/living/carbon/human/H = new(T)
	var/mob/abstract/observer/O = new(T)

	O.ManualFollow(H)
	O.stop_following()
	if(!is_listening_to_movement(H, O))
		TEST_PASS("The observer is no longer following the mob.")
	else
		TEST_FAIL("The observer is still following the mob.")

	QDEL_IN(H, 10 SECONDS)
	QDEL_IN(O, 10 SECONDS)
	return 1

/datum/unit_test/observation/moved_shall_registers_recursively_on_new_listener
	name = "OBSERVATION: Moved - Shall Register Recursively on New Listener"
	groups = list("generic")

/datum/unit_test/observation/moved_shall_registers_recursively_on_new_listener/start_test()
	var/turf/T = locate(20,20,1)
	var/mob/living/carbon/human/H = new(T)
	var/obj/structure/closet/C = new(T)
	var/mob/abstract/observer/O = new(T)

	H.forceMove(C)
	O.ManualFollow(H)
	var/listening_to_closet = is_listening_to_movement(C, H)
	var/listening_to_human = is_listening_to_movement(H, O)
	if(listening_to_closet && listening_to_human)
		TEST_PASS("Recursive moved registration succesful.")
	else
		TEST_FAIL("Recursive moved registration failed. Human listening to closet: [listening_to_closet] - Observer listening to human: [listening_to_human]")

	QDEL_IN(C, 10 SECONDS)
	QDEL_IN(H, 10 SECONDS)
	QDEL_IN(O, 10 SECONDS)
	return 1

/datum/unit_test/observation/moved_shall_registers_recursively_with_existing_listener
	name = "OBSERVATION: Moved - Shall Register Recursively with Existing Listener"
	groups = list("generic")

/datum/unit_test/observation/moved_shall_registers_recursively_with_existing_listener/start_test()
	var/turf/T = locate(20,20,1)
	var/mob/living/carbon/human/H = new(T)
	var/obj/structure/closet/C = new(T)
	var/mob/abstract/observer/O = new(T)

	O.ManualFollow(H)
	H.forceMove(C)
	var/listening_to_closet = is_listening_to_movement(C, H)
	var/listening_to_human = is_listening_to_movement(H, O)
	if(listening_to_closet && listening_to_human)
		TEST_PASS("Recursive moved registration succesful.")
	else
		TEST_FAIL("Recursive moved registration failed. Human listening to closet: [listening_to_closet] - Observer listening to human: [listening_to_human]")

	QDEL_IN(C, 10 SECONDS)
	QDEL_IN(H, 10 SECONDS)
	QDEL_IN(O, 10 SECONDS)

	return 1
