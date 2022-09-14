/obj/effect/overmap/projectile
	name = "projectile"
	icon_state = "projectile"
	sector_flags = OVERMAP_SECTOR_KNOWN // technically in space, but you can't visit the missile during its flight
	scannable = TRUE

	var/obj/item/ship_ammunition/ammunition
	
	var/walking = FALSE // walking towards something on the overmap?
	var/moving = FALSE // is the missile moving on the overmap?
	var/dangerous = FALSE
	var/should_enter_zs = FALSE

/obj/effect/overmap/projectile/Initialize(var/maploading, var/sx, var/sy)
	. = ..()
	x = sx
	y = sy
	z = current_map.overmap_z
	START_PROCESSING(SSprocessing, src)


/obj/effect/overmap/projectile/Destroy()
	if(!QDELETED(ammunition))
		QDEL_NULL(ammunition)
	ammunition = null
	. = ..()

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
	. += "<br>General purpose projectile frame"
	. += "<br>Additional information:<br>[get_additional_info()]"

/obj/effect/overmap/projectile/proc/get_additional_info()
	if(ammunition)
		return ammunition.get_additional_info()
	return "N/A"

