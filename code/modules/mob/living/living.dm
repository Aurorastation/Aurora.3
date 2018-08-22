//mob verbs are faster than object verbs. See mob/verb/examine.
/mob/living/verb/pulled(atom/movable/AM as mob|obj in oview(1))
	set name = "Pull"
	set category = "Object"

	if(AM.Adjacent(src))
		src.start_pulling(AM)

	return

//mob verbs are faster than object verbs. See above.
/mob/living/pointed(atom/A as mob|obj|turf in view())
	if(src.stat || !src.canmove || src.restrained())
		return 0
	if(src.status_flags & FAKEDEATH)
		return 0
	if(!..())
		return 0

	src.visible_message("<b>[src]</b> points to [A]")
	return 1

/*one proc, four uses
swapping: if it's 1, the mobs are trying to switch, if 0, non-passive is pushing passive
default behaviour is:
 - non-passive mob passes the passive version
 - passive mob checks to see if its mob_bump_flag is in the non-passive's mob_bump_flags
 - if si, the proc returns
*/
/mob/living/proc/can_move_mob(var/mob/living/swapped, swapping = 0, passive = 0)
	if(!swapped)
		return 1
	if(!passive)
		return swapped.can_move_mob(src, swapping, 1)
	else
		var/context_flags = 0
		if(swapping)
			context_flags = swapped.mob_swap_flags
		else
			context_flags = swapped.mob_push_flags
		if(!mob_bump_flag) //nothing defined, go wild
			return 1
		if(mob_bump_flag & context_flags)
			return 1
		return 0

/mob/living
	var/tmp/last_push_notif

/mob/living/Collide(atom/movable/AM)
	spawn
		if (now_pushing || !loc)
			return

		now_pushing = TRUE
		if (istype(AM, /mob/living))
			var/mob/living/tmob = AM

			for(var/mob/living/M in range(tmob, 1))
				if(tmob.pinned.len || ((M.pulling == tmob && ( tmob.restrained() && !( M.restrained() ) && M.stat == 0)) || locate(/obj/item/weapon/grab, tmob.grabbed_by.len)) )
					if (last_push_notif + 0.5 SECONDS <= world.time)
						src << "<span class='warning'>[tmob] is restrained, you cannot push past</span>"
						last_push_notif = world.time

					now_pushing = FALSE
					return
				if( tmob.pulling == M && ( M.restrained() && !( tmob.restrained() ) && tmob.stat == 0) )
					if (last_push_notif + 0.5 SECONDS <= world.time)
						src << "<span class='warning'>[tmob] is restraining [M], you cannot push past</span>"
						last_push_notif = world.time

					now_pushing = FALSE
					return

			//Leaping mobs just land on the tile, no pushing, no anything.
			if(status_flags & LEAPING)
				forceMove(tmob.loc)
				status_flags &= ~LEAPING
				now_pushing = FALSE
				return

			if(can_swap_with(tmob)) // mutual brohugs all around!
				var/turf/oldloc = loc
				forceMove(tmob.loc)
				tmob.forceMove(oldloc)
				now_pushing = FALSE
				for(var/mob/living/carbon/slime/slime in view(1,tmob))
					if(slime.Victim == tmob)
						slime.UpdateFeed()
				return

			if(!can_move_mob(tmob, 0, 0))
				now_pushing = FALSE
				return

			if(a_intent == I_HELP || src.restrained())
				now_pushing = FALSE
				return

			if(istype(tmob, /mob/living/carbon/human) && (FAT in tmob.mutations))
				if(prob(40) && !(FAT in src.mutations))
					src << "<span class='danger'>You fail to push [tmob]'s fat ass out of the way.</span>"
					now_pushing = FALSE
					return

			if(istype(tmob.r_hand, /obj/item/weapon/shield/riot))
				if(prob(99))
					now_pushing = FALSE
					return

			if(istype(tmob.l_hand, /obj/item/weapon/shield/riot))
				if(prob(99))
					now_pushing = FALSE
					return

			if(!(tmob.status_flags & CANPUSH))
				now_pushing = FALSE
				return

			tmob.LAssailant = WEAKREF(src)

		now_pushing = FALSE
		spawn(0)
			. = ..()
			if (!istype(AM, /atom/movable))
				return
			if (!now_pushing)
				now_pushing = TRUE

				if (!AM.anchored)
					if(isobj(AM))
						var/obj/O = AM
						if ((can_pull_size == 0) || (can_pull_size < O.w_class))
							now_pushing = FALSE
							return

					var/t = get_dir(src, AM)
					if (istype(AM, /obj/structure/window))
						for(var/obj/structure/window/win in get_step(AM,t))
							now_pushing = FALSE
							return

					step(AM, t)
					if(ishuman(AM) && AM:grabbed_by)
						for(var/obj/item/weapon/grab/G in AM:grabbed_by)
							step(G:assailant, get_dir(G:assailant, AM))
							G.adjust_position()

				now_pushing = FALSE

