//Projectiles
/obj/item/projectile/kinetic
	name = "kinetic force"
	icon_state = null
	damage = 0 //Base damage handled elsewhere.
	damage_type = BRUTE
	check_armour = "bomb"
	range = 5
	var/pressure_decrease = 0.25
	var/damage_s
	var/aoe_s

/obj/item/projectile/kinetic/mech/
	damage = 40
	aoe = 5

/obj/item/projectile/kinetic/mech/burst
	damage = 25

/obj/item/projectile/kinetic/Collide(var/atom/A, var/aoe_scale = 1, var/damage_scale)
	var/turf/target_turf = get_turf(A)
	if(!target_turf)
		target_turf = get_turf(src)
	if(istype(target_turf))
		var/datum/gas_mixture/environment = target_turf.return_air()
		if(damage_scale)
			damage = damage_scale
		else
			damage *= max(1 - (environment.return_pressure()/100)*0.75,0)
			damage_scale = damage
		if(isliving(A)) //Never do more than 15 damage to a living being per shot.
			damage = min(damage, 50)

	aoe_s = aoe_scale
	damage_s = damage_scale
	. = ..()

/obj/item/projectile/kinetic/on_impact(var/atom/A)
	var/turf/target_turf = get_turf(A)
	if(!target_turf)
		target_turf = get_turf(src)
	if(istype(target_turf))

		strike_thing(A, aoe*aoe_s, damage_s)

/obj/item/projectile/kinetic/proc/strike_thing(atom/target, var/new_aoe, var/damage_scale)

	var/turf/target_turf = get_turf(target)
	if(istype(target_turf, /turf/simulated/mineral))
		var/turf/simulated/mineral/M = target_turf
		M.kinetic_hit(damage, dir)

	new /obj/effect/overlay/temp/kinetic_blast(target_turf)

	if(new_aoe > 0)
		for(var/new_target in orange(new_aoe, target_turf))
			src.Collide(new_target, 0, min(damage_scale - damage_scale * get_dist(new_target, target_turf) * 0.25, 0))
			CHECK_TICK