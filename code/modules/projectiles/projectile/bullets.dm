/obj/item/projectile/bullet
	name = "bullet"
	icon_state = "bullet"
	damage = 60
	damage_type = BRUTE
	impact_sounds = list(BULLET_IMPACT_MEAT = SOUNDS_BULLET_MEAT, BULLET_IMPACT_METAL = SOUNDS_BULLET_METAL)
	nodamage = FALSE
	check_armour = "bullet"
	embed = TRUE
	sharp = TRUE
	shrapnel_type = /obj/item/material/shard/shrapnel
	var/mob_passthrough_check = 0

	muzzle_type = /obj/effect/projectile/muzzle/bullet

/obj/item/projectile/bullet/on_hit(var/atom/target, var/blocked = 0, var/def_zone = null)
	if (..(target, blocked, def_zone))
		var/mob/living/L = target
		shake_camera(L, 3, 2)

/obj/item/projectile/bullet/attack_mob(var/mob/living/target_mob, var/distance, var/miss_modifier)
	if(penetrating > 0 && damage > 20 && prob(damage))
		mob_passthrough_check = 1
	else
		mob_passthrough_check = 0
	return ..()

/obj/item/projectile/bullet/can_embed()
	//prevent embedding if the projectile is passing through the mob
	if(mob_passthrough_check)
		return 0
	return ..()

/obj/item/projectile/bullet/check_penetrate(var/atom/A)
	if(!A || !A.density) return 1 //if whatever it was got destroyed when we hit it, then I guess we can just keep going

	if(ismob(A))
		if(!mob_passthrough_check)
			return 0
		if(iscarbon(A))
			damage *= 0.7 //squishy mobs absorb KE
		return 1

	var/chance = 0
	if(istype(A, /turf/simulated/wall))
		var/turf/simulated/wall/W = A
		chance = round(damage/W.material.integrity*180)
	else if(istype(A, /obj/machinery/door))
		var/obj/machinery/door/D = A
		chance = round(damage/D.maxhealth*180)
		if(D.glass) chance *= 2
	else if(istype(A, /obj/structure/girder))
		chance = 100
	else if(istype(A, /obj/machinery) || istype(A, /obj/structure))
		chance = damage

	if(prob(chance))
		if(A.opacity)
			//display a message so that people on the other side aren't so confused
			A.visible_message("<span class='warning'>\The [src] pierces through \the [A]!</span>")
		return 1

	return 0

//For projectiles that actually represent clouds of projectiles
/obj/item/projectile/bullet/pellet
	name = "shrapnel" //'shrapnel' sounds more dangerous (i.e. cooler) than 'pellet'
	icon_state = "pellets"
	damage = 20
	//icon_state = "bullet" //TODO: would be nice to have it's own icon state
	var/pellets = 4			//number of pellets
	var/range_step = 2		//projectile will lose a fragment each time it travels this distance. Can be a non-integer.
	var/base_spread = 90	//lower means the pellets spread more across body parts. If zero then this is considered a shrapnel explosion instead of a shrapnel cone
	var/spread_step = 10	//higher means the pellets spread more across body parts with distance

/obj/item/projectile/bullet/pellet/proc/get_pellets(var/distance)
	var/pellet_loss = round((distance - 1)/range_step) //pellets lost due to distance
	return max(pellets - pellet_loss, 1)

/obj/item/projectile/bullet/pellet/attack_mob(var/mob/living/target_mob, var/distance, var/miss_modifier)
	if (pellets < 0) return 1

	var/total_pellets = get_pellets(distance)
	var/spread = max(base_spread - (spread_step*distance), 0)

	//shrapnel explosions miss prone mobs with a chance that increases with distance
	var/prone_chance = 0
	if(!base_spread)
		prone_chance = max(spread_step*(distance - 2), 0)

	var/hits = 0
	for (var/i in 1 to total_pellets)
		if(target_mob.lying && target_mob != original && prob(prone_chance))
			continue

		//pellet hits spread out across different zones, but 'aim at' the targeted zone with higher probability
		//whether the pellet actually hits the def_zone or a different zone should still be determined by the parent using get_zone_with_miss_chance().
		var/old_zone = def_zone
		def_zone = ran_zone(def_zone, spread)
		if (..()) hits++
		def_zone = old_zone //restore the original zone the projectile was aimed at

	pellets -= hits //each hit reduces the number of pellets left
	if (hits >= total_pellets || pellets <= 0)
		return 1
	return 0

