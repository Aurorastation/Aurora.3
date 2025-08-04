/obj/machinery/ship_weapon
	name = "ship weapon"
	desc = DESC_PARENT
	icon = 'icons/obj/machinery/ship_guns/longbow.dmi'
	idle_power_usage = 1500
	active_power_usage = 50000
	anchored = TRUE
	density = TRUE
	var/damage = 0
	var/max_damage = 1000
	var/heavy_firing_sound = 'sound/weapons/gunshot/ship_weapons/120mm_mortar.ogg' //The sound in the immediate firing area. Very loud.
	var/light_firing_sound = 'sound/effects/explosionfar.ogg' //The sound played when you're a few walls away. Kind of loud.
	var/projectile_type = /obj/projectile/ship_ammo
	var/special_firing_mechanism = FALSE //If set to TRUE, the gun won't show up on normal controls.
	var/charging_sound					 //The sound played when the gun is charging up.
	var/caliber = SHIP_CALIBER_NONE
	var/use_ammunition = TRUE	//If we use physical ammo or not. Note that the creation of ammunition in pre_fire() is still REQUIRED!
								//This just skips the initial check for ammunition.
	var/list/obj/item/ship_ammunition/ammunition = list()
	var/ammo_per_shot = 1
	var/max_ammo = 1
	var/firing_effects
	var/screenshake_type = SHIP_GUN_SCREENSHAKE_SCREEN
	var/firing = FALSE //Helper variable in case we need to track if we're firing or not. Must be set manually. Used for the Leviathan.
	var/load_time = 5 SECONDS
	/// When toggled, targeting computers will be able to force ammunition heading direction. Used for guns on visitables.
	var/mobile_platform = FALSE

	var/weapon_id //Used to identify a gun in the targeting consoles and connect weapon systems to the relevant ammunition loader. Must be unique!
	var/list/obj/structure/ship_weapon_dummy/connected_dummies = list()
	var/obj/structure/ship_weapon_dummy/barrel

/obj/machinery/ship_weapon/condition_hints(mob/user, distance, is_adjacent)
	. += ..()
	var/ratio = (damage / max_damage) * 100
	switch(ratio)
		if(1 to 10)
			. += SPAN_NOTICE("It looks to be in tip top shape apart from a few minor scratches and dings.")
		if(10 to 20)
			. += SPAN_ALERT("It has some kinks and bends here and there.")
		if(20 to 40)
			. += SPAN_ALERT("It has a few holes through which you can see some machinery.")
		if(40 to 60)
			. += SPAN_WARNING("Some fairly important parts are missing... but it should work anyway.")
		if(60 to 80)
			. += SPAN_WARNING("It needs repairs direly. Both aiming and firing components are missing or broken. It has a lot of holes, too. It definitely wouldn't \
				pass inspection.")
		if(90 to 100)
			. += SPAN_DANGER("It's falling apart! Just touching it might make the whole thing collapse!")
		else //At roundstart, weapons start with 0 damage, so it'd be 0 / 1000 * 100 -> 0
			. += SPAN_NOTICE("It looks to be in tip top shape and not damaged at all.")

/obj/machinery/ship_weapon/mechanics_hints(mob/user, distance, is_adjacent)
	. += ..()
	. += "Use a multitool to check or update the weapon's internal network ID for linking purposes. You probably don't need to do this."
	. += "To load a ship weapon, you must use a nearby Ammunition Loader linked to it."
	. += "This weapon is LOUD when it fires; you probably want to wear ear protection when nearby."

/obj/machinery/ship_weapon/assembly_hints(mob/user, distance, is_adjacent)
	. += ..()
	var/ratio = (damage / max_damage) * 100
	if(ratio > 0)
		. += "The damage can be repaired with a <b>welder</b>, but given the size of \the [src] it will take a lot of time and welding fuel."

