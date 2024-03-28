//Beam Datum and effect
/datum/beam
	var/atom/origin = null
	var/atom/target = null
	var/list/elements = list()
	var/icon/base_icon = null
	var/icon
	var/icon_state = "" //icon state of the main segments of the beam
	var/max_distance = 0
	var/curr_distance = 0
	var/sleep_time = 3
	var/finished = 0
	var/turf/target_oldloc = null
	var/turf/origin_oldloc = null
	var/beam_type = /obj/effect/ebeam //must be subtype
	var/timing_id = null
	var/recalculating = FALSE

/datum/beam/New(beam_origin,beam_target,beam_icon='icons/effects/beam.dmi',beam_icon_state="b_beam",time=50,maxdistance=10,btype = /obj/effect/ebeam,beam_sleep_time=3)
	origin = beam_origin
	target = beam_target
	var/turf/origin_turf = get_turf(origin)
	var/turf/target_turf = get_turf(target)
	max_distance = maxdistance
	curr_distance = get_dist(origin_turf, target_turf)

	if((curr_distance == -1 && origin_turf != target_turf) || curr_distance >= max_distance || origin_turf.z != target_turf.z)
		qdel(src)
		return

	sleep_time = beam_sleep_time
	base_icon = new(beam_icon,beam_icon_state)
	icon = beam_icon
	icon_state = beam_icon_state
	beam_type = btype
	if(time != -1)
		addtimer(CALLBACK(src, PROC_REF(End), time))

/datum/beam/proc/Start()
	recalculate()
	recalculate_in(sleep_time)

/datum/beam/proc/recalculate()
	if(recalculating)
		recalculate_in(sleep_time)
		return
	recalculating = TRUE
	timing_id = null
	var/turf/origin_turf = get_turf(origin)
	var/turf/target_turf = get_turf(target)
	if(!istype(origin_turf) || !istype(target_turf) || QDELETED(origin) || QDELETED(target))
		End()
		return
	curr_distance = get_dist(origin_turf, target_turf)
	if(!(curr_distance == -1 && origin_turf != target_turf) && curr_distance < max_distance && origin_turf.z == target_turf.z)
		if((origin_turf != origin_oldloc || target_turf != target_oldloc))
			origin_oldloc = origin_turf //so we don't keep checking against their initial positions, leading to endless Reset()+Draw() calls
			target_oldloc = target_turf
			Reset()
			Draw()
		after_calculate()
		recalculating = FALSE
	else
		End()

/datum/beam/proc/afterDraw()
	return

/datum/beam/proc/recalculate_in(time)
	timing_id = addtimer(CALLBACK(src, PROC_REF(recalculate)), time, TIMER_STOPPABLE | TIMER_UNIQUE | TIMER_NO_HASH_WAIT | TIMER_OVERRIDE)

/datum/beam/proc/after_calculate()
	if((sleep_time == null) || finished)	//Does not automatically recalculate.
		return
	timing_id = addtimer(CALLBACK(src, PROC_REF(recalculate)), sleep_time, TIMER_STOPPABLE | TIMER_UNIQUE | TIMER_NO_HASH_WAIT)

/datum/beam/proc/End(destroy_self = TRUE)
	finished = TRUE
	if(timing_id)
		deltimer(timing_id)
	if(!QDELING(src) && destroy_self)
		qdel(src)

/datum/beam/proc/Reset()
	for(var/obj/effect/ebeam/B in elements)
		qdel(B)
	elements.Cut()

/datum/beam/Destroy()
	if(timing_id)
		deltimer(timing_id)
	Reset()
	target = null
	origin = null
	return ..()

/datum/beam/proc/Draw()
	var/Angle = round(Get_Angle(origin.z ? origin : get_turf(origin), target.z ? target : get_turf(target)))
	var/matrix/rot_matrix = matrix()
	rot_matrix.Turn(Angle)

	//Translation vector for origin and target
	var/DX = get_x_translation_vector()
	var/DY = get_y_translation_vector()
	var/N = 0
	var/length = round(sqrt((DX)**2+(DY)**2)) //hypotenuse of the triangle formed by target and origin's displacement

	for(N in 0 to length-1 step world.icon_size)//-1 as we want < not <=, but we want the speed of X in Y to Z and step X
		var/obj/effect/ebeam/segment = new beam_type(origin_oldloc)
		segment.owner = src
		elements += segment

		//Assign icon, for main segments it's base_icon, for the end, it's icon+icon_state
		//cropped by a transparent box of length-N pixel size
		if(N + world.icon_size > length)
			var/icon/II = new(icon, icon_state)
			II.DrawBox(null, 1, (length-N), world.icon_size, world.icon_size)
			segment.icon = II
		else
			segment.icon = base_icon
		segment.transform = rot_matrix

		//Calculate pixel offsets (If necessary)
		var/x_offset = round(sin(Angle) * (N + world.icon_size/2))
		var/y_offset = round(cos(Angle) * (N + world.icon_size/2))
		//Position the effect so the beam is one continuous line
		segment.x += SIMPLE_SIGN(x_offset) * FLOOR(abs(x_offset)/world.icon_size, 1)
		x_offset %= world.icon_size

		segment.y += SIMPLE_SIGN(y_offset) * FLOOR(abs(y_offset)/world.icon_size, 1)
		y_offset %= world.icon_size

		segment.pixel_x = x_offset
		segment.pixel_y = y_offset
		CHECK_TICK
	afterDraw()

