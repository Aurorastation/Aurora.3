/obj/machinery/ship_weapon/francisca
	name = "francisca rotary gun"
	desc = "A Kumar Arms rotary gun developed in 2461. While its barrels may be smaller than its significantly larger kin's, the Longbow's, don't let that fool you: this gun will shred through smaller ships."
	icon = 'icons/obj/machines/ship_guns/francisca.dmi'
	heavy_firing_sound = 'sound/weapons/gunshot/ship_weapons/rotary_fire.ogg'
	icon_state = "weapon_base"
	max_ammo = 3
	projectile_type = /obj/item/projectile/ship_ammo/francisca
	caliber = SHIP_CALIBER_40MM
	screenshake_type = SHIP_GUN_SCREENSHAKE_SCREEN

/obj/machinery/ammunition_loader/francisca
	name = "francisca ammunition loader"

/obj/item/ship_ammunition/francisca
	name = "40mm FMJ ammunition box"
	name_override = "40mm FMJ burst"
	desc = "A box of FMJ bullets for use in a Francisca rotary gun."
	icon = 'icons/obj/guns/ship/ship_ammo_rotary.dmi'
	icon_state = "box_fmj"
	overmap_icon_state = "cannon_salvo"
	impact_type = SHIP_AMMO_IMPACT_FMJ
	ammunition_flags = SHIP_AMMO_FLAG_INFLAMMABLE|SHIP_AMMO_FLAG_VERY_HEAVY|SHIP_AMMO_FLAG_INFLAMMABLE
	caliber = SHIP_CALIBER_40MM
	burst = 8
	cookoff_heavy = 0

/obj/item/ship_ammunition/francisca/ap
	name = "40mm AP ammunition box"
	name_override = "40mm AP burst"
	desc = "A box of AP bullets for use in a Francisca rotary gun."
	icon_state = "box_ap"
	impact_type = SHIP_AMMO_IMPACT_AP
	projectile_type_override = /obj/item/projectile/ship_ammo/francisca/ap

/obj/item/projectile/ship_ammo/francisca
	name = "40mm FMJ bullet"
	icon_state = "small"
	damage = 50
	armor_penetration = 50
	penetrating = 2

/obj/item/projectile/ship_ammo/francisca/ap
	name = "40mm AP bullet"
	damage = 30
	armor_penetration = 100
	penetrating = 4