/obj/item/projectile/bullet/pellet/get_structure_damage()
	var/distance = get_dist(loc, starting)
	return ..() * get_pellets(distance)

/obj/item/projectile/bullet/pellet/Move()
	. = ..()

	//If this is a shrapnel explosion, allow mobs that are prone to get hit, too
	if(. && !base_spread && isturf(loc))
		for(var/mob/living/M in loc)
			if(M.lying || !M.CanPass(src, loc)) //Bump if lying or if we would normally Bump.
				if(Collide(M)) //Bump will make sure we don't hit a mob multiple times
					return

/* short-casing projectiles, like the kind used in pistols or SMGs */

/obj/item/projectile/bullet/pistol
	damage = 20

/obj/item/projectile/bullet/pistol/medium
	damage = 25

/obj/item/projectile/bullet/pistol/strong
	damage = 60

/obj/item/projectile/bullet/pistol/revolver
	damage = 45
	armor_penetration = 15

/obj/item/projectile/bullet/pistol/rubber //"rubber" bullets
	name = "rubber bullet"
	check_armour = "melee"
	damage = 5
	agony = 40
	embed = 0

/* shotgun projectiles */

/obj/item/projectile/bullet/shotgun
	name = "slug"
	damage = 60

/obj/item/projectile/bullet/shotgun/beanbag		//because beanbags are not bullets
	name = "beanbag"
	check_armour = "melee"
	damage = 10
	agony = 60
	embed = 0
	sharp = 0

/obj/item/projectile/bullet/shotgun/incendiary
	name = "incendiary"
	check_armour = "melee"
	damage = 5
	agony = 0
	embed = 0
	sharp = 0
	incinerate = 10

//Should do about 80 damage at 1 tile distance (adjacent), and 50 damage at 3 tiles distance.
//Overall less damage than slugs in exchange for more damage at very close range and more embedding
/obj/item/projectile/bullet/pellet/shotgun
	name = "shrapnel"
	damage = 13
	pellets = 6
	range_step = 1
	spread_step = 10

/obj/item/projectile/bullet/pellet/shotgun/canister
	pellets = 15
	range_step = 3
	spread_step = 15

/* "Rifle" rounds */

/obj/item/projectile/bullet/rifle
	armor_penetration = 20
	penetrating = 1

/obj/item/projectile/bullet/rifle/a762
	damage = 25

/obj/item/projectile/bullet/rifle/a556
	damage = 30

/obj/item/projectile/bullet/rifle/a556/ap
	damage = 25
	armor_penetration = 25

/obj/item/projectile/bullet/rifle/a145
	damage = 80
	stun = 3
	weaken = 3
	penetrating = 5
	armor_penetration = 80
	hitscan = 1 //so the PTR isn't useless as a sniper weapon
	maiming = 1
	maim_rate = 3
	maim_type = DROPLIMB_BLUNT

/obj/item/projectile/bullet/rifle/vintage
	name = "vintage bullet"
	damage = 50
	weaken = 1

/obj/item/projectile/bullet/rifle/tranq
	name = "dart"
	icon_state = "dart"
	damage = 5
	stun = 0
	weaken = 0
	drowsy = 0
	eyeblur = 0
	damage_type = TOX
	speed = 0.3

/obj/item/projectile/bullet/rifle/tranq/on_hit(var/atom/target, var/blocked = 0, var/def_zone = null)
	var/mob/living/L = target
	if(!(isanimal(target)))
		if(!(isipc(target)))
			if(!isrobot(target))
				L.apply_effect(5, DROWSY, 0)
				if(def_zone == "torso")
					if(blocked < 100 && !(blocked < 20))
						L.emote("yawns")
					if(blocked < 20)
						if(L.reagents)	L.reagents.add_reagent("stoxin", 10)
				if(def_zone == BP_HEAD && blocked < 100)
					if(L.reagents)	L.reagents.add_reagent("stoxin", 15)
				if(def_zone != "torso" && def_zone != BP_HEAD)
					if(blocked < 100 && !(blocked < 20))
						L.emote("yawns")
					if(blocked < 20)
						if(L.reagents)	L.reagents.add_reagent("stoxin", 5)

	if(isanimal(target))
		target.visible_message("<b>[target]</b> twitches, foaming at the mouth.")
		L.apply_damage(35, TOX) //temporary until simple_mob paralysis actually works.
	/*	var/mob/living/simple_animal/M = target
		spawn(60)
			target.visible_message("<b>[target]</b> collapses.")
			M.Sleeping(1200)*/ //commented out until simple_mob paralysis actually works.
	..()

