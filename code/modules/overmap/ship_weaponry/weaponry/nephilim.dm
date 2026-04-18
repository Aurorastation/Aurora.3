/obj/machinery/ship_weapon/nephilim
	name = "nephilim blaster repeater"
	desc = "The Nephilim is a reliable blaster repeater produced on-contract by several factories across the spur. Seeing widespread use on both sides of the piracy epidemic in the Coalition, it has been shown to be effective and easy to maintain; two details not shared by earlier ship-mounted blaster weapons. Utilising hydrogen blaster cells, it is quicker to charge, while necessitating frequent reloads."
	icon = 'icons/obj/machinery/ship_guns/nephilim.dmi'
	icon_state = "weapon_base"
	idle_power_usage = 1500
	active_power_usage = 100000
	max_ammo = 1
	projectile_type = /obj/projectile/ship_ammo/nephilim
	caliber = SHIP_CALIBER_BLASTER
	screenshake_type = SHIP_GUN_SCREENSHAKE_SCREEN


/obj/machinery/ship_weapon/nephilim/pre_fire(/atom/target, /obj/effect/landmark/landmark)
	for(var/mob/M in GLOB.living_mob_list)
		if(AreConnectedZLevels(GET_Z(M), z))
			sound_to(M, sound('sound/weapons/gunshot/ship_weapons/gatling_laser.ogg'))
	flick("weapon_charging", src)
	sleep(1.1 SECONDS)
	. = ..()

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
	icon = 'icons/obj/guns/ship/physical_projectiles.dmi'
	icon_state = "blaster_burst"
	damage = 40
	armor_penetration = 40
	penetrating = 0


/obj/projectile/ship_ammo/nephilim/ap
	name = "hydrogen cell ap"
	damage = 20
	armor_penetration = 100
	penetrating = 4

/obj/projectile/ship_ammo/nephilim/he/on_hit(atom/target, blocked, def_zone, is_landmark_hit)
	. = ..()
	explosion(target, 0, 2, 3)
