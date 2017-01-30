/obj/item/projectile/forcebolt
	name = "force bolt"
	icon = 'icons/obj/projectiles.dmi'
	icon_state = "bluespace"
	damage = 40
	check_armour = "energy"
	embed = 1

/obj/item/projectile/forcebolt/strong
	name = "force bolt"
	icon_state = "bluespace"

/obj/item/projectile/forcebolt/on_hit(var/atom/movable/target, var/blocked = 0)
	if(istype(target))
		var/throwdir = get_dir(firer,target)
		target.throw_at(get_edge_target_turf(target, throwdir),10,10)
		return 1

/obj/item/projectile/forcebolt/strong/on_hit(var/atom/target, var/blocked = 0)

//	var/throwdir = null

	for(var/mob/M in hearers(2, src))
		if(M.loc != src.loc)
			var/throwdir = get_dir(firer,target)
			M.throw_at(get_edge_target_turf(M, throwdir),30,10)
	return ..()

