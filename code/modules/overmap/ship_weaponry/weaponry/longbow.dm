/obj/machinery/ship_weapon/longbow
	name = "longbow cannon"
	desc = "A Kumar Arms high-velocity cannon and flagship of <i>\"Chivalry\"</i> weapons line, developed in 2461 as an upgrade to its predecessor, the Ballista. Its upgrades include a bigger payload, a more streamlined loading process, and easier maintenance, making this cannon one of the best armaments in the Spur."
	icon_state = "weapon_base"

	projectile_type = /obj/item/projectile/ship_ammo/longbow
	caliber = SHIP_CALIBER_406MM
	firing_effects = FIRING_EFFECT_FLAG_EXTREMELY_LOUD
	screenshake_type = SHIP_GUN_SCREENSHAKE_ALL_MOBS

/obj/machinery/ammunition_loader/longbow
	name = "longbow shell loader"

/obj/item/projectile/ship_ammo/longbow
	icon_state = "heavy"
	damage = 1000
	armor_penetration = 1000
	var/penetrated = FALSE

/obj/item/projectile/ship_ammo/longbow/launch_projectile(atom/target, target_zone, mob/user, params, angle_override, forced_spread)
	if(ammo.impact_type == SHIP_AMMO_IMPACT_AP)
		penetrating = 1
	. = ..()

/obj/item/projectile/ship_ammo/longbow/on_hit(atom/target, blocked, def_zone, is_landmark_hit)
	. = ..()
	if(ismob(target))
		var/mob/M = target
		M.visible_message(SPAN_DANGER("<font size=5>\The [src] blows [M] apart and punches straight through!</font>"))
		M.gib()
	if(isturf(target) || isobj(target))
		switch(ammo.impact_type)
			if(SHIP_AMMO_IMPACT_AP)
				if(!penetrated)
					target.ex_act(1)
					if(!QDELING(target) && target.density)
						qdel(target)
					penetrated = TRUE
				else
					explosion(target, 4, 8, 12)
					qdel(src)
			if(SHIP_AMMO_IMPACT_HE)
				explosion(target, 6, 8, 10)
			if(SHIP_AMMO_IMPACT_BUNKERBUSTER)
				target.visible_message(SPAN_DANGER("<font size=5>\The [src] punches straight through \the [target]!</font>"))
				explosion(target, 1, 2, 4)
				target.ex_act(1)
				if(!QDELING(target) && target.density)
					qdel(target)
		return TRUE