/obj/machinery/ship_weapon/leviathan
	name = "leviathan zero-point artillery"
	desc = "A hulking structure made up by an insane amount of moving parts, components and capacitors. It has no branding besides the \"ZAT\" inscription on the sides."
	icon = 'icons/obj/machines/ship_guns/leviathan.dmi'
	icon_state = "weapon_off"

	projectile_type = /obj/item/projectile/ship_ammo/leviathan
	use_ammunition = FALSE
	heavy_firing_sound = 'sound/weapons/gunshot/ship_weapons/leviathan_fire.ogg'
	caliber = SHIP_CALIBER_ZTA
	firing_effects = FIRING_EFFECT_FLAG_THROW_MOBS|FIRING_EFFECT_FLAG_EXTREMELY_LOUD
	screenshake_type = SHIP_GUN_SCREENSHAKE_ALL_MOBS
	layer = ABOVE_MOB_LAYER

	use_power = POWER_USE_OFF //Start off.
	idle_power_usage = 50 KILOWATTS
	active_power_usage = 100 KILOWATTS
	var/obj/machinery/power/smes/superconducting/smes

/obj/machinery/ship_weapon/leviathan/Destroy()
	smes = null
	return ..()
	
/obj/machinery/ship_weapon/leviathan/LateInitialize()
	. = ..()
	couple_to_smes()

/obj/machinery/ship_weapon/leviathan/firing_checks()
	if(use_power == POWER_USE_OFF)
		return FALSE
	if(!istype(smes))
		return FALSE
	. = ..()

/obj/machinery/ship_weapon/leviathan/pre_fire(atom/target, obj/effect/landmark/landmark)
	firing = TRUE
	icon_state = "weapon_on"
	visible_message(SPAN_DANGER("<font size=5>\The [src] begins lighting up with a powerful hum...</font>"))
	for(var/mob/M in living_mob_list)
		if(AreConnectedZLevels(GET_Z(M), z))
			if(get_area(M) != get_area(src))
				to_chat(M, SPAN_DANGER("<font size=4>The ground below you starts shaking...</font>"))
			sound_to(M, sound('sound/weapons/gunshot/ship_weapons/leviathan_chargeup.ogg'))
	var/power_draw = smes.draw_power(active_power_usage)
	if(power_draw >= active_power_usage)
		sleep(7 SECONDS)
		var/obj/item/ship_ammunition/leviathan/L = new()
		ammunition |= L
		if(!stat)
			flick("weapon_charge", src)
			visible_message(SPAN_DANGER("<font size=6>\The [src] fires, quaking the ground below you!</font>"))
			for(var/mob/M in living_mob_list)
				if(AreConnectedZLevels(M.z, z) && (get_area(M) != get_area(src)))
					to_chat(M, SPAN_DANGER("<font size=4>A gigantic shock courses through the hull of the ship!</font>"))
			. = ..()
	disable()
	firing = FALSE

/obj/machinery/ship_weapon/leviathan/process()
	if(firing)
		for(var/mob/M in living_mob_list)
			if(AreConnectedZLevels(GET_Z(M), z))
				shake_camera(M, 3, 3)

/obj/machinery/ship_weapon/leviathan/power_change()
	. = ..()
	if((stat & NOPOWER) && .)
		disable()

/obj/machinery/ship_weapon/leviathan/update_use_power(new_use_power)
	. = ..()
	if(new_use_power == POWER_USE_OFF && (use_power != POWER_USE_OFF))
		disable()

/obj/machinery/ship_weapon/leviathan/disable()
	visible_message(SPAN_WARNING("<font size=4>\The [src]'s humming comes to an abrupt halt.</font>"))
	update_use_power(POWER_USE_OFF)
	icon_state = "weapon_off"

/obj/machinery/ship_weapon/leviathan/enable()
	visible_message(SPAN_WARNING("<font size=4>\The [src] lights up with a powerful hum...</font>"))
	update_use_power(POWER_USE_IDLE)
	icon_state = "weapon_on"

/obj/machinery/ship_weapon/leviathan/proc/couple_to_smes()
	for(var/obj/machinery/power/smes/superconducting/S in get_area(src))
		if(istype(S))
			smes = S
			break

/obj/item/ship_ammunition/leviathan
	name = "zero-point artillery beam"
	desc = "A beam of pure energy."
	caliber = SHIP_CALIBER_ZTA
	impact_type = SHIP_AMMO_IMPACT_ZTA
	overmap_icon_state = "heavy_pulse"

/obj/item/projectile/ship_ammo/leviathan
	name = "zero-point artillery beam"
	desc = "A concentrated stream of pure energy."
	icon_state = "pulse"
	damage = 10000
	armor_penetration = 1000
	penetrating = 100
	hitscan = TRUE

	muzzle_type = /obj/effect/projectile/muzzle/pulse
	tracer_type = /obj/effect/projectile/tracer/pulse
	impact_type = /obj/effect/projectile/impact/pulse

/obj/item/projectile/ship_ammo/leviathan/on_hit(atom/target, blocked, def_zone, is_landmark_hit)
	if(ismob(target))
		var/mob/M = target
		M.visible_message(SPAN_DANGER("<font size=6>[M] evaporates as they are engulfed by the beam!</font>"))
		M.dust()
		return
	explosion(target, 6, 6, 6)

/obj/item/projectile/ship_ammo/leviathan/check_penetrate(atom/A)
	on_hit(A)
	return TRUE

/obj/machinery/zta_lever
	name = "activation lever"
	desc = "An old-style lever that couples the Leviathan's capacitors. <span class='danger'>Flicking this will cause extreme power usage!</span>"
	icon = 'icons/obj/power.dmi'
	icon_state = "lever1"
	var/obj/machinery/ship_weapon/leviathan/ZTA
	var/toggled = FALSE

/obj/machinery/zta_lever/Initialize(mapload, d, populate_components, is_internal)
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/machinery/zta_lever/LateInitialize()
	for(var/obj/machinery/ship_weapon/leviathan/cannon in get_area(src))
		ZTA = cannon
		break

/obj/machinery/zta_lever/Destroy()
	ZTA = null
	return..()

/obj/machinery/zta_lever/attack_hand(mob/user)
	if(!use_check_and_message(user, USE_DISALLOW_SILICONS) && !stat)
		if(do_after(user, 1 SECOND))
			visible_message(SPAN_DANGER("[user] pulls \the [src] [toggled ? "up" : "down"]!"))
			toggled = !toggled
			switch(toggled)
				if(FALSE)
					flick("lever3", src)
					ZTA.disable()
					sleep(2)
					icon_state = "lever1"
				if(TRUE)
					flick("lever2", src)
					ZTA.enable()
					sleep(2)
					icon_state = "lever_down"
			playsound(src, 'sound/effects/spring.ogg', 100)