/obj/machinery/ship_weapon/feedback_hints(mob/user, distance, is_adjacent)
	. += ..()
	var/loaded_ammo_count_txt = num2text(length(ammunition))
	var/max_ammo_txt = num2text(max_ammo)
	. += "\the [src] can load a maximum of [max_ammo_txt] [max_ammo == 1 ? "round" : "rounds"] at a time."
	if(length(ammunition) >= max_ammo)
		. += "\the [src] is fully loaded with ammunition!"
	else
		. += SPAN_NOTICE("\the [src] is currently loaded with [loaded_ammo_count_txt] [length(ammunition) == 1 ? "round" : "rounds"] of ammunition.")

/obj/machinery/ship_weapon/Initialize(mapload)
	..()
	appearance_flags &= ~TILE_BOUND //NOT BOUND BY ANY LIMITS
	return INITIALIZE_HINT_LATELOAD

/obj/machinery/ship_weapon/LateInitialize()
	SSshuttle.weapons_to_initialize += src
	if(SSshuttle.initialized)
		SSshuttle.initialize_ship_weapons()
	for(var/obj/structure/ship_weapon_dummy/SD in orange(1, src))
		SD.connect(src)
	if(!weapon_id)
		weapon_id = "[name] - [sequential_id(type)]"

/obj/machinery/ship_weapon/Destroy()
	for(var/obj/O in ammunition)
		qdel(O)
	destroy_dummies()
	ammunition.Cut()
	barrel = null
	LAZYREMOVE(linked?.ship_weapons, src)
	return ..()

/obj/machinery/ship_weapon/ex_act(severity)
	switch(severity)
		if(1)
			add_damage(50)
		if(2)
			add_damage(25)
		if(3)
			add_damage(10)

/obj/machinery/ship_weapon/proc/add_damage(var/amount)
	damage = max(0, min(damage + amount, max_damage))
	update_damage()

/obj/machinery/ship_weapon/proc/update_damage()
	if(damage >= max_damage)
		qdel(src)

/obj/machinery/ship_weapon/attackby(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/device/multitool))
		to_chat(user, SPAN_NOTICE("You hook up the tester to \the [src]'s wires: its identification tag is <b>[weapon_id]></b>."))
		var/new_id = input(user, "Change the identification tag?", "Identification Tag", weapon_id) as text|null
		if(length(new_id) && !use_check_and_message(user))
			new_id = sanitizeSafe(new_id, 32)
			for(var/obj/machinery/ammunition_loader/SW in SSmachinery.machinery)
				if(SW.weapon_id == new_id)
					if(get_area(SW) != get_area(src))
						to_chat(user, SPAN_WARNING("The loader returns an error message of two beeps, indicating that the weapon ID is invalid."))
						return TRUE
				weapon_id = new_id
				to_chat(user, SPAN_NOTICE("With some finicking, you change the identification tag to <b>[new_id]</b>."))
				return TRUE
	if(istype(attacking_item, /obj/item/weldingtool) && damage)
		var/obj/item/weldingtool/WT = attacking_item
		if(WT.get_fuel() >= 20)
			user.visible_message(SPAN_NOTICE("[user] starts slowly welding kinks and holes in \the [src] back to working shape..."),
								SPAN_NOTICE("You start welding kinks and holes back to working shape. This'll take a long while..."))
			if(do_after(user, 15 SECONDS))
				add_damage(-max_damage)
				user.visible_message(SPAN_NOTICE("[user] finally finishes patching up \the [src]'s exterior! It's not a pretty job, but it'll do."),
									SPAN_NOTICE("You finally finish patching up \the [src]'s exterior! It's not a pretty job, but it'll do."))
				WT.use(20)
				return TRUE
			else
				return FALSE
		else
			to_chat(user, SPAN_WARNING("You need at least 20 units of fuel with how big this thing is!"))
			return FALSE
	return ..()

/obj/machinery/ship_weapon/proc/destroy_dummies()
	for(var/A in connected_dummies)
		var/obj/structure/ship_weapon_dummy/dummy = A
		qdel(dummy)
	connected_dummies.Cut()

/obj/machinery/ship_weapon/proc/pre_fire(var/atom/target, var/obj/effect/landmark/landmark, var/direction_override) //We can fire, so what do we do before that? Think like a laser charging up.
	fire(target, landmark, direction_override)
	on_fire()
	return TRUE

