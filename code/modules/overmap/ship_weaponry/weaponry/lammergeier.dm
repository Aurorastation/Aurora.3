/obj/machinery/ship_weapon/lammergeier
	name = "ZA-98/5 200mm typhoon naval gun"
	desc = "One of the most common naval guns produced by the Zhurong Imperial Naval Arsenal, the ZA-98/5 is the fifth revision of a gun which has proudly served the Imperial Fleet since 2398. Produced in cooperation with Zavodskoi Interstellar, the ZA-98/5 features and updates reloading mechanism and further improvements to the ballistic profile of its shots. This naval gun is commonly seen on Imperial Fleet corvettes and frigates as their main armament, and is often seen on larger Fleet vessels as a secondary armament to support larger weaponry. It is easily capable of destroying a smaller vessel if the Goddess ensures its shot flies true."
	icon = 'icons/obj/machines/ship_guns/lammergeier.dmi'
	icon_state = "weapon_base"
	projectile_type = /obj/item/projectile/ship_ammo/lammergeier

	heavy_firing_sound = 'sound/weapons/railgun.ogg'
	firing_effects = FIRING_EFFECT_FLAG_EXTREMELY_LOUD
	screenshake_type = SHIP_GUN_SCREENSHAKE_ALL_MOBS
	caliber = SHIP_CALIBER_200MM

/obj/item/ship_ammunition/lammergeier
	name = "200mm shell"
	name_override = "200mm cannon shell"
	desc = "A typhoon cannon shell."
	icon = 'icons/obj/guns/ship/ship_ammo_lammergeier.dmi'
	icon_state = "shell_ap"
	caliber = SHIP_CALIBER_200MM
	overmap_icon_state = "cannon"
	impact_type = SHIP_AMMO_IMPACT_HE

/obj/item/projectile/ship_ammo/lammergeier
	name = "typhoon shell"
	icon_state = "heavy"
	damage = 10000
	armor_penetration = 1000
	penetrating = 1

/obj/item/projectile/ship_ammo/lammergeier/on_hit(atom/target, blocked, def_zone, is_landmark_hit)
	. = ..()
	if(ismob(target))
		var/mob/M = target
		M.visible_message(SPAN_DANGER("<font size=5>\The [src] blows [M]'s chest apart and punches straight through!</font>"))
	if(isturf(target) || isobj(target))
		explosion(target, 4, 6, 8)

/obj/machinery/ammunition_loader/lammergeier
	name = "typhoon cannon loader"