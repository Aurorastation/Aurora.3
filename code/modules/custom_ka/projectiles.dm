//Projectiles
/obj/item/projectile/kinetic
	name = "kinetic force"
	icon_state = null
	damage = 0 //Base damage handled elsewhere.
	damage_type = BRUTE
	check_armour = "bomb"
	range = 5
	var/pressure_decrease = 0.25

/obj/item/projectile/kinetic/mech
	damage = 30

/obj/item/projectile/kinetic/mech/burst
	damage = 20

/obj/item/projectile/kinetic/on_impact(var/atom/A,var/aoe_scale = 1, var/damage_scale = 1)
	var/turf/target_turf = get_turf(A)
	if(!target_turf)
		target_turf = get_turf(src)
	if(istype(target_turf))
		var/datum/gas_mixture/environment = target_turf.return_air()

		damage *= max(1 - (environment.return_pressure()/100)*0.75,0)

		if(isliving(A)) //Never do more than 15 damage to a living being per shot.
			damage = min(damage,15)

		strike_thing(A,aoe*aoe_scale,damage)

	. = ..()

/obj/item/projectile/kinetic/proc/strike_thing(atom/target,var/new_aoe,var/damage_scale)

	var/turf/target_turf = get_turf(target)
	if(istype(target_turf, /turf/simulated/mineral))
		var/turf/simulated/mineral/M = target_turf
		M.kinetic_hit(damage,dir)

	new /obj/effect/overlay/temp/kinetic_blast(target_turf)

	if(new_aoe > 0)
		for(var/new_target in orange(new_aoe, target_turf))
			src.on_impact(new_target,0,0.5)