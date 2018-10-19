/obj/item/projectile/ion
	name = "ion bolt"
	icon_state = "ion"
	damage = 0
	damage_type = BURN
	nodamage = 1
	check_armour = "energy"
	var/pulse_range = 1

/obj/item/projectile/ion/on_impact(var/atom/A)
	empulse(A, pulse_range, pulse_range)
	return 1

/obj/item/projectile/ion/small
	name = "ion pulse"
	pulse_range = 0

/obj/item/projectile/ion/heavy
	name = "heavy ion pulse"
	pulse_range = 5

/obj/item/projectile/bullet/gyro
	name ="explosive bolt"
	icon_state= "bolter"
	damage = 50
	check_armour = "bullet"
	sharp = 1
	edge = 1

/obj/item/projectile/bullet/gyro/on_impact(var/atom/A)
	explosion(A, -1, 0, 2)
	..()

/obj/item/projectile/bullet/gyro/law
	name ="high-ex round"
	icon_state= "bolter"
	damage = 15

/obj/item/projectile/bullet/gyro/law/on_hit(var/atom/target, var/blocked = 0)
	explosion(target, -1, 0, 2)
	sleep(0)
	var/obj/T = target
	var/throwdir = get_dir(firer,target)
	T.throw_at(get_edge_target_turf(target, throwdir),3,3)
	return 1

/obj/item/projectile/temp
	name = "freeze beam"
	icon_state = "ice_2"
	damage = 0
	damage_type = BURN
	nodamage = 1
	check_armour = "energy"
	//var/temperature = 300


/obj/item/projectile/temp/on_hit(var/atom/target, var/blocked = 0)//These two could likely check temp protection on the mob
	if(istype(target, /mob/living))
		var/mob/M = target
		M.bodytemperature = -273
	return 1

/obj/item/projectile/meteor
	name = "meteor"
	icon = 'icons/obj/meteor.dmi'
	icon_state = "small1"
	damage = 0
	damage_type = BRUTE
	nodamage = 1
	check_armour = "bullet"

/obj/item/projectile/meteor/Collide(atom/A)
	if(A == firer)
		loc = A.loc
		return

	sleep(-1) //Might not be important enough for a sleep(-1) but the sleep/spawn itself is necessary thanks to explosions and metoerhits

	if(src)//Do not add to this if() statement, otherwise the meteor won't delete them
		if(A)

			A.ex_act(2)
			playsound(src.loc, 'sound/effects/meteorimpact.ogg', 40, 1)

			for(var/mob/M in range(10, src))
				if(!M.stat && !istype(M, /mob/living/silicon/ai))\
					shake_camera(M, 3, 1)
			qdel(src)
			return 1
	else
		return 0

/obj/item/projectile/energy/floramut
	name = "alpha somatoray"
	icon_state = "energy"
	damage = 0
	damage_type = TOX
	nodamage = 1
	check_armour = "energy"

/obj/item/projectile/energy/floramut/on_hit(var/atom/target, var/blocked = 0)
	var/mob/living/M = target
	if(ishuman(target))
		var/mob/living/carbon/human/H = M
		if((H.species.flags & IS_PLANT) && (M.nutrition < 500))
			if(prob(15))
				H.apply_effect((rand(30,80)),IRRADIATE,blocked = H.getarmor(null, "rad"))
				M.Weaken(5)
				for (var/mob/V in viewers(src))
					V.show_message("<span class='warning'>[M] writhes in pain as \his vacuoles boil.</span>", 3, "<span class='warning'>You hear the crunching of leaves.</span>", 2)
			if(prob(35))
			//	for (var/mob/V in viewers(src)) //Public messages commented out to prevent possible metaish genetics experimentation and stuff. - Cheridan
			//		V.show_message("\red [M] is mutated by the radiation beam.", 3, "\red You hear the snapping of twigs.", 2)
				if(prob(80))
					randmutb(M)
					domutcheck(M,null)
				else
					randmutg(M)
					domutcheck(M,null)
			else
				M.adjustFireLoss(rand(5,15))
				M.show_message("<span class='warning'>The radiation beam singes you!</span>")
			//	for (var/mob/V in viewers(src))
			//		V.show_message("\red [M] is singed by the radiation beam.", 3, "\red You hear the crackle of burning leaves.", 2)
	else if(istype(target, /mob/living/carbon/))
	//	for (var/mob/V in viewers(src))
	//		V.show_message("The radiation beam dissipates harmlessly through [M]", 3)
		M.show_message("<span class='notice'>The radiation beam dissipates harmlessly through your body.</span>")
	else
		return 1

