var/const/OVERMAP_SPEED_CONSTANT = (1 SECOND)
#define SHIP_MOVE_RESOLUTION 0.00001
#define MOVING(speed) abs(speed) >= min_speed
#define SANITIZE_SPEED(speed) SIGN(speed) * Clamp(abs(speed), 0, max_speed)
#define CHANGE_SPEED_BY(speed_var, v_diff) \
	v_diff = SANITIZE_SPEED(v_diff);\
	if(!MOVING(speed_var + v_diff)) \
		{speed_var = 0};\
	else \
		{speed_var = SANITIZE_SPEED((speed_var + v_diff)/(1 + speed_var*v_diff/(max_speed ** 2)))}
// Uses Lorentzian dynamics to avoid going too fast.

/obj/effect/overmap/visitable/ship
	name = "generic ship"
	desc = "Space faring vessel."
	icon = 'icons/obj/overmap/overmap_ships.dmi'
	icon_state = "generic"
	requires_contact = TRUE
	obfuscated_name = "unidentified vessel"
	sensor_range_override = FALSE
	hide_from_reports = TRUE
	generic_object = FALSE
	var/moving_state = "ship_moving"

	layer = OVERMAP_SHIP_LAYER

//RP fluff details to appear on scan readouts for mobile objects.
	var/propulsion = "Chemical Composite Gas Thrust" 	//Slower than light propulsion method. No variation in this currently exists yet except the Horizon which heats its gas.
	var/drive = "None equipped, FTL incapable" 			//Faster than light propulsion method, will usually be warp drives for third party ships and nothing for shuttles

	var/list/known_ships = list()		//List of ships known at roundstart - put types here.
	var/base_sensor_visibility

	vessel_mass = 10000             	//tonnes, arbitrary number, affects acceleration provided by engines
	var/vessel_size = SHIP_SIZE_LARGE	//arbitrary number, affects how likely are we to evade meteors
	var/max_speed = 1/(1 SECOND)        //"speed of light" for the ship, in turfs/tick.
	var/min_speed = 1/(2 MINUTES)       // Below this, we round speed to 0 to avoid math errors.

	var/list/speed = list(0,0)          //speed in x,y direction
	var/list/position = list(0,0)       // position within a tile.
	var/last_burn = 0                   // worldtime when ship last acceleated
	var/burn_delay = 1 SECOND           // how often ship can do burns
	var/fore_dir = NORTH                // what dir ship flies towards for purpose of moving stars effect procs
	var/last_combat_roll = 0
	var/last_turn = 0
	var/last_combat_turn = 0

	var/list/engines = list()
	var/engines_state = 0 //global on/off toggle for all engines
	var/thrust_limit = 1  //global thrust limit for all engines, 0..1
	var/halted = 0        //admin halt or other stop.

	comms_support = TRUE

	var/list/colors = list() //Pick a color from this list on init

/obj/effect/overmap/visitable/ship/Initialize()
	. = ..()
	glide_size = world.icon_size
	min_speed = round(min_speed, SHIP_MOVE_RESOLUTION)
	max_speed = round(max_speed, SHIP_MOVE_RESOLUTION)
	base_sensor_visibility = round((vessel_mass/SENSOR_COEFFICENT),1)
	SSshuttle.ships += src

	if(LAZYLEN(colors))
		color = pick(colors)

/obj/effect/overmap/visitable/ship/find_z_levels(var/fore_direction)
	. = ..(fore_dir)

/obj/effect/overmap/visitable/ship/Destroy()
	SSshuttle.ships -= src
	for(var/obj/machinery/computer/ship/S in SSmachinery.machinery)
		if(S.linked == src)
			S.linked = null
	for(var/obj/machinery/computer/shuttle_control/explore/C in SSmachinery.machinery)
		if(C.linked == src)
			C.linked = null

	. = ..()

/obj/effect/overmap/visitable/ship/relaymove(mob/user, direction, accel_limit)
	accelerate(direction, accel_limit)

/obj/effect/overmap/visitable/ship/proc/is_still()
	return !MOVING(speed[1]) && !MOVING(speed[2])

