//Projectiles
/obj/item/projectile/kinetic
	name = "kinetic force"
	icon_state = null
	damage = 0 //Base damage handled elsewhere.
	damage_type = BRUTE
	check_armor = "bomb"
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
	if(istype(target_turf))
		strike_thing(target_turf)

/obj/item/projectile/kinetic/proc/do_damage(var/turf/T)
	var/datum/gas_mixture/environment = T.return_air()
	damage *= max(1 - (environment.return_pressure() / 100) * 0.75, 0)
	for(var/mob/living/L in T)
		damage = min(damage, 50) //Never do more than 50 damage to a living being per shot.
	if(istype(T, /turf/simulated/mineral))
		var/turf/simulated/mineral/M = T
		M.kinetic_hit(base_damage)

/obj/item/projectile/kinetic/proc/strike_thing(var/turf/target_turf)
	for(var/new_target in RANGE_TURFS(aoe, target_turf))
		var/turf/aoe_turf = new_target
		new /obj/item/projectile/kinetic/aoe_shot(aoe_turf, src, get_dist(aoe_turf, target_turf))
	if(!QDELETED(src))
		qdel(src)

/obj/item/projectile/kinetic/aoe_shot
	aoe_shot = TRUE

/obj/item/projectile/kinetic/aoe_shot/Initialize(mapload, var/obj/item/projectile/kinetic/master_shot, var/distance_from_master)
	..()
	var/turf/spawn_turf = mapload
	if(!istype(spawn_turf))
		spawn_turf = get_turf(src)
	new /obj/effect/overlay/temp/kinetic_blast(spawn_turf)
	damage = max(master_shot.base_damage - master_shot.base_damage * distance_from_master * 0.25, 0)
	base_damage = master_shot.base_damage
	do_damage(spawn_turf)
	return INITIALIZE_HINT_QDEL