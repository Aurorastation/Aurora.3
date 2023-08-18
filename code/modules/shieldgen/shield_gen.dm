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
	icon_state = "generator0"
	var/list/field
	density = TRUE
	var/strength
	var/charge
	var/modulation
	var/dissipation_rate = 0.030	//the percentage of the shield strength that needs to be replaced each second
	var/min_dissipation = 0.01		//will dissipate by at least this rate in renwicks per field tile (otherwise field would never dissipate completely as dissipation is a percentage)
	var/powered = FALSE
	var/check_powered = TRUE
	var/obj/machinery/shield_matrix/parent_matrix
	var/directional = FALSE
	use_power = POWER_USE_OFF	//doesn't use APC power

/obj/machinery/shield_gen/Initialize()
	for(var/obj/machinery/shield_matrix/possible_matrix in range(2, src))
		if(!directional || get_dir(possible_matrix, src) == switch_dir(dir))
			parent_matrix = possible_matrix
			break
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

		if(active)
			toggle()
		if(anchored)
			for(var/obj/machinery/shield_matrix/matrix in range(2, src))
				if(!directional || get_dir(matrix, src) == switch_dir(dir))
					parent_matrix = matrix
					LAZYADD(matrix.owned_projectors, src)
					break
		else
			if(owned_matrix && src in owned_matrix.owned_projectors)
				LAZYREMOVE(owned_matrix.owned_projectors, src)
			owned_matrix = null
	else
		..()

/obj/machinery/shield_gen/process()

	if(field.len)
		for(var/obj/effect/energy_field/E as anything in field)
			if(!E)
				field -= E
				continue
			var/amount_to_dissipate = -1 * max(E.strength * SHIELD_DISCHARGE_RATE, SHIELD_DISCHARGE_MINIMUM)

			E.Strengthen(amount_to_dissipate)

/obj/machinery/shield_gen/proc/generate_field(var/s_renwicks, var/c_renwicks, var/m_renwicks)
	var/list/covered_turfs = get_shielded_turfs()
	var/turf/T = get_turf(parent_matrix)
	for(var/turf/O as anything in covered_turfs - T)
		if(!(locate(/obj/effect/energy_field) in O))
			var/obj/effect/energy_field/E = new(O)
			E.parent_gen = src
			LAZYADD(field, E)
	covered_turfs = null

	strength = s_renwicks / LAZYLEN(field)
	charge = c_renwicks / LAZYLEN(field)
	modulation = m_renwicks / LAZYLEN(field)

	for(var/obj/effect/energy_field/E in field)
		E.Strengthen(charge)

	for(var/datum/shield_mode/M in parent_matrix.modulators)
		modulation -= M.renwicks
		if(modulation <= 0)
			LAZYREMOVE(parent_matrix.modulators, M)
	modulation = max(0, modulation)
	if(modulation)
		for(var/datum/shield_mode/M in parent_matrix.modulators)
			M.use_excess(modulation / LAZYLEN(parent_matrix.modulators))

/obj/machinery/shield_gen/update_icon()
	if(stat & BROKEN)
		icon_state = "broke"
	else
		if (LAZYLEN(field))
			icon_state = "generator1"
		else
			icon_state = "generator0"

/obj/machinery/shield_gen/proc/handle_shield_damage(var/damage, var/damage_flags, var/severity)
	var/mode

	if(GEN_MODULATED(src, MODEFLAG_MODULATE))
		mode = MODEFLAG_MODULATE
	else if((damage == DAMAGE_BURN) && GEN_MODULATED(src, MODEFLAG_PHOTONIC))
		mode = MODEFLAG_PHOTONIC
	else if((damage == DAMAGE_BRUTE) && GEN_MODULATED(src, MODEFLAG_HYPERKINETIC))
		mode = MODEFLAG_HYPERKINETIC

	if(!mode)
		return -1 //Sing that we do not have protections against this kind of damage

	var/datum/shield_mode/M = parent_matrix.get_modulator_by_flag(mode)
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

	if(multiz)
		var/turf/above = getzabove(mat_turf)
		var/turf/below = getzbelow(mat_turf)
		if(above)
			for(var/turf/z as anything in above)
				LAZYADD(connected_levels, z)
		if(below)
			for(var/turf/z as anything in below)
				LAZYADD(connected_levels, z)
	for(var/turf/z in connected_level)
		for (var/tt in RANGE_TURFS(parent_matrix.field_radius, z))
			T = tt
			// If we are directional, ignore turfs in the wrong direction
			if(directional && !(get_dir(T, parent_matrix) == dir))
				continue
			// Ignore station areas if on hull mode.
			if ((the_station_areas[T.loc] || is_shuttle_area(T.loc)) && GEN_MODULATED(src, MODEFLAG_HULL))
				continue
			else if (istype(T, /turf/space) || istype(T, /turf/unsimulated/floor/asteroid) || isopenturf(T) || istype(T, /turf/simulated/floor/reinforced))
				if(!GEN_MODULATED(src, MODEFLAG_HULL))
					LAZYADD(out, T)
					break

				for (var/uu in RANGE_TURFS(1, T))
					U = uu
					if (T == U)
						continue

					if (the_station_areas[U.loc] || istype(U, /turf/simulated/mineral/surface))
						LAZYADD(out, T)
						break
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
