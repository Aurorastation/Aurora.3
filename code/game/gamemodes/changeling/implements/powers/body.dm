//Change our DNA to that of somebody we've absorbed.
/mob/proc/changeling_transform()
	set category = "Changeling"
	set name = "Transform (5)"

	var/datum/changeling/changeling = changeling_power(5, 1, 0)
	if(!changeling)
		return

	if(!ishuman(src))
		to_chat(src, SPAN_WARNING("We cannot perform this ability as this form!"))
		return

	var/list/names = list()
	for(var/datum/absorbed_dna/DNA in changeling.absorbed_dna)
		names += "[DNA.name]"

	var/S = input("Select the target DNA: ", "Target DNA", null) as null|anything in names
	if(!S)
		return

	var/datum/absorbed_dna/chosen_dna = changeling.GetDNA(S)
	if(!chosen_dna)
		return

	changeling.chem_charges -= 5
	changeling.geneticdamage = 30

	handle_changeling_transform(chosen_dna)

	src.verbs -= /mob/proc/changeling_transform
	ADD_VERB_IN(src, 10, /mob/proc/changeling_transform)

	changeling_update_languages(changeling.absorbed_languages)

	feedback_add_details("changeling_powers", "TR")
	return TRUE

/mob/proc/handle_changeling_transform(var/datum/absorbed_dna/chosen_dna)
	if(ishuman(src))
		src.visible_message(SPAN_WARNING("[src] transforms!"))
		var/mob/living/carbon/human/H = src
		var/newSpecies = chosen_dna.speciesName
		H.set_species(newSpecies, 1)

		H.dna = chosen_dna.dna
		H.real_name = chosen_dna.name
		H.sync_organ_dna()
		H.flavor_text = ""
		domutcheck(H, null) //donut check heh heh heh - Geeves
		H.UpdateAppearance()

//Transform into a monkey.
/mob/proc/changeling_lesser_form()
	set category = "Changeling"
	set name = "Lesser Form (1)"

	var/datum/changeling/changeling = changeling_power(1, 0, 0)
	if(!changeling)
		return

	if(src.has_brain_worms()) //why the fuck does brain worms prevent you from turning into a monkey
		to_chat(src, SPAN_WARNING("We cannot perform this ability at the present time!"))
		return

	var/mob/living/carbon/human/H = src

	if(!istype(H) || !H.species.primitive_form)
		to_chat(src, SPAN_WARNING("We cannot perform this ability in this form!"))
		return

	if(H.handcuffed)
		var/cuffs = H.handcuffed
		H.u_equip(H.handcuffed)
		qdel(cuffs)

	changeling.chem_charges--
	H.visible_message(SPAN_WARNING("[H] transforms!"))
	changeling.geneticdamage = 30
	to_chat(H, SPAN_WARNING("Our genes cry out!"))

	var/mob/living/simple_animal/hostile/lesser_changeling/ling = new (get_turf(H))

	if(istype(H,/mob/living/carbon/human))
		for(var/obj/item/I in H.contents)
			if(isorgan(I))
				continue
			H.drop_from_inventory(I)

	if(H.mind)
		H.mind.transfer_to(ling)
	else
		ling.key = H.key
	ling.occupant = H
	var/atom/movable/overlay/effect = new /atom/movable/overlay(get_turf(H))
	effect.density = FALSE
	effect.anchored = TRUE
	effect.icon = 'icons/effects/effects.dmi'
	effect.layer = 3
	flick("summoning", effect)
	QDEL_IN(effect, 10)
	H.forceMove(ling)
	H.status_flags |= GODMODE

	feedback_add_details("changeling_powers", "LF")
	return TRUE

