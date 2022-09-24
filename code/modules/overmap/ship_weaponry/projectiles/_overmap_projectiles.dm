/obj/effect/overmap/projectile
	name = "projectile"
	icon = 'icons/obj/guns/ship/overmap_projectiles.dmi'
	icon_state = "cannon"
	sector_flags = OVERMAP_SECTOR_KNOWN //Technically in space, but you can't visit the ammo during its flight.
	scannable = TRUE
	layer = ABOVE_OBJ_LAYER

	var/obj/item/ship_ammunition/ammunition
	var/atom/target
	var/obj/entry_target
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
		move_to(target)
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
		
		if(!length(V.map_z))
			return
		
		if(V.check_ownership(entry_target)) //Target spotted!
			if(istype(V, /obj/effect/overmap/visitable/sector/exoplanet))
				//Todomatt: add a grace period maybe?
				var/obj/item/projectile/ship_ammo/widowmaker = new ammunition.original_projectile.type
				widowmaker.ammo = ammunition
				qdel(ammunition.original_projectile) //No longer needed.
				ammunition.original_projectile = widowmaker
				//TODOMATT: add the FSHWOWOOOOOOOOM sound here
				widowmaker.primed = TRUE
				widowmaker.forceMove(entry_target)
				widowmaker.on_hit(get_turf(entry_target))
				log_and_message_admins("A projectile ([name]) has entered a z-level at [entry_target.name]! (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[widowmaker.x];Y=[widowmaker.y];Z=[widowmaker.z]'>JMP</a>)")
				qdel(widowmaker)
			else
				//Todomatt: add a grace period maybe?
				var/obj/item/projectile/ship_ammo/widowmaker = new ammunition.original_projectile.type
				widowmaker.ammo = ammunition
				qdel(ammunition.original_projectile) //No longer needed.
				ammunition.original_projectile = widowmaker
				widowmaker.primed = TRUE
				var/turf/visitor_turf = get_ranged_target_turf(entry_target, reverse_dir[ammunition.heading], round(min(world.maxx/4, world.maxy/4)))
				widowmaker.forceMove(visitor_turf)
				log_and_message_admins("A projectile ([name]) has entered a z-level at [entry_target.name]! (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[widowmaker.x];Y=[widowmaker.y];Z=[widowmaker.z]'>JMP</a>)")
				widowmaker.dir = ammunition.heading
				var/turf/target_turf = get_step(widowmaker, widowmaker.dir)
				widowmaker.launch_projectile(target_turf)
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
	. += "<br>A high-velocity ballistic projectile."
	. += "<br>Additional information:<br>[get_additional_info()]"

/obj/effect/overmap/projectile/proc/get_additional_info()
	if(ammunition)
		return ammunition.get_additional_info()
	return "N/A"

