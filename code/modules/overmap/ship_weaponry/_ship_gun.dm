/obj/machinery/ship_weapon
	name = "ship weapon"
	desc = "You shouldn't be seeing this."
	icon = 'icons/obj/machines/ship_guns/longbow.dmi'
	active_power_usage = 50000
	var/heavy_firing_sound = 'sound/weapons/gunshot/ship_weapons/120mm_mortar.ogg' //The sound in the immediate firing area. Very loud.
	var/light_firing_sound = 'sound/effects/explosionfar.ogg' //The sound played when you're a few walls away. Kind of loud.
	var/projectile_type = /obj/item/projectile/ship_ammo
	var/special_firing_mechanism = FALSE //If set to TRUE, the gun won't show up on normal controls.
	var/charging_sound //The sound played when the gun is charging up.
	var/caliber = SHIP_CALIBER_NONE
	var/use_ammunition = TRUE //If we use physical ammo or not. Note that the creation of ammunition in pre_fire() is still REQUIRED! This just skips the initial check for ammunition.
	var/list/obj/item/ship_ammunition/ammunition = list()
	var/ammo_per_shot = 1
	var/max_ammo = 1
	var/firing_effects
	var/screenshake_type = SHIP_GUN_SCREENSHAKE_SCREEN
	var/firing = FALSE //Helper variable in case we need to track if we're firing or not. Must be set manually. Used for the Leviathan.
	var/load_time = 5 SECONDS

	var/weapon_id //Used to connect weapon systems to the relevant ammunition loader.
	var/obj/structure/ship_weapon_dummy/barrel

/obj/machinery/ship_weapon/Initialize(mapload)
	..()
	appearance_flags &= ~TILE_BOUND //NOT BOUND BY ANY LIMITS
	return INITIALIZE_HINT_LATELOAD

/obj/machinery/ship_weapon/LateInitialize()
	if(current_map.use_overmap && !linked)
		var/my_sector = map_sectors["[z]"]
		if(istype(my_sector, /obj/effect/overmap/visitable/ship))
			attempt_hook_up(my_sector)
	if(linked)
		LAZYADD(linked.ship_weapons, src)
	for(var/obj/structure/ship_weapon_dummy/SD in orange(1, src))
		SD.connect(src)

/obj/machinery/ship_weapon/Destroy()
	for(var/obj/O in ammunition)
		qdel(O)
	ammunition.Cut()
	barrel = null
	return ..()

/obj/machinery/ship_weapon/proc/pre_fire(var/atom/target, var/obj/effect/landmark/landmark) //We can fire, so what do we do before that? Think like a laser charging up.
	fire(target, landmark)
	on_fire()
	return TRUE

/obj/machinery/ship_weapon/proc/on_fire() //We just fired! Cool effects!
	if(firing_effects & FIRING_EFFECT_FLAG_EXTREMELY_LOUD)
		var/list/connected_z_levels = GetConnectedZlevels(z)
		for(var/mob/living/carbon/human/H in player_list)
			if(H.z in connected_z_levels)
				playsound(H, heavy_firing_sound, 100)
	else if(firing_effects & FIRING_EFFECT_FLAG_SILENT)
		for(var/mob/living/carbon/human/H in get_area(src))
			playsound(H, heavy_firing_sound, 100)
	else
		for(var/mob/living/carbon/human/H in get_area(src))
			playsound(H, heavy_firing_sound, 100)
		var/list/connected_z_levels = GetConnectedZlevels(z)
		for(var/mob/living/carbon/human/H in player_list)
			if(H.z in connected_z_levels)
				playsound(H, light_firing_sound, 50)
	if(screenshake_type == SHIP_GUN_SCREENSHAKE_ALL_MOBS)
		var/list/connected_z_levels = GetConnectedZlevels(z)
		for(var/mob/living/H in living_mob_list)
			if(H.z in connected_z_levels)
				to_chat(H, SPAN_DANGER("<font size=4>Your legs buckle as the ground shakes beneath you!</font>"))
				shake_camera(H, 10, 5)
	else if(screenshake_type == SHIP_GUN_SCREENSHAKE_SCREEN)
		for(var/mob/living/carbon/human/H in get_area(src))
			if(!H.buckled_to)
				to_chat(H, SPAN_DANGER("<font size=4>Your legs buckle as the ground shakes beneath you!</font>"))
				shake_camera(H, 10, 5)
	if(firing_effects & FIRING_EFFECT_FLAG_THROW_MOBS)
		var/list/connected_z_levels = GetConnectedZlevels(z)
		for(var/mob/M in living_mob_list)
			if(M.z in connected_z_levels)
				M.throw_at_random(FALSE, 7, 10)
	flick("weapon_firing", src)
	return TRUE

/obj/machinery/ship_weapon/proc/enable()
	return

/obj/machinery/ship_weapon/proc/disable()
	return

/obj/machinery/ship_weapon/proc/load_ammunition(var/obj/item/ship_ammunition/SA)
	if(length(ammunition) >= max_ammo)
		return FALSE
	ammunition |= SA
	SA.forceMove(src)
	return TRUE

/obj/machinery/ship_weapon/proc/firing_checks() //Check if we CAN fire.
	if((!use_ammunition || length(ammunition)) && !stat)
		return TRUE
	else
		return FALSE

