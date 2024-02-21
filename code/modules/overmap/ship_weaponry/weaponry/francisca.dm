/obj/machinery/ship_weapon/francisca
	name = "francisca rotary gun"
	desc = "A Kumar Arms rotary gun developed in 2461. While its barrels may be smaller than its significantly larger kin's, the Longbow's, don't let that fool you: this gun will shred through smaller ships."
	icon = 'icons/obj/machinery/ship_guns/francisca.dmi'
	heavy_firing_sound = 'sound/weapons/gunshot/ship_weapons/rotary_fire.ogg'
	icon_state = "weapon_base"
	max_ammo = 3
	projectile_type = /obj/item/projectile/ship_ammo/francisca
	caliber = SHIP_CALIBER_40MM
	screenshake_type = SHIP_GUN_SCREENSHAKE_SCREEN

/obj/machinery/ship_weapon/francisca/compact//Franky but small, for shuttles with very little space
	name = "compact francisca rotary gun"
	icon = 'icons/obj/machinery/ship_guns/francisca_compact.dmi'

/obj/machinery/ammunition_loader/francisca
	name = "francisca ammunition loader"

/obj/item/ship_ammunition/francisca
	name = "40mm FMJ ammunition box"
	name_override = "40mm FMJ burst"
	desc = "A box of FMJ shells for use in a Francisca rotary gun."
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
	desc = "A box of AP shells for use in a Francisca rotary gun."
	icon_state = "box_ap"
	impact_type = SHIP_AMMO_IMPACT_AP
	projectile_type_override = /obj/item/projectile/ship_ammo/francisca/ap

/obj/item/ship_ammunition/francisca/frag
	name = "40mm fragmentation ammunition box"
	name_override = "40mm FRAG burst"
	desc = "A box of fragmentation shells for use in a Francisca rotary gun."
	icon_state = "box_inc"
	impact_type = SHIP_AMMO_IMPACT_HE
	projectile_type_override = /obj/item/projectile/ship_ammo/francisca/frag

/obj/item/projectile/ship_ammo/francisca
	name = "40mm FMJ shell"
	icon_state = "small"
	damage = 50
	armor_penetration = 50
	penetrating = 2

/obj/item/projectile/ship_ammo/francisca/ap
	name = "40mm AP shell"
	damage = 30
	armor_penetration = 100
	penetrating = 4

/obj/item/projectile/ship_ammo/francisca/frag
	name = "40mm FRAG shell"
	damage = 30
	armor_penetration = 50
	penetrating = 1

/obj/item/projectile/ship_ammo/francisca/frag/on_impact(var/atom/A)
	fragem(src, 70, 70, 1, 2, 10, 4, TRUE)
	..()
