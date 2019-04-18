//Projectiles
/obj/item/projectile/kinetic
	name = "kinetic force"
	icon_state = null
	damage = 0 //Base damage handled elsewhere.
	damage_type = BRUTE
	check_armour = "bomb"
	range = 5
	var/pressure_decrease = 0.25

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

	if(A == src)
		return FALSE	//no.

	if(A in permutated)
		return FALSE

	if(firer && !ignore_source_check)
		if(A == firer || (A == firer.loc && istype(A, /obj/mecha))) //cannot shoot yourself or your mech
			trajectory_ignore_forcemove = TRUE
			forceMove(get_turf(A))
			trajectory_ignore_forcemove = FALSE
			return FALSE

	var/distance = get_dist(get_turf(A), starting) // Get the distance between the turf shot from and the mob we hit and use that for the calculations.
	var/passthrough = FALSE //if the projectile should continue flying
	if(ismob(A))
		var/mob/M = A
		if(istype(A, /mob/living))
			//if they have a neck grab on someone, that person gets hit instead
			var/obj/item/weapon/grab/G = locate() in M
			if(G && G.state >= GRAB_NECK)
				visible_message("<span class='danger'>\The [M] uses [G.affecting] as a shield!</span>")
				if(Collide(G.affecting))
					return //If Collide() returns 0 (keep going) then we continue on to attack M.

			passthrough = !attack_mob(M, distance)
		else
			passthrough = TRUE	//so ghosts don't stop bullets
	else
		passthrough = (A.bullet_act(src, def_zone) == PROJECTILE_CONTINUE) //backwards compatibility
		if(isturf(A))
			for(var/obj/O in A)
				O.bullet_act(src)
			for(var/mob/living/M in A)
				attack_mob(M, distance)

	//penetrating projectiles can pass through things that otherwise would not let them
	if(!passthrough && penetrating > 0)
		if(check_penetrate(A))
			passthrough = TRUE
		penetrating--

	//the bullet passes through a dense object!
	if(passthrough || forcedodge)
		//move ourselves onto A so we can continue on our way.
		if(A)
			trajectory_ignore_forcemove = TRUE
			if(istype(A, /turf))
				forceMove(A)
			else
				forceMove(get_turf(A))
			trajectory_ignore_forcemove = FALSE
			permutated.Add(A)
		return FALSE

	//stop flying
	on_impact(A, aoe_scale)

	qdel(src)
	return TRUE

/obj/item/projectile/kinetic/on_impact(var/atom/A, var/aoe_scale = 1, var/damage_scale)
	var/turf/target_turf = get_turf(A)
	if(!target_turf)
		target_turf = get_turf(src)
	if(istype(target_turf))

		damage_scale = damage
		strike_thing(A, aoe*aoe_scale, damage_scale)

/obj/item/projectile/kinetic/proc/strike_thing(atom/target, var/new_aoe, var/damage_scale)

	var/turf/target_turf = get_turf(target)
	if(istype(target_turf, /turf/simulated/mineral))
		var/turf/simulated/mineral/M = target_turf
		M.kinetic_hit(damage, dir)

	new /obj/effect/overlay/temp/kinetic_blast(target_turf)

	if(new_aoe > 0)
		for(var/new_target in orange(new_aoe, target_turf))
			src.Collide(new_target, 0, damage_scale * 0.75)
			CHECK_TICK