/obj/machinery/ship_weapon/proc/on_fire() //We just fired! Cool effects!
	if(firing_effects & FIRING_EFFECT_FLAG_EXTREMELY_LOUD)
		var/list/connected_z_levels = GetConnectedZlevels(z)
		for(var/mob/living/carbon/human/H in GLOB.player_list)
			if(H.z in connected_z_levels)
				sound_to(H, sound(heavy_firing_sound, volume = 50))
				if(H.is_listening())
					H.adjustEarDamage(rand(0, 5), 2, TRUE)
	else if(firing_effects & FIRING_EFFECT_FLAG_SILENT)
		for(var/mob/living/carbon/human/H in GLOB.human_mob_list)
			if(get_area(H) == get_area(src))
				sound_to(H, sound(heavy_firing_sound, volume = 50))
				if(H.is_listening())
					H.adjustEarDamage(rand(0, 5), 2, TRUE)
	else
		for(var/mob/living/carbon/human/H in GLOB.human_mob_list)
			var/list/connected_z_levels = GetConnectedZlevels(z)
			if(get_area(H) == get_area(src))
				sound_to(H, sound(heavy_firing_sound, volume = 50))
				if (H.is_listening())
					H.adjustEarDamage(rand(0, 5), 2, TRUE)
			else
				if(H.z in connected_z_levels)
					sound_to(H, sound(light_firing_sound, volume = 50))
	if(screenshake_type == SHIP_GUN_SCREENSHAKE_ALL_MOBS)
		var/list/connected_z_levels = GetConnectedZlevels(z)
		for(var/mob/living/carbon/human/H in GLOB.human_mob_list)
			if(H.z in connected_z_levels)
				to_chat(H, SPAN_DANGER("<font size=4>Your legs buckle as the ground shakes beneath you!</font>"))
				shake_camera(H, 10, 5)
	else if(screenshake_type == SHIP_GUN_SCREENSHAKE_SCREEN)
		for(var/mob/living/carbon/human/H in GLOB.human_mob_list)
			if(get_area(H) == get_area(src))
				if(!H.buckled_to)
					to_chat(H, SPAN_DANGER("<font size=4>Your legs buckle as the ground shakes beneath you!</font>"))
					shake_camera(H, 10, 5)
	if(firing_effects & FIRING_EFFECT_FLAG_THROW_MOBS)
		var/list/connected_z_levels = GetConnectedZlevels(z)
		for(var/mob/M in GLOB.living_mob_list)
			if(M.z in connected_z_levels)
				if(!M.Check_Shoegrip() && !M.buckled_to && !M.anchored)
					M.throw_at_random(FALSE, 7, 10)
	flick("weapon_firing", src)
	return TRUE

/obj/machinery/ship_weapon/proc/enable()
	return

/obj/machinery/ship_weapon/proc/disable()
	return

/obj/machinery/ship_weapon/proc/load_ammunition(var/obj/item/ship_ammunition/SA, var/mob/living/H, var/obj/item/mecha_equipment/clamp/clamp)
	if(length(ammunition) >= max_ammo)
		return FALSE
	ammunition |= SA
	if(ismech(H))
		var/mob/living/heavy_vehicle/mecha = H
		var/obj/item/mecha_equipment/clamp/CL = mecha.selected_system
		if(istype(CL))
			CL.drop_carrying()
	else
		H.drop_from_inventory(SA)
	SA.forceMove(src)
	return TRUE

/obj/machinery/ship_weapon/proc/firing_checks() //Check if we CAN fire.
	if((!use_ammunition || length(ammunition)) && !stat)
		return TRUE
	else
		return FALSE

/obj/machinery/ship_weapon/proc/firing_command(var/atom/target, var/obj/landmark, var/direction_override)
	if(firing_checks())
		var/result = pre_fire(target, landmark, direction_override)
		if(result)
			use_power_oneoff(active_power_usage)
			return SHIP_GUN_FIRING_SUCCESSFUL
	else
		return SHIP_GUN_ERROR_NO_AMMO

