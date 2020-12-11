/obj/item/melee/arm_blade
	name = "arm blade"
	desc = "A grotesque blade made out of bone and flesh that cleaves through people like a hot knife through butter."
	icon = 'icons/obj/changeling.dmi'
	icon_state = "arm_blade"
	item_state = "arm_blade"
	contained_sprite = TRUE
	w_class = ITEMSIZE_LARGE
	force = 30
	sharp = TRUE
	edge = TRUE
	anchored = TRUE
	throwforce = 0 //Just to be on the safe side
	throw_range = 0
	throw_speed = 0
	can_embed = FALSE
	hitsound = 'sound/weapons/bladeslice.ogg'
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	canremove = FALSE
	var/mob/living/creator

/obj/item/melee/arm_blade/New()
	..()
	START_PROCESSING(SSprocessing, src)

/obj/item/melee/arm_blade/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	return ..()

/obj/item/melee/arm_blade/dropped(var/mob/living/user)
	visible_message(SPAN_DANGER("With a sickening crunch, [user] reforms their arm blade into an arm!"),
	SPAN_WARNING("You hear organic matter ripping and tearing!"))
	playsound(loc, 'sound/effects/blobattack.ogg', 30, 1)
	QDEL_IN(src, 1)

/obj/item/melee/arm_blade/process()
	if(!creator || loc != creator || (creator.l_hand != src && creator.r_hand != src))
		// Tidy up a bit.
		if(istype(loc,/mob/living))
			var/mob/living/carbon/human/host = loc
			if(istype(host))
				for(var/obj/item/organ/external/organ in host.organs)
					for(var/obj/item/O in organ.implants)
						if(O == src)
							organ.implants -= src
			host.pinned -= src
			host.embedded -= src
			host.drop_from_inventory(src)
		QDEL_IN(src, 1)

/obj/item/melee/arm_blade/iscrowbar()
	if(creator.a_intent == I_HELP)
		return TRUE
	return FALSE

/obj/item/melee/arm_blade/resolve_attackby(atom/A, mob/living/user, var/click_parameters)
	if(istype(A,/turf/simulated/floor) && user.a_intent != I_HELP)
		return
	else
		..()

/obj/item/shield/riot/changeling
	name = "shield-like mass"
	desc = "A mass of tough, boney tissue. You can still see the fingers as a twisted pattern in the shield."
	icon = 'icons/obj/changeling.dmi'
	icon_state = "ling_shield"
	item_state = "ling_shield"
	contained_sprite = TRUE
	force = 15 //Bash the crap out of people
	slot_flags = null
	anchored = TRUE
	throwforce = 0 //Just to be on the safe side
	throw_range = 0
	throw_speed = 0
	can_embed = FALSE
	base_block_chance = 70
	var/mob/living/creator

/obj/item/shield/riot/changeling/New()
	..()
	START_PROCESSING(SSprocessing, src)

/obj/item/shield/riot/changeling/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	return ..()

/obj/item/shield/riot/changeling/dropped(var/mob/living/user)
	visible_message(SPAN_DANGER("With a sickening crunch, [user] reforms their shield into an arm!"),
	SPAN_WARNING("You hear organic matter ripping and tearing!"))
	playsound(loc, 'sound/effects/blobattack.ogg', 30, 1)
	QDEL_IN(src, 1)

/obj/item/shield/riot/changeling/process()
	if(!creator || loc != creator || (creator.l_hand != src && creator.r_hand != src))
		// Tidy up a bit.
		if(istype(loc,/mob/living))
			var/mob/living/carbon/human/host = loc
			if(istype(host))
				for(var/obj/item/organ/external/organ in host.organs)
					for(var/obj/item/O in organ.implants)
						if(O == src)
							organ.implants -= src
			host.pinned -= src
			host.embedded -= src
			host.drop_from_inventory(src)
		QDEL_IN(src, 1)

