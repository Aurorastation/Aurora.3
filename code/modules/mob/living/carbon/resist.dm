/mob/living/carbon/process_resist()

	//drop && roll
	if(on_fire && !buckled_to)
		var/obj/effect/decal/cleanable/foam/extinguisher_foam = locate() in src.loc
		var/extra = 0
		if(extinguisher_foam)
			extra = extinguisher_foam.amount * 1.5
		ExtinguishMob(1.2 + extra)
		Weaken(3)
		spin(32,2)
		visible_message(
			SPAN_DANGER("[src] rolls on the floor, trying to put themselves out!"),
			SPAN_NOTICE("You stop, drop, and roll!")
			)
		sleep(3 SECONDS)
		if(fire_stacks <= 0)
			visible_message(
				SPAN_DANGER("[src] has successfully extinguished themselves!"),
				SPAN_NOTICE("You extinguish yourself.")
				)
		return

	..()

	if (handcuffed)
		INVOKE_ASYNC(src, PROC_REF(escape_handcuffs))
	else if (legcuffed)
		INVOKE_ASYNC(src, PROC_REF(escape_legcuffs))

/mob/living/carbon/human/process_resist()
	if (istype(wear_suit, /obj/item/clothing/suit/straight_jacket))
		INVOKE_ASYNC(src, PROC_REF(escape_jacket))
		return
	..()

/mob/living/carbon/human/proc/escape_jacket()
	visible_message(
		SPAN_DANGER("\The [src] attempts to escape [wear_suit]!"),
		SPAN_WARNING("You attempt to escape [wear_suit]. (This will take around 6 minutes and you need to stand still)")
		)
	if (!do_after(src, 1.5 MINUTES, act_target = src))
		return
	visible_message(
			SPAN_WARNING("\The [src] is shifting in their [wear_suit]!"),
			SPAN_WARNING("You start to loosen the [wear_suit].")
		)
	if (!do_after(src, 1.5 MINUTES, act_target = src))
		return
	visible_message(
			SPAN_DANGER("\The [src] is moving in their [wear_suit]!"),
			SPAN_WARNING("You slip one of your arms out of the [wear_suit].")
		)
	if (!do_after(src, 1.5 MINUTES, act_target = src))
		return
	visible_message(
			SPAN_DANGER("\The [src] is moving around in their [wear_suit] - it looks like they are about to break out!"),
			SPAN_WARNING("You start to pull loose the straps on the straightjacket[wear_suit].")
		)
	if (do_after(src, 1.5 MINUTES, act_target = src))
		var/obj/ex_suit = wear_suit
		remove_from_mob(wear_suit)
		ex_suit.forceMove(get_turf(src))

/mob/living/carbon/proc/escape_handcuffs()
	//if(!(last_special <= world.time)) return

	//This line represent a significant buff to grabs...
	// We don't have to check the click cooldown because /mob/living/verb/resist() has done it for us, we can simply set the delay
	setClickCooldown(100)

	if(can_break_cuffs()) //Don't want to do a lot of logic gating here.
		break_handcuffs()
		return

	var/obj/item/handcuffs/HC = handcuffed

	//A default in case you are somehow handcuffed with something that isn't an obj/item/handcuffs type
	var/breakouttime = 1200
	var/displaytime = 2 //Minutes to display in the "this will take X minutes."
	//If you are handcuffed with actual handcuffs... Well what do I know, maybe someone will want to handcuff you with toilet paper in the future...
	if(istype(HC))
		breakouttime = HC.breakouttime

	if(buckled_to)
		breakouttime += 600 //If you are buckled_to, it takes a minute longer, but you are unbuckled and uncuffed instantly

	displaytime = breakouttime / 600 //Minutes

	var/mob/living/carbon/human/H = src
	if(istype(H) && H.gloves && istype(H.gloves,/obj/item/clothing/gloves/rig))
		breakouttime /= 2
		displaytime /= 2

	//Check if the user is trying to violently remove the handcuffs
	var/violent_removal = 0
	if(a_intent == I_HURT)
		violent_removal = 1
		breakouttime = rand(450,600)
		visible_message(
			SPAN_DANGER("\The [src] attempts to break out of \the [HC]!"),
			SPAN_WARNING("You attempt to break out of \the [HC]. (This will take around 1 minute and you need to stand still)")
			)
	else
		visible_message(
			SPAN_DANGER("\The [src] attempts to slip out of \the [HC]!"),
			SPAN_WARNING("You attempt to slip out of \the [HC]. (This will take around [displaytime] minutes and you need to stand still)")
			)

	if(do_after(src, breakouttime))
		if(!handcuffed)
			return

		var/buckle_message_user = ""
		var/buckle_message_other = ""
		if(buckled_to) //If the person is buckled, also unbuckle the person
			buckle_message_user = " and unbuckle yourself"
			buckle_message_other = " and to unbuckle themself"
			buckled_to.user_unbuckle(src)

		if(violent_removal)
			var/obj/item/organ/external/E = H.get_organ(pick(BP_L_ARM,BP_R_ARM))
			var/dislocate_message = ""
			if(E && !ORGAN_IS_DISLOCATED(E))
				E.dislocate(1)
				dislocate_message = ", but dislocate your [E] in the process"
			visible_message(
				SPAN_DANGER("\The [src] manages to remove \the [handcuffed][buckle_message_other]!"),
				SPAN_NOTICE("You successfully remove \the [handcuffed][buckle_message_user][dislocate_message].")
				)
		else
			visible_message(
				SPAN_NOTICE("\The [src] manages to slip out of \the [handcuffed][buckle_message_other]!"),
				SPAN_NOTICE("You successfully slip out of \the [handcuffed][buckle_message_user].")
				)
		drop_from_inventory(handcuffed)


