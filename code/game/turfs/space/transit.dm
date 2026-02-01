/turf/space/transit
	plane = 0
	use_space_appearance = TRUE
	var/pushdirection
	baseturfs = /turf/space/transit

/turf/space/transit/Initialize()
	. = ..()
	RegisterSignal(src, COMSIG_TURF_RESERVATION_RELEASED, PROC_REF(launch_contents))

/turf/space/transit/Destroy()
	UnregisterSignal(src, COMSIG_TURF_RESERVATION_RELEASED)
	return ..()

/turf/space/transit/Exited(atom/movable/Obj, atom/newloc)
	. = ..()

	var/turf/location = Obj.loc
	if(istype(location, /turf/space) && !istype(location, src.type))
		dump_in_space(Obj)

/turf/space/transit/proc/launch_contents(datum/turf_reservation/reservation)
	SIGNAL_HANDLER

	for(var/atom/movable/movable in contents)
		dump_in_space(movable)

/proc/dump_in_space(atom/movable/dumpee)
	var/max = world.maxx - TRANSITIONEDGE
	var/min = 1 + TRANSITIONEDGE

	var/list/possible_transitions

	for(var/datum/space_level/level as anything in SSmapping.z_list)
		if(level.linkage == CROSSLINKED)
			LAZYADD(possible_transitions, level.z_value)

	if(!LAZYLEN(possible_transitions))
		possible_transitions = SSmapping.levels_by_trait(ZTRAIT_STATION) // throw them on the station or runtime

	dumpee.forceMove(locate(rand(min, max), rand(min, max), pick(possible_transitions)))

//Overwrite because we dont want people building rods in space.
/turf/space/transit/attackby(obj/item/attacking_item, mob/user)
	return FALSE

//generates a list used to randomize transit animations so they aren't in lockstep
/turf/space/transit/proc/get_cross_shift_list(size)
	var/list/result = list()

	result += rand(0, 14)
	for(var/i in 2 to size)
		var/shifts = list(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14)
		shifts -= result[i - 1] //consecutive shifts should not be equal
		if(i == size)
			shifts -= result[1] //because shift list is a ring buffer
		result += pick(shifts)

	return result

/turf/space/transit/north // moving to the north
	pushdirection = SOUTH  // south because the space tile is scrolling south
	var/static/list/phase_shift_by_x

/turf/space/transit/north/Initialize()
	. = ..()
	if(!phase_shift_by_x)
		phase_shift_by_x = get_cross_shift_list(15)

	var/x_shift = phase_shift_by_x[src.x % (phase_shift_by_x.len - 1) + 1]
	var/transit_state = (world.maxy - src.y + x_shift)%15 + 1

	icon_state = "speedspace_ns_[transit_state]"

/turf/space/transit/east // moving to the east
	pushdirection = WEST
	var/static/list/phase_shift_by_y

/turf/space/transit/east/New()
	..()
	if(!phase_shift_by_y)
		phase_shift_by_y = get_cross_shift_list(15)

	var/y_shift = phase_shift_by_y[src.y % (phase_shift_by_y.len - 1) + 1]
	var/transit_state = (world.maxx - src.x + y_shift)%15 + 1

	icon_state = "speedspace_ew_[transit_state]"

/turf/space/transit/bluespace //this is typically going to be used by shuttles/ships that aren't present in the sector, to imply they've had to bluespace jump some distance away.
	name = "bluespace"
	desc = "The blue beyond, a breach into an unknown dimension. Don't lick it."
	desc_extended = "Bluespace is a very strange form of pocket dimension, that is largely unpredictable and completely unexplored. While there is speculation about the possibility of celestial bodies existing in Bluespace, it is highly unlikely. Travelling in the Bluespace dimension without a proper gate or Bluespace drive has thus far been proven to be incredibly dangerous, with probes either appearing in unintended locations or never returning at all."
	icon_state = "bluespace-n"
	plane = 0
	use_space_appearance = FALSE
	use_starlight = FALSE
	baseturfs = /turf/space/transit/bluespace

/turf/space/transit/bluespace/ChangeTurf(path, list/new_baseturfs, flags, parent_datum)
	flags |= CHANGETURF_FORCE_LIGHTING
	return ..()

/turf/space/transit/bluespace/east
	icon_state = "bluespace-e"

/turf/space/transit/bluespace/south
	icon_state = "bluespace-s"

/turf/space/transit/bluespace/west
	icon_state = "bluespace-w"
