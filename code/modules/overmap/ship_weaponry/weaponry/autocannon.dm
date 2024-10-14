/obj/machinery/ship_weapon/autocannon
	name = "goshawk heavy autocannon"
	desc = "This rugged thing is a Kumar Arms Goshawk heavy autocannon, developed originally in 2456 and ubiqutous in certain circles ever since. A heavier predecessor to the later Francisca rotary gun developed some years after, this fires 60mm shells large enough to rend walls apart outright, reducing hulls to a pepppered gore of scrap metal under sustained fire. Its simplicity is only eclipsed by its efficiency, and such models are not expected to be leaving active service in both military and civilian hands anytime soon despite their advancing age."
	icon = 'icons/obj/machinery/ship_guns/autocannon.dmi'
	heavy_firing_sound = 'sound/weapons/gunshot/ship_weapons/flak_fire.ogg'
	icon_state = "weapon_base"
	max_ammo = 3
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
	burst = 11
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


/obj/item/ship_ammunition/autocannon/frag
	name = "60mm fragmentation shell bundle"
	name_override = "60mm fragmentation burst"
	desc = "A bundle of fragmentation shells for use in a heavy autocannon emplacement. These are intented to penetrate a short distance into the target before exploding in a shower of shrapnel, effective at targeting the crews of vessels."
	icon = 'icons/obj/guns/ship/ship_ammo_autocannon.dmi'
	icon_state = "autocannon_frag"
	overmap_icon_state = "cannon_salvo"
	impact_type = SHIP_AMMO_IMPACT_HE
	ammunition_flags = SHIP_AMMO_FLAG_INFLAMMABLE|SHIP_AMMO_FLAG_VERY_HEAVY
	caliber = SHIP_CALIBER_60MM
	burst = 8
	cookoff_heavy = 1
	projectile_type_override = /obj/projectile/ship_ammo/autocannon/frag

/obj/projectile/ship_ammo/autocannon
	name = "60mm AP shell"
	icon_state = "small"
	damage = 100
	armor_penetration = 60
	penetrating = 3

/obj/projectile/ship_ammo/autocannon/he
	name = "60mm HE shell"
	icon_state = "small"
	damage = 80
	armor_penetration = 30
	penetrating = 0 // Explodes on the hull.

/obj/projectile/ship_ammo/autocannon/frag
	name = "60mm fragmentation shell"
	icon_state = "small"
	damage = 60
	armor_penetration = 30
	penetrating = 2

/obj/projectile/ship_ammo/autocannon/he/on_hit(atom/target, blocked, def_zone, is_landmark_hit)
	. = ..()
	explosion(target, 0, 2, 3)

/obj/projectile/ship_ammo/autocannon/frag/on_hit(atom/target, blocked, def_zone, is_landmark_hit)
	fragem(target, 70, 70, 1, 2, 15, 5, TRUE)
	..()
