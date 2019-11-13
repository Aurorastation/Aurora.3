/mob/living/carbon/Initialize()
	//setup reagent holders
	bloodstr = new/datum/reagents/metabolism(1000, src, CHEM_BLOOD)
	ingested = new/datum/reagents/metabolism(1000, src, CHEM_INGEST)
	touching = new/datum/reagents/metabolism(1000, src, CHEM_TOUCH)
	breathing = new/datum/reagents/metabolism(1000, src, CHEM_BREATHE)
	reagents = bloodstr

	. = ..()

/mob/living/carbon/Life()
	..()

	handle_viruses()

	// Increase germ_level regularly
	if(germ_level < GERM_LEVEL_AMBIENT && prob(30))	//if you're just standing there, you shouldn't get more germs beyond an ambient level
		germ_level++

/mob/living/carbon/Destroy()
	QDEL_NULL(touching)
	bloodstr = null
	QDEL_NULL(dna)
	for(var/guts in internal_organs)
		qdel(guts)
	return ..()

/mob/living/carbon/rejuvenate()
	bloodstr.clear_reagents()
	ingested.clear_reagents()
	touching.clear_reagents()
	breathing.clear_reagents()
	..()

/mob/living/carbon/Move(NewLoc, direct)
	. = ..()

	if(.)
		if(src.stat != 2)
			if(src.nutrition)
				adjustNutritionLoss(nutrition_loss*0.1)
			if(src.hydration)
				adjustHydrationLoss(hydration_loss*0.1)

		if((FAT in src.mutations) && src.m_intent == "run" && src.bodytemperature <= 360)
			src.bodytemperature += 2

		// Moving around increases germ_level faster
		if(germ_level < GERM_LEVEL_MOVE_CAP && prob(8))
			germ_level++

/mob/living/carbon/relaymove(var/mob/living/user, direction)
	if((user in src.stomach_contents) && istype(user))
		if(user.last_special <= world.time)
			user.last_special = world.time + 50
			src.visible_message("<span class='danger'>You hear something rumbling inside [src]'s stomach...</span>")
			var/obj/item/I = user.get_active_hand()
			if(I && I.force)
				var/d = rand(round(I.force / 4), I.force)
				if(istype(src, /mob/living/carbon/human))
					var/mob/living/carbon/human/H = src
					var/obj/item/organ/external/organ = H.get_organ("chest")
					if (istype(organ))
						if(organ.take_damage(d, 0))
							H.UpdateDamageIcon()
					H.updatehealth()
				else
					src.take_organ_damage(d)
				user.visible_message("<span class='danger'>[user] attacks [src]'s stomach wall with the [I.name]!</span>")
				playsound(user.loc, 'sound/effects/attackblob.ogg', 50, 1)

				if(prob(src.getBruteLoss() - 50))
					for(var/atom/movable/A in stomach_contents)
						A.forceMove(loc)
						LAZYREMOVE(stomach_contents, A)
					src.gib()

/mob/living/carbon/gib()
	for(var/mob/M in src)
		if(M in src.stomach_contents)
			LAZYREMOVE(src.stomach_contents, M)
		M.forceMove(src.loc)
		for(var/mob/N in viewers(src, null))
			if(N.client)
				N.show_message(text("<span class='danger'>[M] bursts out of [src]!</span>"), 2)
	..()

/mob/living/carbon/attack_hand(mob/M as mob)
	if(!istype(M, /mob/living/carbon)) return
	if (!M.can_use_hand())
		return

	if(M.a_intent != I_HELP)
		var/action
		switch(a_intent)
			if(I_GRAB)
				action = "grabbed"
			if(I_DISARM)
				action = "pushed"
			if(I_HURT)
				action = "punched"
		var/t_him = "it"
		if (src.gender == MALE)
			t_him = "him"
		else if (src.gender == FEMALE)
			t_him = "her"
		var/show_ssd
		var/mob/living/carbon/human/H
		if(ishuman(src))
			H = src
			show_ssd = H.species.show_ssd
		if(H && show_ssd && !client && !teleop)
			if(H.bg)
				to_chat(H, span("danger", "You sense some disturbance to your physical body!"))
			else
				visible_message("<span class='notice'>[M] [action] [src], but they do not respond... Maybe they have S.S.D?</span>")
		else if(client && willfully_sleeping)
			visible_message("<span class='notice'>[M] [action] [src] waking [t_him] up!</span>")
			sleeping = 0
			willfully_sleeping = 0

	for(var/datum/disease/D in viruses)

		if(D.spread_by_touch())

			M.contract_disease(D, 0, 1, CONTACT_HANDS)

	for(var/datum/disease/D in M.viruses)

		if(D.spread_by_touch())

			contract_disease(D, 0, 1, CONTACT_HANDS)

	return

