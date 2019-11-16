/mob/living/carbon/process_resist()

	//drop && roll
	if(on_fire && !buckled)
		var/obj/effect/decal/cleanable/foam/extinguisher_foam = locate() in src.loc
		var/extra = 0
		if(extinguisher_foam)
			extra = extinguisher_foam.amount * 1.5
		ExtinguishMob(1.2 + extra)
		Weaken(3)
		spin(32,2)
		visible_message(
			"<span class='danger'>[src] rolls on the floor, trying to put themselves out!</span>",
			"<span class='notice'>You stop, drop, and roll!</span>"
			)
		sleep(3 SECONDS)
		if(fire_stacks <= 0)
			visible_message(
				"<span class='danger'>[src] has successfully extinguished themselves!</span>",
				"<span class='notice'>You extinguish yourself.</span>"
				)
		return

	..()

	if (handcuffed)
		INVOKE_ASYNC(src, .proc/escape_handcuffs)
	else if (legcuffed)
		INVOKE_ASYNC(src, .proc/escape_legcuffs)

/mob/living/carbon/human/process_resist()
	if (istype(wear_suit, /obj/item/clothing/suit/straight_jacket))
		INVOKE_ASYNC(src, .proc/escape_jacket)
		return
	..()

/mob/living/carbon/human/proc/escape_jacket()
	visible_message(
		"<span class='danger'>\The [src] attempts to escape [wear_suit]!</span>",
		"<span class='warning'>You attempt to escape [wear_suit]. (This will take around 6 minutes and you need to stand still)</span>"
		)
	if (!do_after(src, 1.5 MINUTES, act_target = src))
		return
	visible_message(
			"<span class='danger'>\The [src] is shifting in their [wear_suit]!</span>",
			"<span class='warning'>You start to loosen the [wear_suit].</span>"
		)
	if (!do_after(src, 1.5 MINUTES, act_target = src))
		return
	visible_message(
			"<span class='danger'>\The [src] is moving in their [wear_suit]!</span>",
			"<span class='warning'>You slip one of your arms out of the [wear_suit].</span>"
		)
	if (!do_after(src, 1.5 MINUTES, act_target = src))
		return
	visible_message(
			"<span class='danger'>\The [src] is moving around in their [wear_suit] - it looks like they are about to break out!</span>",
			"<span class='warning'>You start to pull loose the straps on the straightjacket[wear_suit].</span>"
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

	if(buckled)
		breakouttime += 600 //If you are buckled, it takes a minute longer, but you are unbuckled and uncuffed instantly

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
			"<span class='danger'>\The [src] attempts to break out of \the [HC]!</span>",
			"<span class='warning'>You attempt to break out of \the [HC]. (This will take around 1 minute and you need to stand still)</span>"
			)
	else
		visible_message(
			"<span class='danger'>\The [src] attempts to slip out of \the [HC]!</span>",
			"<span class='warning'>You attempt to slip out of \the [HC]. (This will take around [displaytime] minutes and you need to stand still)</span>"
			)

	if(do_after(src, breakouttime))
		if(!handcuffed)
			return

		var/buckle_message_user = ""
		var/buckle_message_other = ""
		if(buckled) //If the person is buckled, also unbuckle the person
			buckle_message_user = " and unbuckle yourself"
			buckle_message_other = " and to unbuckle themself"
			buckled.user_unbuckle_mob(src)

		if(violent_removal)
			var/obj/item/organ/external/E = H.get_organ(pick("l_arm","r_arm"))
			var/dislocate_message = ""
			if(E && !E.is_dislocated())
				E.dislocate(1)
				dislocate_message = ", but dislocate your [E] in the process"
			visible_message(
				"<span class='danger'>\The [src] manages to remove \the [handcuffed][buckle_message_other]!</span>",
				"<span class='notice'>You successfully remove \the [handcuffed][buckle_message_user][dislocate_message].</span>"
				)
		else
			visible_message(
				"<span class='notice'>\The [src] manages to slip out of \the [handcuffed][buckle_message_other]!</span>",
				"<span class='notice'>You successfully slip out of \the [handcuffed][buckle_message_user].</span>"
				)
		drop_from_inventory(handcuffed)


/mob/living/carbon/proc/escape_legcuffs()
	if(!canClick())
		return

	setClickCooldown(100)

	if(can_break_cuffs()) //Don't want to do a lot of logic gating here.
		break_legcuffs()
		return

	var/obj/item/legcuffs/HC = legcuffed

	//A default in case you are somehow legcuffed with something that isn't an obj/item/legcuffs type
	var/breakouttime = 1200
	var/displaytime = 2 //Minutes to display in the "this will take X minutes."
	//If you are legcuffed with actual legcuffs... Well what do I know, maybe someone will want to legcuff you with toilet paper in the future...
	if(istype(HC))
		breakouttime = HC.breakouttime
		displaytime = breakouttime / 600 //Minutes

	visible_message(
		"<span class='danger'>[usr] attempts to remove \the [HC]!</span>",
		"<span class='warning'>You attempt to remove \the [HC]. (This will take around [displaytime] minutes and you need to stand still)</span>"
		)

	if(do_after(src, breakouttime))
		if(!legcuffed || buckled)
			return
		visible_message(
			"<span class='danger'>[src] manages to remove \the [legcuffed]!</span>",
			"<span class='notice'>You successfully remove \the [legcuffed].</span>"
			)

		drop_from_inventory(legcuffed)
		legcuffed = null
		update_inv_legcuffed()

/mob/living/carbon/proc/can_break_cuffs()
	if(HULK in mutations)
		return 1

	if(stamina < 100)
		return 0

	if(src.gender in src.species.breakcuffs)
		return 1

	return 0

/mob/living/carbon/proc/break_handcuffs()
	visible_message(
		"<span class='danger'>[src] is trying to break \the [handcuffed]!</span>",
		"<span class='warning'>You attempt to break your [handcuffed.name]. (This will take around 5 seconds and you need to stand still)</span>"
		)

	if(do_after(src, 50))
		if(!handcuffed)
			return

		visible_message(
			"<span class='danger'>[src] manages to break \the [handcuffed]!</span>",
			"<span class='warning'>You successfully break your [handcuffed.name].</span>"
			)

		if((isunathi(src)) || (HULK in mutations))
			say(pick("RAAAAAAAARGH!", "HNNNNNNNNNGGGGGGH!", "GWAAAAAAAARRRHHH!", "NNNNNNNNGGGGGGGGHH!", "AAAAAAARRRGH!" ))
			stamina -= 100 //takes a bunch of stamina

		qdel(handcuffed)
		handcuffed = null
		if(buckled)
			buckled.unbuckle_mob()
		update_inv_handcuffed()

/mob/living/carbon/proc/break_legcuffs()
	to_chat(src, "<span class='warning'>You attempt to break your legcuffs. (This will take around 5 seconds and you need to stand still)</span>")
	visible_message("<span class='danger'>[src] is trying to break the legcuffs!</span>")

	if(do_after(src, 50))
		if(!legcuffed || buckled)
			return

		visible_message(
			"<span class='danger'>[src] manages to break the legcuffs!</span>",
			"<span class='warning'>You successfully break your legcuffs.</span>"
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