/obj/effect/overmap/visitable/ship/get_scan_data(mob/user)
	. = ..()
	if(!is_still())
		. += "<br>Heading: [dir2angle(get_heading())], speed [get_speed() * 1000]"
	if(instant_contact)
		. += "<br>It is broadcasting a distress signal."
	. += "<hr>"
	. += "<br><center><large><b>Scan Details</b></large>"
	. += "<br><large><b>[name]</b></large></center>"
	. += "<br><small><b>Estimated Mass:</b> [vessel_mass]"
	. += "<br><b>Projected Volume:</b> [volume]"
	. += "<br><b>STL Propulsion:</b> [propulsion]"
	. += "<br><b>FTL Drive:</b> [drive]</small>"
	. += "<hr>"
	. += "<br><center><b>Native Database Specifications</b>"
	. += "<br><img src = [scanimage]></center>"
	. += "<br><small><b>Manufacturer:</b> [designer]"
	. += "<br><b>Class Designation:</b> [sizeclass]"
	. += "<br><b>Designated Purpose:</b> [shiptype]"
	. += "<br><b>Weapons Estimation:</b> [weapons]</small>"
	. += "<hr>"
	. += "<br><center><b>Native Database Notes</b></center>"
	. += "<br><small>[desc]</small>"

/obj/effect/overmap/visitable/ship/get_tooltip_description()
	var/description = "<ul>"
	description += "<li><b>Manufacturer:</b> [designer]</li>"
	description += "<li><b>Class Designation:</b> [sizeclass]</li>"
	description += "<li><b>Designated Purpose:</b> [shiptype]</li>"
	description += "<li><b>Weapons Estimation:</b> [weapons]</li>"
	description += "</ul>"
	return description

//Projected acceleration based on information from engines
/obj/effect/overmap/visitable/ship/proc/get_acceleration()
	return round(get_total_thrust()/get_vessel_mass(), SHIP_MOVE_RESOLUTION)

//Does actual burn and returns the resulting acceleration
/obj/effect/overmap/visitable/ship/proc/get_burn_acceleration()
	return round(burn() / get_vessel_mass(), SHIP_MOVE_RESOLUTION)

/obj/effect/overmap/visitable/ship/proc/get_vessel_mass()
	. = vessel_mass
	for(var/obj/effect/overmap/visitable/ship/ship in src)
		. += ship.get_vessel_mass()

/obj/effect/overmap/visitable/ship/proc/get_speed()
	return round(sqrt(speed[1] ** 2 + speed[2] ** 2), SHIP_MOVE_RESOLUTION)

// returns a two-item list with the speed of the ship on x and y axes
/obj/effect/overmap/visitable/ship/proc/get_speed_xy()
	return list(round(speed[1], SHIP_MOVE_RESOLUTION), round(speed[2], SHIP_MOVE_RESOLUTION))

/obj/effect/overmap/visitable/ship/get_heading()
	var/res = 0
	if(MOVING(speed[1]))
		if(speed[1] > 0)
			res |= EAST
		else
			res |= WEST
	if(MOVING(speed[2]))
		if(speed[2] > 0)
			res |= NORTH
		else
			res |= SOUTH
	return res

/obj/effect/overmap/visitable/ship/proc/adjust_speed(n_x, n_y)
	CHANGE_SPEED_BY(speed[1], n_x)
	CHANGE_SPEED_BY(speed[2], n_y)
	for(var/zz in map_z)
		if(is_still())
			toggle_move_stars(zz)
		else
			toggle_move_stars(zz, fore_dir)
	update_icon()

/obj/effect/overmap/visitable/ship/proc/get_brake_path()
	if(!get_acceleration())
		return INFINITY
	if(is_still())
		return 0
	if(!burn_delay)
		return 0
	if(!get_speed())
		return 0
	var/num_burns = get_speed()/get_acceleration() + 2 //some padding in case acceleration drops form fuel usage
	var/burns_per_grid = 1/ (burn_delay * get_speed())
	return round(num_burns/burns_per_grid)

