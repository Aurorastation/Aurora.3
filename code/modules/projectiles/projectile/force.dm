/obj/projectile/forcebolt
	name = "force bolt"
	icon = 'icons/obj/projectiles.dmi'
	icon_state = "bluespace"
	damage = 40
	check_armor = ENERGY
	embed = 1

/obj/projectile/forcebolt/strong
	name = "force bolt"
	icon_state = "bluespace"

/obj/projectile/forcebolt/on_hit(atom/target, blocked, def_zone)
	. = ..()
	if(ismovable(target))
		var/atom/movable/M = target
		var/throwdir = get_dir(firer,target)
		M.throw_at(get_edge_target_turf(target, throwdir),10,10)
		return BULLET_ACT_HIT

/obj/projectile/forcebolt/strong/on_hit(atom/target, blocked, def_zone)
	for(var/mob/M in hearers(2, src))
		if(M.loc != src.loc)
			var/throwdir = get_dir(firer,target)
			M.throw_at(get_edge_target_turf(M, throwdir),30,10)
	return ..()

