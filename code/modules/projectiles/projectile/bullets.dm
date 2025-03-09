/obj/projectile/bullet
	name = "bullet"
	icon_state = "bullet"
	damage = 60
	damage_type = DAMAGE_BRUTE
	impact_sounds = list(BULLET_IMPACT_MEAT = SOUNDS_BULLET_MEAT, BULLET_IMPACT_METAL = SOUNDS_BULLET_METAL)
	check_armor = BULLET
	embed = TRUE
	sharp = TRUE
	shrapnel_type = /obj/item/material/shard/shrapnel
	var/mob_passthrough_check = 0

	muzzle_type = /obj/effect/projectile/muzzle/bullet

/obj/projectile/bullet/on_hit(atom/target, blocked, def_zone)
	if(isliving(target) && (..(target, blocked, def_zone) == BULLET_ACT_HIT))
		var/mob/living/L = target
		shake_camera(L, 3, 2)

	if(penetrating > 0 && damage > 20 && prob(damage))
		mob_passthrough_check = 1
	else
		mob_passthrough_check = 0
	return ..()

/obj/projectile/bullet/can_embed()
	//prevent embedding if the projectile is passing through the mob
	if(mob_passthrough_check)
		return 0
	return ..()

/**
 * # Pellet projectiles
 *
 * For projectiles that actually represent clouds of projectiles
 */
/obj/projectile/bullet/pellet
	name = "shrapnel" //'shrapnel' sounds more dangerous (i.e. cooler) than 'pellet'
	icon_state = "pellets"
	damage = 20

	///Number of pellets that will be ejected from this bullet
	var/pellets = 4

	///The projectile will lose a pellet each time it travels this distance. Can be a non-integer.
	var/range_step = 2

	///Lower means the pellets spread more across body parts. If zero then this is considered a shrapnel explosion instead of a shrapnel cone
	var/base_spread = 90

	///Higher means the pellets spread more across body parts with distance
	var/spread_step = 10

/obj/projectile/bullet/pellet/proc/get_pellets(var/distance)
	var/pellet_loss = round((distance - 1)/range_step) //pellets lost due to distance
	return max(pellets - pellet_loss, 1)

/obj/projectile/bullet/pellet/on_hit(atom/target, blocked, def_zone)
	if(!isliving(target))
		return ..()

	var/mob/living/living_target = target

	if (pellets < 0)
		return BULLET_ACT_BLOCK

	var/distance = get_dist(src.starting, get_turf(living_target))

	var/total_pellets = get_pellets(distance)
	var/spread = max(base_spread - (spread_step*distance), 0)

	//shrapnel explosions miss prone mobs with a chance that increases with distance
	var/prone_chance = 0
	if(!base_spread)
		prone_chance = max(spread_step*(distance - 2), 0)

	var/hits = 0
	for (var/i in 1 to total_pellets)
		if(living_target.lying && living_target != original && prob(prone_chance))
			continue

		// pellet hits spread out across different zones, but 'aim at' the targeted zone with higher probability
		// whether the pellet actually hits the def_zone or a different zone should still be determined by the parent using get_zone_with_miss_chance().
		var/old_zone = def_zone
		def_zone = ran_zone(def_zone, spread)
		// relatively hacky way of basing a shotgun pellet's likelihood of hitting on the first pellet of the burst while not affecting shrapnel explosions.
		if (base_spread > 0)
			if (i == 1)
				if (..() == BULLET_ACT_HIT)
					hits++
				else
					return 0
			else if (..() == BULLET_ACT_HIT)
				hits++
		else if (..() == BULLET_ACT_HIT)
			hits++
		def_zone = old_zone //restore the original zone the projectile was aimed at

	pellets -= hits //each hit reduces the number of pellets left
	// if (hits >= total_pellets || pellets <= 0)
	// 	return TRUE
	if(hits)
		return BULLET_ACT_HIT //Technically not everything, but good enough
	return BULLET_ACT_BLOCK //Nothing hit

/obj/projectile/bullet/pellet/get_structure_damage()
	var/distance = get_dist(loc, starting)
	return ..() * get_pellets(distance)

/obj/projectile/bullet/pellet/Move()
	. = ..()

	//If this is a shrapnel explosion, allow mobs that are prone to get hit, too
	if(. && !base_spread && isturf(loc))
		for(var/mob/living/M in loc)
			if(M.lying || !M.CanPass(src, loc)) //Bump if lying or if we would normally Bump.
				if(Collide(M)) //Bump will make sure we don't hit a mob multiple times
					return

/obj/projectile/bullet/rubberball
	name = "rubber ball"
	icon_state = "pellets"
	damage = 2
	agony = 50
	embed = FALSE
	var/balls = 4
	///projectile will lose a fragment each time it travels this distance. Can be a non-integer.
	var/range_step = 3
	var/base_spread = 90
	var/spread_step = 10