/obj/machinery/ship_weapon/proc/firing_command(var/atom/target, var/obj/landmark)
	if(firing_checks())
		var/result = pre_fire(target, landmark)
		if(result)
			use_power_oneoff(active_power_usage)
			return SHIP_GUN_FIRING_SUCCESSFUL
	else
		return SHIP_GUN_ERROR_NO_AMMO

/obj/machinery/ship_weapon/proc/fire(var/atom/overmap_target, var/obj/landmark)
	var/obj/item/ship_ammunition/SA = consume_ammo()
	if(!barrel)
		crash_with("No barrel found for [src] at [x] [y] [z]! Cannot fire!")
	var/turf/firing_turf = get_step(barrel, barrel.dir)
	var/obj/item/projectile/ship_ammo/projectile = new projectile_type(firing_turf)
	projectile.name = SA.name
	projectile.desc = SA.desc
	projectile.ammo = SA
	projectile.dir = barrel.dir
	projectile.shot_from = name
	SA.overmap_target = overmap_target
	SA.entry_point = landmark
	SA.origin = linked
	if(istype(linked, /obj/effect/overmap/visitable/ship))
		var/obj/effect/overmap/visitable/ship/SH = linked
		SA.heading = SH.dir
	else
		SA.heading = barrel.dir
	SA.forceMove(projectile)
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
	return caliber

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
	invisibility = 100
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
	name = SW.name
	desc = SW.name
	if(is_barrel)
		SW.barrel = src
	for(var/obj/structure/ship_weapon_dummy/SD in orange(1, src))
		if(!SD.connected)
			SD.connect(SW)

/obj/machinery/computer/gunnery
	name = "gunnery console"
	desc = "From this console, you will be able to singlehandedly doom ships' worth of people to an instant and fiery death."
	icon_screen = "teleport"
	icon_keyboard = "teal_key"
	light_color = LIGHT_COLOR_CYAN

/obj/machinery/computer/gunnery/Initialize()
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/machinery/computer/gunnery/LateInitialize()
	if(current_map.use_overmap && !linked)
		var/my_sector = map_sectors["[z]"]
		if(istype(my_sector, /obj/effect/overmap/visitable/ship))
			attempt_hook_up(my_sector)

/obj/machinery/computer/gunnery/attack_hand(mob/user)
	. = ..()
	var/list/obj/machinery/ship_weapon/ship_weapons
	for(var/obj/machinery/ship_weapon/SW in linked.ship_weapons)
		if(!SW.special_firing_mechanism)
			ship_weapons += SW
	var/obj/machinery/ship_weapon/big_gun = input(user, "Select a gun.", "Gunnery Control") as null|anything in ship_weapons
	if(!big_gun)
		visible_message(SPAN_WARNING("[icon2html(src, viewers(get_turf(src)))] \The [src] displays an error message, \"Aborting.\""))
		return
	if(!linked.targeting)
		visible_message(SPAN_WARNING("[icon2html(src, viewers(get_turf(src)))] \The [src] displays an error message, \"No target designated.\""))
		playsound(src, 'sound/machines/buzz-sigh.ogg')
		return
	var/list/obj/effect/possible_entry_points = list()
	if(istype(linked.targeting, /obj/effect/overmap/visitable))
		var/obj/effect/overmap/visitable/V = linked.targeting
		for(var/obj/effect/O in V.generic_waypoints)
			possible_entry_points[O.name] = O
		for(var/obj/effect/O in V.entry_points)
			possible_entry_points[O.name] = O
	var/targeted_landmark = input(user, "Select an entry point.", "Gunnery Control") as null|anything in possible_entry_points
	if(!targeted_landmark)
		visible_message(SPAN_WARNING("[icon2html(src, viewers(get_turf(src)))] \The [src] displays an error message, \"No entry point selected. Aborting.\""))
		playsound(src, 'sound/machines/buzz-sigh.ogg')
		return
	var/obj/effect/landmark = possible_entry_points[targeted_landmark]
	if(linked.targeting) //Check if we're still targeting.
		visible_message(SPAN_NOTICE("[icon2html(src, viewers(get_turf(src)))] \The [src] beeps, \"Target acquired! Firing for effect...\""))
		playsound(src, 'sound/effects/alert.ogg')
		var/result = big_gun.firing_command(linked.targeting, landmark)
		if(result == SHIP_GUN_ERROR_NO_AMMO)
			visible_message(SPAN_WARNING("[icon2html(src, viewers(get_turf(src)))] \The [src] displays an error message, \"Ammunition or power insufficient for firing sequence. Aborting.\""))
			playsound(src, 'sound/machines/buzz-sigh.ogg')
		if(result == SHIP_GUN_FIRING_SUCCESSFUL)
			visible_message(SPAN_NOTICE("[icon2html(src, viewers(get_turf(src)))] \The [src] beeps, \"Firing sequence completed!\""))
	else
		visible_message(SPAN_WARNING("[icon2html(src, viewers(get_turf(src)))] \The [src] displays an error message, \"No target given. Aborting.\""))
		playsound(src, 'sound/machines/buzz-sigh.ogg')