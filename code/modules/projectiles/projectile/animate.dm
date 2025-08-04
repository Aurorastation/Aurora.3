/obj/projectile/animate
	name = "bolt of animation"
	icon_state = "ice_1"
	damage = 0
	damage_type = DAMAGE_BURN
	check_armor = ENERGY

/obj/projectile/animate/Collide(atom/change)
	if((istype(change, /obj/item) || istype(change, /obj/structure)) && !is_type_in_list(change, GLOB.protected_objects))
		var/obj/O = change
		new /mob/living/simple_animal/hostile/mimic/copy(O.loc, O, firer)
	. = ..()
