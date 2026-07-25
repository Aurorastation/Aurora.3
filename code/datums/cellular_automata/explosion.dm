/**
 * A directional cellular-automata blast wave, adapted from CMSS13.
 *
 * Each cell damages one turf, loses power to that turf and its contents, then
 * branches forward. Waves meeting on a turf merge, while an obstruction which
 * survives the blast reflects a weakened wave.
 */
/datum/automata_cell/explosion
	var/power = 0
	var/initial_power = 0
	var/power_falloff = 1
	var/reflection_power_multiplier = 0.4
	var/direction
	var/delay = 0
	var/should_merge = TRUE
	var/list/exploded_atoms = list()
	var/mob/source_mob
	var/source_name = "an explosion"
	var/obj/effect/cellular_explosion_wave/wave_visual

/datum/automata_cell/explosion/birth()
	RegisterSignal(in_turf, COMSIG_ATOM_ENTERED, PROC_REF(on_turf_entered))
	wave_visual = SScellular_automata.acquire_wave_visual(in_turf)

/datum/automata_cell/explosion/death()
	if(in_turf)
		UnregisterSignal(in_turf, COMSIG_ATOM_ENTERED)
	if(wave_visual)
		SScellular_automata.release_wave_visual(wave_visual)
		wave_visual = null

/datum/automata_cell/explosion/proc/update_wave_visual()
	if(wave_visual)
		animate(wave_visual, alpha = clamp(round(power), 50, 180), time = 0, flags = ANIMATION_END_NOW)

/datum/automata_cell/explosion/proc/get_severity()
	if(power >= 200)
		return 1
	if(power >= 100)
		return 2
	return 3

/datum/automata_cell/explosion/proc/on_turf_entered(turf/source, atom/movable/arrived)
	SIGNAL_HANDLER
	if(QDELETED(arrived) || (arrived in exploded_atoms))
		return
	exploded_atoms += arrived
	arrived.ex_act(get_severity())
	log_explosion_hit(arrived)
	if(!QDELETED(arrived))
		arrived.explosion_throw(power, null)

/datum/automata_cell/explosion/merge(datum/automata_cell/explosion/other)
	if(!should_merge)
		return TRUE

	var/keep_existing = power < other.power
	var/datum/automata_cell/explosion/survivor = keep_existing ? other : src
	var/datum/automata_cell/explosion/dying = keep_existing ? src : other

	if(isnull(dying.direction))
		survivor.power += dying.power
	else if(isnull(survivor.direction))
		survivor.power -= dying.power
	else if(survivor.direction == dying.direction)
		survivor.power += dying.power
	else if(survivor.direction == REVERSE_DIR(dying.direction))
		survivor.power -= dying.power

	return keep_existing

/datum/automata_cell/explosion/proc/get_propagation_dirs(reflected)
	if(isnull(direction))
		return GLOB.alldirs

	var/travel_direction = reflected ? REVERSE_DIR(direction) : direction
	if(travel_direction in GLOB.cardinals)
		return list(travel_direction, turn(travel_direction, 45), turn(travel_direction, -45))
	return list(travel_direction)

/datum/automata_cell/explosion/proc/merge_on_turf()
	for(var/datum/automata_cell/explosion/other as anything in in_turf.autocells)
		if(other == src)
			continue
		if(merge(other))
			qdel(src)
		else
			qdel(other)
		return TRUE
	return FALSE

/datum/automata_cell/explosion/update_state()
	if(delay > 0)
		delay--
		return

	var/resistance = in_turf.get_explosion_resistance(direction)
	for(var/atom/thing as anything in in_turf)
		resistance += thing.get_explosion_resistance(direction)

	var/severity = get_severity()
	in_turf.ex_act(severity, direction)
	for(var/atom/movable/thing as anything in in_turf)
		if(QDELETED(thing) || !thing.simulated || (thing in exploded_atoms))
			continue
		var/obj/object = thing
		if(istype(object) && object.hides_under_flooring() && !in_turf.is_plating())
			continue
		thing.ex_act(severity, direction)
		log_explosion_hit(thing)
		if(!QDELETED(thing))
			thing.explosion_throw(power, direction)
			if(ismob(thing))
				var/mob/affected_mob = thing
				for(var/obj/item/held_item in list(affected_mob.l_hand, affected_mob.r_hand))
					if(held_item && affected_mob.drop_from_inventory(held_item, in_turf))
						held_item.explosion_throw(power, direction)

	var/reflected = FALSE
	if(!isnull(direction))
		if(power < resistance)
			reflected = TRUE
			power *= reflection_power_multiplier
		else
			power -= resistance

	if(power <= 0)
		qdel(src)
		return

	for(var/spread_direction in get_propagation_dirs(reflected))
		var/direction_falloff = (spread_direction in GLOB.diagonals) ? 1.414 : 1
		if(isnull(direction))
			direction_falloff = 0

		var/new_power = power - (power_falloff * direction_falloff)
		if(new_power <= 0)
			continue

		var/datum/automata_cell/explosion/new_cell = propagate(spread_direction)
		if(!new_cell || QDELETED(new_cell))
			continue
		new_cell.power = new_power
		new_cell.initial_power = initial_power
		new_cell.power_falloff = power_falloff
		new_cell.direction = spread_direction
		new_cell.source_mob = source_mob
		new_cell.source_name = source_name
		if(isnull(direction) && (spread_direction in GLOB.diagonals))
			new_cell.delay = 1
		new_cell.update_wave_visual()
		new_cell.merge_on_turf()

	qdel(src)

