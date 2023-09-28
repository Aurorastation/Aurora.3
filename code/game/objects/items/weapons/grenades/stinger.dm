/proc/stinger(var/source,var/fragx,var/fragy,var/light_dam,var/flash_dam,var/p_dam,var/p_range,var/can_cover=TRUE,var/shard_range = 50)
	var/turf/O = get_turf(source)
	var/fragger = rand(fragx,fragy)
	explosion(O, -1, -1, light_dam, flash_dam)
	var/list/target_turfs = getcircle(O, 7)
	var/fragments_per_projectile = round(fragger/target_turfs.len)

	for(var/turf/T in target_turfs)
		sleep(0)
		var/obj/item/projectile/bullet/rubberball/stinger_ball/P = new (O)

		P.damage = p_dam
		P.balls = fragments_per_projectile
		P.range_step = p_range
		P.shot_from = source
		P.range = shard_range
		P.name = "rubber balls"

		P.launch_projectile(T)

		if(can_cover)
			for(var/mob/living/M in O)
				if(M.lying && isturf(get_turf(source)))
					P.attack_mob(M, 0, 0)
				else
					P.attack_mob(M, 0, 100)

//Fragmentation grenade projectile
/obj/item/projectile/bullet/rubberball/stinger_ball
	damage = 2
	agony = 50
	armor_penetration = 10
	range_step = 2
	embed = FALSE

	base_spread = 0
	spread_step = 20

	suppressed = TRUE //embedding messages are still produced so it's kind of weird when enabled.
	no_attack_log = 1
	muzzle_type = null

/obj/item/grenade/stinger
	name = "stinger grenade"
	desc = "A stinger grenade, designed to explode and expel rubber balls over an area for less-lethal takedowns. Popular with many law enforcement agencies."
	icon_state = "stinger"

	var/num_fragments = 70  //total number of fragments produced by the grenade
	var/fragment_damage = 2
	var/damage_step = 2      //projectiles lose a fragment each time they travel this distance. Can be a non-integer.
	var/explosion_size = 1   //size of the center explosion

	//The radius of the circle used to launch projectiles. Lower values mean less projectiles are used but if set too low gaps may appear in the spread pattern
	var/spread_range = 7

/obj/item/grenade/stinger/prime()
	set waitfor = 0
	..()

	stinger(src,num_fragments,num_fragments,explosion_size,explosion_size+1,fragment_damage,damage_step,TRUE)

	qdel(src)
