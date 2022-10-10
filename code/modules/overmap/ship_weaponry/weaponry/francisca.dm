/datum/ship_weapon/francisca
	name = "francisca rotary gun"
	desc = "A Zavodskoi rotary gun developed in 2461. While its barrels may be smaller than its significantly larger kin's, the Longbow's, don't let that fool you: this gun will shred through smaller ships."
	projectile_type = /obj/item/projectile/ship_ammo/francisca
	caliber = SHIP_CALIBER_90MM
	screenshake_type = SHIP_GUN_SCREENSHAKE_SCREEN

/obj/machinery/ship_weapon/francisca
	weapon = /datum/ship_weapon/francisca
	icon = 'icons/obj/machines/ship_guns/francisca.dmi'
	icon_state = "weapon_base"

/obj/machinery/ammunition_loader/francisca
	name = "francisca ammunition loader"

/obj/item/projectile/ship_ammo/francisca
	icon_state = "small"
	damage = 250
	armor_penetration = 100
	penetrating = 2
