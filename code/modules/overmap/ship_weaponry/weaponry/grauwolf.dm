/datum/ship_weapon/grauwolf
	name = "grauwolf flak battery"
	desc = "A Zavodskoi flak battery developed in 2461. While its barrels may be smaller than its significantly larger kin's, the Longbow's, don't let that fool you: this gun will shred through smaller ships."
	projectile_type = /obj/item/projectile/ship_ammo/grauwolf
	caliber = SHIP_CALIBER_72MM
	screenshake_type = SHIP_GUN_SCREENSHAKE_SCREEN

/obj/machinery/ship_weapon/grauwolf
	weapon = /datum/ship_weapon/grauwolf
	icon = 'icons/obj/machines/ship_guns/grauwolf.dmi'
	icon_state = "weapon_base"

/obj/machinery/ammunition_loader/grauwolf
	name = "grauwolf flak loader"

/obj/item/projectile/ship_ammo/grauwolf
	icon_state = "small_burst"
	damage = 100
	armor_penetration = 50
	penetrating = 0

/obj/item/projectile/ship_ammo/grauwolf/on_translate(var/turf/entry_turf, var/turf/target_turf)
	for(var/i = 1 to 4)
		var/turf/new_turf = get_random_turf_in_range(entry_turf, 7, 7, TRUE, TRUE)
		var/obj/item/projectile/ship_ammo/grauwolf/burst = new(new_turf)
		var/turf/front_turf = get_step(new_turf, dir)
		burst.dir = dir
		burst.launch_projectile(front_turf)