/obj/projectile/bullet/rubberball/proc/get_balls(var/distance)
	var/ball_loss = round((distance - 1)/range_step)
	return max(balls - ball_loss, 1)

/obj/projectile/bullet/rubberball/on_hit(atom/target, blocked, def_zone)
	if(!isliving(target))
		return ..()

	var/mob/living/target_mob = target
	var/distance = get_dist(src.starting, get_turf(target_mob))

	if (balls < 0)
		return TRUE

	var/total_balls = get_balls(distance)
	var/spread = max(base_spread - (spread_step*distance), 0)

	var/prone_chance = 0
	if(!base_spread)
		prone_chance = max(spread_step*(distance - 2), 0)

	var/hits = 0
	for (var/i in 1 to total_balls)
		if(target_mob.lying && target_mob != original && prob(prone_chance))
			continue

		var/old_zone = def_zone
		def_zone = ran_zone(def_zone, spread)
		if (..())
			hits++
		def_zone = old_zone

	balls -= hits
	if (hits >= total_balls || balls <= 0)
		return TRUE
	return FALSE

/obj/projectile/bullet/rubberball/Move()
	. = ..()

	if(. && !base_spread && isturf(loc))
		for(var/mob/living/M in loc)
			if(M.lying || !M.CanPass(src, loc))
				if(Collide(M))
					return

/* short-casing projectiles, like the kind used in pistols or SMGs */

/obj/projectile/bullet/pistol
	damage = 20
	armor_penetration = 15

/obj/projectile/bullet/pistol/medium
	damage = 30
	armor_penetration = 0

/obj/projectile/bullet/pistol/medium/ap
	armor_penetration = 15
	penetrating = FALSE

/obj/projectile/bullet/pistol/strong
	damage = 45
	armor_penetration = 20

/obj/projectile/bullet/pistol/revolver
	damage = 40
	armor_penetration = 15

/obj/projectile/bullet/pistol/rubber //"rubber" bullets
	name = "rubber bullet"
	check_armor = MELEE
	damage = 5
	agony = 40
	embed = 0

/obj/projectile/bullet/pistol/assassin
	damage = 20
	armor_penetration = 5

/* shotgun projectiles */

/obj/projectile/bullet/shotgun
	name = "slug"
	damage = 55
	armor_penetration = 5

/obj/projectile/bullet/shotgun/beanbag		//because beanbags are not bullets
	name = "beanbag"
	check_armor = MELEE
	damage = 10
	agony = 60
	embed = 0
	sharp = 0

/obj/projectile/bullet/shotgun/incendiary
	name = "incendiary"
	check_armor = MELEE
	damage = 5
	agony = 0
	embed = 0
	sharp = 0
	incinerate = 10

/obj/projectile/bullet/tracking
	name = "tracking shot"
	damage = 20
	embed_chance = 60 // this thing was designed to embed, so it has a 80% base chance to embed (damage + this flat increase)
	agony = 20
	shrapnel_type = /obj/item/implant/tracking

/obj/projectile/bullet/tracking/do_embed(obj/item/organ/external/organ)
	. = ..()
	if(.)
		var/obj/item/implant/tracking/T = .
		T.implanted = TRUE
		T.imp_in = organ.owner
		T.part = organ
		LAZYADD(organ.implants, T)

/obj/projectile/bullet/shotgun/moghes
	name = "wall shot"

//Should do about 80 damage at 1 tile distance (adjacent), and 50 damage at 3 tiles distance.
//Overall less damage than slugs in exchange for more damage at very close range and more embedding
/obj/projectile/bullet/pellet/shotgun
	name = "pellet"
	damage = 25
	pellets = 3
	range_step = 1
	spread_step = 10

/obj/projectile/bullet/pellet/shotgun/canister
	pellets = 15
	range_step = 3
	spread_step = 15

/* "Rifle" rounds */

/obj/projectile/bullet/rifle
	damage = 40
	armor_penetration = 15
	penetrating = FALSE

/obj/projectile/bullet/rifle/a762
	damage = 35
	armor_penetration = 22
	penetrating = TRUE

/obj/projectile/bullet/rifle/a556
	damage = 30
	armor_penetration = 28
	penetrating = FALSE

/obj/projectile/bullet/rifle/a556/ap
	damage = 25
	armor_penetration = 45
	penetrating = TRUE

/obj/projectile/bullet/rifle/a556/polymer
	damage = 25
	armor_penetration = 34
	penetrating = FALSE

/obj/projectile/bullet/rifle/a65
	damage = 30
	armor_penetration = 30
	penetrating = FALSE

