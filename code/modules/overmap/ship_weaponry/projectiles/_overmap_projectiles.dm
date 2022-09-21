/obj/effect/overmap/projectile
	name = "projectile"
	icon = 'icons/obj/guns/ship/overmap_projectiles.dmi'
	icon_state = "cannon"
	sector_flags = OVERMAP_SECTOR_KNOWN //Technically in space, but you can't visit the ammo during its flight.
	scannable = TRUE

	var/obj/item/ship_ammunition/ammunition
	var/atom/target
	var/range = OVERMAP_PROJECTILE_RANGE_ULTRAHIGH
	var/speed = 0
	
	var/walking = FALSE //Walking towards something on the overmap?
	var/moving = FALSE //Is the missile moving on the overmap?
	var/dangerous = FALSE
	var/should_enter_zs = FALSE

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

/obj/effect/overmap/projectile/proc/move_to()
	if(isnull(target) || !speed)
		walk(src, 0)
		walking = FALSE
		return

	walk_towards(src, target, speed)
	walking = TRUE

/obj/effect/overmap/projectile/Destroy()
	if(!QDELETED(ammunition))
		QDEL_NULL(ammunition)
	ammunition = null
	return ..()

/obj/effect/overmap/projectile/proc/set_ammunition(var/obj/item/ship_ammunition/ammo)
	ammunition = ammo

/obj/effect/overmap/projectile/proc/set_dangerous(var/is_dangerous)
	dangerous = is_dangerous

/obj/effect/overmap/projectile/proc/set_moving(var/is_moving)
	moving = is_moving

/obj/effect/overmap/projectile/proc/set_enter_zs(var/enter_zs)
	should_enter_zs = enter_zs

/obj/effect/overmap/projectile/get_scan_data(mob/user)
	. = ..()
	. += "<br>A high-velocity ballistic projectile."
	. += "<br>Additional information:<br>[get_additional_info()]"

/obj/effect/overmap/projectile/proc/get_additional_info()
	if(ammunition)
		return ammunition.get_additional_info()
	return "N/A"

