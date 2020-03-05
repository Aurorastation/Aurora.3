//Projectiles
/obj/item/projectile/kinetic
	name = "kinetic force"
	icon_state = null
	damage = 0 //Base damage handled elsewhere.
	damage_type = BRUTE
	check_armour = "bomb"
	range = 5
	var/pressure_decrease = 0.25
	var/aoe_s = 1 // aoe scale
	var/base_damage = 0

/obj/item/projectile/kinetic/mech
	damage = 40
	aoe = 5

/obj/item/projectile/kinetic/mech/burst
	damage = 25

/obj/item/projectile/kinetic/Collide(var/atom/A)
	var/turf/target_turf = get_turf(A)
	if(!target_turf)
		target_turf = get_turf(src)
	if(istype(target_turf))
		var/datum/gas_mixture/environment = target_turf.return_air()
		damage *= max(1 - (environment.return_pressure()/100)*0.75,0)
		if(isliving(A)) //Never do more than 50 damage to a living being per shot.
			damage = min(damage, 50)
	. = ..()

/obj/item/projectile/kinetic/on_impact(var/atom/A)
	var/turf/target_turf = get_turf(A)
	if(!target_turf)
		target_turf = get_turf(src)
	if(istype(target_turf))
		strike_thing(A, aoe * aoe_s)

/obj/item/projectile/kinetic/proc/strike_thing(atom/target, var/new_aoe)

	var/turf/target_turf = get_turf(target)
	if(istype(target_turf, /turf/simulated/mineral))
		var/turf/simulated/mineral/M = target_turf
		M.kinetic_hit(base_damage, dir)

	new /obj/effect/overlay/temp/kinetic_blast(target_turf)

	if(new_aoe > 0)
		aoe_s = 0
		ignore_source_check = TRUE
		for(var/new_target in orange(new_aoe, target_turf))
			damage = max(base_damage - base_damage * get_dist(new_target, target_turf) * 0.25, 0)
			src.Collide(new_target)
			CHECK_TICK
