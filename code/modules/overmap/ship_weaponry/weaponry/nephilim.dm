/obj/machinery/ship_weapon/nephilim
	name = "nephilim blaster repeater"
	desc = "The Nephilim is a reliable blaster repeater produced on-contract by several factories across the spur. Seeing widespread use on both sides of the piracy epidemic in the Coalition, it has been shown to be effective and easy to maintain; two details not shared by earlier ship-mounted blaster weapons. Utilising hydrogen blaster cells, it is quicker to charge, while necessitating frequent reloads."
	icon = 'icons/obj/machinery/ship_guns/nephilim.dmi'
	heavy_firing_sound = 'sound/weapons/gunshot/bolter.ogg'
	icon_state = "weapon_base"
	max_ammo = 1
	projectile_type = /obj/projectile/ship_ammo/nephilim
	caliber = SHIP_CALIBER_BLASTER
	screenshake_type = SHIP_GUN_SCREENSHAKE_SCREEN

/obj/machinery/ammunition_loader/nephilim
	name = "nephilim ammunition loader"

/obj/item/ship_ammunition/nephilim
	name = "Blaster HE hydrogen cell"
	name_override = "Blaster HE burst"
	desc = "A hydrogen cell for use in a Nephilim blaster repeater, carefully tuned for higher damage and spread at the cost of armour penetration."
	icon = 'icons/obj/guns/ship/ship_ammo_nephilim.dmi'
	icon_state = "repeater_he"
	overmap_icon_state = "light_laser_salvo"
	impact_type = SHIP_AMMO_IMPACT_HE
	ammunition_flags = SHIP_AMMO_FLAG_INFLAMMABLE|SHIP_AMMO_FLAG_VERY_HEAVY|SHIP_AMMO_FLAG_INFLAMMABLE
	caliber = SHIP_CALIBER_BLASTER
	burst = 15
	cookoff_heavy = 0

/obj/item/ship_ammunition/nephilim/ap
	name = "Blaster AP hydrogen cell"
	name_override = "Blaster AP burst"
	desc = "A hydrogen cell for use in a Nephilim blaster repeater, carefully tuned for higher armour penetration at the cost of damage."
	icon = 'icons/obj/guns/ship/ship_ammo_nephilim.dmi'
	icon_state = "repeater_ap"
	impact_type = SHIP_AMMO_IMPACT_AP

/obj/projectile/ship_ammo/nephilim
	name = "hydrogen cell he"
	damage = 20
	armor_penetration = 20
	penetrating = 0

/obj/projectile/ship_ammo/nephilim/ap
	name = "hydrogen cell ap"
	damage = 10
	armor_penetration = 25
	penetrating = 4
