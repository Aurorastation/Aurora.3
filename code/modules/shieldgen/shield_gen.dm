//renwicks: fictional unit to describe shield strength
//a small meteor hit will deduct 1 renwick of strength from that shield tile
//light explosion range will do 1 renwick's damage
//medium explosion range will do 2 renwick's damage
//heavy explosion range will do 3 renwick's damage
//explosion damage is cumulative. if a tile is in range of light, medium and heavy damage, it will take a hit from all three

/obj/machinery/shield_gen
	name = "bubble shield projector"
	desc = "A machine capable of producing a force field in all directions when supplied with Force Renwicks."
	icon = 'icons/obj/machinery/shielding.dmi'
	icon_state = "generator"
	var/list/field
	density = TRUE
	var/strength = 0
	var/charge = 0
	var/modulation = 0
	var/shield_max = 0
	var/powered = FALSE
	var/check_powered = TRUE
	var/obj/machinery/shield_matrix/parent_matrix
	var/directional = FALSE
	use_power = POWER_USE_OFF	//doesn't use APC power

/obj/machinery/shield_gen/Initialize()
	for(var/obj/machinery/shield_matrix/possible_matrix in range(2, src))
		possible_matrix.update_shield_parts()
	LAZYINITLIST(field)
	. = ..()

/obj/machinery/shield_gen/Destroy()
	for(var/obj/effect/energy_field/D as anything in field)
		LAZYREMOVE(field, D)
		D.loc = null
	return ..()

/obj/machinery/shield_gen/attackby(obj/item/W, mob/user)
	if(W.ispen())
		return // TODO: Add labelling
	else if(W.iswrench())
		anchored = !anchored
		visible_message(SPAN_NOTICE("\The [src] has been [anchored ? "bolted to the floor":"unbolted from the floor"] by \the [user]."))

		if(anchored)
			for(var/obj/machinery/shield_matrix/matrix in range(2, src))
				matrix.update_shield_parts()
		else
			if(parent_matrix && (src in parent_matrix.owned_projectors))
				LAZYREMOVE(parent_matrix.owned_projectors, src)
			parent_matrix = null
	else
		..()

/obj/machinery/shield_gen/process()
	update_icon()
	if(!anchored)
		for(var/obj/effect/energy_field/E as anything in field)
			qdel(E)
		LAZYCLEARLIST(field)
		return
	if(field.len)
		for(var/obj/effect/energy_field/E as anything in field)
			if(!E)
				LAZYREMOVE(field, E)
				continue
			var/amount_to_dissipate = max(E.strength * SHIELD_DISCHARGE_RATE, SHIELD_DISCHARGE_MINIMUM)

			E.Stress(amount_to_dissipate)
			E.update_icon()

/obj/machinery/shield_gen/proc/generate_field(var/s_renwicks, var/c_renwicks, var/m_renwicks)
	if(!(s_renwicks || c_renwicks))
		return
	var/list/covered_turfs = get_shielded_turfs()
	var/turf/T = get_turf(parent_matrix)
	for(var/turf/O as anything in covered_turfs - T)
		var/obj/effect/energy_field/F = locate(/obj/effect/energy_field)
		if(!F in O))
			var/obj/effect/energy_field/E = new(O)
			E.parent_gen = src
			LAZYADD(field, E)
		else if(!(F.parent_gen == src) && (F.parent_gen.shield_max < shield_max)) //As shields can overlap in NE, SE, SW & NW, this means shields are always given to the strongest generator
			LAZYREMOVE(F.parent_gen.field, F)
			F.parent_gen = src
			LAZYADD(field, F)
	covered_turfs = null

	if(!field.len)
		return

	strength = min(s_renwicks / LAZYLEN(field), shield_max)
	charge = min(c_renwicks / LAZYLEN(field), shield_max)
	modulation = min(m_renwicks / LAZYLEN(field), shield_max)

	for(var/obj/effect/energy_field/E in field)
		E.Strengthen(charge / 10)

	for(var/datum/shield_mode/M in parent_matrix.modulators)
		modulation -= M.renwicks
		if(modulation <= 0)
			LAZYREMOVE(parent_matrix.modulators, M)
	modulation = max(0, modulation)
	if(modulation)
		var/list/greedy_modules = parent_matrix.get_greedy_modules()
		for(var/datum/shield_mode/M in greedy_modules)
			M.use_excess(modulation / LAZYLEN(greedy_modules))

