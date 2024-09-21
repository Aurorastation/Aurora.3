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
	name = "60mm AP shell bundle"
	name_override = "60mm AP burst"
	desc = "A bundle of armour-piercing shells for use in a heavy autocannon emplacement. These are non-explosive, designed to penetrate deep inside their targets without causing heavy structural damage. An impact from such a shell to an enemy crewman is likely to be fatal."
	icon = 'icons/obj/guns/ship/ship_ammo_autocannon.dmi'
	icon_state = "autocannon_ap"
	overmap_icon_state = "cannon_salvo"
	impact_type = SHIP_AMMO_IMPACT_AP
	ammunition_flags = SHIP_AMMO_FLAG_INFLAMMABLE|SHIP_AMMO_FLAG_VERY_HEAVY
	caliber = SHIP_CALIBER_60MM
	burst = 5
	cookoff_heavy = 0
	projectile_type_override = /obj/projectile/ship_ammo/autocannon

/obj/item/ship_ammunition/autocannon/he
	name = "60mm HE shell bundle"
	name_override = "60mm HE burst"
	desc = "A bundle of high-explosive shells for use in a heavy autocannon emplacement. These explode on impact with the hull of their targets, making them effective at causing heavy structural damage while reducing their ability to impact deep inside enemy ships."
	icon = 'icons/obj/guns/ship/ship_ammo_autocannon.dmi'
	icon_state = "autocannon_he"
	overmap_icon_state = "cannon_salvo"
	impact_type = SHIP_AMMO_IMPACT_HE
	ammunition_flags = SHIP_AMMO_FLAG_INFLAMMABLE|SHIP_AMMO_FLAG_VERY_HEAVY|SHIP_AMMO_FLAG_VULNERABLE // More fragile than AP.
	caliber = SHIP_CALIBER_60MM
	burst = 5
	cookoff_heavy = 1
	projectile_type_override = /obj/projectile/ship_ammo/autocannon/he

/obj/projectile/ship_ammo/autocannon
	name = "60mm AP shell"
	icon_state = "small"
	damage = 100
	armor_penetration = 60
	penetrating = 2

/obj/projectile/ship_ammo/autocannon/he
	name = "60mm HE shell"
	icon_state = "small"
	damage = 80
	armor_penetration = 30
	penetrating = 0 // Explodes on the hull.

/obj/projectile/ship_ammo/autocannon/on_hit(atom/target, blocked, def_zone, is_landmark_hit)
	. = ..()
	if(ammo && ammo.impact_type == SHIP_AMMO_IMPACT_HE)
		explosion(target, 0, 2, 3)
	else
		explosion(target, 0, 1, 2)