/proc/swap_density_check(var/mob/swapper, var/mob/swapee)
	var/turf/T = get_turf(swapper)
	if(T.density)
		return 1
	for(var/atom/movable/A in T)
		if(A == swapper)
			continue
		if(!A.CanPass(swapee, T, 1))
			return 1

/mob/living/proc/can_swap_with(var/mob/living/tmob)
	if(tmob.buckled || buckled)
		return 0
	//BubbleWrap: people in handcuffs are always switched around as if they were on 'help' intent to prevent a person being pulled from being seperated from their puller
	if(!(tmob.mob_always_swap || (tmob.a_intent == I_HELP || tmob.restrained()) && (a_intent == I_HELP || src.restrained())))
		return 0
	if(!tmob.canmove || !canmove)
		return 0

	if(swap_density_check(src, tmob))
		return 0

	if(swap_density_check(tmob, src))
		return 0

	return can_move_mob(tmob, 1, 0)

/mob/living/verb/succumb()
	set hidden = 1
	if ((src.health < 0 && src.health > -95.0))
		src.death()
		src << "<span class='notice'>You have given up life and succumbed to death.</span>"
	else
		src << "<span class='warning'>You are not injured enough to succumb to death!</span>"


/mob/living/proc/updatehealth()
	if(status_flags & GODMODE)
		health = 100
		stat = CONSCIOUS
	else
		health = maxHealth - getOxyLoss() - getToxLoss() - getFireLoss() - getBruteLoss() - getCloneLoss()
		//Removed Halloss from here. Halloss isn't supposed to count towards death



//This proc is used for mobs which are affected by pressure to calculate the amount of pressure that actually
//affects them once clothing is factored in. ~Errorage
/mob/living/proc/calculate_affecting_pressure(var/pressure)
	return


//sort of a legacy burn method for /electrocute, /shock, and the e_chair
/mob/living/proc/burn_skin(burn_amount)
	if(istype(src, /mob/living/carbon/human))
		//world << "DEBUG: burn_skin(), mutations=[mutations]"
		if(mShock in src.mutations) //shockproof
			return 0
		if (COLD_RESISTANCE in src.mutations) //fireproof
			return 0
		var/mob/living/carbon/human/H = src	//make this damage method divide the damage to be done among all the body parts, then burn each body part for that much damage. will have better effect then just randomly picking a body part
		var/divided_damage = (burn_amount)/(H.organs.len)
		var/extradam = 0	//added to when organ is at max dam
		for(var/obj/item/organ/external/affecting in H.organs)
			if(!affecting)	continue
			if(affecting.take_damage(0, divided_damage+extradam))	//TODO: fix the extradam stuff. Or, ebtter yet...rewrite this entire proc ~Carn
				H.UpdateDamageIcon()
		H.updatehealth()
		return 1
	else if(istype(src, /mob/living/silicon/ai))
		return 0

/mob/living/proc/adjustBodyTemp(actual, desired, incrementboost)
	var/temperature = actual
	var/difference = abs(actual-desired)	//get difference
	var/increments = difference/10 //find how many increments apart they are
	var/change = increments*incrementboost	// Get the amount to change by (x per increment)

	// Too cold
	if(actual < desired)
		temperature += change
		if(actual > desired)
			temperature = desired
	// Too hot
	if(actual > desired)
		temperature -= change
		if(actual < desired)
			temperature = desired
