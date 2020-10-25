/obj/item/device/multitool/hacktool
	var/is_hacking = 0

	var/in_hack_mode = 0
	var/list/current_hacks
	var/list/known_targets
	var/list/supported_types
	var/datum/topic_state/default/must_hack/hack_state

	var/hack_time = 10 SECONDS
	var/max_known_targets = 7
	var/silent = FALSE
	var/multihack = FALSE
	var/allow_movement = FALSE

/obj/item/device/multitool/hacktool/New()
	..()
	known_targets = list()
	current_hacks = list()
	supported_types = list(/obj/machinery/door/airlock)
	hack_state = new(src)

/obj/item/device/multitool/hacktool/Destroy()
	for(var/T in known_targets)
		var/atom/target = T
		destroyed_event.unregister(target, src)
	known_targets.Cut()
	qdel(hack_state)
	hack_state = null
	return ..()

/obj/item/device/multitool/hacktool/attackby(var/obj/item/W, var/mob/user)
	if(W.isscrewdriver())
		in_hack_mode = !in_hack_mode
		playsound(src.loc, 'sound/items/screwdriver.ogg', 50, TRUE)
	else
		..()

/obj/item/device/multitool/hacktool/resolve_attackby(atom/A, mob/user)
	sanity_check()

	if(!in_hack_mode || istype(A, /obj/item/storage))
		return ..()

	if(!attempt_hack(user, A))
		return FALSE

	if(A.Adjacent(user))
		A.ui_interact(user)
	return TRUE

/obj/item/device/multitool/hacktool/proc/attempt_hack(var/mob/user, var/atom/target)
	if(is_hacking && !multihack)
		to_chat(user, SPAN_WARNING("You are already hacking!"))
		return FALSE
	if(target in current_hacks)
		to_chat(user, SPAN_WARNING("You are already hacking this door!"))
		return FALSE
	if(!is_type_in_list(target, supported_types))
		to_chat(user, "[icon2html(src, user)] <span class='warning'>Unable to hack this target!</span>")
		return FALSE
	if(istype(target, /obj/machinery/door/airlock))
		var/obj/machinery/door/airlock/door = target
		if(door.hackProof)
			to_chat(user, SPAN_WARNING("Hacking [target] is beyond the capabilities of this device!"))
			return FALSE
	var/found = known_targets.Find(target)
	if(found)
		known_targets.Swap(1, found)	// Move the last hacked item first
		return TRUE

	to_chat(user, SPAN_NOTICE("You begin hacking \the [target]..."))
	is_hacking = TRUE
	current_hacks += target

	// On average hackin takes ~10 seconds. Fairly small random span to avoid people simply aborting and trying again
	var/hack_result = do_after(user, hack_time + rand(-3 SECONDS, 3 SECONDS), use_user_turf = (allow_movement ? -1 : FALSE))
	is_hacking = FALSE
	current_hacks -= target

	if(hack_result && in_hack_mode)
		to_chat(user, SPAN_NOTICE("Your hacking attempt was successful!"))
		if(!silent)
			playsound(src.loc, 'sound/piano/A#6.ogg', 75)
	else
		to_chat(user, SPAN_WARNING("Your hacking attempt failed!"))
		return FALSE

	known_targets.Insert(1, target)	// Insert the newly hacked target first,
	destroyed_event.register(target, src, /obj/item/device/multitool/hacktool/proc/on_target_destroy)
	return TRUE

/obj/item/device/multitool/hacktool/proc/sanity_check()
	if(max_known_targets < 1)
		max_known_targets = 1
	// Cut away the oldest items if the capacity has been reached
	if(known_targets.len > max_known_targets)
		for(var/i = (max_known_targets + 1) to known_targets.len)
			var/atom/A = known_targets[i]
			destroyed_event.unregister(A, src)
		known_targets.Cut(max_known_targets + 1)

/obj/item/device/multitool/hacktool/proc/on_target_destroy(var/target)
	known_targets -= target

/obj/item/device/multitool/hacktool/rig //For ninjas; Credits to BurgerBB
	hack_time = 5 SECONDS
	max_known_targets = 10
	in_hack_mode = TRUE
	silent = TRUE
	multihack = TRUE
	allow_movement = TRUE
	reach = 8
	var/mob/living/creator

/obj/item/device/multitool/hacktool/rig/Initialize()
	. = ..()
	START_PROCESSING(SSprocessing, src)

/obj/item/device/multitool/hacktool/rig/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	return ..()

/obj/item/device/multitool/hacktool/rig/process()
	if(!creator || loc != creator || (creator.l_hand != src && creator.r_hand != src))
		// Tidy up a bit.
		if(istype(loc,/mob/living))
			var/mob/living/carbon/human/host = loc
			if(istype(host))
				for(var/obj/item/organ/external/organ in host.organs)
					for(var/obj/item/O in organ.implants)
						if(O == src)
							organ.implants -= src
			host.pinned -= src
			host.embedded -= src
			host.drop_from_inventory(src)
		QDEL_IN(src, 1)

/datum/topic_state/default/must_hack
	var/obj/item/device/multitool/hacktool/hacktool

/datum/topic_state/default/must_hack/New(var/hacktool)
	src.hacktool = hacktool
	..()

/datum/topic_state/default/must_hack/Destroy()
	hacktool = null
	return ..()

/datum/topic_state/default/must_hack/can_use_topic(var/src_object, var/mob/user)
	if(!hacktool || !hacktool.in_hack_mode || !(src_object in hacktool.known_targets))
		return STATUS_CLOSE
	return ..()