//Transform into a human
/mob/proc/changeling_lesser_transform()
	set category = "Changeling"
	set name = "Transform (1)"

	var/datum/changeling/changeling = changeling_power(1, 1, 0)
	if(!changeling)
		return

	var/list/names = list()
	for(var/datum/dna/DNA in changeling.absorbed_dna)
		names += "[DNA.real_name]"

	var/S = input("Select the target DNA: ", "Target DNA", null) as null|anything in names
	if(!S)
		return

	var/datum/dna/chosen_dna = changeling.GetDNA(S)
	if(!chosen_dna)
		return

	var/mob/living/carbon/C = src

	changeling.chem_charges--
	C.remove_changeling_powers()
	C.visible_message(SPAN_WARNING("[C] transforms!"))
	C.dna = chosen_dna.Clone()

	var/list/implants = list()
	for (var/obj/item/implant/I in C) //Still preserving implants
		implants += I

	C.transforming = TRUE
	C.canmove = FALSE
	C.icon = null
	C.cut_overlays()
	C.invisibility = 101
	var/atom/movable/overlay/animation = new /atom/movable/overlay(C.loc)
	animation.icon_state = "blank"
	animation.icon = 'icons/mob/mob.dmi'
	animation.master = src
	flick("monkey2h", animation)
	sleep(48)
	qdel(animation)

	for(var/obj/item/W in src)
		C.drop_from_inventory(W)

	var/mob/living/carbon/human/O = new /mob/living/carbon/human( src )
	if (C.dna.GetUIState(DNA_UI_GENDER))
		O.gender = FEMALE
	else
		O.gender = MALE
	O.dna = C.dna.Clone()
	C.dna = null
	O.real_name = chosen_dna.real_name

	for(var/obj/T in C)
		qdel(T)

	O.forceMove(C.loc)

	O.UpdateAppearance()
	domutcheck(O, null)
	O.setToxLoss(C.getToxLoss())
	O.adjustBruteLoss(C.getBruteLoss())
	O.setOxyLoss(C.getOxyLoss())
	O.adjustFireLoss(C.getFireLoss())
	O.stat = C.stat
	for (var/obj/item/implant/I in implants)
		I.forceMove(O)
		I.implanted = O

	C.mind.transfer_to(O)
	O.make_changeling()
	O.changeling_update_languages(changeling.absorbed_languages)

	feedback_add_details("changeling_powers", "LFT")
	qdel(C)
	return TRUE


//Fake our own death and fully heal. You will appear to be dead but regenerate fully after a short delay.
/mob/proc/changeling_fakedeath()
	set category = "Changeling"
	set name = "Regenerative Stasis (30)"

	var/datum/changeling/changeling = changeling_power(30,1,100,DEAD)
	if(!changeling)
		return

	var/mob/living/carbon/C = src
	if(!C.stat && alert("Are we sure we wish to fake our death?", , "Yes", "No") == "No") //Confirmation for living changelings if they want to fake their death
		return
	to_chat(C, SPAN_NOTICE("We will attempt to regenerate our form."))

	C.status_flags |= FAKEDEATH		//play dead
	C.update_canmove()
	C.mind.changeling.in_stasis = TRUE
	C.mind.changeling.can_exit_stasis = FALSE

	C.emote("gasp")
	C.tod = worldtime2text()

	addtimer(CALLBACK(src, .proc/allow_revive, C), 3 MINUTES)
	feedback_add_details("changeling_powers", "FD")
	return TRUE

/mob/proc/allow_revive(var/mob/living/carbon/C)
	if(!(C.mind?.changeling))
		log_debug("Attempted to allow [C] to revive as a changeling, but they are not a changeling!")
		return
	to_chat(C, SPAN_NOTICE(FONT_GIANT("We are ready to rise. Use the <b>Revive</b> verb when you are ready.")))
	C.mind.changeling.can_exit_stasis = TRUE

/mob/proc/changeling_revive()
	set category = "Changeling"
	set name = "Revive"

	var/mob/living/carbon/C = src
	if(!(C.mind?.changeling))
		log_debug("[C] attempted to revive as a changeling, but they are not a changeling!")
		return
	if(!C.mind.changeling.in_stasis) //Well if we're not in stasis...
		return
	if(!C.mind.changeling.can_exit_stasis)
		to_chat(C, SPAN_WARNING("We are not ready to awaken from our stasis. We must bide our time."))
		return
	if(C.changeling_power(30,1,100,DEAD, allow_in_stasis = TRUE))
		//charge the changeling chemical cost for stasis
		C.mind.changeling.chem_charges -= 30
	else
		to_chat(C, SPAN_WARNING("We have not generated enough chemicals to awaken from our stasis. We must bide our time."))
		return
	C.mind.changeling.in_stasis = FALSE
	// restore us to health
	C.revive(FALSE)
	// remove our fake death flag
	C.status_flags &= ~(FAKEDEATH)
	// sending display messages
	to_chat(C, SPAN_NOTICE("We have regenerated fully."))

//Recover from stuns.
/mob/proc/changeling_unstun()
	set category = "Changeling"
	set name = "Adrenaline Sacs (20)"
	set desc = "Removes all manner of stuns, as well as producing painkillers and stimulants."

	var/datum/changeling/changeling = changeling_power(20, 0, 100, UNCONSCIOUS)
	if(!changeling)
		return FALSE
	changeling.chem_charges -= 20

	var/mob/living/carbon/human/C = src
	C.stat = 0
	C.SetParalysis(0)
	C.SetStunned(0)
	C.SetWeakened(0)
	C.lying = FALSE
	C.reagents.add_reagent("hyperzine", 0.10) //Certainly this can't be abused. - Geeves
	C.reagents.add_reagent("oxycodone", 0.10)
	C.update_canmove()

	src.verbs -= /mob/proc/changeling_unstun
	ADD_VERB_IN(src, 5, /mob/proc/changeling_unstun)
	feedback_add_details("changeling_powers", "UNS")
	return TRUE

