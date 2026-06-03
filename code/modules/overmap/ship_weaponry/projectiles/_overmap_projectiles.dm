/obj/effect/overmap/projectile
	name = "projectile"
	icon = 'icons/obj/guns/ship/overmap_projectiles.dmi'
	icon_state = "cannon"
	scannable = TRUE
	layer = ABOVE_OBJ_LAYER
	requires_contact = FALSE

	var/obj/item/ship_ammunition/ammunition
	/// The target is the actual overmap object we're hitting.
	var/atom/target
	/// The submap target is passed by the targetting console, it is the landmark selected on that console. This is the point on the submap (eg. The Horizon's Bridge) that the projectile will aim for when it enters.
	var/obj/submap_target
	var/range = OVERMAP_PROJECTILE_RANGE_MEDIUM
	var/current_range_counter = 0
	// A projectile with 0 speed does not move. Note that this is the 'lag' variable on walk_towards! Lower speed is better.
	var/speed = 0

	/// Is the projectile actively moving on the overmap?
	var/moving = FALSE
	/// Are we entering an entry point?
	var/entering = FALSE

/obj/effect/overmap/projectile/Initialize(var/maploading, var/sx, var/sy)
	. = ..()
	x = sx
	y = sy
	z = SSatlas.current_map.overmap_z
	addtimer(CALLBACK(src, PROC_REF(move_to)), 1, TIMER_STOPPABLE|TIMER_DELETE_ME)

/obj/effect/overmap/projectile/Bump(var/atom/A)
	if(istype(A, /turf/unsimulated/map/edge))
		handle_wraparound()
	..()

/obj/effect/overmap/projectile/handle_wraparound()
	var/nx = x
	var/ny = y
	var/low_edge = 1
	var/high_edge = SSatlas.current_map.overmap_size - 1

	if((dir & WEST) && x == low_edge)
		nx = high_edge
	else if((dir & EAST) && x == high_edge)
		nx = low_edge
	if((dir & SOUTH)  && y == low_edge)
		ny = high_edge
	else if((dir & NORTH) && y == high_edge)
		ny = low_edge
	if((x == nx) && (y == ny))
		return //we're not flying off anywhere
	if(!check_entry())
		var/turf/T = locate(nx,ny,z)
		if(T)
			forceMove(T)

/obj/effect/overmap/projectile/Move()
	if(!check_entry())
		. = ..()
		handle_wraparound()
	current_range_counter++
	if(current_range_counter >= range)
		qdel(src)

/obj/effect/overmap/projectile/Destroy()
	ammunition = null
	target = null
	submap_target = null
	return ..()

///Gets the turf the projectile should enter on. If it's diagnonal it spawns in the corner, if it's orthogonal it spawns on the map edge relative to the target landmark.
/obj/effect/overmap/projectile/proc/get_entry_turf(atom/target_landmark, direction)
	var/turf/target = locate(target_landmark.x, target_landmark.y, target_landmark.z)
	if(!target_landmark || !target)
		return 0

	switch(direction)
		if(NORTH|WEST)
			target = get_ranged_target_turf(locate(1, world.maxy, target.z), direction, max(8, 2 * ammunition.burst)) //We offset the target turf from the edge by 8 (one screen), or twice the burst size. Bursts get their positions randomized up to twice the burst size.
		if(NORTH|EAST)
			target = get_ranged_target_turf(locate(world.maxx, world.maxy, target.z), direction, max(8, 2 * ammunition.burst))
		if(SOUTH|WEST)
			target = get_ranged_target_turf(locate(1, 1, target.z), direction, max(8, 2 * ammunition.burst))
		if(SOUTH|EAST)
			target = get_ranged_target_turf(locate(world.maxx, 1, target.z), direction, max(8, 2 * ammunition.burst))
		if(NORTH)
			target = get_ranged_target_turf(locate(target.x, world.maxy, target.z), direction, max(8, 2 * ammunition.burst))
		if(SOUTH)
			target = get_ranged_target_turf(locate(target.x, 1, target.z), direction, max(8, 2 * ammunition.burst))
		if(EAST)
			target = get_ranged_target_turf(locate(world.maxx, target.y, target.z), direction, max(8, 2 * ammunition.burst))
		if(WEST)
			target = get_ranged_target_turf(locate(1, target.y, target.z), direction, max(8, 2 * ammunition.burst))
	return target

/obj/effect/overmap/projectile/proc/prepare_for_entry()
	moving = FALSE
	entering = FALSE
	walk(src, 0)