/mob/living/carbon/proc/escape_legcuffs()
	if(!canClick())
		return

	setClickCooldown(100)

	if(can_break_cuffs()) //Don't want to do a lot of logic gating here.
		break_legcuffs()
		return

	var/obj/item/handcuffs/HC = legcuffed

	//A default in case you are somehow legcuffed with something that isn't an obj/item/legcuffs type
	var/breakouttime = 1200
	var/displaytime = 2 //Minutes to display in the "this will take X minutes."
	//If you are legcuffed with actual legcuffs... Well what do I know, maybe someone will want to legcuff you with toilet paper in the future...
	if(istype(HC))
		breakouttime = HC.breakouttime
		displaytime = breakouttime / 600 //Minutes

	visible_message(
		SPAN_DANGER("[usr] attempts to remove \the [HC]!"),
		SPAN_WARNING("You attempt to remove \the [HC]. (This will take around [displaytime] minutes and you need to stand still)")
		)

	if(do_after(src, breakouttime))
		if(!legcuffed || buckled_to)
			return
		visible_message(
			SPAN_DANGER("[src] manages to remove \the [legcuffed]!"),
			SPAN_NOTICE("You successfully remove \the [legcuffed].")
			)

		drop_from_inventory(legcuffed)
		legcuffed = null
		update_inv_legcuffed()

/mob/living/carbon/proc/can_break_cuffs()
	if(HAS_FLAG(mutations, HULK))
		return TRUE

	if(stamina < 100)
		return FALSE

	if(species?.break_cuffs)
		return TRUE

	return FALSE

/mob/living/carbon/proc/break_handcuffs()
	visible_message(
		SPAN_DANGER("[src] is trying to break \the [handcuffed]!"),
		SPAN_WARNING("You attempt to break your [handcuffed.name]. (This will take around 10 seconds and you need to stand still)")
		)

	if(do_after(src, 10 SECONDS))
		if(!handcuffed)
			return

		visible_message(
			SPAN_DANGER("[src] manages to break \the [handcuffed]!"),
			SPAN_WARNING("You successfully break your [handcuffed.name].")
			)

		if((isunathi(src)) || HAS_FLAG(mutations, HULK))
			say(pick("RAAAAAAAARGH!", "HNNNNNNNNNGGGGGGH!", "GWAAAAAAAARRRHHH!", "NNNNNNNNGGGGGGGGHH!", "AAAAAAARRRGH!" ))
			stamina -= 100 //takes a bunch of stamina

		qdel(handcuffed)
		handcuffed = null
		if(buckled_to)
			buckled_to.unbuckle()
		update_inv_handcuffed()

/mob/living/carbon/proc/break_legcuffs()
	to_chat(src, SPAN_WARNING("You attempt to break your legcuffs. (This will take around 5 seconds and you need to stand still)"))
	visible_message(SPAN_DANGER("[src] is trying to break the legcuffs!"))

	if(do_after(src, 50))
		if(!legcuffed || buckled_to)
			return

		visible_message(
			SPAN_DANGER("[src] manages to break the legcuffs!"),
			SPAN_WARNING("You successfully break your legcuffs.")
			)

		say(pick("RAAAAAAAARGH!", "HNNNNNNNNNGGGGGGH!", "GWAAAAAAAARRRHHH!", "NNNNNNNNGGGGGGGGHH!", "AAAAAAARRRGH!" ))

		qdel(legcuffed)
		legcuffed = null
		update_inv_legcuffed()

/mob/living/carbon/human/can_break_cuffs()
	if(species.can_shred(src,1))
		return 1
	return ..()

/mob/living/carbon/human/escape_buckle()
	if(!restrained())
		..()
