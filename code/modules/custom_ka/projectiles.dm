//Projectiles
/obj/item/projectile/kinetic
	name = "kinetic force"
	icon_state = null
	damage = 0 //Base damage handled elsewhere.
	damage_type = BRUTE
	check_armour = "bomb"
	range = 5
	var/pressure_decrease = 0.25
	var/base_damage = 0
	var/aoe_shot = FALSE
	ignore_source_check = TRUE

/obj/item/projectile/kinetic/mech
	damage = 40
	aoe = 5

/obj/item/projectile/kinetic/mech/burst
	damage = 25

/obj/item/projectile/kinetic/on_impact(var/atom/A)
	var/turf/target_turf = get_turf(A)
	if(!target_turf)
		target_turf = get_turf(src)
	if(istype(target_turf) && !aoe_shot)
		aoe_shot = TRUE
		strike_thing(A)

/obj/item/projectile/kinetic/proc/do_damage(var/atom/A)
	var/turf/target_turf = get_turf(A)
	if(!target_turf)
		target_turf = get_turf(src)
	if(istype(target_turf))
		var/datum/gas_mixture/environment = target_turf.return_air()
		damage *= max(1 - (environment.return_pressure() / 100) * 0.75, 0)
		if(isliving(A)) //Never do more than 50 damage to a living being per shot.
			damage = min(damage, 50)
	if(istype(target_turf, /turf/simulated/mineral))
		var/turf/simulated/mineral/M = target_turf
		M.kinetic_hit(base_damage, dir)

/obj/item/projectile/kinetic/proc/strike_thing(atom/target)

	var/turf/target_turf = get_turf(target)
	if(istype(target_turf, /turf/simulated/mineral))
		var/turf/simulated/mineral/M = target_turf
		M.kinetic_hit(base_damage, dir)

	new /obj/effect/overlay/temp/kinetic_blast(target_turf)

	for(var/new_target in orange(aoe, target_turf))
		new /obj/effect/overlay/temp/kinetic_blast(get_turf(new_target))
		var/obj/item/projectile/kinetic/spread = new /obj/item/projectile/kinetic
		spread.aoe_shot = TRUE
		spread.damage = max(base_damage - base_damage * get_dist(new_target, target_turf) * 0.25, 0)
		spread.do_damage(new_target)
		spread.Collide(new_target)
		CHECK_TICK