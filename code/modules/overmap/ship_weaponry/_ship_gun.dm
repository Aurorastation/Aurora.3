/obj/machinery/ship_weapon
	name = "ship weapon"
	desc = "You shouldn't be seeing this."
	icon = 'icons/obj/machines/ship_guns/zavod_longarm.dmi'
	var/weapon_id //TODOMATT: Figure out if this is needed after all. Used to connect weapon systems to the relevant ammunition loader.
	var/list/obj/item/ship_ammunition/ammunition = list()
	var/load_time = 5 SECONDS
	var/datum/ship_weapon/weapon

/obj/machinery/ship_weapon/Initialize(mapload)
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/machinery/ship_weapon/LateInitialize()
	weapon = new weapon()
	weapon.controller = src
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
	for(var/obj/O in ammunition)
		qdel(O)
	ammunition.Cut()
	return ..()

/obj/machinery/ship_weapon/proc/load_ammunition(var/obj/item/ship_ammunition/SA)
	ammunition |= SA
	SA.forceMove(src)

/obj/machinery/ship_weapon/proc/firing_checks() //Check if we CAN fire.
	if(length(ammunition))
		return TRUE
	else
		return FALSE

/obj/machinery/ship_weapon/proc/firing_command()
	if(firing_checks())
		weapon.pre_fire()

/obj/machinery/ship_weapon/proc/consume_ammo(var/ammo_per_shot)
	for(var/i = 1; i <= ammo_per_shot; i++)
		var/obj/item/ship_ammunition/SA = ammunition[i]
		SA.eject_shell(src)
		ammunition -= SA
		qdel(SA)

/obj/machinery/ship_weapon/proc/get_caliber()
	return weapon.caliber

//The fake objects below handle things like density/opaqueness for empty tiles, since the icons for guns are larger than 32x32.
//What kind of dinky ass gun is only 32x32?
/obj/structure/ship_weapon_dummy
	name = "ship weapon"
	icon = 'icons/obj/machines/ship_guns/ship_weapon_attachments.dmi'
	icon_state = "dummy"
	layer = OBJ_LAYER //Higher than the gun itself.
	density = TRUE
	opacity = FALSE
	var/obj/machinery/ship_weapon/connected

/obj/structure/ship_weapon_dummy/attack_hand(mob/user)
	connected.attack_hand(user)

/obj/structure/ship_weapon_dummy/attackby(obj/item/W, mob/user)
	connected.attackby(W, user)

/obj/structure/ship_weapon_dummy/hitby(atom/movable/AM)
	connected.hitby(AM)

/obj/structure/ship_weapon_dummy/bullet_act(obj/item/projectile/P, def_zone)
	connected.bullet_act(P)

/obj/structure/ship_weapon_dummy/ex_act(severity)
	connected.ex_act(severity)

/obj/structure/ship_weapon_dummy/proc/connect(var/obj/machinery/ship_weapon/SW)
	connected = SW
	name = SW.weapon.name
	desc = SW.weapon.name
	for(var/obj/structure/ship_weapon_dummy/SD in orange(1, src))
		if(!SD.connected)
			SD.connect(SW)