/mob/living/carbon/electrocute_act(var/shock_damage, var/obj/source, var/siemens_coeff = 1.0, var/def_zone = null, var/tesla_shock = 0, var/ground_zero)
	if(status_flags & GODMODE)	return 0	//godmode
	if (!tesla_shock)
		shock_damage *= siemens_coeff
	if (shock_damage<1)
		return 0

	src.apply_damage(shock_damage, BURN, def_zone, used_weapon="Electrocution")
	playsound(loc, "sparks", 50, 1, -1)
	if (shock_damage > 15 || tesla_shock)
		src.visible_message(
			"<span class='warning'>[src] was shocked by the [source]!</span>", \
			"<span class='danger'>You feel a powerful shock course through your body!</span>", \
			"<span class='warning'>You hear a heavy electrical crack.</span>" \
		)
		Stun(10)//This should work for now, more is really silly and makes you lay there forever
		Weaken(10)
	else
		src.visible_message(
			"<span class='warning'>[src] was mildly shocked by the [source].</span>", \
			"<span class='warning'>You feel a mild shock course through your body.</span>", \
			"<span class='warning'>You hear a light zapping.</span>" \
		)

	spark(loc, 5, alldirs)

	return shock_damage

/mob/proc/swap_hand()
	return

/mob/living/carbon/swap_hand()
	var/obj/item/item_in_hand = src.get_active_hand()
	if(item_in_hand) //this segment checks if the item in your hand is twohanded.
		if(istype(item_in_hand,/obj/item/material/twohanded) || istype(item_in_hand,/obj/item/gun) || istype(item_in_hand,/obj/item/pickaxe))
			if(item_in_hand:wielded == 1)
				to_chat(usr, "<span class='warning'>Your other hand is too busy holding the [item_in_hand.name]</span>")
				return
	src.hand = !( src.hand )
	if(hud_used.l_hand_hud_object && hud_used.r_hand_hud_object)
		if(hand)	//This being 1 means the left hand is in use
			hud_used.l_hand_hud_object.icon_state = "l_hand_active"
			hud_used.r_hand_hud_object.icon_state = "r_hand_inactive"
		else
			hud_used.l_hand_hud_object.icon_state = "l_hand_inactive"
			hud_used.r_hand_hud_object.icon_state = "r_hand_active"
	/*if (!( src.hand ))
		src.hands.set_dir(NORTH)
	else
		src.hands.set_dir(SOUTH)*/
	return

/mob/living/carbon/proc/activate_hand(var/selhand) //0 or "r" or "right" for right hand; 1 or "l" or "left" for left hand.

	if(istext(selhand))
		selhand = lowertext(selhand)

		if(selhand == "right" || selhand == "r")
			selhand = 0
		if(selhand == "left" || selhand == "l")
			selhand = 1

	if(selhand != src.hand)
		swap_hand()

