/obj/machinery/ship_weapon/autocannon
	name = "heavy autocannon"
	desc = "Big gun!"
	icon = 'icons/obj/machinery/ship_guns/autocannon.dmi'
	heavy_firing_sound = 'sound/weapons/gunshot/ship_weapons/flak_fire.ogg'
	icon_state = "weapon_base"
	max_ammo = 2
	caliber = SHIP_CALIBER_60MM
	screenshake_type = SHIP_GUN_SCREENSHAKE_SCREEN

/obj/machinery/ammunition_loader/autocannon
	name = "autocannon ammunition loader"

/obj/item/ship_ammunition/autocannon
	name = "60mm FMJ ammunition box"
	name_override = "60mm FMJ burst"
	desc = "A box of FMJ shells for use in a heavy autocannon emplacement"
	icon = 'icons/obj/guns/ship/ship_ammo_rotary.dmi'
	icon_state = "box_fmj"
	overmap_icon_state = "cannon_salvo"
	impact_type = SHIP_AMMO_IMPACT_FMJ
	ammunition_flags = SHIP_AMMO_FLAG_INFLAMMABLE|SHIP_AMMO_FLAG_VERY_HEAVY
	caliber = SHIP_CALIBER_60MM
	burst = 11
	cookoff_heavy = 0
	projectile_type_override = /obj/projectile/ship_ammo/autocannon

/obj/item/ship_ammunition/autocannon/he
	name = "60mm HE ammunition box"
	name_override = "60mm HE burst"
	desc = "A box of HE shells for use in a heavy autocannon emplacement"
	icon = 'icons/obj/guns/ship/ship_ammo_rotary.dmi'
	icon_state = "box_ap"
	overmap_icon_state = "cannon_salvo"
	impact_type = SHIP_AMMO_IMPACT_HE
	ammunition_flags = SHIP_AMMO_FLAG_INFLAMMABLE|SHIP_AMMO_FLAG_VERY_HEAVY|SHIP_AMMO_FLAG_VULNERABLE // More fragile than the FMJ.
	caliber = SHIP_CALIBER_60MM
	burst = 11
	cookoff_heavy = 0
	projectile_type_override = /obj/projectile/ship_ammo/autocannon/he

/obj/projectile/ship_ammo/autocannon
	name = "60mm FMJ shell"
	icon_state = "small"
	damage = 120
	armor_penetration = 60
	penetrating = 2

/obj/projectile/ship_ammo/autocannon/he
	name = "60mm HE shell"
	icon_state = "small"
	damage = 100
	armor_penetration = 30
	penetrating = 0 // Explodes on the hull.

/obj/projectile/ship_ammo/autocannon/he/on_hit(atom/target, blocked, def_zone, is_landmark_hit)
	. = ..()
	explosion(target, 0, 1, 3)
