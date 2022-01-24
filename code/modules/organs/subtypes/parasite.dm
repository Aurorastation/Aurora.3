/obj/item/organ/internal/parasite
	name = "parasite"
	icon = 'icons/mob/npc/alien.dmi'
	icon_state = "burst_lie"
	dead_icon = "bursted_lie"

	organ_tag = "parasite"
	var/stage = 1
	var/max_stage = 4
	var/stage_ticker = 0
	var/infection_speed = 2 //Will be determined by get_infect_speed()
	var/infect_speed_high = 35	//The fastest this parasite will advance stages
	var/infect_speed_low = 15	//The slowest this parasite will advance stages
	var/stage_interval = 600 //time between stages, in seconds
	var/subtle = 0 //will the body reject the parasite naturally?

/obj/item/organ/internal/parasite/Initialize()
	. = ..()
	get_infect_speed()

/obj/item/organ/internal/parasite/proc/get_infect_speed() //Slightly randomizes how fast each infection progresses.
	infection_speed = rand(infect_speed_low, infect_speed_high) / 10

/obj/item/organ/internal/parasite/process()
	..()

	if(!owner)
		return

	if(stage < max_stage)
		stage_ticker += infection_speed 

	if(stage_ticker >= stage*stage_interval)
		stage = min(stage+1,max_stage)
		get_infect_speed() //Each stage may progress faster or slower than the previous one
		stage_effect()

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

	origin_tech = list(TECH_BIO = 3)

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
			owner.reagents.add_reagent(/decl/reagent/toxin/phoron, 8)
			owner.reagents.add_reagent(/decl/reagent/kois, 5)

	if(stage >= 4)
		if(prob(10))
			to_chat(owner, "<span class='danger'>You feel something alien coming up your throat!</span>")
			owner.emote("cough")

			var/turf/T = get_turf(owner)

			var/datum/reagents/R = new/datum/reagents(100)
			R.add_reagent(/decl/reagent/kois,10)
			R.add_reagent(/decl/reagent/toxin/phoron,10)
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
	var/removed_langs = 0
	stage_interval = 150
	origin_tech = list(TECH_BIO = 7)

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
			to_chat(owner, "<span class='warning'>You feel something squirming inside of you!</span>")
			owner.reagents.add_reagent(/decl/reagent/kois/black, 4)

		else if(prob(5))
			to_chat(owner, "In your struggle, a part of you wishes for the spread to continue.")

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
			to_chat(owner, "<span class='danger'>As the K'ois consumes your mind, you feel your past self, your memories, your very being slip away... only slavery to the swarm remains...</span>")
			to_chat(owner, "<b>You have been lobotomized by K'ois infection. All of your previous memories up until this point are gone, and all of your ambitions are nothing. You live for only one purpose; to serve the Lii'dra hive.</b>")

			B.prepared = 1


		if(!removed_langs)
			for(var/datum/language/L in owner.languages)
				owner.remove_language(L.name)
			owner.add_language(LANGUAGE_VAURCA)
			removed_langs = 1

		if(prob(10))
			if(owner.can_feel_pain())
				to_chat(owner, "<span class='warning'>You feel an unbearable pain in your mind!</span>")
				owner.emote("scream")
			owner.adjustBrainLoss(1, 55)

		else if(prob(0.5))
			to_chat(owner, "<span class='danger'>You feel something alien coming up your throat!</span>")

			var/turf/T = get_turf(owner)

			var/datum/reagents/R = new/datum/reagents(20)
			R.add_reagent(/decl/reagent/kois/black,5)
			var/datum/effect/effect/system/smoke_spread/chem/spores/S = new("blackkois")

			S.attach(T)
			S.set_up(R, 20, 0, T, 40)
			S.start()

			if(owner.can_feel_pain())
				owner.emote("scream")
				owner.adjustHalLoss(5)
				owner.drip(5)
				owner.delayed_vomit()

/obj/item/organ/internal/parasite/blackkois/removed(var/mob/living/carbon/human/target)
	if(all_languages[LANGUAGE_VAURCA] in target.languages && stage >= 3 && !isvaurca(target))
		target.remove_language(LANGUAGE_VAURCA)
		to_chat(target, "<span class='warning'>Your mind suddenly grows dark as the unity of the Hive is torn from you.</span>")
	removed_langs = 0
	..()

/obj/item/organ/internal/parasite/zombie
	name = "black tumor"
	icon = 'icons/obj/surgery.dmi'
	icon_state = "blacktumor"
	dead_icon = "blacktumor"

	organ_tag = BP_ZOMBIE_PARASITE
	parent_organ = BP_HEAD
	stage_interval = 150

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