//	if(istype(src, /mob/living/carbon/human))
//		world << "[src] ~ [src.bodytemperature] ~ [temperature]"
	return temperature


// ++++ROCKDTBEN++++ MOB PROCS -- Ask me before touching.
// Stop! ... Hammertime! ~Carn
// I touched them without asking... I'm soooo edgy ~Erro (added nodamage checks)

/mob/living/proc/getBruteLoss()
	return bruteloss

/mob/living/proc/adjustBruteLoss(var/amount)
	if(status_flags & GODMODE)	return 0	//godmode
	amount *= brute_mod
	bruteloss = min(max(bruteloss + amount, 0),(maxHealth*2))

/mob/living/proc/getOxyLoss()
	return oxyloss

/mob/living/proc/adjustOxyLoss(var/amount)
	if(status_flags & GODMODE)	return 0	//godmode
	oxyloss = min(max(oxyloss + amount, 0),(maxHealth*2))

/mob/living/proc/setOxyLoss(var/amount)
	if(status_flags & GODMODE)	return 0	//godmode
	oxyloss = amount

/mob/living/proc/getToxLoss()
	return toxloss

/mob/living/proc/adjustToxLoss(var/amount)
	if(status_flags & GODMODE)	return 0	//godmode
	toxloss = min(max(toxloss + amount, 0),(maxHealth*2))

/mob/living/proc/setToxLoss(var/amount)
	if(status_flags & GODMODE)	return 0	//godmode
	toxloss = amount

/mob/living/proc/getFireLoss()
	return fireloss

/mob/living/proc/adjustFireLoss(var/amount)
	if(status_flags & GODMODE)	return 0	//godmode
	amount *= burn_mod
	fireloss = min(max(fireloss + amount, 0),(maxHealth*2))

/mob/living/proc/getCloneLoss()
	return cloneloss

/mob/living/proc/adjustCloneLoss(var/amount)
	if(status_flags & GODMODE)	return 0	//godmode
	cloneloss = min(max(cloneloss + amount, 0),(maxHealth*2))

/mob/living/proc/setCloneLoss(var/amount)
	if(status_flags & GODMODE)	return 0	//godmode
	cloneloss = amount

/mob/living/proc/getBrainLoss()
	. = 0

/mob/living/proc/adjustBrainLoss(var/amount, var/maximum)
	return

/mob/living/proc/setBrainLoss(var/amount)
	return

/mob/living/proc/getHalLoss()
	return halloss

/mob/living/proc/adjustHalLoss(var/amount)
	if(status_flags & GODMODE)	return 0	//godmode
	halloss = min(max(halloss + amount, 0),(maxHealth*2))

/mob/living/carbon/adjustHalLoss(var/amount, var/ignoreImmunity = 0)//An inherited version so this doesnt affect cyborgs
	if(status_flags & GODMODE)	return 0	//godmode
	if(!ignoreImmunity)//Adjusting how hallloss works. Species with the NO_PAIN flag will suffer most of the effects of halloss, but will be immune to most conventional sources of accumulating it
		if (species && species.flags & NO_PAIN)//Species with this flag will only gather halloss through species-specific mechanics, which apply it with the ignoreImmunity flag
			return 0

	halloss = min(max(halloss + amount, 0),(maxHealth*2))

/mob/living/proc/setHalLoss(var/amount)
	if(status_flags & GODMODE)	return 0	//godmode
	halloss = amount

/mob/living/proc/getMaxHealth()
	return maxHealth

/mob/living/proc/setMaxHealth(var/newMaxHealth)
	maxHealth = newMaxHealth

// ++++ROCKDTBEN++++ MOB PROCS //END

/mob/proc/get_contents()