/obj/machinery/shield_gen/update_icon()
	if (parent_matrix && parent_matrix.active)
		icon_state = "[initial(icon_state)]_on"
	else
		icon_state = initial(icon_state)

/obj/machinery/shield_gen/proc/handle_shield_damage(var/damage, var/damage_flags, var/severity)
	var/mode

	if(parent_matrix.has_modulator(MODEFLAG_MODULATE))
		mode = MODEFLAG_MODULATE
	else if((damage == DAMAGE_BURN) && parent_matrix.has_modulator(MODEFLAG_PHOTONIC))
		mode = MODEFLAG_PHOTONIC
	else if((damage == DAMAGE_BRUTE) && parent_matrix.has_modulator(MODEFLAG_HYPERKINETIC))
		mode = MODEFLAG_HYPERKINETIC

	var/datum/shield_mode/M = parent_matrix.get_modulator_by_flag(mode)

	if(!M)
		return -1 //Sing that we do not have protections against this kind of damage

	severity = M.adjust_damage(severity, damage, damage_flags)
	return severity

//grab the border tiles in a square around the parent matrix
/obj/machinery/shield_gen/proc/get_shielded_turfs()
	set background = 1
	var/list/out = list()

	var/turf/mat_turf = get_turf(parent_matrix)
	if (!mat_turf)
		return

	var/turf/U
	var/turf/T

	var/list/connected_levels = list()
	LAZYADD(connected_levels, mat_turf)

	if(parent_matrix.multi_z)
		var/turf/above = getzabove(mat_turf)
		var/turf/below = getzbelow(mat_turf)
		if(above)
			for(var/turf/z as anything in above)
				LAZYADD(connected_levels, z)
		if(below)
			for(var/turf/z as anything in below)
				LAZYADD(connected_levels, z)
	for(var/turf/z in connected_levels)
		for (var/tt in RANGE_TURFS(parent_matrix.field_radius, z))
			T = tt
			// If we are directional, ignore turfs in the wrong direction
			if(directional && !(get_cardinal_dir(parent_matrix, T) == dir))
				continue
			if(parent_matrix.has_modulator(MODEFLAG_HULL))
				// Ignore station areas if on hull mode.
				if ((the_station_areas[T.loc] || is_shuttle_area(T.loc)))
					continue
				if (istype(T, /turf/space) || istype(T, /turf/unsimulated/floor/asteroid) || isopenturf(T) || istype(T, /turf/simulated/floor/reinforced))
					for (var/uu in RANGE_TURFS(1, T))
						U = uu
						if (T == U)
							continue

						if (the_station_areas[U.loc] || istype(U, /turf/simulated/mineral/surface))
							LAZYADD(out, T)
							break
				continue
			if(get_dist(parent_matrix, T) == parent_matrix.field_radius)
				LAZYADD(out, T)
				continue

	return out

/obj/machinery/shield_gen/proc/getzabove(var/turf/location)
	var/connected = list()
	var/turf/above = GetAbove(location)

	if(above)
		connected += above
		var/connected_levels = getzabove(above)
		for(var/turf/z as anything in connected_levels)
			connected += z

	return connected

/obj/machinery/shield_gen/proc/getzbelow(var/turf/location)
	var/connected = list()
	var/turf/below = GetBelow(location)

	if(below)
		connected += below
		var/connected_levels = getzbelow(below)
		for(var/turf/z as anything in connected_levels)
			connected += z

	return connected
