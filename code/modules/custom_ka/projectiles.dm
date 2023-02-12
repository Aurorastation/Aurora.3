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

/obj/item/projectile/kinetic/proc/do_damage(var/turf/T, var/living_damage = 1, var/mineral_damage = 1)
	if(!istype(T)) return
	var/datum/gas_mixture/environment = T.return_air()
	living_damage *= max(1 - (environment.return_pressure() / 100) * 0.75, 0)
	new /obj/effect/overlay/temp/kinetic_blast(T)
	for(var/mob/living/L in T)
		L.take_overall_damage(min(living_damage, 50))
		L.visible_message(SPAN_DANGER("\The [L] is hit by \the [src]!"), SPAN_DANGER("You are hit by \the [src]!"))
	if(istype(T, /turf/simulated/mineral))
		var/turf/simulated/mineral/M = T
		M.kinetic_hit(mineral_damage)

/obj/item/projectile/kinetic/proc/strike_thing(var/turf/target_turf)
	for(var/new_target in RANGE_TURFS(aoe, target_turf))
		var/turf/aoe_turf = new_target
		do_damage(aoe_turf, max(base_damage - base_damage * get_dist(aoe_turf, target_turf) * 0.25, 0), base_damage)
	if(!QDELETED(src))
		qdel(src)
