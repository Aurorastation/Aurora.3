/obj/projectile/ion
	name = "ion bolt"
	icon_state = "ion"
	damage = 0
	damage_type = DAMAGE_BURN
	impact_sounds = list(BULLET_IMPACT_MEAT = SOUNDS_ION_ANY, BULLET_IMPACT_METAL = SOUNDS_ION_ANY)
	check_armor = ENERGY
	var/pulse_range = 1

/obj/projectile/ion/on_hit(atom/target, blocked, def_zone)
	. = ..()

	empulse(target, pulse_range, pulse_range)

/obj/projectile/ion/stun/on_hit(atom/target, blocked, def_zone)
	. = ..()

	if(isipc(target))
		var/mob/living/carbon/human/H = target
		var/obj/item/organ/internal/surge/s = H.internal_organs_by_name["surge"]
		if(!isnull(s))
			if(s.surge_left >= 0.5)
				playsound(src.loc, 'sound/magic/LightningShock.ogg', 25, 1)
				s.surge_left -= 0.5
				if(s.surge_left)
					H.visible_message(SPAN_WARNING("[H] was not affected by EMP pulse."),
										SPAN_WARNING("Warning: EMP detected, integrated surge prevention module activated. There are [s.surge_left] preventions left."))
				else
					s.broken = 1
					s.icon_state = "surge_ipc_broken"
					to_chat(H, SPAN_WARNING("Warning: EMP detected, integrated surge prevention module activated. The surge prevention module is fried, replacement recommended."))
				return
			else
				to_chat(src, SPAN_DANGER("Warning: EMP detected, integrated surge prevention module is fried and unable to protect from EMP. Replacement recommended."))
	if (isrobot(target))
		var/mob/living/silicon/robot/R = target
		var/datum/robot_component/surge/C = R.components["surge"]
		if(C && C.installed)
			if(C.surge_left >= 0.5)
				playsound(src.loc, 'sound/magic/LightningShock.ogg', 25, 1)
				C.surge_left -= 0.5
				R.visible_message(SPAN_WARNING("[R] was not affected by EMP pulse."),
									SPAN_WARNING("Warning: Power surge detected, source - EMP. Surge prevention module re-routed surge to prevent damage to vital electronics."))
				if(C.surge_left)
					to_chat(R, SPAN_NOTICE("Surge module has [C.surge_left] preventions left!"))
				else
					C.destroy()
					to_chat(R, SPAN_DANGER("Module is entirely fried, replacement is recommended."))
				return
			else
				to_chat(src, SPAN_NOTICE("Warning: Power surge detected, source - EMP. Surge prevention module is depleted and requires replacement"))

		R.emp_act(EMP_LIGHT) // Borgs emp_act is 1-2
	else
		target.emp_act(EMP_LIGHT)
	return

/obj/projectile/ion/small
	name = "ion pulse"
	pulse_range = 0

/obj/projectile/ion/heavy
	name = "heavy ion pulse"
	pulse_range = 5

/obj/projectile/ion/gauss
	name = "ion slug"
	icon_state = "heavygauss"

/obj/projectile/bullet/gyro
	name ="explosive bolt"
	icon_state= "bolter"
	damage = 50
	check_armor = BULLET
	sharp = 1
	edge = TRUE

/obj/projectile/bullet/gyro/on_hit(atom/target, blocked, def_zone)
	explosion(target, -1, 0, 2)
	. = ..()

/obj/projectile/bullet/gyro/law
	name ="high-ex round"
	icon_state= "bolter"
	damage = 15

/obj/projectile/bullet/gyro/law/on_hit(atom/target, blocked, def_zone)
	. = ..()

	explosion(target, -1, 0, 2)
	var/obj/T = target
	var/throwdir = get_dir(firer,target)
	T.throw_at(get_edge_target_turf(target, throwdir),3,3)
	return 1

/obj/projectile/temp
	name = "freeze beam"
	icon_state = "ice_2"
	damage = 0
	damage_type = DAMAGE_BURN
	check_armor = ENERGY
	//var/temperature = 300


/obj/projectile/temp/on_hit(atom/target, blocked, def_zone)//These two could likely check temp protection on the mob
	. = ..()
	if(istype(target, /mob/living))
		var/mob/M = target
		M.bodytemperature = -273
	return 1

/obj/projectile/meteor
	name = "meteor"
	icon = 'icons/obj/meteor.dmi'
	icon_state = "small1"
	damage = 0
	damage_type = DAMAGE_BRUTE
	check_armor = BULLET

/obj/projectile/meteor/Collide(atom/A)
	if(A == firer)
		loc = A.loc
		return

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

/obj/projectile/energy/floramut
	name = "alpha somatoray"
	icon_state = "energy"
	damage = 0
	damage_type = DAMAGE_TOXIN
	check_armor = ENERGY

/obj/projectile/energy/floramut/gene
	name = "gamma somatoray"
	icon_state = "energy2"
	damage = 0
	damage_type = DAMAGE_TOXIN
	var/singleton/plantgene/gene = null

