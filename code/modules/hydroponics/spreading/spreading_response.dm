/obj/effect/plant/HasProximity(var/atom/movable/AM)

	if(!is_mature() || (seed.get_trait(TRAIT_SPREAD) != 2 && seed.get_trait(TRAIT_CARNIVOROUS) == 0))
		return

	var/mob/living/M = AM
	if(!istype(M))
		return

	if(!issmall(M) && seed.get_trait(TRAIT_SPREAD) != 2 && seed.get_trait(TRAIT_CARNIVOROUS) != 2)
		// let TRAIT_CARNIVOROUS = 1 plants eat small creatures without murdering every hydroponicist
		return

	if(!buckled && !M.buckled_to && !M.anchored && (issmall(M) || prob(round(seed.get_trait(TRAIT_POTENCY)/6))))
		//wait a tick for the Entered() proc that called HasProximity() to finish (and thus the moving animation),
		//so we don't appear to teleport from two tiles away when moving into a turf adjacent to vines.
		addtimer(CALLBACK(src, PROC_REF(entangle), M), 1)

/obj/effect/plant/attack_hand(var/mob/user)
	manual_unbuckle(user)

/obj/effect/plant/attack_generic(var/mob/user)
	manual_unbuckle(user)

/obj/effect/plant/proc/trodden_on(var/mob/living/victim)
	if(!is_mature())
		return
	var/mob/living/carbon/human/H = victim
	if(istype(H) && H.shoes)
		return
	seed.do_thorns(victim,src)
	seed.do_sting(victim,src,pick(BP_R_FOOT,BP_L_FOOT,BP_R_LEG,BP_L_LEG))

/obj/effect/plant/unbuckle()
	if(istype(buckled, /mob/living))
		var/mob/living/M = buckled
		if(M.buckled_to == src)
			M.buckled_to = null
			M.anchored = initial(buckled.anchored)
			M.update_canmove()
		buckled = null
	return

/obj/effect/plant/proc/manual_unbuckle(mob/user as mob)
	if(buckled)
		if(prob(seed ? min(max(0,100 - seed.get_trait(TRAIT_POTENCY)/2),100) : 50))
			if(buckled.buckled_to == src)
				if(buckled != user)
					buckled.visible_message(\
						"<span class='notice'>[user.name] frees [buckled.name] from \the [src].</span>",\
						"<span class='notice'>[user.name] frees you from \the [src].</span>",\
						"<span class='warning'>You hear shredding and ripping.</span>")
				else
					buckled.visible_message(\
						"<span class='notice'>[buckled.name] struggles free of \the [src].</span>",\
						"<span class='notice'>You untangle \the [src] from around yourself.</span>",\
						"<span class='warning'>You hear shredding and ripping.</span>")
			unbuckle()
		else
			var/text = pick("rip","tear","pull")
			user.visible_message(\
				"<span class='notice'>[user.name] [text]s at \the [src].</span>",\
				"<span class='notice'>You [text] at \the [src].</span>",\
				"<span class='warning'>You hear shredding and ripping.</span>")
	return

/obj/effect/plant/proc/entangle(var/mob/living/victim)

	if(buckled)
		return

	if(victim.buckled_to)
		return

	//grabbing people
	if(!victim.anchored && Adjacent(victim) && victim.loc != get_turf(src))
		var/can_grab = 1
		if(istype(victim, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = victim
			if(H.Check_Shoegrip(FALSE))
				can_grab = 0
		if(can_grab)
			src.visible_message("<span class='danger'>Tendrils lash out from \the [src] and drag \the [victim] in!</span>")
			victim.forceMove(src.loc)

	//entangling people
	if(victim.loc == src.loc)
		buckle(victim)
		victim.set_dir(pick(cardinal))
		to_chat(victim, "<span class='danger'>Tendrils tighten around you!</span>")
