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

/obj/effect/map_effect/door_helper/unres
	icon_state = "unres_door"

/obj/effect/map_effect/door_helper/unres/modify_door(obj/machinery/door/D)
	D.unres_dir ^= dir

/obj/effect/map_effect/door_helper/level_access
	icon_state = "level_door"

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
