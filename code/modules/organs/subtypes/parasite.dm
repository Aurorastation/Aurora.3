/obj/item/organ/internal/parasite
	name = "parasite"

	organ_tag = "parasite"
	var/stage = 1
	var/max_stage = 4
	var/stage_ticker = 0
	var/recession = 0
	var/infection_speed = 2 //Will be determined by get_infect_speed()
	var/infect_speed_high = 35	//The fastest this parasite will advance stages
	var/infect_speed_low = 15	//The slowest this parasite will advance stages
	var/stage_interval = 300 //time between stages, in seconds. interval of 300 allows convenient treating with antiparasitics, higher will require spaced dosing of medications.
	var/subtle = 0 //will the body reject the parasite naturally?
	var/egg = null //does the parasite have a reagent which seeds an infection?
	var/drug_resistance = 0 //is the parasite resistant to antiparasitic medications?

/obj/item/organ/internal/parasite/Initialize()
	. = ..()
	get_infect_speed()

/obj/item/organ/internal/parasite/proc/get_infect_speed() //Slightly randomizes how fast each infection progresses.
	infection_speed = rand(infect_speed_low, infect_speed_high) / 10

/obj/item/organ/internal/parasite/process()
	..()
	if(!owner)
		return

	if(owner.chem_effects[CE_ANTIPARASITE] && !drug_resistance)
		recession = owner.chem_effects[CE_ANTIPARASITE]/10

	if((stage < max_stage) && !recession)
		stage_ticker = Clamp(stage_ticker+=infection_speed, 0, stage_interval*max_stage)
		if(stage_ticker >= stage*stage_interval)
			stage = min(stage+1,max_stage)
			get_infect_speed() //Each stage may progress faster or slower than the previous one
			stage_effect()

	if(recession)
		stage_ticker = Clamp(stage_ticker-=recession, 0, stage_interval*max_stage)
		if(stage_ticker <= stage*stage_interval-stage_interval)
			stage = max(stage-1, 1)
			stage_effect()
		if(!owner.chem_effects[CE_ANTIPARASITE] || drug_resistance)
			recession = 0
		if(stage_ticker == 0)
			qdel(src)

/obj/item/organ/internal/parasite/handle_rejection()
	if(subtle)
		return ..()
	else
		if(rejecting)
			rejecting = 0
		return

/obj/item/organ/internal/parasite/proc/stage_effect()
	return

///////////////////
///K'ois Mycosis///
///////////////////

/obj/item/organ/internal/parasite/kois
	name = "k'ois mycosis"
	icon = 'icons/obj/surgery.dmi'
	icon_state = "kois-on"
	dead_icon = "kois-off"

	organ_tag = "kois"

	parent_organ = BP_CHEST
	stage_interval = 150
	drug_resistance = 1

	origin_tech = list(TECH_BIO = 3)

	egg = /singleton/reagent/kois

/obj/item/organ/internal/parasite/kois/process()
	..()

	if (!owner)
		return

	if(prob(10) && (owner.can_feel_pain()))
		to_chat(owner, "<span class='warning'>You feel a stinging pain in your abdomen!</span>")
		owner.visible_message("<b>[owner]</b> winces slightly.")
		owner.adjustHalLoss(5)

	else if(prob(10) && !(owner.species.flags & NO_BREATHE))
		owner.emote("cough")

	else if(prob(10) && !(owner.species.flags & NO_BREATHE))
		owner.visible_message("<b>[owner]</b> coughs up blood!")
		owner.drip(10)

	if(stage >= 2)
		if(prob(10) && !(owner.species.flags & NO_BREATHE))
			owner.visible_message("<b>[owner]</b> gasps for air!")
			owner.losebreath += 5

	if(stage >= 3)
		set_light(1, l_color = "#E6E600")
		if(prob(10))
			to_chat(owner, "<span class='warning'>You feel something squirming inside of you!</span>")
			owner.reagents.add_reagent(/singleton/reagent/toxin/phoron, 8)
			owner.reagents.add_reagent(/singleton/reagent/kois, 5)

	if(stage >= 4)
		if(prob(10))
			to_chat(owner, "<span class='danger'>You feel something alien coming up your throat!</span>")
			owner.emote("cough")

			var/turf/T = get_turf(owner)

			var/datum/reagents/R = new/datum/reagents(100)
			R.add_reagent(/singleton/reagent/kois,10)
			R.add_reagent(/singleton/reagent/toxin/phoron,10)
			var/datum/effect/effect/system/smoke_spread/chem/spores/S = new("koisspore")

			S.attach(T)
			S.set_up(R, 20, 0, T, 40)
			S.start()

			if(owner.can_feel_pain())
				owner.emote("scream")
				owner.adjustHalLoss(15)
				owner.drip(15)
				owner.delayed_vomit()

