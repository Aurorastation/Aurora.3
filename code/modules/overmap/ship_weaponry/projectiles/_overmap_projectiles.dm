/obj/effect/overmap/projectile
	name = "projectile"
	icon = 'icons/obj/guns/ship/overmap_projectiles.dmi'
	icon_state = "cannon"
	scannable = TRUE
	layer = ABOVE_OBJ_LAYER

	var/obj/item/ship_ammunition/ammunition
	var/atom/target //The target is the actual overmap object we're hitting.
	var/obj/entry_target //The entry target is where the projectile itself is going to spawn in world.
	var/range = OVERMAP_PROJECTILE_RANGE_ULTRAHIGH
	var/speed = 0 //A projectile with 0 speed does not move. Note that this is the 'lag' variable on walk_towards! Lower speed is better.
	
	var/moving = FALSE //Is the projectile actively moving on the overmap?

/obj/effect/overmap/projectile/Initialize(var/maploading, var/sx, var/sy)
	. = ..()
	x = sx
	y = sy
	z = current_map.overmap_z
	START_PROCESSING(SSprocessing, src)

/obj/effect/overmap/projectile/Bump(var/atom/A)
	if(istype(A, /turf/unsimulated/map/edge))
		QDEL_NULL(ammunition)
		qdel(src)
	..()

/obj/effect/overmap/projectile/process()
	if(target)
		move_to()
	check_entry()

/obj/effect/overmap/projectile/Destroy()
	ammunition = null
	target = null
	entry_target = null
	return ..()

/obj/effect/overmap/projectile/proc/check_entry()
	var/turf/T = get_turf(src)
	for(var/obj/effect/overmap/visitable/V in T)
		if(V == ammunition.origin)
			continue
		
		if((V.check_ownership(entry_target)) || (V == target)) //Target spotted!
			if(istype(V, /obj/effect/overmap/visitable/sector/exoplanet) && (ammunition.overmap_behaviour & SHIP_AMMO_CAN_HIT_SHIPS))
				//Manually stopping & going invisible because this proc needs to sleep for a bit.
				invisibility = 100
				moving = FALSE
				STOP_PROCESSING(SSprocessing, src) //Also, don't sleep in process().
				var/obj/item/projectile/ship_ammo/widowmaker = new ammunition.original_projectile.type
				widowmaker.ammo = ammunition
				qdel(ammunition.original_projectile) //No longer needed.
				var/turf/laze = get_turf(entry_target)
				ammunition.original_projectile = widowmaker
				playsound(laze, 'sound/weapons/gunshot/ship_weapons/orbital_travel.ogg')
				laze.visible_message(SPAN_DANGER("<font size=6>A bright star is getting closer from the sky...!</font>"))
				sleep(11 SECONDS) //Let the sound play!
				widowmaker.primed = TRUE
				widowmaker.forceMove(entry_target)
				widowmaker.on_hit(laze, is_landmark_hit = TRUE)
				log_and_message_admins("A projectile ([name]) has entered a z-level at [entry_target.name]! (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[widowmaker.x];Y=[widowmaker.y];Z=[widowmaker.z]'>JMP</a>)")
				qdel(widowmaker)
				qdel(src)
			else if(istype(V, /obj/effect/overmap/visitable) && (ammunition.overmap_behaviour & SHIP_AMMO_CAN_HIT_SHIPS))
				if(istype(V, /obj/effect/overmap/visitable/ship))
					var/obj/effect/overmap/visitable/ship/VS = V
					if(istype(ammunition.origin, /obj/effect/overmap/visitable/ship))
						var/obj/effect/overmap/visitable/ship/OR = ammunition.origin
						if(VS.fore_dir != OR.fore_dir)
							var/naval_heading = SSatlas.headings_to_naval["[OR.fore_dir]"]["[ammunition.heading]"]
							var/corrected_heading = SSatlas.naval_to_dir["[VS.fore_dir]"][naval_heading]
							ammunition.heading = corrected_heading
				var/obj/item/projectile/ship_ammo/widowmaker = new ammunition.original_projectile.type
				widowmaker.ammo = ammunition
				qdel(ammunition.original_projectile) //No longer needed.
				ammunition.original_projectile = widowmaker
				widowmaker.primed = TRUE
				var/turf/entry_turf_initial = get_ranged_target_turf(entry_target, reverse_dir[entry_target.dir], 20)
				var/turf/entry_turf = get_ranged_target_turf(entry_turf_initial, pick(list(EAST, WEST)), 5)
				widowmaker.forceMove(entry_turf)
				widowmaker.dir = ammunition.heading
				var/turf/target_turf = get_step(widowmaker, widowmaker.dir)
				widowmaker.on_translate(entry_turf, target_turf)
				log_and_message_admins("A projectile ([widowmaker.name]) has entered a z-level at [entry_target.name], with direction [dir_name(widowmaker.dir)]! (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[widowmaker.x];Y=[widowmaker.y];Z=[widowmaker.z]'>JMP</a>)")
				widowmaker.launch_projectile(target_turf)
				qdel(src)
			else if(istype(V, /obj/effect/overmap/event) && (ammunition.overmap_behaviour & SHIP_AMMO_CAN_HIT_HAZARDS))
				var/obj/effect/overmap/event/EV = V
				if(EV.can_be_destroyed)
					qdel(EV)
				qdel(src)

/obj/effect/overmap/projectile/proc/move_to()
	if(isnull(target) || !speed)
		walk(src, 0)
		moving = FALSE
		return
	if(ammunition.ammunition_behaviour == SHIP_AMMO_BEHAVIOUR_DUMBFIRE)
		walk_towards(src, get_step(src, dir), speed)
	else if(ammunition.ammunition_behaviour == SHIP_AMMO_BEHAVIOUR_GUIDED)
		walk_towards(src, target, speed)
	moving = TRUE

/obj/effect/overmap/projectile/Destroy()
	if(!QDELETED(ammunition))
		QDEL_NULL(ammunition)
	ammunition = null
	return ..()

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
		qdel(src)
	..()