/obj/machinery/ship_weapon/proc/fire(var/atom/overmap_target, var/obj/landmark, var/direction_override)
	var/obj/item/ship_ammunition/SA = consume_ammo()
	if(!barrel)
		crash_with("No barrel found for [src] at [x] [y] [z]! Cannot fire!")
	var/turf/firing_turf = get_step(barrel, barrel.dir)
	var/obj/projectile/ship_ammo/projectile
	if(SA.projectile_type_override)
		projectile = new SA.projectile_type_override(firing_turf)
	else
		projectile = new projectile_type(firing_turf)
	projectile.name = SA.name
	projectile.desc = SA.desc
	projectile.ammo = SA
	projectile.dir = barrel.dir
	SA.overmap_target = overmap_target
	SA.entry_point = landmark
	SA.origin = linked
	if(direction_override)
		SA.heading = direction_override
	else if(istype(linked, /obj/effect/overmap/visitable/ship))
		var/obj/effect/overmap/visitable/ship/SH = linked
		SA.heading = SH.dir
	else
		SA.heading = barrel.dir
	SA.forceMove(projectile)
	var/turf/target = get_step(projectile, barrel.dir)
	projectile.preparePixelProjectile(target, firing_turf)
	projectile.fired_from = barrel
	projectile.fire()
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
	name = "ship weapon dummy"
	icon = 'icons/obj/machinery/ship_guns/ship_weapon_dummy.dmi'
	icon_state = "dummy"
	mouse_opacity = MOUSE_OPACITY_OPAQUE
	layer = OBJ_LAYER+0.1 //Higher than the gun itself.
	anchored = TRUE
	density = TRUE
	opacity = FALSE
	atmos_canpass = CANPASS_DENSITY
	var/obj/machinery/ship_weapon/connected
	var/is_barrel = FALSE //Ammo spawns in front of THIS dummy.

/obj/structure/ship_weapon_dummy/Initialize(mapload)
	icon_state = null
	. = ..()

/obj/structure/ship_weapon_dummy/examine(mob/user, distance, is_adjacent, infix, suffix, show_extended)
	SHOULD_CALL_PARENT(FALSE)

	if(connected)
		return connected.examine(arglist(args))
	else
		return TRUE

/obj/structure/ship_weapon_dummy/attack_hand(mob/user)
	if(connected)
		connected.attack_hand(user)

/obj/structure/ship_weapon_dummy/attackby(obj/item/attacking_item, mob/user)
	if(connected)
		connected.attackby(attacking_item, user)

/obj/structure/ship_weapon_dummy/hitby(atom/movable/hitting_atom, skipcatch, hitpush, blocked, datum/thrownthing/throwingdatum)
	if(connected)
		connected.hitby(arglist(args))
	if(ismob(hitting_atom))
		if(isliving(hitting_atom))
			var/mob/living/M = hitting_atom
			M.turf_collision(src, throwingdatum.speed)
			return

/obj/structure/ship_weapon_dummy/bullet_act(obj/projectile/hitting_projectile, def_zone, piercing_hit)
	. = ..()
	if(. != BULLET_ACT_HIT)
		return .

	connected.bullet_act(hitting_projectile)

/obj/structure/ship_weapon_dummy/ex_act(severity)
	connected.ex_act(severity)

/obj/structure/ship_weapon_dummy/Destroy()
	connected.connected_dummies -= src
	connected = null
	return ..()

/obj/structure/ship_weapon_dummy/proc/connect(var/obj/machinery/ship_weapon/SW)
	connected = SW
	SW.connected_dummies |= src
	name = SW.name
	desc = SW.desc
	if(is_barrel)
		SW.barrel = src
	for(var/obj/structure/ship_weapon_dummy/SD in orange(1, src))
		if(!SD.connected)
			SD.connect(SW)

// Ship Weapon Barrel Dummy
/obj/structure/ship_weapon_dummy/barrel
	name = "ship weapon barrel dummy"
	icon_state = "dummy_barrel"
	is_barrel = TRUE

// ^^
//Cardinal variants of the "ship weapon barrel dummy" intentionally left out since ship guns only face south and thus only fire south.

/obj/machinery/computer/ship/targeting/cockpit
	density = 0
	icon = 'icons/obj/cockpit_console.dmi'
	icon_state = "left"
	icon_screen = "targeting"
	icon_keyboard = null
	circuit = null