///Checks if we can hit the thing we just bumped into. If we can, do the initial setup for the projectile entering the submab and continue.
/obj/effect/overmap/projectile/proc/check_entry()
	. = FALSE
	if(!ammunition)
		return
	var/turf/T = get_turf(src)
	for(var/obj/effect/overmap/A in T)
		if(ammunition && A == ammunition.origin) //Don't collide with the thing that fired us.
			continue
		if(istype(A, /obj/effect/overmap/visitable))
			var/obj/effect/overmap/visitable/V = A
			if((V.check_ownership(submap_target)) || (V == target)) //If the visitable is owned by the target landmark, or is the target itself, we can hit it.
				var/turf/target_turf = get_turf(submap_target)
				var/obj/projectile/ship_ammo/widowmaker = new ammunition.original_projectile.type
				prepare_for_entry()
				widowmaker.ammo = ammunition
				qdel(ammunition.original_projectile) //No longer needed.
				ammunition.original_projectile = widowmaker
				widowmaker.primed = TRUE

				if(istype(V, /obj/effect/overmap/visitable/sector/exoplanet) && (ammunition.overmap_behaviour & SHIP_AMMO_CAN_HIT_PLANETS))
					return check_entry_exoplanet(widowmaker, target_turf, target_turf)
				else if(istype(V, /obj/effect/overmap/visitable/ship) && (ammunition.overmap_behaviour & SHIP_AMMO_CAN_HIT_VISITABLES))
					return check_entry_ship(widowmaker, target_turf, V)
				else if(ammunition.overmap_behaviour & SHIP_AMMO_CAN_HIT_VISITABLES)
					return check_entry_visitable(widowmaker, target_turf)

		if(istype(A, /obj/effect/overmap/event)) //Check hazards last, in case a ship is hiding in a hazard.
			var/obj/effect/overmap/event/EV = A
			if(EV.can_be_destroyed && (ammunition.overmap_behaviour & SHIP_AMMO_CAN_HIT_HAZARDS))
				. = TRUE
				qdel(EV)
				qdel(src)

///Handle bombardment of planets. Spawn the shot in a random open tile near the target and fire the projectile at it. If there is no open tile, call on_hit directly. This allows non-explosive weapons to strafe targets.
/obj/effect/overmap/projectile/proc/check_entry_exoplanet(obj/projectile/ship_ammo/widowmaker, turf/entry_turf, turf/laze)
	. = TRUE
	playsound(laze, 'sound/weapons/gunshot/ship_weapons/orbital_travel.ogg', 60)
	laze.visible_message(SPAN_DANGER("<font size=6>A bright star is getting closer from the sky...!</font>"))
	sleep(11 SECONDS) //Let the sound play!
	var/turf/nearest_valid_turf

	if (!(nearest_valid_turf = get_random_turf_in_range(entry_turf, 1, 5, TRUE, FALSE))) //Get a random empty turf between 1 and 5 tiles away from the target, if this fails call on_hit directly on the target turf.
		widowmaker.forceMove(submap_target)
		widowmaker.on_hit(laze, is_landmark_hit = TRUE)
		log_and_message_admins("A ([widowmaker.name]) landed at ([entry_turf.x], [entry_turf.y], [entry_turf.z]) aimed at [submap_target.name]! (<A href='byond://?_src_=holder;adminplayerobservecoodjump=1;X=[widowmaker.x];Y=[widowmaker.y];Z=[widowmaker.z]'>JMP</a>)")
		say_dead_direct("A ([widowmaker.name]) landed at ([entry_turf.x], [entry_turf.y], [entry_turf.z]) aimed at [submap_target.name]!")
		qdel(widowmaker)
		qdel(src)

	else //If there's an empty turf, spawn our projectile there and aim it at the target.
		widowmaker.on_translate(entry_turf, nearest_valid_turf)
		log_and_message_admins("A ([widowmaker.name]) landed at ([entry_turf.x], [entry_turf.y], [entry_turf.z]) aimed at [submap_target.name]! (<A href='byond://?_src_=holder;adminplayerobservecoodjump=1;X=[widowmaker.x];Y=[widowmaker.y];Z=[widowmaker.z]'>JMP</a>)")
		say_dead_direct("A ([widowmaker.name]) landed at ([entry_turf.x], [entry_turf.y], [entry_turf.z]) aimed at [submap_target.name]!")
		widowmaker.preparePixelProjectile(nearest_valid_turf, entry_turf)
		widowmaker.fired_from = src
		widowmaker.fire()
		qdel(src)

