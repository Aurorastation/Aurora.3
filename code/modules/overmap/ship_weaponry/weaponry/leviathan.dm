/datum/ship_weapon/leviathan
	name = "leviathan zero-point artillery spatial emitter"
	desc = "The Leviathan's exact construction date is not known, but it surfaced for the first time on the SCCV Horizon. The lack of any branding on it leads most to think that it was built by the SCC as a joint project, and its specifics are currently unknown. \
			Zero-point artillery technology is, in a nutshell, the condensation of ludicrous amounts of energy into a zero-point field, which is then collapsed to create a beam capable of destroying just about anything. The Leviathan is untested on planetary grounds."
	projectile_type = /obj/item/projectile/ship_ammo/leviathan
	caliber = SHIP_CALIBER_ZTA
	firing_effects = FIRING_EFFECT_FLAG_THROW_MOBS|FIRING_EFFECT_FLAG_EXTREMELY_LOUD
	screenshake_type = SHIP_GUN_SCREENSHAKE_ALL_MOBS

/obj/machinery/ship_weapon/leviathan
	weapon = /datum/ship_weapon/leviathan
	icon = 'icons/obj/machines/ship_guns/leviathan.dmi'
	icon_state = "weapon_base"

/obj/item/projectile/ship_ammo/leviathan
	name = "zero-point artillery beam"
	desc = "You should run."
	icon_state = "pulse"
	damage = 10000
	armor_penetration = 1000
	penetrating = 100

	muzzle_type = /obj/effect/projectile/muzzle/pulse
	tracer_type = /obj/effect/projectile/tracer/pulse
	impact_type = /obj/effect/projectile/impact/pulse

/obj/item/projectile/ship_ammo/leviathan/on_hit(atom/target, blocked, def_zone, is_landmark_hit)
	explosion(target, 3, 3, 3)
	if(ismob(target))
		var/mob/M = target
		M.visible_message(SPAN_DANGER("<font size=6>[M] evaporates as they are engulfed by the beam!</font>"))
		M.dust()
		return
	if(!QDELETED(target) || !QDELING(target))
		qdel(target)
	. = ..()