/obj/item/shield/riot/changeling/get_block_chance(mob/user, var/damage, atom/damage_source = null, mob/attacker = null)
	if(istype(damage_source, /obj/item/projectile))
		var/obj/item/projectile/P = damage_source
		if((is_sharp(P) && damage > 10) || istype(P, /obj/item/projectile/beam))
			return base_block_chance / 2 //lings still have a 35% chance of blocking these kinds of attacks
	return base_block_chance

/obj/item/bone_dart
	name = "bone dart"
	desc = "A sharp piece of bone shapped as small dart."
	icon = 'icons/obj/changeling.dmi'
	icon_state = "bone_dart"
	item_state = "bolt"
	sharp = TRUE
	edge = FALSE
	throwforce = 5
	w_class = ITEMSIZE_SMALL


/***************************************\
|***********COMBAT TENTACLES*************|
\***************************************/

/obj/item/gun/energy/tentacle
	name = "tentacle"
	desc = "A horrible amalgamation of blood and flesh, warped into the shape of a pulsing tentacle."
	desc_info = null
	desc_antag = "A fleshy tentacle that can stretch out and grab things or people."
	icon = 'icons/obj/contained_items/weapons/ling_tentacle.dmi'
	icon_state = "tentacle"
	item_state = "tentacle"
	flags = NOBLUDGEON
	w_class = ITEMSIZE_HUGE
	has_safety = FALSE
	needspin = FALSE
	pin = null
	projectile_type = /obj/item/projectile/tentacle
	fire_sound = 'sound/effects/splat.ogg'
	force = 0
	max_shots = 1
	throwforce = 0 //Just to be on the safe side
	throw_range = 0
	throw_speed = 0
	charge_failure_message = "cannot be charged."

/obj/item/gun/energy/tentacle/update_icon()
	return

/obj/item/gun/energy/tentacle/dropped(mob/living/user)
	if(power_supply?.charge > 0 && !user.stat)
		user.visible_message(SPAN_DANGER("With a sickening crunch, [user] reforms their tentacle into an arm!"), SPAN_NOTICE("You reform your tentacle into an arm."), SPAN_WARNING("You hear organic matter ripping and tearing!"))
		playsound(loc, 'sound/effects/blobattack.ogg', 30, 1)
	QDEL_IN(src, 1)

/obj/item/gun/energy/tentacle/handle_click_empty(user)
	to_chat(user, SPAN_WARNING("\The [src] is not ready yet."))

/obj/item/gun/energy/tentacle/handle_suicide(mob/living/user)
	user.visible_message(SPAN_WARNING("[user] coils \the [src] tightly around [user.get_pronoun("his")] neck!"))
	if(!do_after(user, 40))
		return
	user.adjustOxyLoss(300)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		var/obj/item/organ/internal/brain = H.internal_organs_by_name[BP_BRAIN]
		if(brain)
			brain.take_internal_damage(brain.max_damage)
	user.death() // double tap - geeves

/obj/item/projectile/tentacle
	name = "tentacle"
	icon = 'icons/obj/contained_items/weapons/ling_tentacle.dmi'
	icon_state = "tentacle_end"
	pass_flags = PASSTABLE
	cant_miss = TRUE
	damage = 0
	damage_type = BRUTE
	range = 8
	hitsound = 'sound/weapons/thudswoosh.ogg'
	var/chain
	var/obj/item/gun/energy/tentacle/source //the item that shot it

/obj/item/projectile/tentacle/New(obj/item/gun/energy/tentacle/tentacle_gun)
	source = tentacle_gun
	..()

/obj/item/projectile/tentacle/fire(setAngle)
	if(firer)
		chain = firer.Beam(src, icon_state = "tentacle", time = -1, maxdistance = INFINITY, beam_sleep_time = 1)
	..()

/obj/item/projectile/tentacle/proc/reset_throw(mob/living/carbon/human/H)
	if(H.in_throw_mode)
		H.throw_mode_off() //Don't annoy the changeling if he doesn't catch the item