/obj/projectile/bullet/rifle/a145
	damage = 80
	stun = 3
	weaken = 3
	penetrating = 5
	armor_penetration = 70
	hitscan = 1 //so the PTR isn't useless as a sniper weapon
	maim_rate = 3
	anti_materiel_potential = 2

/obj/projectile/rifle/kumar_super
	damage = 40
	armor_penetration = 30
	penetrating = TRUE

/obj/projectile/bullet/rifle/vintage
	name = ".30-06 Govt. bullet"
	damage = 50
	weaken = 1
	penetrating = TRUE

/obj/projectile/bullet/rifle/govt
	name = ".40-70 Govt. bullet"
	damage = 50

/obj/projectile/bullet/rifle/slugger
	name = "slugger round"
	damage = 60
	weaken = 3
	penetrating = 5
	armor_penetration = 10
	maim_rate = 3
	anti_materiel_potential = 2

/obj/projectile/bullet/rifle/slugger/on_hit(atom/target, blocked, def_zone)
	var/atom/movable/movable_target = target
	if(istype(movable_target))
		var/throwdir = get_dir(firer, movable_target)
		movable_target.throw_at(get_edge_target_turf(movable_target, throwdir), 3, 3)
	. = ..()

/obj/projectile/bullet/rifle/tranq
	name = "dart"
	icon_state = "dart"
	damage = 5
	stun = 0
	weaken = 0
	drowsy = 0
	eyeblur = 0
	damage_type = DAMAGE_BRUTE
	speed = 0.3

/obj/projectile/bullet/rifle/tranq/on_hit(var/atom/target, var/blocked = 0, var/def_zone = null)
	var/mob/living/L = target

	if(isanimal(target))
		target.visible_message("[SPAN_BOLD("[target]")] twitches, foaming at the mouth.")
		L.apply_damage(35, DAMAGE_TOXIN) //temporary until simple_animal paralysis actually works.

		//Determine in how long the mob will be put to rest, depending on its size
		var/sleep_in = 10 SECONDS
		switch(L.mob_size)
			if(MOB_TINY)
				sleep_in = 3 SECOND
			if(MOB_SMALL)
				sleep_in = 6 SECONDS
			if(MOB_MEDIUM)
				sleep_in = 10 SECONDS
			if(MOB_LARGE)
				sleep_in = 40 SECONDS

		addtimer(CALLBACK(L, TYPE_PROC_REF(/mob/living, Weaken), (L.weakened + 40)), sleep_in)

	else

		if(!(isipc(target)) && !isrobot(target))
			L.apply_effect(5, DROWSY, 0)

			switch(def_zone)

				if(BP_CHEST)
					if(blocked < 20)
						if(L.reagents)
							L.reagents.add_reagent(/singleton/reagent/soporific, 10)
					else if(blocked < 100)
						L.emote("yawns")

				if(BP_HEAD)
					if(blocked < 100)
						if(L.reagents)
							L.reagents.add_reagent(/singleton/reagent/soporific, 15)

				else
					if(blocked < 20)
						if(L.reagents)
							L.reagents.add_reagent(/singleton/reagent/soporific, 5)
					else if(blocked < 100)
						L.emote("yawns")

	..()

/* Miscellaneous */
/obj/projectile/bullet/blank
	invisibility = 101
	damage = 1
	embed = 0

/obj/projectile/bullet/chameleon
	damage = 1 // stop trying to murderbone with a fake gun dumbass!!!
	embed = 0 // nope

/* Practice */

/obj/projectile/bullet/pistol/practice
	damage = 5

/obj/projectile/bullet/rifle/a556/practice
	damage = 5

/obj/projectile/bullet/shotgun/practice
	name = "practice"
	damage = 5

/obj/projectile/bullet/pistol/cap
	name = "cap"
	damage_type = DAMAGE_PAIN
	damage = 0
	embed = 0
	sharp = 0

/obj/projectile/bullet/pistol/cap/process()
	loc = null
	qdel(src)

/obj/projectile/bullet/flechette
	name = "flechette"
	icon = 'icons/obj/terminator.dmi'
	icon_state = "flechette_bullet"
	damage = 40
	armor_penetration = 15
	damage_type = DAMAGE_BRUTE
	check_armor = BULLET
	embed = 1
	sharp = 1
	penetrating = 1

	muzzle_type = /obj/effect/projectile/muzzle/pulse

/obj/projectile/bullet/flechette/explosive
	shrapnel_type = /obj/item/material/shard/shrapnel/flechette
	penetrating = 0
	damage = 10
	armor_penetration = 60

/obj/projectile/bullet/gauss
	name = "slug"
	icon_state = "heavygauss"
	damage = 40
	armor_penetration = 20
	muzzle_type = /obj/effect/projectile/muzzle/gauss
	embed = 0