/datum/beam/proc/get_x_translation_vector()
	return (world.icon_size*target.x+target.pixel_x)-(world.icon_size*origin.x+origin.pixel_x)

/datum/beam/proc/get_y_translation_vector()
	return (world.icon_size*target.y+target.pixel_y)-(world.icon_size*origin.y+origin.pixel_y)

/datum/beam/exploration
	var/obj/item/tethering_device/owner

/datum/beam/exploration/End()
	owner.active_beams -= target
	owner.untether(target, FALSE)
	return ..()

/datum/beam/exploration/get_x_translation_vector()
	return (world.icon_size * target_oldloc.x) - (world.icon_size * origin_oldloc.x)

/datum/beam/exploration/get_y_translation_vector()
	return (world.icon_size * target_oldloc.y) - (world.icon_size * origin_oldloc.y)

/datum/beam/exploration/afterDraw()
	var/distance = curr_distance / max_distance
	var/set_color = COLOR_GREEN
	if(distance >= 0.8)
		set_color = COLOR_MAROON
	else if(distance >= 0.3)
		set_color = COLOR_BLUE
	else
		set_color = COLOR_GREEN
	var/beam_index = 1
	var/elements_length = length(elements)
	var/half_elements = elements_length / 2
	for(var/beam in elements)
		var/obj/effect/ebeam/B = beam
		B.color = set_color
		if(beam_index > half_elements)
			B.alpha = clamp(255 - (40 * (elements_length - beam_index)), 0, 255)
		else
			B.alpha = clamp(255 - (40 * (beam_index - 1)), 0, 255)
		beam_index++

/datum/beam/power
	var/obj/item/computer_hardware/tesla_link/charging_cable/owner

/datum/beam/power/End()
	owner.beam = null
	if(owner.source)
		owner.untether(FALSE)
	return ..()

/datum/beam/power/get_x_translation_vector()
	return (world.icon_size * target_oldloc.x + target.pixel_x) - (world.icon_size * origin_oldloc.x + origin.pixel_x)

/datum/beam/power/get_y_translation_vector()
	return (world.icon_size * target_oldloc.y + target.pixel_y) - (world.icon_size * origin_oldloc.y + origin.pixel_y)

/datum/beam/power/afterDraw()
	for(var/beam in elements)
		var/obj/effect/ebeam/B = beam
		B.color = COLOR_GRAY40

// this simplified datum will work with timed beams that are held
/datum/beam/held/get_x_translation_vector()
	return (world.icon_size * target_oldloc.x) - (world.icon_size * origin_oldloc.x)

/datum/beam/held/get_y_translation_vector()
	return (world.icon_size * target_oldloc.y) - (world.icon_size * origin_oldloc.y)

/obj/effect/ebeam
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	anchored = 1
	layer = BEAM_PROJECTILE_LAYER
	blend_mode = BLEND_ADD
	var/datum/beam/owner

/obj/effect/ebeam/tesla_act()
	return

/obj/effect/ebeam/Destroy()
	owner = null
	return ..()

/atom/proc/Beam(atom/BeamTarget,icon_state="b_beam",icon='icons/effects/beam.dmi',time=50, maxdistance=10,beam_type=/obj/effect/ebeam,beam_sleep_time = 3, beam_datum_type=/datum/beam)
	if(time >= INFINITY)
		crash_with("Tried to create beam with infinite time!")
		return null
	var/datum/beam/newbeam = new beam_datum_type(src,BeamTarget,icon,icon_state,time,maxdistance,beam_type,beam_sleep_time)
	INVOKE_ASYNC(newbeam, TYPE_PROC_REF(/datum/beam, Start))
	return newbeam
