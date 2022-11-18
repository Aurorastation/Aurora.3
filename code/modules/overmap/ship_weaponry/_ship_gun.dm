/obj/machinery/ship_weapon
	name = "ship weapon"
	desc = "You shouldn't be seeing this."
	icon = 'icons/obj/machines/ship_guns/longbow.dmi'
	idle_power_usage = 1500
	active_power_usage = 50000
	anchored = TRUE
	density = TRUE
	var/damage = 0
	var/max_damage = 1000
	var/heavy_firing_sound = 'sound/weapons/gunshot/ship_weapons/120mm_mortar.ogg' //The sound in the immediate firing area. Very loud.
	var/light_firing_sound = 'sound/effects/explosionfar.ogg' //The sound played when you're a few walls away. Kind of loud.
	var/projectile_type = /obj/item/projectile/ship_ammo
	var/special_firing_mechanism = FALSE //If set to TRUE, the gun won't show up on normal controls.
	var/charging_sound //The sound played when the gun is charging up.
	var/caliber = SHIP_CALIBER_NONE
	var/use_ammunition = TRUE //If we use physical ammo or not. Note that the creation of ammunition in pre_fire() is still REQUIRED! 
							  //This just skips the initial check for ammunition.
	var/list/obj/item/ship_ammunition/ammunition = list()
	var/ammo_per_shot = 1
	var/max_ammo = 1
	var/firing_effects
	var/screenshake_type = SHIP_GUN_SCREENSHAKE_SCREEN
	var/firing = FALSE //Helper variable in case we need to track if we're firing or not. Must be set manually. Used for the Leviathan.
	var/load_time = 5 SECONDS
	var/mobile_platform = FALSE //When toggled, targeting computers will be able to force ammunition heading direction. Used for guns on visitables.

	var/weapon_id //Used to identify a gun in the targeting consoles and connect weapon systems to the relevant ammunition loader. Must be unique!
	var/list/obj/structure/ship_weapon_dummy/connected_dummies = list()
	var/obj/structure/ship_weapon_dummy/barrel

/obj/machinery/ship_weapon/Initialize(mapload)
	..()
	appearance_flags &= ~TILE_BOUND //NOT BOUND BY ANY LIMITS
	return INITIALIZE_HINT_LATELOAD

/obj/machinery/ship_weapon/LateInitialize()
	SSshuttle.weapons_to_initialize += src
	if(SSshuttle.init_state == SS_INITSTATE_DONE)
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

/obj/machinery/ship_weapon/proc/get_damage_description()
	var/ratio = (damage / max_damage) * 100
	switch(ratio)
		if(1 to 10)
			. = "It looks to be in tip top shape."
		if(10 to 20)
			. = "It has some kinks and bends here and there."
		if(20 to 40)
			. = "It has a few holes through which you can see some machinery."
		if(40 to 60)
			. = "<span class='warning'>Some fairly important parts are missing... but it should work anyway.</span>"
		if(60 to 80)
			. = "<span class='danger'>It needs repairs direly. Both aiming and firing components are missing or broken. It has a lot of holes, too. It definitely wouldn't \
				pass inspection.</span>"
		if(90 to 100)
			. = "<span class='danger'>It's falling apart! Just touching it might make the whole thing collapse!</span>"
		else //At roundstart, weapons start with 0 damage, so it'd be 0 / 1000 * 100 -> 0
			return "It looks to be in tip top shape and not damaged at all."

/obj/machinery/ship_weapon/examine(mob/user)
	. = ..()
	to_chat(user, get_damage_description())

