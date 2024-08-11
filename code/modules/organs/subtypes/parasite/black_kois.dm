/obj/item/organ/internal/parasite/blackkois
	name = "k'ois mycosis"
	icon = 'icons/obj/organs/organs.dmi'
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
			to_chat(owner, SPAN_WARNING("You feel a stinging pain in your head!"))
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
		if(!(GLOB.all_languages[LANGUAGE_VAURCA] in owner.languages))
			owner.add_language(LANGUAGE_VAURCA)
			to_chat(owner, SPAN_NOTICE("Your mind expands, and your thoughts join the unity of the Hivenet."))

		if(prob(5))
			if(stage < 4)
				to_chat(owner, SPAN_WARNING("You feel something squirming inside of you!"))
			else
				to_chat(owner, SPAN_GOOD("You feel it, within you. Its presence soothes, a constant companion. There is no need to resist. We are with you. We will not abandon you."))
			owner.reagents.add_reagent(/singleton/reagent/kois/black, 4)

		else if(prob(5))
			if(stage < 4)
				to_chat(owner, SPAN_GOOD("In your struggle, a part of you wishes for the spread to continue."))
			else
				to_chat(owner, SPAN_GOOD("You cannot ever believe that you struggled against this feeling. You are home. You are happy."))

		else if(prob(10))
			to_chat(owner, SPAN_WARNING("You feel disorientated!"))
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
			owner.set_default_language(LANGUAGE_LIIDRA)
			removed_langs = TRUE

		owner.set_see_invisible(SEE_INVISIBLE_NOLIGHTING)
		owner.add_client_color(/datum/client_color/vaurca)

		if(prob(10))
			if(owner.can_feel_pain())
				to_chat(owner, SPAN_WARNING("You feel an unbearable pain in your mind!"))
				owner.emote("scream")
			else if(full_zombie)
				to_chat(owner, SPAN_GOOD("Your mind hums with a billion voices that are not your own. You will never be alone again. Unbidden, a smile comes to your face."))
			owner.adjustBrainLoss(1, 55)

		else if(prob(0.5))
			if(stage <= 4)
				to_chat(owner, SPAN_DANGER("You feel something alien coming up your throat!"))
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
	if(GLOB.all_languages[LANGUAGE_VAURCA] in target.languages && stage >= 3 && !isvaurca(target))
		target.remove_language(LANGUAGE_VAURCA)
		to_chat(target, SPAN_WARNING("Your mind suddenly grows dark as the unity of the Hive is torn from you."))
	if(GLOB.all_languages[LANGUAGE_LIIDRA] in target.languages && stage >= 3)
		target.remove_language(LANGUAGE_LIIDRA)
	removed_langs = 0
	remove_verb(owner, /mob/living/carbon/human/proc/kois_cough)
	remove_verb(owner, /mob/living/carbon/human/proc/kois_infect)
	..()