/* Miscellaneous */

/obj/item/projectile/bullet/suffocationbullet//How does this even work?
	name = "co bullet"
	damage = 20
	damage_type = OXY

/obj/item/projectile/bullet/cyanideround
	name = "poison bullet"
	damage = 40
	damage_type = TOX

/obj/item/projectile/bullet/burstbullet
	name = "exploding bullet"
	damage = 20
	embed = 0
	edge = 1

/obj/item/projectile/bullet/burstbullet/on_impact(var/atom/A)
	explosion(A, -1, 0, 2)
	..()

/obj/item/projectile/bullet/blank
	invisibility = 101
	damage = 1
	embed = 0

/obj/item/projectile/bullet/chameleon
	damage = 1 // stop trying to murderbone with a fake gun dumbass!!!
	embed = 0 // nope

/* Practice */

/obj/item/projectile/bullet/pistol/practice
	damage = 5

/obj/item/projectile/bullet/rifle/a556/practice
	damage = 5

/obj/item/projectile/bullet/shotgun/practice
	name = "practice"
	damage = 5

/obj/item/projectile/bullet/pistol/cap
	name = "cap"
	damage_type = PAIN
	damage = 0
	nodamage = 1
	embed = 0
	sharp = 0

/obj/item/projectile/bullet/pistol/cap/process()
	loc = null
	qdel(src)

/obj/item/projectile/bullet/flechette
	name = "flechette"
	icon = 'icons/obj/terminator.dmi'
	icon_state = "flechette_bullet"
	damage = 40
	damage_type = BRUTE
	check_armour = "bullet"
	embed = 1
	sharp = 1
	penetrating = 1

	muzzle_type = /obj/effect/projectile/muzzle/pulse

/obj/item/projectile/bullet/flechette/explosive
	shrapnel_type = /obj/item/material/shard/shrapnel/flechette
	penetrating = 0
	damage = 10

/obj/item/projectile/bullet/gauss
	name = "slug"
	icon_state = "heavygauss"
	damage = 30
	muzzle_type = /obj/effect/projectile/muzzle/gauss
	embed = 0

/obj/item/projectile/bullet/gauss/highex
	name ="high-ex shell"
	damage = 10

/obj/item/projectile/bullet/gauss/highex/on_impact(var/atom/A)
	explosion(A, -1, 0, 2)
	..()

/obj/item/projectile/bullet/gauss/highex/on_hit(var/atom/target, var/blocked = 0)
	explosion(target, -1, 0, 2)
	sleep(0)
	var/obj/T = target
	var/throwdir = get_dir(firer,target)
	T.throw_at(get_edge_target_turf(target, throwdir),3,3)
	return 1

/obj/item/projectile/bullet/cannonball
	name = "cannonball"
	icon_state = "cannonball"
	damage = 60
	embed = 0
	penetrating = 1
	armor_penetration = 25

/obj/item/projectile/bullet/cannonball/explosive
	damage = 30
	penetrating = 0
	armor_penetration = 5

/obj/item/projectile/bullet/cannonball/explosive/on_impact(var/atom/A)
	explosion(A, -1, 1, 2)
	..()

/obj/item/projectile/bullet/nuke
	name = "miniaturized nuclear warhead"
	icon_state = "nuke"
	damage = 25

/obj/item/projectile/bullet/nuke/on_impact(var/atom/A)
	for(var/mob/living/carbon/human/mob in human_mob_list)
		var/turf/T = get_turf(mob)
		if(T && (loc.z == T.z))
			if(ishuman(mob))
				mob.apply_effect(450, IRRADIATE)
	new /obj/effect/temp_visual/nuke(A.loc)
	explosion(A,2,5,9)
	..()