/obj/machinery/ship_weapon/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/device/multitool))
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
	if(istype(W, /obj/item/weldingtool) && damage)
		var/obj/item/weldingtool/WT = W
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
		for(var/mob/living/carbon/human/H in player_list)
			if(H.z in connected_z_levels)
				sound_to(H, sound(heavy_firing_sound, volume = 50))
				if(H.is_listening())
					H.adjustEarDamage(rand(0, 5), 2, TRUE)
	else if(firing_effects & FIRING_EFFECT_FLAG_SILENT)
		for(var/mob/living/carbon/human/H in human_mob_list)
			if(get_area(H) == get_area(src))
				sound_to(H, sound(heavy_firing_sound, volume = 50))
				if(H.is_listening())
					H.adjustEarDamage(rand(0, 5), 2, TRUE)
	else
		for(var/mob/living/carbon/human/H in human_mob_list)
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
		for(var/mob/living/carbon/human/H in human_mob_list)
			if(H.z in connected_z_levels)
				to_chat(H, SPAN_DANGER("<font size=4>Your legs buckle as the ground shakes beneath you!</font>"))
				shake_camera(H, 10, 5)
	else if(screenshake_type == SHIP_GUN_SCREENSHAKE_SCREEN)
		for(var/mob/living/carbon/human/H in human_mob_list)
			if(get_area(H) == get_area(src))
				if(!H.buckled_to)
					to_chat(H, SPAN_DANGER("<font size=4>Your legs buckle as the ground shakes beneath you!</font>"))
					shake_camera(H, 10, 5)
	if(firing_effects & FIRING_EFFECT_FLAG_THROW_MOBS)
		var/list/connected_z_levels = GetConnectedZlevels(z)
		for(var/mob/M in living_mob_list)
			if(M.z in connected_z_levels)
				if(!M.Check_Shoegrip() && !M.buckled_to)
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
	var/obj/item/projectile/ship_ammo/projectile
	if(SA.projectile_type_override)
		projectile = new SA.projectile_type_override(firing_turf)
	else
		projectile = new projectile_type(firing_turf)
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
	else if(direction_override)
		SA.heading = direction_override
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
	mouse_opacity = 2
	layer = OBJ_LAYER+0.1 //Higher than the gun itself.
	anchored = TRUE
	density = TRUE
	opacity = FALSE
	atmos_canpass = CANPASS_DENSITY
	var/obj/machinery/ship_weapon/connected
	var/is_barrel = FALSE //Ammo spawns in front of THIS dummy.

/obj/structure/ship_weapon_dummy/Initialize(mapload)
	icon_state = "dummy_inv"
	. = ..()

/obj/structure/ship_weapon_dummy/examine(mob/user)
	connected.examine(user)

/obj/structure/ship_weapon_dummy/attack_hand(mob/user)
	connected.attack_hand(user)

/obj/structure/ship_weapon_dummy/attackby(obj/item/W, mob/user)
	connected.attackby(W, user)

/obj/structure/ship_weapon_dummy/hitby(atom/movable/AM, var/speed = THROWFORCE_SPEED_DIVISOR)
	connected.hitby(AM)
	if(ismob(AM))
		if(isliving(AM))
			var/mob/living/M = AM
			M.turf_collision(src, speed)
			return

/obj/structure/ship_weapon_dummy/bullet_act(obj/item/projectile/P, def_zone)
	connected.bullet_act(P)

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

/obj/machinery/computer/ship/targeting
	name = "targeting systems console"
	desc = "A targeting systems console using Zavodskoi software."
	icon_screen = "teleport"
	icon_keyboard = "teal_key"
	light_color = LIGHT_COLOR_CYAN
	var/obj/machinery/ship_weapon/cannon
	var/selected_entrypoint
	var/platform_direction
	var/list/names_to_guns = list()
	var/list/names_to_entries = list()

/obj/machinery/computer/ship/targeting/Initialize()
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/machinery/computer/ship/targeting/LateInitialize()
	if(current_map.use_overmap && !linked)
		var/my_sector = map_sectors["[z]"]
		if(istype(my_sector, /obj/effect/overmap/visitable))
			attempt_hook_up(my_sector)

/obj/machinery/computer/ship/targeting/Destroy()
	cannon = null
	names_to_guns.Cut()
	names_to_entries.Cut()
	return ..()

/obj/machinery/computer/ship/targeting/ui_interact(mob/user)
	var/datum/vueui/ui = SSvueui.get_open_ui(user, src)
	if(!ui)
		ui = new(user, src, "machinery-gunnery", 400, 400, "Ajax Targeting Systems")
		ui.auto_update_content = TRUE
	ui.open()

/obj/machinery/computer/ship/targeting/proc/build_gun_lists()
	for(var/obj/machinery/ship_weapon/SW in linked.ship_weapons)
		if(!SW.special_firing_mechanism)
			var/gun_name = capitalize_first_letters(SW.weapon_id)
			names_to_guns[gun_name] = SW