///////////////////
///Black Mycosis///
///////////////////

/obj/item/organ/internal/parasite/blackkois
	name = "k'ois mycosis"
	icon = 'icons/obj/surgery.dmi'
	icon_state = "black-on"
	dead_icon = "black-off"
	subtle = 1

	organ_tag = "blackkois"

	parent_organ = BP_HEAD
	var/removed_langs = FALSE
	var/full_zombie = FALSE
	stage_interval = 150
	drug_resistance = 1
	max_stage = 5

	origin_tech = list(TECH_BIO = 7)

	egg = /singleton/reagent/kois/black

/obj/item/organ/internal/parasite/blackkois/process()
	..()

	if(prob(10) && (owner.can_feel_pain()))
		if(stage < 3)
			to_chat(owner, "<span class='warning'>You feel a stinging pain in your head!</span>")
		else
			to_chat(owner, "A part of you tries to fight back, but the taste of the black k'ois puts you at ease.")
		owner.visible_message("<b>[owner]</b> winces slightly.")
		owner.adjustHalLoss(5)

	if(stage >= 2)
		if(prob(10) && !(owner.species.flags & NO_BREATHE))
			owner.visible_message("<b>[owner]</b> gasps for air!")
			owner.losebreath += 5

	if(stage >= 3)
		set_light(-1.5, 6, "#FFFFFF")
		if(!(all_languages[LANGUAGE_VAURCA] in owner.languages))
			owner.add_language(LANGUAGE_VAURCA)
			to_chat(owner, "<span class='notice'> Your mind expands, and your thoughts join the unity of the Hivenet.</span>")

		if(prob(5))
			if(stage < 4)
				to_chat(owner, "<span class='warning'>You feel something squirming inside of you!</span>")
			else
				to_chat(owner, SPAN_GOOD("You feel it, within you. Its presence soothes, a constant companion. There is no need to resist. We are with you. We will not abandon you."))
			owner.reagents.add_reagent(/singleton/reagent/kois/black, 4)

		else if(prob(5))
			if(stage < 4)
				to_chat(owner, SPAN_GOOD("In your struggle, a part of you wishes for the spread to continue."))
			else
				to_chat(owner, SPAN_GOOD("You cannot ever believe that you struggled against this feeling. You are home. You are happy."))

		else if(prob(10))
			to_chat(owner, "<span class='warning'>You feel disorientated!</span>")
			switch(rand(1,3))
				if(1)
					owner.confused += 10
					owner.apply_effect(10,EYE_BLUR)
				if(2)
					owner.slurring += 30
				if(3)
					owner.make_dizzy(10)

	if(stage >= 4)

		var/obj/item/organ/internal/brain/B = owner.internal_organs_by_name[BP_BRAIN]

		if(B && !B.prepared)
			to_chat(owner, SPAN_GOOD("As the K'ois consumes your mind, you feel your past self, your memories, your very being slip away. Do not resist it. Let Us in."))
			to_chat(owner, SPAN_HIGHDANGER("You have been lobotomized by K'ois infection."))
			to_chat(owner, SPAN_NOTICE("All of your previous memories up until this point are gone, and all of your ambitions are nothing. You live for only one purpose; to serve the Lii'dra hive."))

			B.prepared = 1


		if(!removed_langs)
			for(var/datum/language/L in owner.languages)
				owner.remove_language(L.name)
			owner.add_language(LANGUAGE_VAURCA)
			owner.add_language(LANGUAGE_LIIDRA)
			removed_langs = TRUE

		if(prob(10))
			if(owner.can_feel_pain())
				to_chat(owner, "<span class='warning'>You feel an unbearable pain in your mind!</span>")
				owner.emote("scream")
			else if (full_zombie)
				to_chat(owner, SPAN_GOOD("Your mind hums with a billion voices that are not your own. You will never be alone again. Unbidden, a smile comes to your face."))
			owner.adjustBrainLoss(1, 55)

		else if(prob(0.5))
			if(stage <= 4)
				to_chat(owner, "<span class='danger'>You feel something alien coming up your throat!</span>")
			else
				to_chat(owner, SPAN_GOOD("You can feel it, flowering within your lungs. What a beautiful feeling, to share it with the Spur. You exhale, and the companion nestled within your flesh blooms, drowning out the light."))
			var/turf/T = get_turf(owner)

			var/datum/reagents/R = new/datum/reagents(20)
			R.add_reagent(/singleton/reagent/kois/black,5)
			var/datum/effect/effect/system/smoke_spread/chem/spores/S = new("blackkois")

			S.attach(T)
			S.set_up(R, 20, 0, T, 40)
			S.start()

			if(owner.can_feel_pain())
				owner.emote("scream")
				owner.adjustHalLoss(5)
				owner.drip(5)
				owner.delayed_vomit()

	if(stage >= 5)
		if(!full_zombie)
			to_chat(owner, SPAN_GOOD("You are dying. But it does not matter. You will serve Our will, until you can serve no more."))
			to_chat(owner, SPAN_NOTICE("You are in the final stage of black k'ois mycosis. It cannot be removed, and you can no longer handle guns or other complex devices, as \
			your fine motor skills erode. However, you are stronger, and no longer affected by pain."))
			if(owner.can_feel_pain())
				owner.pain_immune = TRUE
			if(!owner.lobotomized)
				owner.lobotomized = TRUE //no guns for you, beat people to death as high queen lii'dra intended
			owner.max_stamina = 500 //you are a discount zombie, you run good
			add_verb(owner, /mob/living/carbon/human/proc/kois_cough)
			add_verb(owner, /mob/living/carbon/human/proc/kois_infect)
			full_zombie = TRUE