/mob/living/carbon/proc/help_shake_act(mob/living/carbon/M)
	if (src.health >= config.health_threshold_crit)
		if(src == M && istype(src, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = src
			src.visible_message( \
				text("<span class='notice'>[src] examines [].</span>",src.gender==MALE?"himself":"herself"), \
				"<span class='notice'>You check yourself for injuries.</span>" \
				)

			for(var/obj/item/organ/external/org in H.organs)
				var/list/status = list()
				var/brutedamage = org.brute_dam
				var/burndamage = org.burn_dam
				if(halloss > 0)
					if(prob(30))
						brutedamage += halloss
					if(prob(30))
						burndamage += halloss
				switch(brutedamage)
					if(1 to 20)
						status += "bruised"
					if(20 to 40)
						status += "wounded"
					if(40 to INFINITY)
						status += "mangled"

				switch(burndamage)
					if(1 to 10)
						status += "numb"
					if(10 to 40)
						status += "blistered"
					if(40 to INFINITY)
						status += "peeling away"

				if(org.is_stump())
					status += "MISSING"
				if(org.status & ORGAN_MUTATED)
					status += "weirdly shapen"
				if(org.dislocated == 2)
					status += "dislocated"
				if(org.status & ORGAN_BROKEN)
					status += "hurts when touched"
				if(org.status & ORGAN_DEAD)
					status += "is bruised and necrotic"
				if(!org.is_usable())
					status += "dangling uselessly"
				if(status.len)
					src.show_message("My [org.name] is <span class='warning'> [english_list(status)].</span>",1)
				else
					src.show_message("My [org.name] is <span class='notice'> OK.</span>",1)

			if((isskeleton(H)) && (!H.w_uniform) && (!H.wear_suit))
				H.play_xylophone()
		else if (on_fire)
			playsound(src.loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
			if (M.on_fire)
				M.visible_message("<span class='warning'>[M] tries to pat out [src]'s flames, but to no avail!</span>",
				"<span class='warning'>You try to pat out [src]'s flames, but to no avail! Put yourself out first!</span>")
			else
				M.visible_message("<span class='warning'>[M] tries to pat out [src]'s flames!</span>",
				"<span class='warning'>You try to pat out [src]'s flames! Hot!</span>")
				if(do_mob(M, src, 1.5 SECONDS))
					if (M.IgniteMob(prob(10)))
						M.visible_message("<span class='danger'>The fire spreads from [src] to [M]!</span>",
						"<span class='danger'>The fire spreads to you as well!</span>")
					else
						if (src.ExtinguishMob(1))
							M.visible_message("<span class='warning'>[M] successfully pats out [src]'s flames.</span>",
							"<span class='warning'>You successfully pat out [src]'s flames.</span>")
		else
			var/t_him = "it"
			if (src.gender == MALE)
				t_him = "him"
			else if (src.gender == FEMALE)
				t_him = "her"
			if (istype(src,/mob/living/carbon/human) && src:w_uniform)
				var/mob/living/carbon/human/H = src
				H.w_uniform.add_fingerprint(M)

			var/show_ssd
			var/mob/living/carbon/human/H
			if(ishuman(src))
				H = src
				show_ssd = H.species.show_ssd
			if(H && show_ssd && !client && !teleop)
				if(H.bg)
					to_chat(H, span("warning", "You sense some disturbance to your physical body, like someone is trying to wake you up."))
				else
					M.visible_message("<span class='notice'>[M] shakes [src] trying to wake [t_him] up!</span>", \
										"<span class='notice'>You shake [src], but they do not respond... Maybe they have S.S.D?</span>")
			else if(lying || src.sleeping)
				src.sleeping = max(0,src.sleeping-5)
				if(src.sleeping == 0)
					src.resting = 0
				M.visible_message("<span class='notice'>[M] shakes [src] trying to wake [t_him] up!</span>", \
									"<span class='notice'>You shake [src] trying to wake [t_him] up!</span>")
			else
				var/mob/living/carbon/human/tapper = M
				if(istype(tapper))
					tapper.species.tap(tapper,src)
				else
					M.visible_message("<span class='notice'>[M] taps [src] to get their attention!</span>", \
								"<span class='notice'>You tap [src] to get their attention!</span>")
			AdjustParalysis(-3)
			AdjustStunned(-3)
			AdjustWeakened(-3)

			playsound(src.loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)

/mob/living/carbon/proc/eyecheck()
	return 0

// ++++ROCKDTBEN++++ MOB PROCS -- Ask me before touching.
// Stop! ... Hammertime! ~Carn

/mob/living/carbon/proc/getDNA()
	return dna

/mob/living/carbon/proc/setDNA(var/datum/dna/newDNA)
	dna = newDNA

// ++++ROCKDTBEN++++ MOB PROCS //END

/mob/living/carbon/clean_blood()
	. = ..()
	if(ishuman(src))
		var/mob/living/carbon/human/H = src
		if(H.gloves)
			if(H.gloves.clean_blood())
				H.update_inv_gloves(0)
			H.gloves.germ_level = 0
		else
			if(!isnull(H.bloody_hands))
				H.bloody_hands = null
				H.update_inv_gloves(0)
			H.germ_level = 0
	update_icons()	//apply the now updated overlays to the mob



/mob/living/carbon/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	..()
	var/temp_inc = max(min(BODYTEMP_HEATING_MAX*(1-get_heat_protection()), exposed_temperature - bodytemperature), 0)
	bodytemperature += temp_inc

/mob/living/carbon/can_use_hands()
	if(handcuffed)
		return 0
	if(buckled && ! istype(buckled, /obj/structure/bed/chair)) // buckling does not restrict hands
		return 0
	return 1

/mob/living/carbon/restrained()
	if (handcuffed)
		return 1
	return

/mob/living/carbon/u_equip(obj/item/W as obj)
	if(!W)	return 0

	else if (W == handcuffed)
		handcuffed = null
		update_inv_handcuffed()
		if(buckled && buckled.buckle_require_restraints)
			buckled.unbuckle_mob()

	else if (W == legcuffed)
		legcuffed = null
		update_inv_legcuffed()
	else
	 ..()

	return

//generates realistic-ish pulse output based on preset levels
/mob/living/carbon/proc/get_pulse(var/method)	//method 0 is for hands, 1 is for machines, more accurate
	var/temp = 0								//see setup.dm:694
	switch(src.pulse)
		if(PULSE_NONE)
			return "0"
		if(PULSE_SLOW)
			temp = rand(40, 60)
			return num2text(method ? temp : temp + rand(-10, 10))
		if(PULSE_NORM)
			temp = rand(60, 90)
			return num2text(method ? temp : temp + rand(-10, 10))
		if(PULSE_FAST)
			temp = rand(90, 120)
			return num2text(method ? temp : temp + rand(-10, 10))
		if(PULSE_2FAST)
			temp = rand(120, 160)
			return num2text(method ? temp : temp + rand(-10, 10))
		if(PULSE_THREADY)
			return method ? ">250" : "extremely weak and fast, patient's artery feels like a thread"
//			output for machines^	^^^^^^^output for people^^^^^^^^^

/mob/living/carbon/verb/mob_sleep()
	set name = "Sleep"
	set category = "IC"

	if(usr.sleeping)
		to_chat(usr, "<span class='warning'>You are already sleeping</span>")
		return
	if(alert(src,"You sure you want to sleep for a while?","Sleep","Yes","No") == "Yes")
		willfully_sleeping = 1
		usr.sleeping = 20 //Short nap

/mob/living/carbon/Collide(atom/A)
	if(now_pushing)
		return
	. = ..()
	if(istype(A, /mob/living/carbon) && prob(10))
		src.spread_disease_to(A, "Contact")

/mob/living/carbon/cannot_use_vents()
	return

/mob/living/carbon/slip(var/slipped_on,stun_duration=8)
	if(buckled)
		return 0
	stop_pulling()
	to_chat(src, "<span class='warning'>You slipped on [slipped_on]!</span>")
	playsound(src.loc, 'sound/misc/slip.ogg', 50, 1, -3)
	Stun(stun_duration)
	Weaken(Floor(stun_duration/2))
	return 1

/mob/living/carbon/proc/add_chemical_effect(var/effect, var/magnitude = 1)
	if(effect in chem_effects)
		chem_effects[effect] += magnitude
	else
		chem_effects[effect] = magnitude

/mob/living/carbon/get_default_language()
	if(default_language)
		return default_language

	if(!species)
		return null
	return species.default_language ? all_languages[species.default_language] : null

/mob/living/carbon/is_berserk()
	return (CE_BERSERK in chem_effects)

/mob/living/carbon/is_pacified()
	if(disabilities & PACIFIST)
		return TRUE
	if(CE_PACIFIED in chem_effects)
		return TRUE

/mob/living/carbon/proc/get_metabolism(metabolism)
	return metabolism

/mob/living/carbon/proc/can_feel_pain()
	if (species && (species.flags & NO_PAIN))
		return FALSE
	if (is_berserk())
		return FALSE
	if (analgesic > 100)
		return FALSE

	return TRUE