/obj/projectile/energy/floramut/on_hit(atom/target, blocked, def_zone)
	. = ..()
	var/mob/living/M = target
	if(ishuman(target))
		var/mob/living/carbon/human/H = M
		if((H.species.flags & IS_PLANT) && (M.nutrition < 500))
			if(prob(15))
				H.apply_damage(rand(30,80), DAMAGE_RADIATION, damage_flags = DAMAGE_FLAG_DISPERSED)
				M.Weaken(5)
				for (var/mob/V in viewers(src))
					V.show_message(SPAN_WARNING("[M] writhes in pain as [M.get_pronoun("his")] vacuoles boil."), 3, SPAN_WARNING("You hear the crunching of leaves."), 2)
			if(prob(35))
				if(prob(80))
					randmutb(M)
					domutcheck(M,null)
				else
					randmutg(M)
					domutcheck(M,null)
			else
				M.adjustFireLoss(rand(5,15))
				M.show_message(SPAN_WARNING("The radiation beam singes you!"))
	else if(iscarbon(target))
		M.show_message(SPAN_NOTICE("The radiation beam dissipates harmlessly through your body."))
	else
		return 1

/obj/projectile/energy/florayield
	name = "beta somatoray"
	icon_state = "energy2"
	damage = 0
	damage_type = DAMAGE_TOXIN
	check_armor = ENERGY

/obj/projectile/energy/florayield/on_hit(atom/target, blocked, def_zone)
	. = ..()
	var/mob/M = target
	if(ishuman(target)) //These rays make plantmen fat.
		var/mob/living/carbon/human/H = M
		if((H.species.flags & IS_PLANT) && (M.nutrition < 500))
			M.adjustNutritionLoss(-30)
	else if (istype(target, /mob/living/carbon/))
		M.show_message(SPAN_NOTICE("The radiation beam dissipates harmlessly through your body."))
	else
		return 1


/obj/projectile/beam/mindflayer
	name = "flayer ray"

/obj/projectile/beam/mindflayer/on_hit(atom/target, blocked, def_zone)
	. = ..()
	if(ishuman(target))
		var/mob/living/carbon/human/M = target
		M.adjustBrainLoss(5)
		M.hallucination += 20

/obj/projectile/bullet/trod
	name ="tungsten rod"
	icon_state= "gauss"
	damage = 75
	check_armor = BOMB
	sharp = 1
	edge = TRUE

/obj/projectile/bullet/trod/on_hit(atom/target, blocked, def_zone)
	explosion(target, 0, 0, 4)
	. = ..()

/obj/projectile/chameleon
	name = "bullet"
	icon_state = "bullet"
	damage = 0 // stop trying to murderbone with a fake gun dumbass!!!
	embed = 0 // nope
	damage_type = DAMAGE_PAIN
	muzzle_type = /obj/effect/projectile/muzzle/bullet

/obj/projectile/bullet/cannon
	name ="armor-piercing shell"
	icon = 'icons/obj/grenade.dmi'
	icon_state = "shell"
	damage = 90
	armor_penetration = 80
	penetrating = 1

/obj/projectile/bullet/cannon/on_hit(atom/target, blocked, def_zone)
	explosion(target, 1, 2, 3, 3)
	. = ..()

//magic

/obj/projectile/magic
	name = "bolt of nothing"
	icon = 'icons/obj/projectiles.dmi'
	icon_state = "spell"
	damage = 0
	check_armor = ENERGY
	embed = 0
	damage_type = DAMAGE_PAIN

/obj/projectile/magic/fireball
	name = "fireball"
	icon_state = "fireball"
	damage = 20
	damage_type = DAMAGE_BURN

/obj/projectile/magic/fireball/on_hit(atom/target, blocked, def_zone)
	explosion(target, 0, 0, 4)
	. = ..()

/obj/projectile/magic/teleport //literaly bluespace crystal code, because i am lazy and it seems to work
	name = "bolt of teleportation"
	icon = 'icons/obj/projectiles.dmi'
	icon_state = "energy2"
	var/blink_range = 8

/obj/projectile/magic/teleport/on_hit(atom/target, blocked, def_zone)
	var/turf/T = get_turf(target)
	single_spark(T)
	playsound(src.loc, /singleton/sound_category/spark_sound, 50, 1)
	if(isliving(target))
		blink_mob(target)
	return ..()

/obj/projectile/magic/teleport/proc/blink_mob(mob/living/L)
	do_teleport(L, get_turf(L), blink_range, asoundin = 'sound/effects/phasein.ogg')

/obj/projectile/plasma
	name = "plasma slug"
	icon_state = "plasma_bolt"
	damage = 20
	damage_type = DAMAGE_BRUTE
	damage_flags = DAMAGE_FLAG_LASER
	check_armor = ENERGY
	incinerate = 10
	armor_penetration = 60
	penetrating = 1

/obj/projectile/plasma/light
	name = "plasma bolt"
	damage = 15
	armor_penetration = 60
	incinerate = 8

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

/obj/projectile/ice
	name ="ice bolt"
	icon_state= "icer_bolt"
	damage = 15
	damage_type = DAMAGE_BRUTE
	check_armor = ENERGY

/obj/projectile/bonedart
	name = "bone dart"
	icon_state = "bonedart"
	damage = 35
	damage_type = DAMAGE_BRUTE
	impact_sounds = list(BULLET_IMPACT_MEAT = SOUNDS_BULLET_MEAT, BULLET_IMPACT_METAL = SOUNDS_BULLET_METAL)
	check_armor = MELEE
	embed = TRUE
	sharp = TRUE
	shrapnel_type = /obj/item/bone_dart/vannatusk

/obj/projectile/bonedart/ling
	name = "bone dart"
	damage = 10
	armor_penetration = 10
	check_armor = BULLET
