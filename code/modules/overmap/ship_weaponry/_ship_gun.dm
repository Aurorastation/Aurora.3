/obj/machinery/ship_weapon
	name = "ship weapon"
	desc = "You shouldn't be seeing this."
	icon = 'icons/obj/machines/ship_guns/zavod_longarm.dmi'
	var/weapon_id //TODOMATT: Figure out if this is needed after all. This is a variable to allow connection to weapon controllers w/o adjacency in the same area
	var/datum/ship_weapon/weapon

/obj/machinery/ship_weapon/Initialize(mapload)
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/machinery/ship_weapon/LateInitialize()
	. = ..()
	weapon = new weapon()
	if(current_map.use_overmap && !linked)
		var/my_sector = map_sectors["[z]"]
		if(istype(my_sector, /obj/effect/overmap/visitable/ship))
			attempt_hook_up(my_sector)
	name = weapon.name
	desc = weapon.desc
	for(var/obj/structure/ship_weapon_dummy/SD in orange(1, src))
		SD.connect(src)

/obj/machinery/ship_weapon/Destroy()
	QDEL_NULL(weapon)
	return ..()

/obj/structure/ship_weapon_dummy
	name = "ship weapon"
	var/obj/machinery/ship_weapon/connected

/obj/structure/ship_weapon_dummy/proc/connect(var/obj/machinery/ship_weapon/SW)
	connected = SW
	name = SW.weapon.name
	desc = SW.weapon.name
	for(var/obj/structure/ship_weapon_dummy/SD in orange(1, src))
		if(!SD.connected)
			SD.connect(src)