/obj/effect/overmap/visitable/ship/proc/decelerate()
	if(((speed[1]) || (speed[2])) && can_burn())
		if (speed[1])
			adjust_speed(-SIGN(speed[1]) * min(get_burn_acceleration(),abs(speed[1])), 0)
		if (speed[2])
			adjust_speed(0, -SIGN(speed[2]) * min(get_burn_acceleration(),abs(speed[2])))
		last_burn = world.time

/obj/effect/overmap/visitable/ship/proc/accelerate(direction, accel_limit)
	if(can_burn())
		last_burn = world.time
		var/acceleration = min(get_burn_acceleration(), accel_limit)
		if(direction & EAST)
			adjust_speed(acceleration, 0)
		if(direction & WEST)
			adjust_speed(-acceleration, 0)
		if(direction & NORTH)
			adjust_speed(0, acceleration)
		if(direction & SOUTH)
			adjust_speed(0, -acceleration)

/obj/effect/overmap/visitable/ship/process()
	..()
	if(!halted && !is_still())
		var/list/deltas = list(0,0)
		for(var/i = 1 to 2)
			if(MOVING(speed[i]))
				position[i] += speed[i] * OVERMAP_SPEED_CONSTANT
				if(position[i] < 0)
					deltas[i] = CEILING(position[i], 1)
				else if(position[i] > 0)
					deltas[i] = FLOOR(position[i])
				if(deltas[i] != 0)
					position[i] -= deltas[i]
					position[i] += (deltas[i] > 0) ? -1 : 1

		update_icon()
		var/turf/newloc = locate(x + deltas[1], y + deltas[2], z)
		if(newloc && loc != newloc)
			Move(newloc)
			handle_wraparound()
	sensor_visibility = min(round(base_sensor_visibility + get_speed_sensor_increase(), 1), 100)

/obj/effect/overmap/visitable/ship/update_icon()
	pixel_x = position[1] * (world.icon_size/2)
	pixel_y = position[2] * (world.icon_size/2)
	if(!is_still())
		icon_state = moving_state
	else
		icon_state = initial(icon_state)
	for(var/obj/machinery/computer/ship/machine in consoles)
		if(machine.z in map_z)
			for(var/datum/weakref/W in machine.viewers)
				var/mob/M = W.resolve()
				if(istype(M) && M.client)
					M.client.pixel_x = pixel_x
					M.client.pixel_y = pixel_y
	..()

/obj/effect/overmap/visitable/ship/proc/burn(var/power_modifier = 1)
	for(var/datum/ship_engine/E in engines)
		. += E.burn(power_modifier)

/obj/effect/overmap/visitable/ship/proc/get_total_thrust()
	for(var/datum/ship_engine/E in engines)
		. += E.get_thrust()

/obj/effect/overmap/visitable/ship/proc/can_burn()
	if(halted)
		return 0
	if (world.time < last_burn + burn_delay)
		return 0
	for(var/datum/ship_engine/E in engines)
		. |= E.can_burn()

//deciseconds to next step
/obj/effect/overmap/visitable/ship/proc/ETA()
	. = INFINITY
	for(var/i = 1 to 2)
		if(MOVING(speed[i]))
			. = min(., ((speed[i] > 0 ? 1 : -1) - position[i]) / speed[i])
	if(. == INFINITY)
		. = 0
	. = max(CEILING(., 1),0)

/obj/effect/overmap/visitable/ship/proc/halt()
	adjust_speed(-speed[1], -speed[2])
	halted = 1

/obj/effect/overmap/visitable/ship/proc/unhalt()
	if(!SSshuttle.overmap_halted)
		halted = 0

/obj/effect/overmap/visitable/ship/Bump(var/atom/A)
	if(istype(A,/turf/unsimulated/map/edge))
		handle_wraparound()
	..()

/obj/effect/overmap/visitable/ship/populate_sector_objects()
	..()
	for(var/obj/machinery/computer/ship/S in SSmachinery.machinery)
		S.attempt_hook_up(src)
	for(var/obj/machinery/computer/shuttle_control/explore/C in SSmachinery.machinery)
		C.attempt_hook_up(src)
	for(var/datum/ship_engine/E in ship_engines)
		if(check_ownership(E.holder))
			engines |= E

/obj/effect/overmap/visitable/ship/proc/get_landed_info()
	return "This ship cannot land."

