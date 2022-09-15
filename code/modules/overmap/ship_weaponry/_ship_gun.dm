/obj/machinery/ship_weapon
	name = "ship weapon"
	desc = "You shouldn't be seeing this."
	icon = 'icons/obj/machines/ship_guns/zavod_longarm.dmi'
	var/weapon_id //TODOMATT: Figure out if this is needed after all. Used to connect weapon systems to the relevant ammunition loader.
	var/obj/structure/ship_weapon_dummy/barrel
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
	if(linked)
		LAZYADD(linked.ship_weapons, src)
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

/obj/machinery/ship_weapon/proc/firing_command(var/atom/target)
	if(firing_checks())
		weapon.pre_fire(target)

/obj/machinery/ship_weapon/proc/fire(var/atom/overmap_target)
	var/obj/item/ship_ammunition/SA = consume_ammo()
	if(!barrel)
		crash_with("No barrel found for [src] at [x] [y] [z]! Cannot fire!")
	var/turf/firing_turf = get_step(barrel, barrel.dir)
	var/obj/item/projectile/ship_ammo/projectile = new(firing_turf)
	projectile.name = SA.name
	projectile.desc = SA.desc
	projectile.ammo = SA
	projectile.shot_from = name
	SA.overmap_target = overmap_target
	var/turf/target = get_step(projectile, barrel.dir)
	projectile.launch_projectile(target)
	return TRUE

/obj/machinery/ship_weapon/proc/consume_ammo()
	//In this proc, 'ammo per shot' is intended as ammunition per SINGLE SHOT. A gatling gun that fires 30 times in one burst fires 30 individual shots.
	var/obj/item/ship_ammunition/SA = ammunition[1]
	SA.eject_shell(src)
	ammunition -= SA
	return SA

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
	atmos_canpass = CANPASS_DENSITY
	var/obj/machinery/ship_weapon/connected
	var/is_barrel = FALSE //Ammo spawns in front of THIS dummy.

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
	if(is_barrel)
		SW.barrel = src
	for(var/obj/structure/ship_weapon_dummy/SD in orange(1, src))
		if(!SD.connected)
			SD.connect(SW)