//Prevents AIs tracking you but makes you easily detectable to the human-eye.
/mob/proc/changeling_digitalcamo()
	set category = "Changeling"
	set name = "Toggle Digital Camouflage"
	set desc = "The AI can no longer track us, but we will look uncanny if examined. Has a constant cost while active."

	var/datum/changeling/changeling = changeling_power()
	if(!changeling)
		return FALSE

	var/mob/living/carbon/human/C = src
	if(C.digitalcamo)
		to_chat(C, SPAN_NOTICE("We cease distorting our form."))
	else
		to_chat(C, SPAN_NOTICE("We distort our form to prevent AI-tracking."))
	C.digitalcamo = !C.digitalcamo

	spawn(0)
		while(C && C.digitalcamo && C.mind && C.mind.changeling)
			C.mind.changeling.chem_charges = max(C.mind.changeling.chem_charges - 1, 0)
			sleep(40)

	src.verbs -= /mob/proc/changeling_digitalcamo
	ADD_VERB_IN(src, 5, /mob/proc/changeling_digitalcamo)
	feedback_add_details("changeling_powers", "CAM")
	return TRUE

//Starts healing you every second for 10 seconds. Can be used whilst unconscious.
/mob/proc/changeling_rapidregen()
	set category = "Changeling"
	set name = "Rapid Regeneration (30)"
	set desc = "We begin rapidly regenerating ourselves. Does not affect stuns or chemicals."

	var/datum/changeling/changeling = changeling_power(30, 0, 100, UNCONSCIOUS)
	if(!changeling)
		return FALSE
	src.mind.changeling.chem_charges -= 30

	var/mob/living/carbon/human/C = src
	spawn(0)
		for(var/i = 0, i < 10, i++)
			if(C)
				C.adjustBruteLoss(-10)
				C.adjustToxLoss(-10)
				C.adjustOxyLoss(-10)
				C.adjustFireLoss(-10)
				C.adjustCloneLoss(-10)
				sleep(10)

	src.verbs -= /mob/proc/changeling_rapidregen
	ADD_VERB_IN(src, 5, /mob/proc/changeling_rapidregen)
	feedback_add_details("changeling_powers", "RR")
	return TRUE

// Fake Voice
/mob/proc/changeling_mimicvoice()
	set category = "Changeling"
	set name = "Mimic Voice"
	set desc = "Shape our vocal glands to form a voice of anyone we choose."

	var/datum/changeling/changeling = changeling_power()
	if(!changeling)
		return

	if(changeling.mimicing)
		changeling.mimicing = ""
		to_chat(src, SPAN_NOTICE("We return our vocal glands to their original form."))
		return

	var/mimic_voice = sanitize(input(usr, "Enter a name to mimic.", "Mimic Voice", null), MAX_NAME_LEN)
	if(!mimic_voice)
		return

	changeling.mimicing = mimic_voice

	to_chat(src, SPAN_NOTICE("We shape our glands to take the voice of <b>[mimic_voice]</b>, this will stop us from regenerating chemicals while active."))
	to_chat(src, SPAN_NOTICE("Use this power again to return to our original voice and reproduce chemicals again."))

	feedback_add_details("changeling_powers","MV")

	spawn(0)
		while(src && src.mind && src.mind.changeling && src.mind.changeling.mimicing)
			src.mind.changeling.chem_charges = max(src.mind.changeling.chem_charges - 1, 0)
			sleep(40)
		if(src && src.mind && src.mind.changeling)
			src.mind.changeling.mimicing = ""

/mob/proc/armblades()
	set category = "Changeling"
	set name = "Form Blades (20)"
	set desc = "Rupture the flesh and mend the bone of your hand into a deadly blade."

	var/datum/changeling/changeling = changeling_power(20, 0, 0)
	if(!changeling)
		return FALSE
	src.mind.changeling.chem_charges -= 20

	var/mob/living/carbon/M = src

	if(M.l_hand && M.r_hand)
		to_chat(M, SPAN_DANGER("Your hands are full."))
		return

	if(M.handcuffed)
		var/cuffs = M.handcuffed
		M.u_equip(M.handcuffed)
		qdel(cuffs)

	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(istype(H.wear_suit, /obj/item/clothing/suit/straight_jacket))
			src.visible_message(SPAN_DANGER("[H] tears through the [H.wear_suit] with their grotesque arm blades!"),
								SPAN_DANGER("We tear through the [H.wear_suit] with our arm blades!"),
								SPAN_DANGER("You hear cloth ripping and tearing!"))
			QDEL_IN(H.wear_suit, 0)
			H.unEquip(H.wear_suit, force = TRUE)

	var/obj/item/melee/arm_blade/blade = new(M)
	blade.creator = M
	M.put_in_hands(blade)
	playsound(loc, 'sound/weapons/bloodyslice.ogg', 30, 1)
	src.visible_message(SPAN_DANGER("A grotesque blade forms around [M]\'s arm!"),
						SPAN_DANGER("Our arm twists and mutates, transforming it into a deadly blade."),
						SPAN_DANGER("You hear flesh ripping and tearing!"))

