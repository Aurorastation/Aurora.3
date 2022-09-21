/datum/ship_weapon/longbow
	name = "longbow cannon"
	desc = "A Zavodskoi high-velocity cannon that fires 406mm artillery rounds. Developed in 2461, this cannon truly packs a punch."
	projectile_type = /obj/item/projectile/ship_ammo/longbow
	caliber = SHIP_CALIBER_406MM
	firing_effects = FIRING_EFFECT_FLAG_EXTREMELY_LOUD
	screenshake_type = SHIP_GUN_SCREENSHAKE_SCREEN

/obj/machinery/ship_weapon/longbow
	weapon = /datum/ship_weapon/longbow
	icon_state = "weapon_base"

/obj/item/projectile/ship_ammo/longbow
	icon_state = "heavy"
	damage = 1000
	armor_penetration = 1000
	penetrating = 100

/obj/item/projectile/ship_ammo/longbow/on_hit(atom/target, blocked, def_zone)
	. = ..()
	if(ismob(target))
		var/mob/M = target
		M.visible_message(SPAN_DANGER("<font size=5>\The [src] blows [M] apart and punches straight through!</font>"))
		M.gib()