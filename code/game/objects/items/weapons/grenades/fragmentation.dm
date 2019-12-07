proc/fragem(var/source,var/fragx,var/fragy,var/light_dam,var/flash_dam,var/p_dam,var/p_range,var/can_cover=1)
	var/turf/O = get_turf(source)
	var/fragger = rand(fragx,fragy)
	explosion(O, -1, -1, light_dam, flash_dam)
	var/list/target_turfs = getcircle(O, 7)
	var/fragments_per_projectile = round(fragger/target_turfs.len)

	for(var/turf/T in target_turfs)
		sleep(0)
		var/obj/item/projectile/bullet/pellet/fragment/P = new (O)

		P.damage = p_dam
		P.pellets = fragments_per_projectile
		P.range_step = p_range
		P.shot_from = source
		P.name = "[source]'s shrapnel"

		P.launch_projectile(T)

		if(can_cover)
			for(var/mob/living/M in O)
				//lying on a frag grenade while the grenade is on the ground causes you to absorb most of the shrapnel.
				//you will most likely be dead, but others nearby will be spared the fragments that hit you instead.
				if(M.lying && isturf(get_turf(source)))
					P.attack_mob(M, 0, 0)
				else
					P.attack_mob(M, 0, 100) //otherwise, allow a decent amount of fragments to pass

//Fragmentation grenade projectile
/obj/item/projectile/bullet/pellet/fragment
	damage = 10
	range_step = 2

	base_spread = 0 //causes it to be treated as a shrapnel explosion instead of cone
	spread_step = 20

	silenced = 1 //embedding messages are still produced so it's kind of weird when enabled.
	no_attack_log = 1
	muzzle_type = null

/obj/item/grenade/frag
	name = "fragmentation grenade"
	desc = "A military fragmentation grenade, designed to explode in a deadly shower of fragments."
	icon_state = "frag"

	var/num_fragments = 70  //total number of fragments produced by the grenade
	var/fragment_damage = 10
	var/damage_step = 2      //projectiles lose a fragment each time they travel this distance. Can be a non-integer.
	var/explosion_size = 3   //size of the center explosion

	//The radius of the circle used to launch projectiles. Lower values mean less projectiles are used but if set too low gaps may appear in the spread pattern
	var/spread_range = 7

/obj/item/grenade/frag/prime()
	set waitfor = 0
	..()

	fragem(src,num_fragments,num_fragments,explosion_size,explosion_size+1,fragment_damage,damage_step,1)

	qdel(src)
