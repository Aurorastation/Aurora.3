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
	kill_count = 15 //if the shell hasn't hit anything after travelling this far it just explodes.
	var/flash_range = 0
	var/brightness = 7
	var/light_duration = 5

/obj/item/projectile/energy/flash/on_impact(var/atom/A)
	var/turf/T = flash_range? src.loc : get_turf(A)
	if(!istype(T)) return

	//blind adjacent people
	for (var/mob/living/carbon/M in viewers(T, flash_range))
		if(M.eyecheck() < 1)
			flick("e_flash", M.flash)

	//snap pop
	playsound(src, 'sound/effects/snap.ogg', 50, 1)
	src.visible_message("<span class='warning'>\The [src] explodes in a bright flash!</span>")

	new /obj/effect/decal/cleanable/ash(src.loc) //always use src.loc so that ash doesn't end up inside windows
	new /obj/effect/effect/sparks(T)
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

/obj/item/projectile/energy/sonic
	name = "distortion"
	icon = 'icons/obj/machines/particle_accelerator2.dmi'
	icon_state = "particle"
	check_armour = "bomb"
	damage = 60
	damage_type = BRUTE
	pass_flags = PASSTABLE | PASSGLASS | PASSGRILLE
	kill_count = 100
	embed = 0
//	incinerate = 40
	weaken = 5
	stun = 5

/obj/item/projectile/energy/sonic/on_impact(var/atom/A)
	if(isturf(A))
		A.ex_act(0)
	if(ismob(A))
		var/mob/M = A
		explosion(M, -1, 0, 2)
		M.gib()
	if(!(isturf(A)) & !(ismob(A)))
		explosion(A, -1, 0, 2)
	..()

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
	for(var/i=1, i<=8, i++)
		var/atom/movable/x = new /mob/living/simple_animal/bee/beegun //hackmaster pro, butt fuck it
		x.loc = T
		if(istype(T, /turf/simulated/wall) || istype(T, /turf/simulated/shuttle/wall))
			qdel(x)
		if(istype(A, /obj/structure/window) || istype(A, /obj/machinery/door))
			qdel(x)
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