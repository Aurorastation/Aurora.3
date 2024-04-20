/obj/effect/overmap/projectile
	name = "projectile"
	icon = 'icons/obj/guns/ship/overmap_projectiles.dmi'
	icon_state = "cannon"
	scannable = TRUE
	layer = ABOVE_OBJ_LAYER
	requires_contact = FALSE

	var/obj/item/ship_ammunition/ammunition
	var/atom/target //The target is the actual overmap object we're hitting.
	var/obj/entry_target //The entry target is where the projectile itself is going to spawn in world.
	var/range = OVERMAP_PROJECTILE_RANGE_MEDIUM
	var/current_range_counter = 0
	var/speed = 0 //A projectile with 0 speed does not move. Note that this is the 'lag' variable on walk_towards! Lower speed is better.

	var/moving = FALSE //Is the projectile actively moving on the overmap?
	var/entering = FALSE //Are we entering an entry point?

/obj/effect/overmap/projectile/Initialize(var/maploading, var/sx, var/sy)
	. = ..()
	x = sx
	y = sy
	z = SSatlas.current_map.overmap_z
	addtimer(CALLBACK(src, PROC_REF(move_to)), 1)

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
	entry_target = null
	return ..()

/obj/effect/overmap/projectile/proc/prepare_for_entry()
	moving = FALSE
	entering = FALSE
	walk(src, 0)

/obj/effect/overmap/projectile/proc/check_entry()
	. = FALSE
	if(!ammunition)
		return
	var/turf/T = get_turf(src)
	for(var/obj/effect/overmap/A in T)
		if(ammunition && A == ammunition.origin)
			continue
		if(istype(A, /obj/effect/overmap/visitable))
			var/obj/effect/overmap/visitable/V = A
			if((V.check_ownership(entry_target)) || (V == target)) //Target spotted!
				if(istype(V, /obj/effect/overmap/visitable/sector/exoplanet) && (ammunition.overmap_behaviour & SHIP_AMMO_CAN_HIT_PLANETS))
					. = TRUE
					//Manually stopping because this proc needs to sleep for a bit.
					prepare_for_entry()
					var/obj/item/projectile/ship_ammo/widowmaker = new ammunition.original_projectile.type
					widowmaker.ammo = ammunition
					qdel(ammunition.original_projectile) //No longer needed.
					var/turf/laze = get_turf(entry_target)
					ammunition.original_projectile = widowmaker
					playsound(laze, 'sound/weapons/gunshot/ship_weapons/orbital_travel.ogg', 60)
					laze.visible_message(SPAN_DANGER("<font size=6>A bright star is getting closer from the sky...!</font>"))
					sleep(11 SECONDS) //Let the sound play!
					widowmaker.primed = TRUE
					widowmaker.forceMove(entry_target)
					widowmaker.on_hit(laze, is_landmark_hit = TRUE)
					log_and_message_admins("A projectile ([name]) has entered a z-level at [entry_target.name]! (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[widowmaker.x];Y=[widowmaker.y];Z=[widowmaker.z]'>JMP</a>)")
					say_dead_direct("A projectile ([name]) has entered a z-level at [entry_target.name]!")
					qdel(widowmaker)
					qdel(src)
				else if(istype(V, /obj/effect/overmap/visitable) && (ammunition.overmap_behaviour & SHIP_AMMO_CAN_HIT_VISITABLES))
					. = TRUE
					if(istype(V, /obj/effect/overmap/visitable/ship))
						var/obj/effect/overmap/visitable/ship/VS = V
						if(istype(ammunition.origin, /obj/effect/overmap/visitable/ship))
							var/naval_heading = SSatlas.headings_to_naval["[VS.dir]"]["[ammunition.heading]"]
							var/corrected_heading = SSatlas.naval_to_dir["[VS.fore_dir]"][naval_heading]
							ammunition.heading = corrected_heading
					else //if it's not a ship it doesn't have a fore direction, so we need to autocorrect
						ammunition.heading = entry_target.dir
					prepare_for_entry()
					var/obj/item/projectile/ship_ammo/widowmaker = new ammunition.original_projectile.type
					widowmaker.ammo = ammunition
					qdel(ammunition.original_projectile) //No longer needed.
					ammunition.original_projectile = widowmaker
					widowmaker.primed = TRUE
					var/turf/entry_turf_initial = get_ranged_target_turf(entry_target, GLOB.reverse_dir[entry_target.dir], 20)
					var/entry_dir_choice = (dir & NORTH) || (dir & SOUTH) ? list(EAST, WEST) : list(NORTH, SOUTH)
					var/turf/entry_turf = get_ranged_target_turf(entry_turf_initial, entry_dir_choice, 5)
					widowmaker.forceMove(entry_turf)
					widowmaker.dir = ammunition.heading
					var/turf/target_turf = get_step(widowmaker, widowmaker.dir)
					widowmaker.on_translate(entry_turf, target_turf)
					log_and_message_admins("A projectile ([widowmaker.name]) has entered a z-level at [entry_target.name], with direction [dir2text(widowmaker.dir)]! (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[widowmaker.x];Y=[widowmaker.y];Z=[widowmaker.z]'>JMP</a>)")
					say_dead_direct("A projectile ([widowmaker.name]) has entered a z-level at [entry_target.name], with direction [dir2text(widowmaker.dir)]!")
					widowmaker.launch_projectile(target_turf)
					qdel(src)
		if(istype(A, /obj/effect/overmap/event))
			var/obj/effect/overmap/event/EV = A
			if(EV.can_be_destroyed && (ammunition.overmap_behaviour & SHIP_AMMO_CAN_HIT_HAZARDS))
				. = TRUE
				qdel(EV)
				qdel(src)

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

/obj/effect/overmap/projectile/Bump(var/atom/A)
	if(istype(A,/turf/unsimulated/map/edge))
		handle_wraparound()
	..()