//Handle hitting ships. This requires translating the projectile's direction to account for the relative rotation of the ship. The projectile then spawns at the edge of the map, aimed at the target landmark.
/obj/effect/overmap/projectile/proc/check_entry_ship(obj/projectile/ship_ammo/widowmaker, turf/target_turf, obj/effect/overmap/visitable/ship/VS)
	var/shot_direction = src.dir
	var/naval_heading = SSatlas.headings_to_naval["[VS.dir]"]["[shot_direction]"]
	var/corrected_heading = SSatlas.naval_to_dir["[VS.fore_dir]"][naval_heading]
	shot_direction = corrected_heading

	var/turf/entry_turf = get_entry_turf(submap_target, REVERSE_DIR(shot_direction))
	widowmaker.forceMove(entry_turf)
	widowmaker.dir = shot_direction
	widowmaker.on_translate(entry_turf, target_turf)
	log_and_message_admins("A ([widowmaker.name]) arrived [naval_heading] of \the [target] at ([entry_turf.x], [entry_turf.y], [entry_turf.z]) aimed at [submap_target.name], with direction [dir2text(shot_direction)]! (<A href='byond://?_src_=holder;adminplayerobservecoodjump=1;X=[submap_target.x];Y=[submap_target.y];Z=[submap_target.z]'>JMP</a>)")
	say_dead_direct("A ([widowmaker.name]) arrived [naval_heading] of \the [target] at ([entry_turf.x], [entry_turf.y], [entry_turf.z]) aimed at [submap_target.name], with direction [dir2text(shot_direction)]! (<A href='byond://?_src_=holder;adminplayerobservecoodjump=1;X=[submap_target.x];Y=[submap_target.y];Z=[submap_target.z]'>JMP</a>)")
	widowmaker.preparePixelProjectile(target_turf, entry_turf)
	widowmaker.fired_from = src
	widowmaker.fire()
	qdel(src)
	return TRUE

///Handle hitting visitables that can't spin, such as asteroids and stations. Otherwise identical to hitting a ship.
/obj/effect/overmap/projectile/proc/check_entry_visitable(obj/projectile/ship_ammo/widowmaker, turf/target_turf)
	var/shot_direction = src.dir
	var/turf/entry_turf = get_entry_turf(submap_target, REVERSE_DIR(shot_direction))
	widowmaker.forceMove(entry_turf)
	widowmaker.dir = shot_direction
	widowmaker.on_translate(entry_turf, target_turf)
	log_and_message_admins("A ([widowmaker.name]) flew in at ([entry_turf.x], [entry_turf.y], [entry_turf.z]) aimed at [submap_target.name], with direction [dir2text(shot_direction)]! (<A href='byond://?_src_=holder;adminplayerobservecoodjump=1;X=[submap_target.x];Y=[submap_target.y];Z=[submap_target.z]'>JMP</a>)")
	say_dead_direct("A ([widowmaker.name]) flew in at ([entry_turf.x], [entry_turf.y], [entry_turf.z]) aimed at [submap_target.name], with direction [dir2text(shot_direction)]! (<A href='byond://?_src_=holder;adminplayerobservecoodjump=1;X=[submap_target.x];Y=[submap_target.y];Z=[submap_target.z]'>JMP</a>)")
	widowmaker.preparePixelProjectile(target_turf, entry_turf)
	widowmaker.fired_from = src
	widowmaker.fire()
	qdel(src)
	return TRUE

/obj/effect/overmap/projectile/proc/move_to()
	if(isnull(target) || !speed)
		walk(src, 0)
		moving = FALSE
		return
	if(!moving && !entering)
		if(ammunition.ammunition_behaviour == SHIP_AMMO_BEHAVIOUR_DUMBFIRE)
			walk(src, ammunition.heading, speed)
		else if(ammunition.ammunition_behaviour == SHIP_AMMO_BEHAVIOUR_GUIDED)
			walk_towards(src, target, speed)
		moving = TRUE

/obj/effect/overmap/projectile/get_scan_data(mob/user)
	. = ..()
	. += "<br>A high-velocity projectile."
	. += "<br>Additional information:<br>[get_additional_info()]"

/obj/effect/overmap/projectile/proc/get_additional_info()
	if(ammunition)
		return ammunition.get_additional_info()
	return "N/A"