/obj/item/projectile/energy/florayield
	name = "beta somatoray"
	icon_state = "energy2"
	damage = 0
	damage_type = TOX
	nodamage = 1
	check_armour = "energy"

/obj/item/projectile/energy/florayield/on_hit(var/atom/target, var/blocked = 0)
	var/mob/M = target
	if(ishuman(target)) //These rays make plantmen fat.
		var/mob/living/carbon/human/H = M
		if((H.species.flags & IS_PLANT) && (M.nutrition < 500))
			M.adjustNutritionLoss(-30)
	else if (istype(target, /mob/living/carbon/))
		M.show_message("<span class='notice'>The radiation beam dissipates harmlessly through your body.</span>")
	else
		return 1


/obj/item/projectile/beam/mindflayer
	name = "flayer ray"

/obj/item/projectile/beam/mindflayer/on_hit(var/atom/target, var/blocked = 0)
	if(ishuman(target))
		var/mob/living/carbon/human/M = target
		M.adjustBrainLoss(5)
		M.hallucination += 20

/obj/item/projectile/bullet/trod
	name ="tungsten rod"
	icon_state= "gauss"
	damage = 75
	check_armour = "bomb"
	sharp = 1
	edge = 1

/obj/item/projectile/bullet/trod/on_impact(var/atom/A)
	explosion(A, 0, 0, 4)
	..()

/obj/item/projectile/chameleon
	name = "bullet"
	icon_state = "bullet"
	damage = 1 // stop trying to murderbone with a fake gun dumbass!!!
	embed = 0 // nope
	nodamage = 1
	damage_type = HALLOSS
	muzzle_type = /obj/effect/projectile/muzzle/bullet

/obj/item/projectile/bullet/cannon
	name ="armor-piercing shell"
	icon = 'icons/obj/grenade.dmi'
	icon_state = "shell"
	damage = 90
	armor_penetration = 80
	penetrating = 1

/obj/item/projectile/bullet/cannon/on_impact(var/atom/A)
	explosion(A, 2, 3, 4, 4)
	..()

//magic

/obj/item/projectile/magic
	name = "bolt of nothing"
	icon = 'icons/obj/projectiles.dmi'
	icon_state = "spell"
	damage = 0
	check_armour = "energy"
	embed = 0
	damage_type = HALLOSS

/obj/item/projectile/magic/fireball
	name = "fireball"
	icon_state = "fireball"
	damage = 20
	damage_type = BURN

/obj/item/projectile/magic/fireball/on_impact(var/atom/A)
	explosion(A, 0, 0, 4)
	..()

/obj/item/projectile/magic/teleport //literaly bluespace crystal code, because i am lazy and it seems to work
	name = "bolt of teleportation"
	icon = 'icons/obj/projectiles.dmi'
	icon_state = "energy2"
	var/blink_range = 8

/obj/item/projectile/magic/teleport/on_hit(var/atom/hit_atom)
	var/turf/T = get_turf(hit_atom)
	single_spark(T)
	playsound(src.loc, "sparks", 50, 1)
	if(isliving(hit_atom))
		blink_mob(hit_atom)
	return ..()

/obj/item/projectile/magic/teleport/proc/blink_mob(mob/living/L)
	do_teleport(L, get_turf(L), blink_range, asoundin = 'sound/effects/phasein.ogg')