//Recursive function to find everything a mob is holding.
/mob/living/get_contents(var/obj/item/weapon/storage/Storage = null)
	var/list/L = list()

	if(Storage) //If it called itself
		L += Storage.return_inv()

		//Leave this commented out, it will cause storage items to exponentially add duplicate to the list
		//for(var/obj/item/weapon/storage/S in Storage.return_inv()) //Check for storage items
		//	L += get_contents(S)

		for(var/obj/item/weapon/gift/G in Storage.return_inv()) //Check for gift-wrapped items
			L += G.gift
			if(istype(G.gift, /obj/item/weapon/storage))
				L += get_contents(G.gift)

		for(var/obj/item/smallDelivery/D in Storage.return_inv()) //Check for package wrapped items
			L += D.wrapped
			if(istype(D.wrapped, /obj/item/weapon/storage)) //this should never happen
				L += get_contents(D.wrapped)
		return L

	else

		L += src.contents
		for(var/obj/item/weapon/storage/S in src.contents)	//Check for storage items
			L += get_contents(S)

		for(var/obj/item/weapon/gift/G in src.contents) //Check for gift-wrapped items
			L += G.gift
			if(istype(G.gift, /obj/item/weapon/storage))
				L += get_contents(G.gift)

		for(var/obj/item/smallDelivery/D in src.contents) //Check for package wrapped items
			L += D.wrapped
			if(istype(D.wrapped, /obj/item/weapon/storage)) //this should never happen
				L += get_contents(D.wrapped)
		return L

/mob/living/proc/check_contents_for(A)
	var/list/L = src.get_contents()

	for(var/obj/B in L)
		if(B.type == A)
			return 1
	return 0


/mob/living/proc/can_inject()
	return 1

/mob/living/proc/get_organ_target()
	var/mob/shooter = src
	var/t = shooter:zone_sel.selecting
	if ((t in list( "eyes", "mouth" )))
		t = "head"
	var/obj/item/organ/external/def_zone = ran_zone(t)
	return def_zone


// heal ONE external organ, organ gets randomly selected from damaged ones.
/mob/living/proc/heal_organ_damage(var/brute, var/burn)
	adjustBruteLoss(-brute)
	adjustFireLoss(-burn)
	src.updatehealth()

// damage ONE external organ, organ gets randomly selected from damaged ones.
/mob/living/proc/take_organ_damage(var/brute, var/burn, var/emp=0)
	if(status_flags & GODMODE)	return 0	//godmode
	adjustBruteLoss(brute)
	adjustFireLoss(burn)
	src.updatehealth()

// heal MANY external organs, in random order
/mob/living/proc/heal_overall_damage(var/brute, var/burn)
	adjustBruteLoss(-brute)
	adjustFireLoss(-burn)
	src.updatehealth()

// damage MANY external organs, in random order
/mob/living/proc/take_overall_damage(var/brute, var/burn, var/used_weapon = null)
	if(status_flags & GODMODE)	return 0	//godmode
	adjustBruteLoss(brute)
	adjustFireLoss(burn)
	src.updatehealth()

/mob/living/proc/restore_all_organs()
	return

/mob/living/update_gravity(has_gravity)
	if(!ROUND_IS_STARTED)
		return
	if(has_gravity)
		stop_floating()
	else
		start_floating()

/mob/living/proc/revive(reset_to_roundstart = TRUE)	// this param is only used in human regen.
	// Stop killing yourself. Please.
//	if(suiciding)
//		suiciding = 0

	rejuvenate()
	if(buckled)
		buckled.unbuckle_mob()
	if(iscarbon(src))
		var/mob/living/carbon/C = src

		if (C.handcuffed && !initial(C.handcuffed))
			C.drop_from_inventory(C.handcuffed)
		C.handcuffed = initial(C.handcuffed)

		if (C.legcuffed && !initial(C.legcuffed))
			C.drop_from_inventory(C.legcuffed)
		C.legcuffed = initial(C.legcuffed)
	BITSET(hud_updateflag, HEALTH_HUD)
	BITSET(hud_updateflag, STATUS_HUD)
	BITSET(hud_updateflag, LIFE_HUD)
	ExtinguishMob()
	fire_stacks = 0

