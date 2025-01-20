/// The minimum strength of a shield to reduce the explosion power of the comet expulsion
#define SHIELD_MINIMUM_STRENGTH_TO_REDUCE_EXPLOSION_POWER 5

/*###############################################
	PROJECTILE OF THE COMET EXPULSION EVENT
###############################################*/

/obj/projectile/comet_expulsion
	name = "Comet Expulsion"
	icon = 'icons/obj/guns/ship/overmap_projectiles.dmi'
	icon_state = "med_xray_salvo" //Eventually a spriter will make a sprite specific for this
	speed = 1
	pixel_speed_multiplier = 0.01
	range = INFINITY

/obj/projectile/comet_expulsion/can_hit_target(atom/target, direct_target = FALSE, ignore_loc = FALSE, cross_failed = FALSE)
	if(istype(get_turf(src), /turf/unsimulated/map/edge) && istype(target, /turf/unsimulated/map/edge))
		return FALSE

	if(!istype(target, /obj/effect/overmap/visitable))
		return FALSE

	return ..()

/obj/projectile/comet_expulsion/on_hit(atom/target, blocked, def_zone)
	. = ..()
	if(. != BULLET_ACT_HIT)
		return

	//If we hit the ship, spawn meteors for the various zlevels
	if(target == original)
		//The direction we are hitting the overmap object from, the true one
		var/hit_direction = angle2dir(get_angle(src, target))

		for(var/zlevel in SSmapping.levels_by_trait(ZTRAIT_STATION))
			//Pick a cardinal direction to spawn the meteor from
			var/meteor_source_dir = hit_direction
			//If it's not a cardinal already, since the meteor code only supports cardinal directions, make it cardinal
			switch(meteor_source_dir)
				if(NORTHEAST)
					meteor_source_dir = pick(EAST, NORTH)
				if(NORTHWEST)
					meteor_source_dir = pick(WEST, NORTH)
				if(SOUTHEAST)
					meteor_source_dir = pick(EAST, SOUTH)
				if(SOUTHWEST)
					meteor_source_dir = pick(WEST, SOUTH)

			//Calculate how many meteors to spawn based on the direction of the hit
			//getting hit broadside (cardinal direction) is worse than hitting it diagonally
			var/meteors_to_spawn = 5
			if(hit_direction in GLOB.cardinals)
				meteors_to_spawn = 3

			spawn_meteors(meteors_to_spawn, list(/obj/effect/meteor/comet_expulsion), meteor_source_dir, zlevel)


/*#############################################
	METEORS OF THE COMET EXPULSION EVENT
#############################################*/

/obj/effect/meteor/comet_expulsion
	heavy = TRUE
	ignore_shield_destruction = TRUE
	hitpwr = 2

/obj/effect/meteor/comet_expulsion/Collide(atom/A)
	//If there's shields and it's strong enough, the power of the explosion is reduced, but it won't stop it
	if(istype(A, /obj/effect/energy_field))
		var/obj/effect/energy_field/impacted_energy_field = A
		if(impacted_energy_field.strength > SHIELD_MINIMUM_STRENGTH_TO_REDUCE_EXPLOSION_POWER)
			hitpwr *= 0.5
			qdel(impacted_energy_field)

	. = ..()

/obj/effect/meteor/comet_expulsion/meteor_effect()
	. = ..()

	explosion(get_turf(src), ROUND_UP(hitpwr), ROUND_UP(hitpwr*1.2), ROUND_UP(hitpwr*1.4))


/*#############################
	COMET EXPULSION EVENT
#############################*/

/datum/event/comet_expulsion
	severity = EVENT_LEVEL_MAJOR
	startWhen = 30

/datum/event/comet_expulsion/setup()
	if(!SSatlas.current_map.use_overmap)
		qdel(src)
		return


/datum/event/comet_expulsion/start()
	. = ..()

	var/list/possible_station_levels = SSmapping.levels_by_all_traits(list(ZTRAIT_STATION))
	if(!length(possible_station_levels))
		qdel(src)
		return

	var/obj/effect/overmap/visitable/target = GLOB.map_sectors["[pick(possible_station_levels)]"]

	if(!istype(target))
		qdel(src)
		return

	var/list/turf/unsimulated/map/edge/overmap_edges = list()

	for(var/turf/unsimulated/map/edge/E in block(locate(1,1,SSatlas.current_map.overmap_z), locate(SSatlas.current_map.overmap_size,SSatlas.current_map.overmap_size,SSatlas.current_map.overmap_z)))
		overmap_edges += E

	var/turf/unsimulated/map/edge/source = pick(overmap_edges)
	if(!istype(source))
		qdel(src)
		return

	var/obj/projectile/comet_expulsion/our_comet = new(source)
	our_comet.preparePixelProjectile(target, source)
	our_comet.original = target
	our_comet.fire(get_angle(source, target))


/datum/event/comet_expulsion/announce_start()
	. = ..()
	command_announcement.Announce("Warning, long range field scanners have detected an unforseen comet mass expulsion in collision route with [location_name()].\n\
									All hands, assume defense condition, perform evasive maneuvers to avoid collision with the debris cloud. Damage control teams prepare to respond to breaches of the \
									vessel perimeter.",
									"[location_name()] Long Range Field Objects Sensor Array", new_sound = 'sound/effects/Evacuation.ogg', zlevels = affecting_z)

#undef SHIELD_MINIMUM_STRENGTH_TO_REDUCE_EXPLOSION_POWER