/mob/proc/tentacle_grab(mob/living/carbon/human/H)
	if(ishuman(H) && Adjacent(H))
		var/obj/item/grab/G = H.grabbedby(src, TRUE)
		if(istype(G))
			G.set_state(GRAB_AGGRESSIVE) //Instant aggressive grab

/mob/proc/tentacle_stab(mob/living/carbon/C)
	if(Adjacent(C))
		var/obj/item/I = r_hand
		if(!is_sharp(I))
			I = l_hand
		if(!is_sharp(I))
			return

		C.visible_message(SPAN_DANGER("[src] impales [C] with [I]!"), SPAN_DANGER("[src] impales you with [I]!"))
		C.apply_damage(I.force, BRUTE, "chest")
		do_attack_animation(C)
		add_blood(C)
		playsound(get_turf(src), I.hitsound, 75, 1)

/obj/item/projectile/tentacle/on_hit(atom/target, blocked = 0)
	qdel(source) //one tentacle only unless you miss
	if(blocked >= 100)
		return FALSE
	var/mob/living/carbon/human/H = firer
	if(istype(target, /obj/item))
		var/obj/item/I = target
		if(!I.anchored)
			to_chat(firer, SPAN_NOTICE("You pull [I] towards yourself."))
			H.throw_mode_on()
			I.throw_at(H, 10, 2)
			. = TRUE

	else if(isliving(target))
		var/mob/living/L = target
		if(!L.anchored && !L.throwing)//avoid double hits
			if(iscarbon(L))
				var/mob/living/carbon/C = L
				switch(firer.a_intent)
					if(I_HELP)
						C.visible_message(SPAN_DANGER("[L] is pulled by [H]'s tentacle!"), SPAN_DANGER("A tentacle grabs you and pulls you towards [H]!"))
						C.throw_at(get_step_towards(H,C), 8, 2)
						return TRUE

					if(I_DISARM)
						var/obj/item/I = C.get_active_hand()
						if(!I || istype(I, /obj/item/grab))
							I = C.get_inactive_hand()
						if(I && !istype(I, /obj/item/grab))
							if(C.unEquip(I))
								C.visible_message(SPAN_DANGER("[I] is yanked out of [C]'s hand by [src]!"),SPAN_DANGER("A tentacle pulls [I] away from you!"))
								I.throw_at(get_step_towards(H, C), 8, 2, callback = CALLBACK(H, /mob/proc/put_in_any_hand_if_possible, I))
								return TRUE
							else
								to_chat(firer, SPAN_DANGER("You can't seem to pry [I] out of [C]'s hands!"))
								return FALSE
						else
							to_chat(firer, SPAN_DANGER("[C] has nothing in hand to disarm!"))
							return FALSE

					if(I_GRAB)
						C.visible_message(SPAN_DANGER("[L] is grabbed by [H]'s tentacle!"), SPAN_DANGER("A tentacle grabs you and pulls you towards [H]!"))
						C.throw_at(get_step_towards(H,C), 8, 2, callback=CALLBACK(H, /mob/proc/tentacle_grab, C))
						return TRUE

					if(I_HURT)
						C.visible_message(SPAN_DANGER("[L] is thrown towards [H] by a tentacle!"), SPAN_DANGER("A tentacle grabs you and throws you towards [H]!"))
						C.throw_at(get_step_towards(H,C), 8, 2, callback=CALLBACK(H, /mob/proc/tentacle_stab, C))
						return TRUE
			else
				L.visible_message(SPAN_DANGER("[L] is pulled by [H]'s tentacle!"), SPAN_DANGER("A tentacle grabs you and pulls you towards [H]!"))
				L.throw_at(get_step_towards(H,L), 8, 2)
				. = TRUE

/obj/item/projectile/tentacle/on_impact(var/atom/A)
	if(isturf(A))
		qdel(source)

/obj/item/projectile/tentacle/Destroy()
	qdel(chain)
	source = null
	return ..()