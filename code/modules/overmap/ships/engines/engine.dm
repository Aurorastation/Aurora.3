//Engine component object

GLOBAL_LIST_INIT_TYPED(ship_engines, /datum/ship_engine, list())

/datum/ship_engine
	var/name = "ship engine"
	var/obj/machinery/holder	//actual engine object

/datum/ship_engine/New(var/obj/machinery/_holder)
	..()
	holder = _holder
	GLOB.ship_engines += src

/datum/ship_engine/proc/can_burn()
	return 0

//Tries to fire the engine with power modifier (0..1). Returns thrust.
//Power modifier is intended to be used for maneuvers or the like,
//that should use less/more fuel/electricity than an actual burn.
/datum/ship_engine/proc/burn(var/power_modifier = 1)
	return 0

//Returns status string for this engine
/datum/ship_engine/proc/get_status()
	return "All systems nominal"

/datum/ship_engine/proc/get_thrust()
	return 1

//Sets thrust limiter, a number between 0 and 1
/datum/ship_engine/proc/set_thrust_limit(var/new_limit)
	return 1

/datum/ship_engine/proc/get_thrust_limit()
	return 1

/datum/ship_engine/proc/is_on()
	return 1

/datum/ship_engine/proc/toggle()
	return 1

/datum/ship_engine/Destroy()
	GLOB.ship_engines -= src
	for(var/obj/effect/overmap/visitable/ship/S in SSshuttle.ships)
		S.engines -= src
	holder = null
	. = ..()
