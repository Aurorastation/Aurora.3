/obj/machinery/ship_weapon/grauwolf
	name = "grauwolf flak battery"
	desc = "A Kumar Arms flak battery developed in 2461 as part of the same <i>\"Chivalry\"</i> line of the Longbow. Its barrels may look smaller than its significantly larger kin's, \
			but don't let that fool you: this gun will shred through smaller ships."
	icon = 'icons/obj/machines/ship_guns/grauwolf.dmi'
	heavy_firing_sound = 'sound/weapons/gunshot/ship_weapons/flak_fire.ogg'
	icon_state = "weapon_base"
	max_ammo = 5
	caliber = SHIP_CALIBER_90MM
	screenshake_type = SHIP_GUN_SCREENSHAKE_SCREEN

/obj/machinery/ammunition_loader/grauwolf
	name = "grauwolf flak loader"

/obj/item/ship_ammunition/grauwolf_bundle
	name = "grauwolf flak bundle"
	desc = "A bundle of high-explosive flak shells."
	icon = 'icons/obj/guns/ship/ship_ammo_flakbox.dmi'
	icon_state = "bundle_he"
	overmap_icon_state = "flak"
	caliber = SHIP_CALIBER_90MM
	ammunition_behaviour = SHIP_AMMO_BEHAVIOUR_DUMBFIRE
	projectile_type_override = /obj/item/projectile/ship_ammo/grauwolf
	burst = 4

/obj/item/ship_ammunition/grauwolf_bundle/ap
	name = "grauwolf armor-piercing flak bundle"
	desc = "A bundle of armor-piercing flak shells."
	icon_state = "bundle_ap"
	impact_type = SHIP_AMMO_IMPACT_AP
	projectile_type_override = /obj/item/projectile/ship_ammo/grauwolf/ap

/obj/item/projectile/ship_ammo/grauwolf
	name = "high-explosive flak"
	icon_state = "small_burst"
	damage = 100
	armor_penetration = 50
	penetrating = 0

/obj/item/projectile/ship_ammo/grauwolf/on_hit(atom/target, blocked, def_zone, is_landmark_hit)
	. = ..()
	if(ammo.impact_type == SHIP_AMMO_IMPACT_HE)
		explosion(target, 0, 2, 4)
	else
		explosion(target, 0, 1, 2)

/obj/item/projectile/ship_ammo/grauwolf/ap
	name = "armor-piercing flak"
	damage = 50
	armor_penetration = 50
	penetrating = 2