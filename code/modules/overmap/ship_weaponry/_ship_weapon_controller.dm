/obj/machinery/weapon_control
	name = "ammunition loader"
	desc = "An ammunition loader for ship weapons systems. All hands to battlestations!"
	icon = 'icons/obj/machines/ship_guns/ship_weapon_attachments.dmi'
	icon_state = "ammo_loader"
	density = TRUE
	var/obj/machinery/ship_weapon/weapon

/obj/machinery/weapon_control/Initialize(mapload)
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/machinery/weapon_control/LateInitialize()
	if(current_map.use_overmap && !linked)
		var/my_sector = map_sectors["[z]"]
		if(istype(my_sector, /obj/effect/overmap/visitable/ship))
			attempt_hook_up(my_sector)
	var/area/A = get_area(src)
	for(var/obj/machinery/ship_weapon/SW in A)
		if(SW.Adjacent(src))
			weapon = SW
	if(!weapon)
		crash_with("[src] at [x] [y] [z] has no weapon attached!")

/obj/structure/viewport
	name = "viewport"
	desc = "A viewport for some sort of ship-mounted weapon. You can see your enemies blow up into many, many bits and pieces from here."
	icon = 'icons/obj/machines/ship_guns/ship_weapon_attachments.dmi'
	icon_state = "viewport_generic"
	density = TRUE
	opacity = FALSE
	anchored = TRUE

/obj/structure/viewport/zavod
	icon = 'icons/obj/machines/ship_guns/ship_weapon_attachments.dmi'
	icon_state = "viewport_zavod"
