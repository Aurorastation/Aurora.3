/obj/item/projectile/energy
	name = "energy"
	icon_state = "spark"
	damage = 0
	damage_type = BURN
	check_armour = "energy"


//releases a burst of light on impact or after travelling a distance
/obj/item/projectile/energy/flash
	name = "chemical shell"
	icon_state = "bullet"
	damage = 5
	agony = 10
	kill_count = 15 //if the shell hasn't hit anything after travelling this far it just explodes.
	var/flash_range = 0
	var/brightness = 7
	var/light_duration = 5

/obj/item/projectile/energy/flash/on_impact(var/atom/A)
	var/turf/T = flash_range? src.loc : get_turf(A)
	if(!istype(T)) return

	//blind adjacent people
	for (var/mob/living/carbon/M in viewers(T, flash_range))
		if(M.eyecheck() < FLASH_PROTECTION_MODERATE)
			flick("e_flash", M.flash)

	//snap pop
	playsound(src, 'sound/effects/snap.ogg', 50, 1)
	src.visible_message("<span class='warning'>\The [src] explodes in a bright flash!</span>")

	new /obj/effect/decal/cleanable/ash(src.loc) //always use src.loc so that ash doesn't end up inside windows
	new /obj/effect/sparks(T)
	new /obj/effect/effect/smoke/illumination(T, brightness=max(flash_range*2, brightness), lifetime=light_duration)

//blinds people like the flash round, but can also be used for temporary illumination
/obj/item/projectile/energy/flash/flare
	damage = 10
	flash_range = 1
	brightness = 9 //similar to a flare
	light_duration = 200

/obj/item/projectile/energy/electrode
	name = "electrode"
	icon_state = "spark"
	nodamage = 1
	taser_effect = 1
	agony = 40
	damage_type = HALLOSS
	//Damage will be handled on the MOB side, to prevent window shattering.

/obj/item/projectile/energy/electrode/stunshot
	name = "stunshot"
	damage = 5
	taser_effect = 1
	agony = 80

/obj/item/projectile/energy/declone
	name = "declone"
	icon_state = "declone"
	nodamage = 1
	damage_type = CLONE
	irradiate = 40


/obj/item/projectile/energy/dart
	name = "dart"
	icon_state = "toxin"
	damage = 5
	damage_type = TOX
	weaken = 5


/obj/item/projectile/energy/bolt
	name = "bolt"
	icon_state = "cbbolt"
	damage = 10
	damage_type = TOX
	nodamage = 0
	agony = 40
	stutter = 10


/obj/item/projectile/energy/bolt/large
	name = "largebolt"
	damage = 20


/obj/item/projectile/energy/neurotoxin
	name = "neuro"
	icon_state = "neurotoxin"
	damage = 5
	damage_type = TOX
	weaken = 5

/obj/item/projectile/energy/phoron
	name = "phoron bolt"
	icon_state = "energy"
	damage = 20
	damage_type = TOX
	irradiate = 20

/obj/item/projectile/energy/bfg
	name = "distortion"
	icon = 'icons/obj/projectiles.dmi'
	icon_state = "bfg"
	check_armour = "bomb"
	damage = 60
	damage_type = BRUTE
	pass_flags = PASSTABLE | PASSGLASS | PASSGRILLE
	kill_count = 100
	embed = 0
	step_delay = 3
	light_range = 4
	light_color = "#b5ff5b"

/obj/item/projectile/energy/bfg/on_impact(var/atom/A)
	if(ismob(A))
		var/mob/M = A
		M.gib()
	explosion(A, -1, 0, 5)
	..()

/obj/item/projectile/energy/bfg/New()
	var/matrix/M = matrix()
	M.Scale(2)
	src.transform = M
	..()

/obj/item/projectile/energy/bfg/process()
	var/first_step = 1

	spawn while(src && src.loc)
		if(kill_count-- < 1)
			on_impact(src.loc) //for any final impact behaviours
			qdel(src)
			return
		if((!( current ) || loc == current))
			current = locate(min(max(x + xo, 1), world.maxx), min(max(y + yo, 1), world.maxy), z)
		if((x == 1 || x == world.maxx || y == 1 || y == world.maxy))
			qdel(src)
			return

		trajectory.increment()	// increment the current location
		location = trajectory.return_location(location)		// update the locally stored location data

		if(!location)
			qdel(src)	// if it's left the world... kill it
			return

		before_move()
		Move(location.return_turf())

		if(!bumped && !isturf(original))
			if(loc == get_turf(original))
				if(!(original in permutated))
					if(Bump(original))
						return

		if(first_step)
			muzzle_effect(effect_transform)
			first_step = 0
		else if(!bumped)
			tracer_effect(effect_transform)

		for(var/turf/T in range(1,src))
			if(T.density)
				T.ex_act(2)
				playsound(src.loc, 'sound/magic/LightningShock.ogg', 75, 1)

		for(var/obj/O in range(1,src))
			if(O.density)
				O.ex_act(2)
				playsound(src.loc, 'sound/magic/LightningShock.ogg', 75, 1)

		for(var/mob/living/M in range(1,src))
			if(M == src.firer) //for the sake of courtesy we will not target our master)
				continue
			else
				if(M.stat == DEAD)
					M.gib()
				else
					M.apply_damage(60, BRUTE, "head")
				playsound(src.loc, 'sound/magic/LightningShock.ogg', 75, 1)
		if(!hitscan)
			sleep(step_delay)	//add delay between movement iterations if it's not a hitscan weapon



/obj/item/projectile/energy/bee
	name = "bees"
	icon = 'icons/obj/apiary_bees_etc.dmi'
	icon_state = "beegun"
	check_armour = "bio"
	damage = 5
	damage_type = BRUTE
	pass_flags = PASSTABLE | PASSGRILLE
	embed = 0
	weaken = 0

/obj/item/projectile/energy/bee/on_impact(var/atom/A)
	playsound(src.loc, pick('sound/effects/Buzz1.ogg','sound/effects/Buzz2.ogg'), 70, 1)
	var/turf/T = get_turf(A)
	if(!istype(T, /turf/simulated/wall) && !istype(T, /turf/simulated/shuttle/wall) && !istype(A, /obj/structure/window) && !istype(A, /obj/machinery/door))
		for(var/i=1, i<=8, i++)
			var/atom/movable/x = new /mob/living/simple_animal/bee/beegun //hackmaster pro, butt fuck it
			x.forceMove(T)
	else
		src.visible_message("<span class='danger'>[src] splat sickly against [T]!</span>")
	..()

/obj/item/projectile/energy/blaster
	name = "blaster bolt"
	icon_state = "laser"
	check_armour = "laser"
	damage = 15
	damage_type = BURN
	pass_flags = PASSTABLE | PASSGLASS | PASSGRILLE
	embed = 0
	incinerate = 2

/*/obj/item/projectile/energy/flamer
	name = "promethium"
	icon_state = "fire"
	check_armour = "energy"
	kill_count = 25
	damage = 10
	damage_type = BURN
	pass_flags = PASSTABLE
	step_delay = 2
	kill_count = 75
	embed = 0
	incinerate = 10*/