/mob/living/proc/rejuvenate()
	if(!isnull(reagents))
		reagents.clear_reagents()

	// shut down various types of badness
	setToxLoss(0)
	setOxyLoss(0)
	setCloneLoss(0)
	setBrainLoss(0)
	SetParalysis(0)
	SetStunned(0)
	SetWeakened(0)

	// shut down ongoing problems
	total_radiation = 0
	nutrition = 400
	bodytemperature = T20C
	sdisabilities = 0
	disabilities = 0

	// fix blindness and deafness
	blinded = 0
	eye_blind = 0
	eye_blurry = 0
	ear_deaf = 0
	ear_damage = 0
	heal_overall_damage(getBruteLoss(), getFireLoss())

	// fix all of our organs
	restore_all_organs()

	// remove the character from the list of the dead
	if(stat == DEAD)
		dead_mob_list -= src
		living_mob_list += src
		tod = null
		timeofdeath = 0

	// restore us to conciousness
	stat = CONSCIOUS

	// make the icons look correct
	regenerate_icons()

	BITSET(hud_updateflag, HEALTH_HUD)
	BITSET(hud_updateflag, STATUS_HUD)
	BITSET(hud_updateflag, LIFE_HUD)

	failed_last_breath = 0 //So mobs that died of oxyloss don't revive and have perpetual out of breath.

	return

/mob/living/proc/UpdateDamageIcon()
	return


/mob/living/proc/Examine_OOC()
	set name = "Examine Meta-Info (OOC)"
	set category = "OOC"
	set src in view()

	if(config.allow_Metadata)
		if(client)
			usr << "[src]'s Metainfo:<br>[client.prefs.metadata]"
		else
			usr << "[src] does not have any stored infomation!"
	else
		usr << "OOC Metadata is not supported by this server!"

	return

/mob/living/Move(a, b, flag)
	if (buckled)
		return

	if (restrained())
		stop_pulling()


	var/t7 = 1
	if (restrained())
		for(var/mob/living/M in range(src, 1))
			if ((M.pulling == src && M.stat == 0 && !( M.restrained() )))
				t7 = null
	if ((t7 && (pulling && ((get_dist(src, pulling) <= 1 || pulling.loc == loc) && (client && client.moving)))))
		var/turf/T = loc
		. = ..()

		if (pulling && pulling.loc)
			if(!( isturf(pulling.loc) ))
				stop_pulling()
				return

		/////
		if(pulling && pulling.anchored)
			stop_pulling()
			return

		if (!restrained())
			var/diag = get_dir(src, pulling)
			if ((diag - 1) & diag)
			else
				diag = null
			if ((get_dist(src, pulling) > 1 || diag))
				if (isliving(pulling))
					var/mob/living/M = pulling
					var/ok = 1
					if (locate(/obj/item/weapon/grab, M.grabbed_by))
						if (prob(75))
							var/obj/item/weapon/grab/G = pick(M.grabbed_by)
							if (istype(G, /obj/item/weapon/grab))
								for(var/mob/O in viewers(M, null))
									O.show_message(text("<span class='warning'>[] has been pulled from []'s grip by []</span>", G.affecting, G.assailant, src), 1)
								//G = null
								qdel(G)
						else
							ok = 0
						if (locate(/obj/item/weapon/grab, M.grabbed_by.len))
							ok = 0
					if (ok)
						var/atom/movable/t = M.pulling
						M.stop_pulling()

						if(!istype(M.loc, /turf/space))
							var/area/A = get_area(M)
							if(A.has_gravity())
								//this is the gay blood on floor shit -- Added back -- Skie
								if (M.lying && (prob(M.getBruteLoss() / 6)))
									var/turf/location = M.loc
									if (istype(location, /turf/simulated))
										location.add_blood(M)
								//pull damage with injured people
									if(prob(25))
										M.adjustBruteLoss(1)
										visible_message("<span class='danger'>\The [M]'s [M.isSynthetic() ? "state worsens": "wounds open more"] from being dragged!</span>")
								if(M.pull_damage())
									if(prob(25))
										M.adjustBruteLoss(2)
										visible_message("<span class='danger'>\The [M]'s [M.isSynthetic() ? "state" : "wounds"] worsen terribly from being dragged!</span>")
										var/turf/location = M.loc
										if (istype(location, /turf/simulated))
											location.add_blood(M)
											if(ishuman(M))
												var/mob/living/carbon/human/H = M
												var/blood_volume = round(H.vessel.get_reagent_amount("blood"))
												if(blood_volume > 0)
													H.vessel.remove_reagent("blood", 1)


						step(pulling, get_dir(pulling.loc, T))
						if(t)
							M.start_pulling(t)
				else
					if (pulling)
						if (istype(pulling, /obj/structure/window))
							var/obj/structure/window/W = pulling
							if(W.is_full_window())
								for(var/obj/structure/window/win in get_step(pulling,get_dir(pulling.loc, T)))
									stop_pulling()
					if (pulling)
						step(pulling, get_dir(pulling.loc, T))
	else
		stop_pulling()
		. = ..()

	if (s_active && !( s_active in contents ) && get_turf(s_active) != get_turf(src))	//check !( s_active in contents ) first so we hopefully don't have to call get_turf() so much.
		s_active.close(src)

	if(update_slimes)
		for(var/mob/living/carbon/slime/M in view(1,src))
			M.UpdateFeed(src)

