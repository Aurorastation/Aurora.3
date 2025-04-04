
// --------------------------

/// Door helper base/parent type.
/obj/effect/map_effect/door_helper
	layer = CLOSED_DOOR_LAYER + 0.01

/obj/effect/map_effect/door_helper/Initialize(mapload, ...)
	..()
	for(var/obj/machinery/door/D in loc)
		if(istype(D, /obj/machinery/door/blast) || istype(D, /obj/machinery/door/firedoor))
			continue
		modify_door(D)
	return INITIALIZE_HINT_QDEL

/obj/effect/map_effect/door_helper/proc/modify_door(obj/machinery/door/D)
	return

// --------------------------

/// Directional access unrestriction.
/// Removes access requirement on the door it is placed on top of, in the helper's direction.
/// Example use: entering a room or department requires an ID access, but leaving it is always possible without any ID.
/obj/effect/map_effect/door_helper/unres
	icon_state = "door_helper_unres_door"

/obj/effect/map_effect/door_helper/unres/modify_door(obj/machinery/door/D)
	D.unres_dir ^= dir

// --------------------------

/// Ship alert level dependent access.
/obj/effect/map_effect/door_helper/level_access
	icon_state = "door_helper_level_door"

	/// Sets access_by_level (access override based on security level) on the airlock this is spawned on.
	/// For more information check the access_by_level variable on the airlock.
	/// Example of an appropriate way to set this: list("red" = list(1, 2))
	/// Alternatively, for a door that is free access on a certain code: list("green" = null)
	var/list/access_by_level
	/// As above, but with req_one_access. Note that only one of these lists should ever be set.
	var/list/req_one_access_by_level

/obj/effect/map_effect/door_helper/level_access/modify_door(obj/machinery/door/D)
	if(length(access_by_level) && length(req_one_access_by_level))
		crash_with("Airlock access level modifier at [x] [y] [z] spawned with both access lists set.")
	if(isairlock(D))
		var/obj/machinery/door/airlock/A = D
		A.access_by_level = access_by_level
		A.req_one_access_by_level = req_one_access_by_level

/obj/effect/map_effect/door_helper/level_access/test1
	access_by_level = list("green" = list(ACCESS_SECURITY))

/obj/effect/map_effect/door_helper/level_access/test2
	req_one_access_by_level = list("green" = list(ACCESS_SECURITY, ACCESS_HEADS))

/obj/effect/map_effect/door_helper/level_access/command_foyer
	access_by_level = list(
	"green",
	"yellow" = list(19,38,72),
	"blue" = list(19,38,72),
	"red" = list(19,38,72),
	"delta" = list(19,38,72)
)

/obj/effect/map_effect/door_helper/level_access/command_stairwell
	access_by_level = list(
	"green" = list(19,28,38),
	"blue" = list(19,38),
	"red" = list(19,38),
	"delta" = list(19,38)
)

// --------------------------

/// Locks/bolts any (lockable) door/airlock this marker is placed on.
/obj/effect/map_effect/door_helper/lock
	icon_state = "door_helper_locked"

/obj/effect/map_effect/door_helper/lock/modify_door(obj/machinery/door/D)
	. = ..()
	if(isairlock(D))
		var/obj/machinery/door/airlock/A = D
		A.locked = TRUE
		A.set_airlock_overlays(AIRLOCK_CLOSED)

// --------------------------

/// Adds access requirements to the door this helper is placed on.
/// Adds, not replaces. So multiple access req helpers can be placed on a door.
/obj/effect/map_effect/door_helper/access_req
	icon_state = "door_helper_access_req"

/obj/effect/map_effect/door_helper/access_req/modify_door(obj/machinery/door/door)
	. = ..()
	if(isairlock(door) || istype(door, /obj/machinery/door/window))
		if(!door.req_access && req_access)
			door.req_access = list()
		door.req_access += req_access
		if(!door.req_one_access && req_one_access)
			door.req_one_access = list()
		door.req_one_access += req_one_access
