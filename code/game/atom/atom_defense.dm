/// Called after the atom takes damage and integrity is below integrity_failure level
/atom/proc/atom_break(damage_flag)
	SHOULD_CALL_PARENT(TRUE)
//	SEND_SIGNAL(src, COMSIG_ATOM_BREAK, damage_flag)

/// A cut-out proc for [/atom/proc/bullet_act] so living mobs can have their own armor behavior checks without causing issues with needing their own on_hit call
/atom/proc/check_projectile_armor(def_zone, obj/projectile/impacting_projectile, is_silent)
	// if(uses_integrity)
	// 	return clamp(PENETRATE_ARMOUR(get_armor_rating(impacting_projectile.armor_flag), impacting_projectile.armour_penetration), 0, 100)
	return 0