/mob/living/verb/resist()
	set name = "Resist"
	set category = "IC"

	if(!incapacitated(INCAPACITATION_KNOCKOUT) && canClick())
		resist_grab()
		if(!weakened)
			process_resist()

/mob/living/proc/process_resist()
	//Getting out of someone's inventory.
	if(istype(src.loc, /obj/item/weapon/holder))
		escape_inventory(src.loc)
		return

	//unbuckling yourself
	if(buckled)
		spawn() escape_buckle()

	//Breaking out of a locker?
	if( src.loc && (istype(src.loc, /obj/structure/closet)) )
		var/obj/structure/closet/C = loc
		spawn() C.mob_breakout(src)

/mob/living/proc/escape_inventory(obj/item/weapon/holder/H)
	if(H != src.loc) return

	var/mob/M = H.loc //Get our mob holder (if any).

	if(istype(M))
		M.drop_from_inventory(H)
		M << "<span class='warning'>\The [H] wriggles out of your grip!</span>"
		src << "<span class='warning'>You wriggle out of \the [M]'s grip!</span>"

		// Update whether or not this mob needs to pass emotes to contents.
		for(var/atom/A in M.contents)
			if(istype(A,/mob/living/simple_animal/borer) || istype(A,/obj/item/weapon/holder))
				return
		M.status_flags &= ~PASSEMOTES

	else if(istype(H.loc,/obj/item/clothing/accessory/holster))
		var/obj/item/clothing/accessory/holster/holster = H.loc
		if(holster.holstered == H)
			holster.clear_holster()
		src << "<span class='warning'>You extricate yourself from \the [holster].</span>"
		H.forceMove(get_turf(H))
	else if(istype(H.loc,/obj/item))
		src << "<span class='warning'>You struggle free of \the [H.loc].</span>"
		H.forceMove(get_turf(H))

/mob/living/proc/escape_buckle()
	if(buckled)
		buckled.user_unbuckle_mob(src)

/mob/living/var/last_resist

/mob/living/proc/resist_grab()
	if (last_resist + 4 > world.time)
		return
	last_resist = world.time
	if(stunned > 10)
		src << "<span class='notice'>You can't move...</span>"
		return
	var/resisting = 0
	for(var/obj/O in requests)
		requests.Remove(O)
		qdel(O)
		resisting++
	for(var/obj/item/weapon/grab/G in grabbed_by)
		resisting++
		switch(G.state)
			if(GRAB_PASSIVE)
				qdel(G)
			if(GRAB_AGGRESSIVE)
				if(incapacitated(INCAPACITATION_KNOCKDOWN)? prob(15) : prob(60))
					visible_message("<span class='warning'>[src] has broken free of [G.assailant]'s grip!</span>")
					qdel(G)
			if(GRAB_NECK)
				//If the you move when grabbing someone then it's easier for them to break free. Same if the affected mob is immune to stun.
				if (((world.time - G.assailant.l_move_time < 30 || !stunned) && prob(15)) || prob(3))
					visible_message("<span class='warning'>[src] has broken free of [G.assailant]'s headlock!</span>")
					qdel(G)
	if(resisting)
		visible_message("<span class='danger'>[src] resists!</span>")
		setClickCooldown(20)