/obj/item/organ/internal/parasite/blackkois/removed(var/mob/living/carbon/human/target)
	var/obj/item/organ/internal/brain/B = target.internal_organs_by_name[BP_BRAIN]
	switch(stage)
		if(1)
			target.visible_message(SPAN_WARNING("As the black k'ois is cut from [target.name], [target.get_pronoun("he")] spasm[target.get_pronoun("end")] briefly, the black k'ois pulsing in [target.get_pronoun("his")] brain. You can see the scars it has left - it was not a clean surgery, but the damage is minor. [target.get_pronoun("He")] will likely fully recover, given time."),\
			SPAN_WARNING("They cut at your mind, removing the growth that infests it. Your head aches - but your mind is still intact."))
			to_chat(target, SPAN_CULT("A shiver passes over your mind, an odd sense of loneliness. But it lasts only a moment, and then it is gone."))
			B.max_damage = B.max_damage*0.95 //you got it early, good job
		if(2)
			target.visible_message(SPAN_WARNING("As the black k'ois is cut from [target.name], [target.get_pronoun("he")] spasm[target.get_pronoun("end")] wildly, the black k'ois embedded in [target.get_pronoun("his")] brain. You can see the scars it has left - though it was not a clean surgery, the damage is not too great. [target.get_pronoun("He")] may well fully recover."),\
			SPAN_WARNING("They cut at your mind, removing the growth that infests it. Your head hurts, and you find some things hard to recall - but you remember who you are, and you are free from a truly terrible fate. Perhaps that is some comfort."))
			to_chat(target, SPAN_CULT("Something lingers on you. You are free of the mycosis before it could kill you - and why does that fact make you feel almost sad?"))
			B.max_damage = B.max_damage*0.75 //bit more scarring but still ok
		if(3)
			target.visible_message(SPAN_WARNING("As the black k'ois is cut from [target.name], [target.get_pronoun("he")] spasm[target.get_pronoun("end")] wildly, the black k'ois deeply embedded in [target.get_pronoun("his")] brain. You can see the scars it has left - it was not a clean surgery, and [target.get_pronoun("he")] may not fully recover - but [target.get_pronoun("he")] will live, at least."),\
			SPAN_WARNING("They cut at your mind, removing the growth that infests it. Your head hurts, and you find some things hard to recall - but you remember who you are, and you are free from a truly terrible fate. Perhaps that is some comfort."))
			to_chat(target, SPAN_CULT("A part of you misses the feeling of it, pulsing inside your skull like a friend, a constant companion. You have survived - but you cannot help but feel empty."))
			B.max_damage = B.max_damage*0.65 //ok, now you have permanent brain damage
		if(4)
			target.visible_message(SPAN_WARNING("As the black k'ois is cut from [target.name], [target.get_pronoun("he")] spasm[target.get_pronoun("end")] wildly, the black k'ois deeply embedded in [target.get_pronoun("his")] brain. You can see the scars it has left - it was not a clean surgery, and [target.get_pronoun("he")] will never fully recover - but [target.get_pronoun("he")] will live, at least."),\
			SPAN_WARNING("They cut at your mind, removing the growth that infests it. It's hard to remember what you are, without it. Perhaps, if you think hard enough, you can remember your name."))
			to_chat(target, SPAN_CULT("You have failed Us. We will find another way. Releasing control."))
			B.max_damage = B.max_damage*0.45 //yeah your brain is severely messed up man
		if(5)
			target.visible_message(SPAN_WARNING("As the black k'ois is cut from [target.name], [target.get_pronoun("he")] spasm[target.get_pronoun("end")] wildly, [target.get_pronoun("his")] brain too damaged to function. A horrible choking sound emerges from [target.get_pronoun("his")] mouth, before it is mercifully silenced as [target.get_pronoun("he")] falls still."),\
			SPAN_DANGER("You feel the cold of the knife cutting and cutting, but it is too late. There is nothing left of you but the Lii'dra's will, now. A final cut - and then you are granted the only escape that still remains to you."))
			to_chat(target, SPAN_GOOD("Your function is fulfilled. We have no further need of you. Releasing control."))
			target.death(FALSE) //too late, there is no brain left to save
	if(all_languages[LANGUAGE_VAURCA] in target.languages && stage >= 3 && !isvaurca(target))
		target.remove_language(LANGUAGE_VAURCA)
		to_chat(target, "<span class='warning'>Your mind suddenly grows dark as the unity of the Hive is torn from you.</span>")
	if(all_languages[LANGUAGE_LIIDRA] in target.languages && stage >= 3)
		target.remove_language(LANGUAGE_LIIDRA)
	removed_langs = 0
	remove_verb(owner, /mob/living/carbon/human/proc/kois_cough)
	remove_verb(owner, /mob/living/carbon/human/proc/kois_infect)
	..()