/// Begin a subsystem-paced cellular explosion.
/proc/cell_explosion(turf/epicenter, power, falloff = 1, direction, mob/source_mob, source_name = "an explosion")
	epicenter = get_turf(epicenter)
	if(!epicenter || power <= 0)
		return

	power = min(power, 5000)
	falloff = max(falloff, power / 100)

	message_admins("Cellular explosion with power [power] caused by [source_name][source_mob ? " ([key_name(source_mob)])" : ""] in [epicenter.loc.name] ([epicenter.x],[epicenter.y],[epicenter.z]) (<A href='byond://?_src_=holder;adminplayerobservecoodjump=1;X=[epicenter.x];Y=[epicenter.y];Z=[epicenter.z]'>JMP</a>)")
	log_game("Cellular explosion with power [power] caused by [source_name][source_mob ? " ([key_name(source_mob)])" : ""] in [epicenter.loc.name] ([epicenter.x],[epicenter.y],[epicenter.z])")
	playsound(epicenter, SFX_EXPLOSION, min(100, 20 + power * 3), TRUE)

	if(power >= 150)
		new /obj/effect/shockwave(epicenter, power / 60)

	for(var/mob/player as anything in GLOB.player_list)
		if(!player.client)
			continue
		var/turf/player_turf = get_turf(player)
		if(!player_turf || !AreConnectedZLevels(player_turf.z, epicenter.z))
			continue
		var/distance = get_dist(player_turf, epicenter) || 1
		var/effect_range = round(power / max(1, falloff)) + world.view
		if(distance > effect_range)
			continue
		shake_camera(player, min(30, max(2, (power * 2) / distance)), min(3.5, (power / 3) / distance), 0.05)

	var/datum/automata_cell/explosion/cell = new(epicenter)
	if(QDELETED(cell))
		return
	cell.power = power
	cell.initial_power = power
	cell.power_falloff = max(0.1, falloff)
	cell.direction = direction
	cell.source_mob = source_mob
	cell.source_name = source_name
	cell.update_wave_visual()
	cell.merge_on_turf()

/**
 * Temporary visible marker for an active explosion cell.
 *
 * This is deliberately separate from functional smoke: it does not block sight,
 * react with mobs, or persist after its owning cell finishes processing.
 */
/obj/effect/cellular_explosion_wave
	name = "blast wave"
	icon = 'icons/effects/96x96.dmi'
	icon_state = "smoke"
	pixel_x = -32
	pixel_y = -32
	color = "#b0b0b0"
	alpha = 100
	anchored = TRUE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	layer = ABOVE_PROJECTILE_LAYER

/datum/automata_cell/explosion/proc/log_explosion_hit(atom/affected)
	if(!source_mob || !isliving(affected))
		return
	var/mob/living/victim = affected
	admin_attack_log(
		source_mob,
		victim,
		"caused an explosion ([source_name]) which struck [key_name(victim)]",
		"was struck by an explosion ([source_name]) caused by [key_name(source_mob)]",
		"caused an explosion ([source_name]) which struck"
	)

/**
 * Throw an atom away from a blast according to the remaining wave power.
 * Overridden by movable types which have a useful concept of weight.
 */
/atom/movable/proc/explosion_throw(power, direction)
	return

/obj/item/explosion_throw(power, direction, scatter_multiplier = 1)
	if(anchored || !isturf(loc))
		return

	var/throw_distance = min(round(power / max(1, w_class) * 0.2), 14)
	if(throw_distance < 1)
		return

	if(!direction)
		throw_distance = round(throw_distance / 2)
		direction = pick(GLOB.alldirs)

	var/turf/target = get_ranged_target_turf(src, direction, throw_distance)
	if(throw_distance >= 2)
		var/scatter = throw_distance / 4 * scatter_multiplier
		target = locate(
			clamp(target.x + round(rand(-scatter, scatter)), 1, world.maxx),
			clamp(target.y + round(rand(-scatter, scatter)), 1, world.maxy),
			target.z
		)
	throw_at(target, throw_distance, max(1, throw_distance * 2.5))

/mob/living/explosion_throw(power, direction)
	if(anchored || !isturf(loc))
		return
	var/weight = max(0.25, mob_size / 9)
	var/throw_distance = round(power / weight * 0.02)
	if(!direction)
		throw_distance = round(throw_distance * 2 / 3)
		direction = pick(GLOB.alldirs)
	if(throw_distance < 1)
		return

	var/turf/target = get_ranged_target_turf(src, direction, throw_distance)
	if(throw_distance >= 2)
		var/scatter = throw_distance / 4
		target = locate(
			clamp(target.x + round(rand(-scatter, scatter)), 1, world.maxx),
			clamp(target.y + round(rand(-scatter, scatter)), 1, world.maxy),
			target.z
		)
	throw_at(target, throw_distance, max(1, throw_distance * 1.5), spin = throw_distance > 1)