/obj/machinery/computer/ship/targeting/vueui_data_change(list/data, mob/user, datum/vueui/ui)
	build_gun_lists()
	if(!data)
		data = list()
		if(!cannon)
			var/cannon_name = names_to_guns[1]
			cannon = names_to_guns[cannon_name]
			data["status"] = cannon.stat ? "MALFUNCTIONING" : "OK"
			data["ammunition"] = length(cannon.ammunition) ? "Loaded, [length(cannon.ammunition)] shots" : "Unloaded"
			data["caliber"] = cannon.caliber
		data["new_ship_weapon"] = capitalize_first_letters(cannon.weapon_id)
		data["entry_points"] = list()
		data["entry_point"] = null
		data["show_z_list"] = FALSE
		data["mobile_platform"] = FALSE
		data["platform_direction"] = 0
		data["selected_z"] = 0
	data["power"] = stat & (NOPOWER|BROKEN) ? FALSE : TRUE
	data["linked"] = linked ? TRUE : FALSE

	if(linked)
		data["is_targeting"] = linked.targeting ? TRUE : FALSE
		data["ship_weapons"] = list()
		for(var/name in names_to_guns)
			data["ship_weapons"] += name //Literally do not even ask me why the FUCK this is needed. I have ZERO, **ZERO** FUCKING CLUE why
										 //this piece of shit UI takes a linked list and AUTOMATICALLY decides it wants to read the fucking linked objects
										 //instead of the actual elements of the list.
		if(data["new_ship_weapon"])
			var/new_cannon = data["new_ship_weapon"]
			cannon = names_to_guns[new_cannon]
		if(cannon)
			data["status"] = cannon.stat ? "Unresponsive" : "OK"
			var/ammunition_type = null
			if(length(cannon.ammunition))
				var/obj/item/ship_ammunition/SA = cannon.ammunition[1]
				ammunition_type = capitalize_first_letters(SA.impact_type)
			data["ammunition"] = length(cannon.ammunition) ? "[ammunition_type] Loaded, [length(cannon.ammunition)] shot(s) left" : "Unloaded"
			data["caliber"] = cannon.caliber
			if(cannon.mobile_platform)
				data["mobile_platform"] = TRUE
				data["directions"] = list("NORTH", "SOUTH", "WEST", "EAST")
				platform_direction = data["platform_direction"]
		if(linked.targeting)
			data["target"] = ""
			if(istype(linked.targeting, /obj/effect/overmap/visitable))
				var/obj/effect/overmap/visitable/V = linked.targeting
				if(V.class && V.designation)
					data["target"] = "[V.class] [V.designation]"
				else
					data["target"] = capitalize_first_letters(linked.targeting.name)
				if(length(V.map_z) > 1)
					data["show_z_list"] = TRUE
					data["z_levels"] = V.map_z.Copy()
				else
					data["selected_z"] = 0
			else
				data["target"] = capitalize_first_letters(linked.targeting.name)
			data["dist"] = get_dist(linked, linked.targeting)
			data["entry_points"] = copy_entrypoints(data["selected_z"])
			if(data["entry_point"])
				selected_entrypoint = data["entry_point"]
	return data

/obj/machinery/computer/ship/targeting/Topic(href, href_list)
	var/datum/vueui/ui = href_list["vueui"]
	if(!istype(ui))
		return
	if(..())
		return

	playsound(src, clicksound, clickvol)
	
	if(href_list["fire"])
		var/obj/effect/landmark/LM
		if(!selected_entrypoint)
			return
		if(!istype(linked.loc, /turf/unsimulated/map))
			to_chat(usr, SPAN_WARNING("The safeties are engaged! You need to be undocked in order to fire."))
			return
		if(selected_entrypoint == SHIP_HAZARD_TARGET || !selected_entrypoint)
			LM = null
		else
			LM = names_to_entries[selected_entrypoint]
		var/result = cannon.firing_command(linked.targeting, LM, platform_direction ? text2dir(platform_direction) : 0)
		if(isliving(usr) && !isAI(usr) && usr.Adjacent(src))
			visible_message(SPAN_WARNING("[usr] presses the fire button!"))
			playsound(src, 'sound/machines/compbeep1.ogg')
		switch(result)
			if(SHIP_GUN_ERROR_NO_AMMO)
				to_chat(usr, SPAN_WARNING("The console shows an error screen: the weapon isn't loaded!"))
			if(SHIP_GUN_FIRING_SUCCESSFUL)
				to_chat(usr, SPAN_WARNING("The console shows a positive message: firing sequence successful!"))
				log_and_message_admins("[usr] has fired [cannon] with target [linked.targeting] and entry point [LM]!", location = get_turf(usr))
	
	if(href_list["viewing"])
		if(usr)
			viewing_overmap(usr) ? unlook(usr) : look(usr)

/obj/machinery/computer/ship/targeting/proc/copy_entrypoints(var/z_level_filter = 0)
	. = list()
	if(istype(linked.targeting, /obj/effect/overmap/visitable))
		var/obj/effect/overmap/visitable/V = linked.targeting
		if(V.targeting_flags & TARGETING_FLAG_ENTRYPOINTS)
			for(var/obj/effect/O in V.entry_points)
				if(!z_level_filter || (z_level_filter && O.z == z_level_filter))
					. += capitalize_first_letters(O.name)
					names_to_entries[capitalize_first_letters(O.name)] = O
		if(V.targeting_flags & TARGETING_FLAG_GENERIC_WAYPOINTS)
			for(var/obj/effect/O in V.generic_waypoints)
				. += capitalize_first_letters(O.name)
				names_to_entries[capitalize_first_letters(O.name)] = O
		. = sortList(.)
	if(!length(.))
		. += SHIP_HAZARD_TARGET //No entrypoints == hazard