/obj/item/organ/internal/parasite/zombie
	name = "black tumour"
	icon = 'icons/obj/organs/organs.dmi'
	icon_state = "black_tumour"
	dead_icon = "black_tumour"

	organ_tag = BP_ZOMBIE_PARASITE
	parent_organ = BP_HEAD
	stage_interval = 150
	drug_resistance = 1
	relative_size = 0

	egg = /singleton/reagent/toxin/trioxin

	var/last_heal = 0
	var/heal_rate = 5 SECONDS

/obj/item/organ/internal/parasite/zombie/process()
	..()

	if (!owner)
		return

	if(length(owner.bad_external_organs) && last_heal + heal_rate < world.time && iszombie(owner))
		var/list/organs_to_heal = owner.bad_external_organs
		shuffle(organs_to_heal)
		for(var/thing in organs_to_heal)
			var/obj/item/organ/external/O = thing
			if(istype(O, /obj/item/organ/external/head)) // the head is the weak point
				continue
			var/healed = FALSE
			if(O.status & ORGAN_ARTERY_CUT)
				O.status &= ~ORGAN_ARTERY_CUT
				owner.visible_message(SPAN_WARNING("The severed artery in \the [owner]'s [O] stitches itself back together..."), SPAN_NOTICE("The severed artery in your [O] stitches itself back together..."))
				healed = TRUE
			else if((O.tendon_status() & TENDON_CUT) && O.tendon.can_recover())
				O.tendon.rejuvenate()
				owner.visible_message(SPAN_WARNING("The severed tendon in \the [owner]'s [O] stitches itself back together..."), SPAN_NOTICE("The severed tendon in your [O] stitches itself back together..."))
				healed = TRUE
			else if(O.status & ORGAN_BROKEN)
				var/list/brute_wounds = list()
				for(var/wound in O.wounds)
					var/datum/wound/W = wound
					if(W.damage_type in list(CUT, BRUISE, PIERCE))
						brute_wounds += W
				for(var/wound in brute_wounds)
					var/datum/wound/W = wound
					W.damage = max(min(W.damage, (O.min_broken_damage / length(brute_wounds))), 0)
				O.status &= ~ORGAN_BROKEN
				owner.visible_message(SPAN_WARNING("The shattered bone in \the [owner]'s [O] melds back together..."), SPAN_NOTICE("The shattered bone in your [O] melds back together..."))
				healed = TRUE
			if(healed)
				last_heal = world.time
				heal_rate += 2 SECONDS
				O.update_damages()
				break

	if(prob(10) && (owner.can_feel_pain()))
		to_chat(owner, "<span class='warning'>You feel a burning sensation on your skin!</span>")
		owner.make_jittery(10)

	else if(prob(10))
		owner.emote("moan")

	if(stage >= 2)
		if(prob(15))
			owner.emote("scream")
			if(!isundead(owner))
				owner.adjustBrainLoss(2, 55)

		else if(prob(10))
			if(!isundead(owner))
				to_chat(owner, "<span class='warning'>You feel sick.</span>")
				owner.adjustToxLoss(5)
				owner.delayed_vomit()

	if(stage >= 3)
		if(prob(10))
			if(isundead(owner))
				owner.adjustBruteLoss(-30)
				owner.adjustFireLoss(-30)
			else
				to_chat(owner, "<span class='cult'>You feel an insatiable hunger.</span>")
				owner.nutrition = -1

	if(stage >= 4)
		if(prob(10))
			if(!isundead(owner))
				if(owner.species.zombie_type)
					var/r = owner.r_skin
					var/g = owner.g_skin
					var/b = owner.b_skin

					for(var/datum/language/L in owner.languages)
						owner.remove_language(L.name)
					to_chat(owner, "<span class='warning'>You feel life leaving your husk, but death rejects you...</span>")
					playsound(src.loc, 'sound/hallucinations/far_noise.ogg', 50, 1)
					to_chat(owner, "<font size='3'><span class='cult'>All that is left is a cruel hunger for the flesh of the living, and the desire to spread this infection. You must consume all the living!</font></span>")
					owner.set_species(owner.species.zombie_type, 0, 0, 0)
					owner.change_skin_color(r, g, b)
					owner.update_dna()
				else
					owner.adjustToxLoss(50)

