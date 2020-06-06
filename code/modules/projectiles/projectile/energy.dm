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
	range = 15 //if the shell hasn't hit anything after travelling this far it just explodes.
	var/flash_range = 0
	var/brightness = 7
	var/light_duration = 5

/obj/item/projectile/energy/flash/on_impact(var/atom/A)
	var/turf/T = flash_range? src.loc : get_turf(A)
	if(!istype(T)) return

	//blind adjacent people
	for (var/mob/living/carbon/M in viewers(T, flash_range))
		if(M.eyecheck() < FLASH_PROTECTION_MODERATE)
			M.confused = rand(5,15)
			flick("e_flash", M.flash)

	//snap pop
	playsound(src, 'sound/effects/snap.ogg', 50, 1)
	src.visible_message("<span class='warning'>\The [src] explodes in a bright flash!</span>")

	new /obj/effect/decal/cleanable/ash(src.loc) //always use src.loc so that ash doesn't end up inside windows
	single_spark(T)
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
	damage = 2 //Flavor.
	damage_type = BURN
	taser_effect = 1
	agony = 40
	eyeblur = 1
	//Damage will be handled on the MOB side, to prevent window shattering.

/obj/item/projectile/energy/electrode/stunshot
	name = "stunshot"
	damage = 5
	taser_effect = 1
	agony = 80

/obj/item/projectile/energy/declone
	name = "decloner beam"
	icon_state = "declone"
	damage = 20
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
	range = 100
	embed = 0
	speed = 8
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

/obj/item/projectile/energy/bfg/after_move()
	for(var/a in range(1, src))
		if(isliving(a) && a != firer)
			var/mob/living/M = a
			if(M.stat == DEAD)
				M.gib()
			else
				M.apply_damage(60, BRUTE, BP_HEAD)
			playsound(src, 'sound/magic/LightningShock.ogg', 75, 1)
		else if(isturf(a) || isobj(a))
			var/atom/A = a
			if(!A.density)
				continue
			A.ex_act(2)
			playsound(src, 'sound/magic/LightningShock.ogg', 75, 1)

/obj/item/projectile/energy/tesla
	name = "tesla bolt"
	icon = 'icons/effects/effects.dmi'
	icon_state = "lightning1"
	damage = 10
	damage_type = BURN
	pass_flags = PASSTABLE | PASSGRILLE
	range = 40
	embed = 0
	speed = 1.5
	light_range = 5
	light_color = "#b5ff5b"

/obj/item/projectile/energy/tesla/on_impact(atom/target)
	. = ..()
	if(isliving(target))
		tesla_zap(target, 3, 5000)

/obj/item/projectile/energy/tesla/master
	damage = 15

/obj/item/projectile/energy/tesla/grandmaster
	damage = 20

/obj/item/projectile/energy/tesla/paramount
	damage = 25

/obj/item/projectile/energy/gravitydisabler
	name = "gravity disabler"
	icon = 'icons/obj/projectiles.dmi'
	icon_state = "bluespace"
	damage = 0
	damage_type = BRUTE
	pass_flags = PASSTABLE | PASSGRILLE
	range = 10
	embed = 0
	speed = 2
	light_range = 4
	light_color = "#b5ff5b"

/obj/item/projectile/energy/gravitydisabler/on_impact(atom/target)
	. = ..()
	var/area/A = get_area(target)
	if(A && A.has_gravity())
		A.gravitychange(FALSE)
		addtimer(CALLBACK(src, .proc/turnongravity), 150)

	if(istype(target, /obj/machinery/gravity_generator/main))
		var/obj/machinery/gravity_generator/main/T = target
		T.eshutoff()

/obj/item/projectile/energy/gravitydisabler/proc/turnongravity(var/area/A)
	A.gravitychange(TRUE)

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
	if(!istype(T, /turf/simulated/wall) && !istype(A, /obj/structure/window) && !istype(A, /obj/machinery/door))
		for(var/i=1, i<=8, i++)
			var/atom/movable/x = new /mob/living/simple_animal/bee/beegun //hackmaster pro, butt fuck it
			x.forceMove(T)
	else
		src.visible_message("<span class='danger'>[src] splat sickly against [T]!</span>")
	..()

/obj/item/projectile/energy/blaster
	name = "blaster bolt"
	icon_state = "heavybolt"
	damage = 30
	check_armour = "laser"
	damage_type = BURN
	pass_flags = PASSTABLE | PASSGLASS | PASSGRILLE
	muzzle_type = /obj/effect/projectile/muzzle/bolt
	hit_effect = /obj/effect/temp_visual/blaster_effect

/obj/item/projectile/energy/blaster/heavy
	damage = 35

/obj/item/projectile/energy/blaster/incendiary
	icon_state = "laser"
	damage = 15
	incinerate = 2
