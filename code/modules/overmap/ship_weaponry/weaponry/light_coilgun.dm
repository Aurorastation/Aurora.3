/obj/machinery/ship_weapon/coilgun/light
	name = "M302A7 piledriver light coilgun"
	desc = "A miniaturized version of the Solarian Navy’s coilgun platform, the M302A7 is the latest version of a weapon class that has served with honor since the Interstellar War. A semiautomatic, magazine-loaded design, it excels at applying pressure to enemy shields and hulls."
	desc_extended = "Pressed for a smaller version of a coilgun to fit onto escort craft, the Alliance contracted what was then Necropolis Industries to design and manufacture the Navy’s first coilgun for corvette use in the mid-2200s. The M2307 is a post-Interstellar War modernization of earlier models that had been steadily improved upon over time. Though phased out of use in some battlegroups in favor of the M455A1 light coilgun, it remains a common sight in many fleets."
	icon = 'icons/obj/machinery/ship_guns/sol_light_coilgun.dmi'
	icon_state = "weapon_base"
	max_ammo = 3
	projectile_type = /obj/projectile/ship_ammo/coilgun/light

	heavy_firing_sound = 'sound/weapons/railgun.ogg'
	firing_effects = FIRING_EFFECT_FLAG_EXTREMELY_LOUD
	screenshake_type = SHIP_GUN_SCREENSHAKE_ALL_MOBS
	caliber = SHIP_CALIBER_COILGUN

/obj/item/ship_ammunition/coilgun/light
	name = "light tungsten rod pack"
	name_override = "light tungsten rod"
	desc = "A pack of rods used as ammunition for a light coilgun."
	icon = 'icons/obj/ammo.dmi'
	icon_state = "trodpack-2"
	caliber = SHIP_CALIBER_COILGUN
	overmap_icon_state = "light_pulse"
	impact_type = SHIP_AMMO_IMPACT_AP

/obj/projectile/ship_ammo/coilgun/light
	name = "low-power tungsten rod"
	icon_state = "heavy"
	damage = 10000
	armor_penetration = 1000
	penetrating = 1

/obj/projectile/ship_ammo/coilgun/light/on_hit(atom/target, blocked, def_zone, is_landmark_hit)
	. = ..()
	if(ismob(target))
		var/mob/M = target
		M.visible_message(SPAN_DANGER("<font size=5>\The [src] blows [M]'s chest apart and punches straight through!</font>"))
	if(isturf(target) || isobj(target))
		explosion(target, 2, 3, 4)
