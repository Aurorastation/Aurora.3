/obj/item/projectile/ion
	name = "ion bolt"
	icon_state = "ion"
	damage = 0
	damage_type = BURN
	nodamage = 1
	check_armor = "energy"
	var/pulse_range = 1

/obj/item/projectile/ion/on_impact(var/atom/A)
	empulse(A, pulse_range, pulse_range)
	return 1


/obj/item/projectile/ion/stun/on_impact(var/atom/A)
	if(isipc(A))
		var/mob/living/carbon/human/H = A
		var/obj/item/organ/internal/surge/s = H.internal_organs_by_name["surge"]
		if(!isnull(s))
			if(s.surge_left >= 0.5)
				playsound(src.loc, 'sound/magic/LightningShock.ogg', 25, 1)
				s.surge_left -= 0.5
				if(s.surge_left)
					H.visible_message("<span class='warning'>[H] was not affected by EMP pulse.</span>", "<span class='warning'>Warning: EMP detected, integrated surge prevention module activated. There are [s.surge_left] preventions left.</span>")
				else
					s.broken = 1
					s.icon_state = "surge_ipc_broken"
					to_chat(H, "<span class='warning'>Warning: EMP detected, integrated surge prevention module activated. The surge prevention module is fried, replacement recommended.</span>")
				return 1
			else
				to_chat(src, "<span class='danger'>Warning: EMP detected, integrated surge prevention module is fried and unable to protect from EMP. Replacement recommended.</span>")
		H.Weaken(5)
		to_chat(H, "<span class='danger'>ERROR: detected low setting EMP, acutators experience temporary power loss. Attempting to restore power.</span>")
	else if (isrobot(A))
		var/mob/living/silicon/robot/R = A
		var/datum/robot_component/surge/C = R.components["surge"]
		if(C && C.installed)
			if(C.surge_left >= 0.5)
				playsound(src.loc, 'sound/magic/LightningShock.ogg', 25, 1)
				C.surge_left -= 0.5
				R.visible_message("<span class='warning'>[R] was not affected by EMP pulse.</span>", "<span class='warning'>Warning: Power surge detected, source - EMP. Surge prevention module re-routed surge to prevent damage to vital electronics.</span>")
				if(C.surge_left)
					to_chat(R, "<span class='notice'>Surge module has [C.surge_left] preventions left!</span>")
				else
					C.destroy()
					to_chat(R, "<span class='danger'>Module is entirely fried, replacement is recommended.</span>")
				return
			else
				to_chat(src, "<span class='notice'>Warning: Power surge detected, source - EMP. Surge prevention module is depleted and requires replacement</span>")

		R.emp_act(2) // Borgs emp_act is 1-2
	else
		A.emp_act(3) // Deals less EMP damage then lethal setting, and not areal pulse
	return 1

/obj/item/projectile/ion/small
	name = "ion pulse"
	pulse_range = 0

/obj/item/projectile/ion/heavy
	name = "heavy ion pulse"
	pulse_range = 5

/obj/item/projectile/ion/gauss
	name = "ion slug"
	icon_state = "heavygauss"

/obj/item/projectile/bullet/gyro
	name ="explosive bolt"
	icon_state= "bolter"
	damage = 50
	check_armor = "bullet"
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
	check_armor = "energy"
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
	check_armor = "bullet"

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
	check_armor = "energy"

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
	check_armor = "energy"

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
	check_armor = "bomb"
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
	damage_type = PAIN
	muzzle_type = /obj/effect/projectile/muzzle/bullet

/obj/item/projectile/bullet/cannon
	name ="armor-piercing shell"
	icon = 'icons/obj/grenade.dmi'
	icon_state = "shell"
	damage = 90
	armor_penetration = 80
	penetrating = 1

/obj/item/projectile/bullet/cannon/on_impact(var/atom/A)
	explosion(A, 1, 2, 3, 3)
	..()

//magic

/obj/item/projectile/magic
	name = "bolt of nothing"
	icon = 'icons/obj/projectiles.dmi'
	icon_state = "spell"
	damage = 0
	check_armor = "energy"
	embed = 0
	damage_type = PAIN

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

/obj/item/projectile/plasma
	name = "plasma slug"
	icon_state = "plasma_bolt"
	damage = 25
	damage_type = BRUTE
	check_armor = "energy"
	incinerate = 10
	armor_penetration = 20
	penetrating = 1

/obj/item/projectile/plasma/light
	name = "plasma bolt"
	damage = 10
	armor_penetration = 10
	incinerate = 5

/obj/item/missile
	icon = 'icons/obj/grenade.dmi'
	icon_state = "missile"
	var/primed = null
	throwforce = 15

/obj/item/missile/throw_impact(atom/hit_atom)
	if(primed)
		explosion(hit_atom, 0, 1, 2, 4)
		qdel(src)
	else
		..()
	return