//Parasitic Worms//

/obj/item/organ/internal/parasite/nerveworm
	name = "bundle of nerve flukes"
	icon = 'icons/obj/organs/organs.dmi'
	icon_state = "helminth"
	dead_icon = "helminth_dead"

	organ_tag = BP_WORM_NERVE
	parent_organ = BP_L_ARM //if desperate, can lop your arm off to remove the infection :)
	subtle = 1

	origin_tech = list(TECH_BIO = 4)

	egg = /singleton/reagent/toxin/nerveworm_eggs

/obj/item/organ/internal/parasite/nerveworm/process()
	..()

	if (!owner)
		return

	if(prob(10))
		owner.adjustNutritionLoss(10)

	if(stage >= 2) //after ~5 minutes
		owner.confused = max(owner.confused, 10)

	if(stage >= 3) //after ~10 minutes
		owner.slurring = max(owner.slurring, 100)
		owner.drowsiness = max(owner.drowsiness, 20)
		if(prob(1))
			owner.delayed_vomit()
		if(prob(2))
			to_chat(owner, SPAN_WARNING(pick("You feel a tingly sensation in your fingers.", "Is that pins and needles?", "An electric sensation jolts its way up your left arm.", "You smell something funny.", "You taste something funny.")))

	if(stage >= 4) //after ~15 minutes
		if(prob(2))
			to_chat(owner, SPAN_WARNING(pick("A deep, tingling sensation paralyses your left arm.", "You feel as if you just struck your funny bone.", "You feel a pulsing sensation within your left arm.")))
			owner.emote(pick("twitch", "shiver"))
			owner.stuttering = 20
		if(prob(1))
			owner.seizure()
		if(prob(5))
			owner.reagents.add_reagent(/singleton/reagent/toxin/nerveworm_eggs, 2)
			owner.adjustHalLoss(15)
			to_chat(owner, SPAN_WARNING("An <b>extreme</b>, nauseating pain erupts from deep within your left arm!"))


/obj/item/organ/internal/parasite/heartworm
	name = "bundle of heart flukes"
	icon = 'icons/obj/organs/organs.dmi'
	icon_state = "helminth"
	dead_icon = "helminth_dead"

	organ_tag = BP_WORM_HEART
	parent_organ = BP_CHEST
	subtle = 1

	stage_interval = 450 //~7.5 minutes/stage

	origin_tech = list(TECH_BIO = 4)

	egg = /singleton/reagent/toxin/heartworm_eggs

/obj/item/organ/internal/parasite/heartworm/process()
	..()

	var/obj/item/organ/internal/heart = owner.internal_organs_by_name[BP_HEART]

	if (!owner)
		return

	if(prob(10))
		owner.adjustNutritionLoss(10)

	if(stage >= 2) //after ~7.5 minutes
		if(prob(2))
			owner.emote("cough")

	if(stage >= 3)  //after ~15 minutes
		if(prob(7))
			heart.take_damage(rand(2,5))
		if(prob(5))
			to_chat(owner, SPAN_WARNING(pick("Your chest feels tight.", "Your chest is aching.", "You feel a stabbing pain in your chest!", "You feel a painful, tickly sensation within your chest.")))
			owner.adjustHalLoss(15)

	if(stage >= 4)  //after ~22.5 minutes
		if(prob(5))
			owner.reagents.add_reagent(/singleton/reagent/toxin/heartworm_eggs, 2)
			owner.adjustHalLoss(15)
			to_chat(owner, SPAN_WARNING("An <b>extreme</b>, nauseating pain erupts from the centre of your chest!"))