/obj/projectile/bullet/gauss/carbine
	name = "compact slug"
	damage = 20

/obj/projectile/bullet/gauss/highex
	name = "high-ex shell"
	damage = 10
	armor_penetration = 30

/obj/projectile/bullet/gauss/highex/on_hit(atom/target, blocked, def_zone)
	. = ..()
	explosion(target, -1, 0, 2)
	if(ismovable(target))
		var/atom/movable/T = target
		var/throwdir = get_dir(firer,target)
		INVOKE_ASYNC(T, TYPE_PROC_REF(/atom/movable, throw_at), get_edge_target_turf(target, throwdir), 3, 3)

/obj/projectile/bullet/cannonball
	name = "cannonball"
	icon_state = "cannonball"
	damage = 60
	embed = 0
	penetrating = 1
	armor_penetration = 25
	anti_materiel_potential = 2

/obj/projectile/bullet/cannonball/explosive
	damage = 50
	penetrating = 0
	armor_penetration = 5

/obj/projectile/bullet/cannonball/explosive/on_hit(atom/target, blocked, def_zone)
	explosion(target, -1, 1, 2)
	. = ..()

/obj/projectile/bullet/nuke
	name = "miniaturized nuclear warhead"
	icon_state = "nuke"
	damage = 25
	anti_materiel_potential = 2

/obj/projectile/bullet/nuke/on_hit(atom/target, blocked, def_zone)
	for(var/mob/living/carbon/human/mob in GLOB.human_mob_list)
		var/turf/T = get_turf(mob)
		if(T && (loc.z == T.z))
			if(ishuman(mob))
				mob.apply_damage(250, DAMAGE_RADIATION, damage_flags = DAMAGE_FLAG_DISPERSED)
	new /obj/effect/temp_visual/nuke(target.loc)
	explosion(target,2,5,9)
	. = ..()

/obj/projectile/bullet/shard
	name = "shard"
	icon_state = "shard"
	damage = 15
	muzzle_type = /obj/effect/projectile/muzzle/bolt

/obj/projectile/bullet/shard/heavy
	damage = 30
	armor_penetration = 15

/obj/projectile/bullet/recoilless_rifle
	name = "anti-tank warhead"
	icon_state = "missile"
	damage = 30
	armor_penetration = 30
	anti_materiel_potential = 4
	embed = FALSE
	penetrating = FALSE
	var/heavy_impact_range = 1

/obj/projectile/bullet/recoilless_rifle/on_hit(atom/target, blocked, def_zone)
	explosion(target, -1, heavy_impact_range, 2)
	. = ..()

/obj/projectile/bullet/peac
	name = "anti-tank missile"
	icon_state = "peac"
	damage = 25
	armor_penetration = 35
	anti_materiel_potential = 6
	embed = FALSE
	penetrating = 1

	var/devastation_range = -1
	var/heavy_impact_range = -1
	var/light_impact_range = 2

/obj/projectile/bullet/peac/on_hit(atom/target, blocked, def_zone)
	. = ..()

	explosion(target, devastation_range, heavy_impact_range, light_impact_range)

/obj/projectile/bullet/peac/he
	name = "high-explosive missile"
	armor_penetration = 0
	anti_materiel_potential = 3

	devastation_range = 1
	heavy_impact_range = 2
	light_impact_range = 4

/obj/projectile/bullet/peac/shrapnel
	name = "fragmentation missile"
	armor_penetration = 0
	anti_materiel_potential = 2

	light_impact_range = 1

/obj/projectile/bullet/peac/shrapnel/preparePixelProjectile(atom/target, atom/source, list/modifiers, deviation)
	. = ..()
	range = get_dist(firer, original)

/obj/projectile/bullet/peac/shrapnel/on_hit(atom/target, blocked, def_zone)
	. = ..()

	spawn_shrapnel(starting ? get_dir(starting, original) : dir)

/obj/projectile/bullet/peac/shrapnel/proc/spawn_shrapnel(var/shrapnel_dir)
	set waitfor = FALSE

	var/turf/O = get_turf(src)
	var/list/target_turfs = list()
	target_turfs += get_step(O, shrapnel_dir)
	target_turfs += get_step(O, turn(shrapnel_dir, -45))
	target_turfs += get_step(O, turn(shrapnel_dir, 45))

	for(var/turf/T in target_turfs)
		var/obj/projectile/bullet/pellet/fragment/P = new(O)
		P.damage = 30
		P.pellets = 4
		P.range_step = 3
		P.range = 15
		P.name = "shrapnel"
		P.preparePixelProjectile(T, src)
		P.firer = src
		P.fired_from = src
		P.fire()