/mob/proc/changeling_shield()
	set category = "Changeling"
	set name = "Form Shield (20)"
	set desc = "Bend the flesh and bone of your hand into a grotesque shield."

	var/datum/changeling/changeling = changeling_power(20,0,0)
	if(!changeling)
		return FALSE
	src.mind.changeling.chem_charges -= 20

	var/mob/living/carbon/M = src

	if(M.l_hand && M.r_hand)
		to_chat(M, SPAN_DANGER("Your hands are full."))
		return

	if(M.handcuffed)
		var/cuffs = M.handcuffed
		M.u_equip(M.handcuffed)
		qdel(cuffs)

	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(istype(H.wear_suit, /obj/item/clothing/suit/straight_jacket))
			src.visible_message(SPAN_DANGER("[H] tears through the [H.wear_suit] with their grotesque shield!"),
							SPAN_DANGER("We tear through the [H.wear_suit] with our newly formed shield!"),
							SPAN_DANGER("You hear cloth ripping and tearing!"))
			QDEL_IN(H.wear_suit, 0)
			H.unEquip(H.wear_suit, force = TRUE)

	var/obj/item/shield/riot/changeling/shield = new(M)
	shield.creator = M
	M.put_in_hands(shield)
	playsound(loc, 'sound/effects/blobattack.ogg', 30, 1)
	src.visible_message(SPAN_DANGER("The end of [M]\'s hand inflates rapidly, forming a huge shield-like mass!"),
						SPAN_DANGER("We inflate our hand into a robust shield."),
						SPAN_DANGER("You hear flesh ripping and tearing!"))

/mob/proc/horror_form()
	set category = "Changeling"
	set name = "Horror Form (40)"
	set desc = "Tear apart your human disguise, revealing your true form."

	var/datum/changeling/changeling = changeling_power(40,0,0)
	if(!changeling)
		return FALSE

	var/mob/living/M = src

	if(alert("Are we sure we wish to reveal ourselves? This will only revert after ten minutes.", , "Yes", "No") == "No") //Changelings have to confirm whether they want to go full horrorform
		return

	src.mind.changeling.chem_charges -= 40

	M.visible_message(SPAN_DANGER("[M] writhes and contorts, their body expanding to inhuman proportions!"),
						SPAN_DANGER("We begin our transformation to our true form!"))
	if(!do_after(src,60))
		M.visible_message(SPAN_DANGER("[M]'s twisting and writhing flesh abruptly reverts itself!"), 
						SPAN_DANGER("Our transformation has been interrupted!"))
		return FALSE

	M.visible_message(SPAN_DANGER("[M] grows into an ever-shifting amalgamation of flesh and gore, and releases an otherworldly scream!"))
	playsound(loc, 'sound/effects/greaterling.ogg', 100, 1)

	var/mob/living/simple_animal/hostile/true_changeling/ling = new (get_turf(M))

	if(ishuman(M))
		for(var/obj/item/I in M.contents)
			if(isorgan(I))
				continue
			M.drop_from_inventory(I)

	if(M.mind)
		M.mind.transfer_to(ling)
	else
		ling.key = M.key
	var/atom/movable/overlay/effect = new /atom/movable/overlay(get_turf(M))
	effect.density = FALSE
	effect.anchored = TRUE
	effect.icon = 'icons/effects/effects.dmi'
	effect.layer = 3
	flick("summoning", effect)
	QDEL_IN(effect, 10)
	M.forceMove(ling) //move inside the new dude to hide him.
	ling.occupant = M
	M.status_flags |= GODMODE //dont want him to die or breathe or do ANYTHING
	addtimer(CALLBACK(src, .proc/revert_horror_form,ling), 10 MINUTES)

/mob/proc/revert_horror_form(var/mob/living/ling)
	if(QDELETED(ling))
		return
	src.status_flags &= ~GODMODE //no more godmode.
	if(ling.mind)
		ling.mind.transfer_to(src)
	else
		src.key = ling.key
	playsound(get_turf(src),'sound/effects/blobattack.ogg',50,1)
	src.forceMove(get_turf(ling))
	qdel(ling)