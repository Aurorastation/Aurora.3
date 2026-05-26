/**
 * Fragem works by shooting a projectile containing fragments at every tile in a circle around it.
 *
 * Source is the tile the projectiles spawn on.
 *
 * fragx and fragy are the upper and lower bounds of the random number of fragments produced.
 *
 * light_dam and flash_dam are the parameters for the explosion produced by the grenade. light_dam is the radius of minor explosive damage, flash_dam is the radius of the flash effect.
 *
 * p_dam is the damage of each individual fragments.
 *
 * p_range is the distance each projectile travels before losing a fragment. When a projectile loses all of its fragments, it is deleted.
 *
 * can_cover determines if a mob can lie on the source turf to absorb most of the fragments.
 *
 * shard_range is the maximum range of the projectiles produced by the fragem. This is separate from p_range to allow for projectiles that lose fragments over distance but have a hard maximum range.  Default 50
 *
 * spread_range is the radius of the circle used to launch projectiles. Lower values mean less projectiles are used but if set too low gaps may appear in the spread pattern. Default 7
 *
 * maim_rate is the bonus for projectiles to decapitate or gib limbs. Negative values reduce this chance, positive values increase it. There is a minimum maim multiplier of 0.1, see handle_limb_gibbing for details.
 */
/proc/fragem(var/source,var/fragx,var/fragy,var/light_dam,var/flash_dam,var/p_dam,var/p_range,var/can_cover=TRUE,var/shard_range = 50,var/spread_range = 7,var/maim_rate)
	var/turf/O = get_turf(source)
	var/fragger = rand(fragx,fragy)
	explosion(O, -1, -1, light_dam, flash_dam)
	var/list/target_turfs = getcircle(O, spread_range)
	var/fragments_per_projectile = round(fragger/target_turfs.len)

	for(var/turf/T in target_turfs)
		sleep(0)
		var/obj/projectile/bullet/pellet/fragment/P = new (O)

		P.damage = p_dam
		P.pellets = fragments_per_projectile
		P.range_step = p_range
		if (maim_rate)
			P.maim_rate = maim_rate
		P.range = shard_range
		P.name = "shrapnel"
		P.preparePixelProjectile(T, get_turf(source))
		P.firer = source
		P.fired_from = source
		P.fire()

		if(can_cover)
			for(var/mob/living/M in O)
				//lying on a frag grenade while the grenade is on the ground causes you to absorb most of the shrapnel.
				//you will most likely be dead, but others nearby will be spared the fragments that hit you instead.
				if(M.lying && isturf(get_turf(source)))
					P.process_hit(get_turf(M), M)
				else
					if(prob(20))
						P.process_hit(get_turf(M), M)

//Fragmentation grenade projectile
/obj/projectile/bullet/pellet/fragment
	damage = 23
	agony = 20
	eyeblur = 2
	armor_penetration = 35
	embed_chance = 30
	range_step = 2

	ricochets_max = 2
	ricochet_chance = 20

	base_spread = 0 //causes it to be treated as a shrapnel explosion instead of cone
	spread_step = 20

	suppressed = TRUE //embedding messages are still produced so it's kind of weird when enabled.
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

	fragem(src,num_fragments,num_fragments,explosion_size,explosion_size+1,fragment_damage,damage_step,TRUE)

	qdel(src)
