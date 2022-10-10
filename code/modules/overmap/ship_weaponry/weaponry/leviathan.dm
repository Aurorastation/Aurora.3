/datum/ship_weapon/leviathan
	name = "leviathan zero-point artillery spatial emitter"
	desc = "The Leviathan's exact construction date is not known, but it surfaced for the first time on the SCCV Horizon. The lack of any branding on it leads most to think that it was built by the SCC as a joint project, and its specifics are currently unknown. \
			Zero-point artillery technology is, in a nutshell, the condensation of ludicrous amounts of energy into a zero-point field, which is then collapsed to create a beam capable of destroying just about anything. The Leviathan is untested on planetary grounds."
	projectile_type = /obj/item/projectile/ship_ammo/leviathan
	use_ammunition = FALSE
	heavy_firing_sound = 'sound/weapons/gunshot/ship_weapons/leviathan_fire.ogg'
	caliber = SHIP_CALIBER_ZTA
	firing_effects = FIRING_EFFECT_FLAG_THROW_MOBS|FIRING_EFFECT_FLAG_EXTREMELY_LOUD
	screenshake_type = SHIP_GUN_SCREENSHAKE_ALL_MOBS

/datum/ship_weapon/leviathan/pre_fire(atom/target, obj/effect/landmark/landmark)
	controller.icon_state = "weapon_on"
	controller.use_power_oneoff(1)
	controller.visible_message(SPAN_WARNING("<font size=5>\The [controller] begins lighting up with a powerful hum...</font>"))
	for(var/mob/M in range(10, controller))
		shake_camera(M, 10 SECONDS, 3)
	playsound(controller, 'sound/weapons/gunshot/ship_weapons/leviathan_chargeup.ogg', 200, is_global = TRUE)
	sleep(7 SECONDS)
	flick("weapon_charge", controller)
	sleep(3 SECOND)
	var/obj/item/ship_ammunition/leviathan/L = new()
	controller.ammunition |= L
	if(!controller.stat)
		controller.visible_message(SPAN_DANGER("<font size=6>\The [controller] fires, quaking the ground below you!</font>"))
		. = ..()
	controller.update_use_power(POWER_USE_OFF)

/obj/item/ship_ammunition/leviathan
	name = "zero-point artillery beam"
	caliber = SHIP_CALIBER_ZTA
	impact_type = SHIP_AMMO_IMPACT_ZTA
	overmap_icon_state = "heavy_pulse"

/obj/machinery/ship_weapon/leviathan
	weapon = /datum/ship_weapon/leviathan
	icon = 'icons/obj/machines/ship_guns/leviathan.dmi'
	icon_state = "weapon_off"
	layer = ABOVE_MOB_LAYER
	use_power = POWER_USE_OFF //Start off.
	idle_power_usage = 100 KILOWATTS
	active_power_usage = 1000 MEGAWATTS

/obj/machinery/ship_weapon/leviathan/power_change()
	. = ..()
	if(stat & NOPOWER && (use_power != POWER_USE_OFF))
		disable()

/obj/machinery/ship_weapon/leviathan/update_use_power(new_use_power)
	. = ..()
	if(new_use_power == POWER_USE_OFF && (use_power != POWER_USE_OFF))
		disable()

/obj/machinery/ship_weapon/leviathan/proc/disable()
	visible_message(SPAN_WARNING("<font size=4>\The [src]'s humming comes to an abrupt halt.</font>"))
	update_use_power(POWER_USE_OFF)
	icon_state = "weapon_off"

/obj/machinery/ship_weapon/leviathan/proc/enable()
	visible_message(SPAN_WARNING("<font size=4>\The [src] lights up with a powerful hum...</font>"))
	update_use_power(POWER_USE_IDLE)
	icon_state = "weapon_on"

/obj/item/projectile/ship_ammo/leviathan
	name = "zero-point artillery beam"
	desc = "A concentrated stream of pure energy."
	icon_state = "pulse"
	damage = 10000
	armor_penetration = 1000
	penetrating = 100

	muzzle_type = /obj/effect/projectile/muzzle/pulse
	tracer_type = /obj/effect/projectile/tracer/pulse
	impact_type = /obj/effect/projectile/impact/pulse

/obj/item/projectile/ship_ammo/leviathan/on_hit(atom/target, blocked, def_zone, is_landmark_hit)
	if(ismob(target))
		var/mob/M = target
		M.visible_message(SPAN_DANGER("<font size=6>[M] evaporates as they are engulfed by the beam!</font>"))
		M.dust()
		return
	explosion(target, 3, 3, 3)
	if(!QDELING(target) || !QDELETED(target))
		qdel(target)
	return	

/obj/machinery/zta_lever
	name = "lever"
	desc = "An old-style lever that couples the Leviathan's accelerators. <span class='danger'>Flicking this will cause extreme power usage!</span>"
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

/obj/machinery/zta_lever/attack_hand(mob/user)
	if(use_check_and_message(user) && !stat)
		if(do_after(user, 1 SECOND))
			visible_message(SPAN_DANGER("[user] pulls \the [src] [toggled ? "up" : "down"]!"))
			toggled = !toggled
			switch(toggled)
				if(FALSE)
					ZTA.disable()
				if(TRUE)
					ZTA.enable()