/mob/living/verb/lay_down()
	set name = "Rest"
	set category = "IC"

	resting = !resting
	src << "<span class='notice'>You are now [resting ? "resting" : "getting up"]</span>"

/mob/living/proc/cannot_use_vents()
	return "You can't fit into that vent."

/mob/living/proc/has_brain()
	return 1

/mob/living/proc/has_eyes()
	return 1

/mob/living/proc/slip(var/slipped_on,stun_duration=8)
	return 0

/mob/living/proc/under_door()
	//This function puts a silicon on a layer that makes it draw under doors, then periodically checks if its still standing on a door
	if (layer > UNDERDOOR)//Don't toggle it if we're hiding
		layer = UNDERDOOR
		underdoor = 1

/mob/living/carbon/drop_from_inventory(var/obj/item/W, var/atom/target = null)
	if(W in internal_organs)
		return
	..()

/mob/living/touch_map_edge()

	//check for nuke disks
	if(client && stat != DEAD) //if they are clientless and dead don't bother, the parent will treat them as any other container
		if(istype(SSticker.mode, /datum/game_mode/nuclear)) //only really care if the game mode is nuclear
			var/datum/game_mode/nuclear/G = SSticker.mode
			if(G.check_mob(src))
				if(x <= TRANSITIONEDGE)
					inertia_dir = 4
				else if(x >= world.maxx -TRANSITIONEDGE)
					inertia_dir = 8
				else if(y <= TRANSITIONEDGE)
					inertia_dir = 1
				else if(y >= world.maxy -TRANSITIONEDGE)
					inertia_dir = 2
				src << "<span class='warning'>Something you are carrying is preventing you from leaving.</span>"
				return

	..()

//damage/heal the mob ears and adjust the deaf amount
/mob/living/adjustEarDamage(var/damage, var/deaf)
	ear_damage = max(0, ear_damage + damage)
	ear_deaf = max(0, ear_deaf + deaf)

//pass a negative argument to skip one of the variable
/mob/living/setEarDamage(var/damage, var/deaf)
	if(damage >= 0)
		ear_damage = damage
	if(deaf >= 0)
		ear_deaf = deaf

/mob/proc/can_be_possessed_by(var/mob/abstract/observer/possessor)
	return istype(possessor) && possessor.client

/mob/living/can_be_possessed_by(var/mob/abstract/observer/possessor)
	if(!..())
		return 0
	if(!possession_candidate)
		possessor << "<span class='warning'>That animal cannot be possessed.</span>"
		return 0
	if(jobban_isbanned(possessor, "Animal"))
		possessor << "<span class='warning'>You are banned from animal roles.</span>"
		return 0
	if(!possessor.MayRespawn(1,ANIMAL))
		return 0
	return 1

/mob/living/proc/do_possession(var/mob/abstract/observer/possessor)

	if(!(istype(possessor) && possessor.ckey))
		return 0

	if(src.ckey || src.client)
		possessor << "<span class='warning'>\The [src] already has a player.</span>"
		return 0

	message_admins("<span class='adminnotice'>[key_name_admin(possessor)] has taken control of \the [src].</span>")
	log_admin("[key_name(possessor)] took control of \the [src].",admin_key=key_name(possessor))
	src.ckey = possessor.ckey
	qdel(possessor)

	if(round_is_spooky(6)) // Six or more active cultists.
		src << "<span class='notice'>You reach out with tendrils of ectoplasm and invade the mind of \the [src]...</span>"
		src << "<b>You have assumed direct control of \the [src].</b>"
		src << "<span class='notice'>Due to the spookiness of the round, you have taken control of the poor animal as an invading, possessing spirit - roleplay accordingly.</span>"
		src.universal_speak = 1
		src.universal_understand = 1
		//src.cultify() // Maybe another time.
		return

	src << "<b>You are now \the [src]!</b>"
	src << "<span class='notice'>Remember to stay in character for a mob of this type!</span>"
	return 1

/mob/living/Destroy()
	for (var/thing in stomach_contents)
		qdel(thing)
	stomach_contents = null
	QDEL_NULL(ingested)

	return ..()