/obj/effect/overmap/visitable/ship/proc/can_combat_roll()
	if(!can_burn())
		return FALSE
	var/cooldown = min(vessel_mass / 100, 100) SECONDS //max 100s for horizon, 50s for Intrepid
	if(world.time >= (last_combat_roll + cooldown))
		return TRUE
	return FALSE

/obj/effect/overmap/visitable/ship/proc/can_combat_turn()
	if(!can_burn())
		return FALSE
	var/cooldown = min(vessel_mass / 200, 20) SECONDS //max 20s for horizon
	if(world.time >= (last_combat_turn + cooldown))
		return TRUE
	return FALSE

/obj/effect/overmap/visitable/ship/proc/can_turn()
	if(!can_burn())
		return FALSE
	var/cooldown = min(vessel_mass / 10, 1) SECONDS //max 1s for horizon
	if(world.time >= (last_turn + cooldown))
		return TRUE
	return FALSE

/obj/effect/overmap/visitable/ship/proc/turn_ship(var/new_dir)
	burn(0.25)
	var/angle = new_dir == WEST ? 45 : -45
	dir = turn(dir, angle)
	update_icon()
	last_turn = world.time

/obj/effect/overmap/visitable/ship/proc/combat_turn(var/new_dir)
	burn(1.0)
	var/angle = -45
	if(new_dir == WEST)
		angle = 45
	var/direction = turn(dir, angle)
	accelerate(direction, 1000)
	if(direction & EAST)
		speed[1] = abs(speed[1])
	else if(direction & WEST)
		if(speed[1] > 0)
			speed[1] = -speed[1]
	else
		speed[1] = 0
	if(direction & NORTH)
		speed[2] = abs(speed[2])
	else if(direction & SOUTH)
		if(speed[2] > 0)
			speed[2] = -speed[2]
	else
		speed[2] = 0
		update_icon()
	dir = get_heading()
	for(var/mob/living/L in GLOB.living_mob_list)
		if(L.z in map_z)
			if(!gravity_generator?.on && !L.anchored)
				to_chat(L, SPAN_DANGER("The ship rapidly turns beneath you!"))
				if(!L.buckled_to)
					L.Weaken(3)
			else
				to_chat(L, SPAN_WARNING("The ship turns beneath you, but the artificial gravity keeps you on your feet."))
			shake_camera(L, 1 SECOND, 2)
			L.playsound_simple(soundin = 'sound/machines/thruster.ogg', volume = 50)
	last_combat_turn = world.time

/obj/effect/overmap/visitable/ship/proc/combat_roll(var/new_dir)
	burn()
	var/dir_to_move = turn(dir, new_dir == WEST ? 90 : -90)
	forceMove(get_step(src, dir_to_move))
	for(var/mob/living/L in GLOB.living_mob_list)
		if(L.z in map_z)
			if(!gravity_generator?.on && !L.anchored)
				to_chat(L, SPAN_DANGER("<font size=4>The ship rapidly inclines beneath you!</font>"))
				if(!L.buckled_to)
					var/turf/T = get_step_away(get_turf(L), get_step(L, new_dir), 10)
					L.throw_at(T, 10, 10)
			else
				to_chat(L, SPAN_WARNING("The ship inclines beneath you, but the artificial gravity keeps you on your feet."))
			shake_camera(L, 2 SECONDS, 10)
			sound_to(L, sound('sound/effects/combatroll.ogg'))
	last_combat_roll = world.time

/obj/effect/overmap/visitable/ship/signal_hit(var/list/hit_data)
	for(var/obj/machinery/computer/ship/targeting/TR in consoles)
		TR.visible_message(SPAN_NOTICE("[icon2html(src, viewers(get_turf(TR)))] Hit confirmed on [hit_data["target_name"]] in [hit_data["target_area"]] at coordinates [hit_data["coordinates"]]."), range = 2)

/obj/effect/overmap/visitable/ship/proc/get_speed_sensor_increase()
	return min(get_speed() * 1000, 50) //Engines should never increase sensor visibility by more than 50.

#undef MOVING
#undef SANITIZE_SPEED
#undef CHANGE_SPEED_BY
