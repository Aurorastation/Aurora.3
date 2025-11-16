/obj/machinery/ship_weapon/coilgun
	name = "M55A2 Coilgun"
	desc = "A venerable mainstay of the Solarian Navy's arsenal and the prime reason of why Issac Newton is still the deadliest human in the Spur. The M55A2 is capable of firing rifled tungsten rods the size of flagpoles at supersonic speeds. Despite it's lackluster performance against a well-armored ship of the line, it's ability to seriously damage any smaller vessel with a few well-aimed shots has earned the platform's ubiqutous status in the Alliance's 100 fleets."
	desc_extended = "Originally desgined just before the outbreak of the Interstellar War, the M55 series of Intermediate Coilgun have seen extensive service from the battles over Gadpathur and Xanu to the actions of the First invasion of Tau Ceti with the M55A1. However, in spite of the A1 variant's significant advancements in percision and ease of use, the M55's greatest hour was arguably in the discord and chaos of the Solarian Civil War. With the faster-firing and much easier to produce M55A2 being used by all sides of the conflict. Tried and tested on the warlord-infested ruins of Southern Sol and over the smoldering battlefields of San Colette, the M55A2 still remains the 'workhorse gun' of the Solarian Navy to this day. It is mostly used as a primary armament (either on turret mounts or fixed in fore-facing casemates) aboard escort vessels. And on secondary turret mounts aboard a ship of the line. "
	icon = 'icons/obj/machinery/ship_guns/sol_coilgun.dmi'
	icon_state = "weapon_base"
	projectile_type = /obj/projectile/ship_ammo/coilgun

	heavy_firing_sound = 'sound/weapons/railgun.ogg'
	firing_effects = FIRING_EFFECT_FLAG_EXTREMELY_LOUD
	screenshake_type = SHIP_GUN_SCREENSHAKE_ALL_MOBS
	caliber = SHIP_CALIBER_COILGUN

/obj/item/ship_ammunition/coilgun
	name = "tungsten rod pack"
	name_override = "tungsten rod"
	desc = "A pack of rods used as ammunition for the M55A2 intermediate coilgun, if the obvious labelling and handling insturctions didn't already give it away."
	icon = 'icons/obj/ammo.dmi'
	icon_state = "trodpack-2"
	caliber = SHIP_CALIBER_COILGUN
	overmap_icon_state = "cannon"
	impact_type = SHIP_AMMO_IMPACT_AP

/obj/projectile/ship_ammo/coilgun
	name = "high-power tungsten rod"
	icon_state = "heavy"
	damage = 10000
	armor_penetration = 1000
	penetrating = 5

/obj/projectile/ship_ammo/coilgun/on_hit(atom/target, blocked, def_zone, is_landmark_hit)
	. = ..()
	if(ismob(target))
		var/mob/M = target
		M.visible_message(SPAN_DANGER("<font size=5>\The [src] blows [M]'s chest apart and punches straight through!</font>"))
	if(isturf(target) || isobj(target))
		explosion(target, 1, 2, 4)

/obj/machinery/ammunition_loader/sol
	icon_state = "ammo_loader_sol"

/obj/structure/viewport/sol
	icon_state = "viewport_sol"
