/turf/space/transit
	plane = 0
	use_space_appearance = TRUE
	use_starlight = TRUE
	var/pushdirection

//Overwrite because we dont want people building rods in space.
/turf/space/transit/attackby(obj/O, mob/user)
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
	desc_info = "Bluespace is a very strange form of pocket dimension, that is largely unpredictable and completely unexplored. While there is speculation about the possibility of celestial bodies existing in Bluespace, it is highly unlikely. Travelling in the Bluespace dimension without a proper gate or Bluespace drive has thus far been proven to be incredibly dangerous, with probes either appearing in unintended locations or never returning at all."
	icon_state = "bluespace-n"
	plane = 0
	use_space_appearance = FALSE
	use_starlight = FALSE

/turf/space/transit/bluespace/ChangeTurf(var/turf/N, var/tell_universe=1, var/force_lighting_update = 0, var/allow = 0, var/keep_air = FALSE)
	return ..(N, tell_universe, 1, allow, keep_air)

/turf/space/transit/bluespace/east
	icon_state = "bluespace-e"

/turf/space/transit/bluespace/south
	icon_state = "bluespace-s"

/turf/space/transit/bluespace/west
	icon_state = "bluespace-w"