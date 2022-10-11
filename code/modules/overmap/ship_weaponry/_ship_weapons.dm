/datum/ship_weapon
	var/name = "ship artillery"
	var/desc = "You shouldn't see this."
	var/heavy_firing_sound = 'sound/weapons/gunshot/ship_weapons/120mm_mortar.ogg' //The sound in the immediate firing area. Very loud.
	var/light_firing_sound = 'sound/effects/explosionfar.ogg' //The sound played when you're a few walls away. Kind of loud.
	var/projectile_type = /obj/item/projectile/ship_ammo
	var/charging_sound //The sound played when the gun is charging up.
	var/caliber = SHIP_CALIBER_NONE
	var/use_ammunition = TRUE //If we use physical ammo or not. Note that the creation of ammunition in pre_fire() is still REQUIRED! This just skips the initial check for ammunition.
	var/firing_effects
	var/screenshake_type = SHIP_GUN_SCREENSHAKE_SCREEN
	var/ammo_per_shot = 1
	var/obj/machinery/ship_weapon/controller
	var/firing = FALSE //Helper variable in case we need to track if we're firing or not. Must be set manually. Used for the Leviathan.

/datum/ship_weapon/Destroy()
	controller = null
	return ..()

/datum/ship_weapon/proc/pre_fire(var/atom/target, var/obj/effect/landmark/landmark) //We can fire, so what do we do before that? Think like a laser charging up.
	controller.fire(target, landmark)
	on_fire()
	return TRUE

/datum/ship_weapon/proc/on_fire() //We just fired! Cool effects!
	if(firing_effects & FIRING_EFFECT_FLAG_EXTREMELY_LOUD)
		var/list/connected_z_levels = GetConnectedZlevels(controller.z)
		for(var/mob/living/carbon/human/H in player_list)
			if(H.z in connected_z_levels)
				playsound(H, heavy_firing_sound, 100)
	else if(firing_effects & FIRING_EFFECT_FLAG_SILENT)
		for(var/mob/living/carbon/human/H in get_area(controller))
			playsound(H, heavy_firing_sound, 100)
	else
		for(var/mob/living/carbon/human/H in get_area(controller))
			playsound(H, heavy_firing_sound, 100)
		var/list/connected_z_levels = GetConnectedZlevels(controller.z)
		for(var/mob/living/carbon/human/H in player_list)
			if(H.z in connected_z_levels)
				playsound(H, light_firing_sound, 50)
	if(screenshake_type == SHIP_GUN_SCREENSHAKE_ALL_MOBS)
		var/list/connected_z_levels = GetConnectedZlevels(controller.z)
		for(var/mob/living/H in living_mob_list)
			if(H.z in connected_z_levels)
				to_chat(H, SPAN_DANGER("<font size=4>Your legs buckle as the ground shakes beneath you!</font>"))
				shake_camera(H, 10, 5)
	else if(screenshake_type == SHIP_GUN_SCREENSHAKE_SCREEN)
		for(var/mob/living/carbon/human/H in get_area(controller))
			if(!H.buckled_to)
				to_chat(H, SPAN_DANGER("<font size=4>Your legs buckle as the ground shakes beneath you!</font>"))
				shake_camera(H, 10, 5)
	if(firing_effects & FIRING_EFFECT_FLAG_THROW_MOBS)
		var/list/connected_z_levels = GetConnectedZlevels(controller.z)
		for(var/mob/M in living_mob_list)
			if(M.z in connected_z_levels)
				M.throw_at_random(FALSE, 7, 10)
	flick("weapon_firing", controller)
	return TRUE