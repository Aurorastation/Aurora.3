//Change our DNA to that of somebody we've absorbed.
/mob/proc/changeling_transform()
	set category = "Changeling"
	set name = "Transform (5)"

	var/datum/changeling/changeling = changeling_power(5, 1, 0)
	if(!changeling)
		return

	if(!ishuman(src))
		to_chat(src, "<span class='warning'>We cannot perform this ability as this form!</span>")
		return

	var/list/names = list()
	for(var/datum/absorbed_dna/DNA in changeling.absorbed_dna)
		names += "[DNA.name]"

	var/S = tgui_input_list(src, "Select the target DNA.", "Target DNA", names)
	if(!S)
		return

	var/datum/absorbed_dna/chosen_dna = changeling.GetDNA(S)
	if(!chosen_dna)
		return

	changeling.use_charges(5)
	changeling.geneticdamage = 30

	handle_changeling_transform(chosen_dna)

	remove_verb(src, /mob/proc/changeling_transform)
	ADD_VERB_IN(src, 10, /mob/proc/changeling_transform)

	client.init_verbs()

	changeling_update_languages(changeling.absorbed_languages)

	feedback_add_details("changeling_powers", "TR")
	return TRUE

/mob/proc/handle_changeling_transform(var/datum/absorbed_dna/chosen_dna)
	if(ishuman(src))
		var/mob/living/carbon/human/H = src
		H.visible_message("<span class='warning'>[H] transforms!</span>")
		var/newSpecies = chosen_dna.speciesName
		H.set_species(newSpecies, 1)
		if(mind) //likely transfomration sting on ghosted corpse if no mind
			var/datum/changeling/changeling = mind.antag_datums[MODE_CHANGELING]
			if(changeling && !changeling.mimicing)
				changeling.mimiced_accent = chosen_dna.accent
		H.dna = chosen_dna.dna
		H.real_name = chosen_dna.name
		H.sync_organ_dna()
		H.flavor_text = ""
		H.height = chosen_dna.height
		H.gender = chosen_dna.gender
		H.pronouns = chosen_dna.pronouns
		H.g_style = chosen_dna.hairGradient.style
		H.r_grad = chosen_dna.hairGradient.red
		H.g_grad = chosen_dna.hairGradient.green
		H.b_grad = chosen_dna.hairGradient.blue
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
		to_chat(src, "<span class='warning'>We cannot perform this ability at the present time!</span>")
		return

	var/mob/living/carbon/human/H = src

	if(!istype(H) || !H.species.primitive_form)
		to_chat(src, "<span class='warning'>We cannot perform this ability in this form!</span>")
		return

	if(!isturf(loc)) // so people can't transform inside places they should not, like sleepers
		return

	if(H.handcuffed)
		var/cuffs = H.handcuffed
		H.u_equip(H.handcuffed)
		qdel(cuffs)

	if(H.buckled_to)
		H.buckled_to.unbuckle()

	changeling.use_charges(1)
	H.visible_message("<span class='warning'>[H] transforms!</span>")
	changeling.geneticdamage = 30
	to_chat(H, "<span class='warning'>Our genes cry out!</span>")

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
	effect.layer = LYING_HUMAN_LAYER
	flick("summoning", effect)
	QDEL_IN(effect, 10)
	H.forceMove(ling)
	H.status_flags |= GODMODE
	ling.client.init_verbs()

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

	var/S = tgui_input_list(src, "Select the target DNA.", "Target DNA", names)
	if(!S)
		return

	var/datum/dna/chosen_dna = changeling.GetDNA(S)
	if(!chosen_dna)
		return

	var/mob/living/carbon/C = src

	changeling.use_charges(1)
	C.remove_changeling_powers()
	C.visible_message("<span class='warning'>[C] transforms!</span>")
	C.dna = chosen_dna.Clone()

	var/list/implants = list()
	for (var/obj/item/implant/I in C) //Still preserving implants
		implants += I

	C.transforming = TRUE
	C.canmove = FALSE
	C.icon = null
	C.cut_overlays()
	C.set_invisibility(101)
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
	O.set_stat(C.stat)
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
	set name = "Regenerative Stasis (20)"

	var/datum/changeling/changeling = changeling_power(20, 1, 100, UNCONSCIOUS)
	if(!changeling)
		return

	var/mob/living/carbon/C = src
	if(!C.stat && alert("Are we sure we wish to fake our death?", , "Yes", "No") == "No") //Confirmation for living changelings if they want to fake their death
		return
	to_chat(C, "<span class='notice'>We will attempt to regenerate our form.</span>")

	C.status_flags |= FAKEDEATH		//play dead
	C.update_canmove()
	C.remove_changeling_powers()
	if(ishuman(C))
		var/mob/living/carbon/human/H = C
		H.handle_hud_list(TRUE)

	C.emote("gasp")
	C.tod = worldtime2text()

	changeling.has_entered_stasis = TRUE

	addtimer(CALLBACK(src, PROC_REF(add_changeling_revive)), 100 SECONDS)

	remove_verb(src, /mob/proc/changeling_fakedeath)

	feedback_add_details("changeling_powers", "FD")
	return TRUE

/mob/proc/add_changeling_revive()
	if(stat == DEAD)
		to_chat(src, SPAN_HIGHDANGER("We died while regenerating! Our last resort is detaching our head now..."))
		return

	var/datum/changeling/changeling = changeling_power(20, 1, 100, UNCONSCIOUS)
	if(!changeling)
		return

	// charge the changeling chemical cost for stasis
	changeling.use_charges(20)
	to_chat(src, SPAN_NOTICE(FONT_GIANT("We are ready to rise. Use the <b>Revive</b> verb when we are ready.")))
	add_verb(src, /mob/proc/changeling_revive)

/mob/proc/changeling_revive()
	set category = "Changeling"
	set name = "Revive"

	var/mob/living/carbon/C = src
	// restore us to health
	C.revive(FALSE)
	// remove our fake death flag
	C.status_flags &= ~(FAKEDEATH)
	// let us move again
	C.update_canmove()
	// re-add out changeling powers
	C.make_changeling()
	// sending display messages
	to_chat(C, "<span class='notice'>We have regenerated fully.</span>")
	remove_verb(C, /mob/proc/changeling_revive)

/// Rip the changeling's head off as a last ditch effort to revive
/mob/proc/changeling_emergency_transform()
	set category = "Changeling"
	set name = "Emergency Transform (1)"

	var/datum/changeling/changeling = changeling_power(1, 0, 100, DEAD)
	if(!changeling)
		return

	var/mob/living/carbon/human/H = src
	if(!isturf(loc)) // so people can't transform inside places they should not, like sleepers
		return

	var/obj/item/organ/external/head = H.get_organ(BP_HEAD)
	if(!head)
		return

	var/datum/absorbed_dna/DNA = changeling.GetDNA(H.real_name)
	var/datum/dna/chosen_dna = DNA.dna
	if(!chosen_dna)
		return

	if(H.handcuffed)
		var/cuffs = H.handcuffed
		H.u_equip(H.handcuffed)
		qdel(cuffs)

	if(H.buckled_to)
		H.buckled_to.unbuckle()

	changeling.use_charges(1)
	changeling.geneticdamage = 70

	H.remove_changeling_powers()

	var/mob/living/simple_animal/hostile/lesser_changeling/revive/ling = new(get_turf(H))

	var/mob/living/carbon/human/O = new /mob/living/carbon/human(ling)
	O.make_changeling(H.mind)
	O.changeling_update_languages(changeling.absorbed_languages)
	O.accent = DNA.accent
	O.handle_changeling_transform(DNA)
	O.status_flags |= GODMODE

	if(H.mind)
		H.mind.transfer_to(ling)
	else
		ling.key = H.key

	ling.untransform_occupant = O
	ling.client.init_verbs()

	H.visible_message(SPAN_HIGHDANGER("[H]'s head decouples from their body in a shower of gore!"))
	head.droplimb(FALSE, DROPLIMB_BLUNT)

	feedback_add_details("changeling_powers", "EMT")

	return TRUE

//Recover from stuns.
/mob/proc/changeling_unstun()
	set category = "Changeling"
	set name = "Adrenaline Sacs (30)"
	set desc = "Removes all manner of stuns, as well as producing painkillers and stimulants."

	var/datum/changeling/changeling = changeling_power(30, 0, 100, UNCONSCIOUS)
	if(!changeling)
		return FALSE
	changeling.use_charges(30)

	var/mob/living/carbon/human/C = src
	C.set_stat(0)
	C.SetParalysis(0)
	C.SetStunned(0)
	C.SetWeakened(0)
	C.lying = FALSE
	C.reagents.add_reagent(/singleton/reagent/hyperzine, 9)
	C.reagents.add_reagent(/singleton/reagent/mortaphenyl, 6)
	C.reagents.add_reagent(/singleton/reagent/synaptizine, 3) // To counter mortaphenyl's side effects.
	C.update_canmove()

	remove_verb(src, /mob/proc/changeling_unstun)
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
		to_chat(C, "<span class='notice'>We return to normal.</span>")
	else
		to_chat(C, "<span class='notice'>We distort our form to prevent AI-tracking.</span>")
	C.digitalcamo = !C.digitalcamo

	spawn(0)
		while(C && C.digitalcamo && C.mind && changeling)
			changeling.use_charges(1)
			sleep(40)

	remove_verb(src, /mob/proc/changeling_digitalcamo)
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
	changeling.use_charges(30)

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

	remove_verb(src, /mob/proc/changeling_rapidregen)
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
		var/datum/absorbed_dna/current_dna = changeling.GetDNA(real_name)
		changeling.mimicing = ""
		changeling.mimiced_accent = current_dna.accent
		to_chat(src, "<span class='notice'>We return our vocal glands to their original form.</span>")
		return

	var/mimic_voice = sanitize(input(usr, "Enter a name to mimic.", "Mimic Voice", null), MAX_NAME_LEN)
	if(!mimic_voice)
		return

	var/chosen_accent = tgui_input_list(src, "Choose an accent to mimic.", "Accent Mimicry", SSrecords.accents)
	if(!chosen_accent)
		return

	changeling.mimicing = mimic_voice
	changeling.mimiced_accent = chosen_accent

	to_chat(src, "<span class='notice'>We shape our glands to take the voice of <b>[mimic_voice]</b>, using the <b>[chosen_accent]</b> accent. This will stop us from regenerating chemicals while active.</span>")
	to_chat(src, "<span class='notice'>Use this power again to return to our original voice and reproduce chemicals again.</span>")

	feedback_add_details("changeling_powers","MV")

	spawn(0)
		while(src?.mind && changeling?.mimicing)
			changeling.use_charges(1)
			sleep(40)
		if(changeling)
			changeling.mimicing = ""

/mob/proc/armblades()
	set category = "Changeling"
	set name = "Form Blades (20)"
	set desc = "Rupture the flesh and mend the bone of your hand into a deadly blade."

	var/datum/changeling/changeling = changeling_power(20, 0, 0)
	if(!changeling)
		return FALSE
	changeling.use_charges(20)

	var/mob/living/carbon/M = src

	if(M.l_hand && M.r_hand)
		to_chat(M, "<span class='danger'>Your hands are full.</span>")
		return

	if(M.handcuffed)
		var/cuffs = M.handcuffed
		M.u_equip(M.handcuffed)
		qdel(cuffs)

	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(istype(H.wear_suit, /obj/item/clothing/suit/straight_jacket))
			src.visible_message("<span class='danger'>[H] tears through the [H.wear_suit] with their grotesque arm blades!</span>",
								"<span class='danger'>We tear through the [H.wear_suit] with our arm blades!</span>",
								"<span class='danger'>You hear cloth ripping and tearing!</span>")
			QDEL_IN(H.wear_suit, 0)
			H.unEquip(H.wear_suit, force = TRUE)

	var/obj/item/melee/arm_blade/blade = new(M)
	blade.creator = M
	M.put_in_hands(blade)
	playsound(loc, 'sound/weapons/bloodyslice.ogg', 30, 1)
	src.visible_message("<span class='danger'>A grotesque blade forms around [M]\'s arm!</span>",
							"<span class='danger'>Our arm twists and mutates, transforming it into a deadly blade.</span>",
							"<span class='danger'>You hear organic matter ripping and tearing!</span>")

/mob/proc/changeling_shield()
	set category = "Changeling"
	set name = "Form Shield (20)"
	set desc = "Bend the flesh and bone of your hand into a grotesque shield."

	var/datum/changeling/changeling = changeling_power(20,0,0)
	if(!changeling)
		return FALSE
	changeling.use_charges(20)

	var/mob/living/carbon/M = src

	if(M.l_hand && M.r_hand)
		to_chat(M, "<span class='danger'>Your hands are full.</span>")
		return

	if(M.handcuffed)
		var/cuffs = M.handcuffed
		M.u_equip(M.handcuffed)
		qdel(cuffs)

	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(istype(H.wear_suit, /obj/item/clothing/suit/straight_jacket))
			src.visible_message("<span class='danger'>[H] tears through the [H.wear_suit] with their grotesque shield!</span>",
							"<span class='danger'>We tear through the [H.wear_suit] with our newly formed shield!</span>",
							"<span class='danger'>You hear cloth ripping and tearing!</span>")
			QDEL_IN(H.wear_suit, 0)
			H.unEquip(H.wear_suit, force = TRUE)

	var/obj/item/shield/riot/changeling/shield = new(M)
	shield.creator = M
	M.put_in_hands(shield)
	playsound(loc, 'sound/effects/blobattack.ogg', 30, 1)
	src.visible_message("<span class='danger'>The end of [M]\'s hand inflates rapidly, forming a huge shield-like mass!</span>",
							"<span class='warning'>We inflate our hand into a robust shield.</span>",
							"<span class='warning'>You hear organic matter ripping and tearing!</span>")

/mob/proc/horror_form()
	set category = "Changeling"
	set name = "Horror Form (50)"
	set desc = "Tear apart your human disguise, revealing your true form."

	var/datum/changeling/changeling = changeling_power(50,0,0)
	if(!changeling)
		return FALSE

	if(!isturf(loc)) // so people can't transform inside places they should not, like sleepers
		return

	var/mob/living/carbon/human/M = src

	if(alert("Are we sure we wish to reveal ourselves and assume our ultimate form? This is irreversible, and we will not be able to revert to our disguised form.", , "Yes", "No") == "No") //Changelings have to confirm whether they want to go full horrorform
		return

	changeling.use_charges(50)

	M.visible_message("<span class='danger'>[M] writhes and contorts, their body expanding to inhuman proportions!</span>", \
						"<span class='danger'>We begin our transformation to our true form!</span>")
	if(!do_after(src, 6 SECONDS, do_flags = DO_DEFAULT | DO_USER_UNIQUE_ACT))
		M.visible_message("<span class='danger'>[M]'s transformation abruptly reverts itself!</span>", \
							"<span class='danger'>Our transformation has been interrupted!</span>")
		return FALSE

	M.visible_message("<span class='danger'>[M] grows into an abomination and lets out an awful scream!</span>")
	playsound(loc, 'sound/effects/greaterling.ogg', 100, 1)

	var/mob/living/simple_animal/hostile/true_changeling/ling = new (get_turf(M))

	if(istype(M,/mob/living/carbon/human))
		if(M.handcuffed)
			var/cuffs = M.handcuffed
			M.u_equip(M.handcuffed)
			qdel(cuffs)

		for(var/obj/item/I in M.contents)
			if(isorgan(I))
				continue
			M.drop_from_inventory(I)

	if(M.buckled_to)
		M.buckled_to.unbuckle()

	if(M.mind)
		M.mind.transfer_to(ling)
	else
		ling.key = M.key
	var/atom/movable/overlay/effect = new /atom/movable/overlay(get_turf(M))
	effect.density = FALSE
	effect.anchored = TRUE
	effect.icon = 'icons/effects/effects.dmi'
	effect.layer = LYING_HUMAN_LAYER
	flick("summoning", effect)
	QDEL_IN(effect, 10)
	M.forceMove(ling) //move inside the new dude to hide him.
	ling.occupant = M
	M.status_flags |= GODMODE //dont want him to die or breathe or do ANYTHING
	ling.client.init_verbs()

// Chiropteran Screech
/mob/proc/resonant_shriek()
	set category = "Changeling"
	set name = "Resonant Shriek (30)"
	set desc = "Emit a powerful screech which shatters glass within a seven-tile radius, and disorients hearers."

	var/datum/changeling/changeling = changeling_power(30,0,0)
	if(!changeling)
		return FALSE

	visible_message(SPAN_DANGER("<font size=4>[src] lets out an ear piercing shriek!</font>"), SPAN_DANGER("<font size=4>You let out an ear-shattering shriek!</font>"), SPAN_DANGER("You hear a painfully loud shriek!"))
	changeling.use_charges(30)

	var/list/victims = list()
	for(var/mob/living/carbon/human/T in hearers(7, src) - src)
		if(T.get_hearing_protection() >= EAR_PROTECTION_MAJOR)
			continue
		if(T.changeling_power())
			continue
		to_chat(T, SPAN_DANGER("<font size=4><b>You hear an ear piercing shriek and feel your senses go dull!</b></font>"))
		if (T.get_hearing_sensitivity())
			if (T.is_listening())
				shake_camera(T, 6 SECONDS, 10)
				T.Weaken(10)
				T.Stun(10)
				T.earpain(4)
			else
				shake_camera(T, 5 SECONDS, 10)
				T.Stun(3)
				T.earpain(3)
		else
			shake_camera(T, 4 SECONDS, 10)

		T.stuttering = 20
		T.confused = 5
		T.adjustEarDamage(10, 20, TRUE)

		victims += T

	for(var/obj/structure/window/W in view(7))
		W.shatter()

	for(var/obj/machinery/door/window/WD in view(7))
		if(get_dist(src, WD) > 5) //Windoors are strong, may only take damage instead of break if far away.
			WD.take_damage(rand(12, 16) * 10)
		else
			WD.shatter()

	for(var/obj/machinery/light/L in view(7))
		L.broken()
		CHECK_TICK

	playsound(src.loc, 'sound/effects/creepyshriek.ogg', 100, 1)

	if(length(victims))
		admin_attacker_log_many_victims(src, victims, "used resonant shriek to stun", "was stunned by [key_name(src)] using resonant shriek", "used resonant shriek to stun")
	else
		log_and_message_admins("used resonant shriek.")

	remove_verb(src, /mob/proc/resonant_shriek)
	ADD_VERB_IN(src, 3600, /mob/proc/resonant_shriek)

/mob/proc/dissonant_shriek()
	set category = "Changeling"
	set name = "Dissonant Shriek (30)"
	set desc = "Emit a moderate sized EMP."

	var/datum/changeling/changeling = changeling_power(30,0,0)
	if(!changeling)
		return FALSE

	visible_message(SPAN_DANGER("<font size=4>[src] opens their mouth and a horrid, high-pitched noise comes out!</font>"))
	log_and_message_admins("used dissonant shriek.")
	empulse(get_turf(src), 2, 3)
	remove_verb(src, /mob/proc/dissonant_shriek)
	ADD_VERB_IN(src, 3600, /mob/proc/dissonant_shriek)

/mob/proc/changeling_thermals()
	set category = "Changeling"
	set name = "Enable Heat Receptors (5)"
	set desc = "Toggles our thermal vision."

	var/datum/changeling/changeling = changeling_power(5,0,0)
	if(!changeling)
		return FALSE

	var/mob/living/carbon/human/H = src
	if(!ishuman(H))
		return

	changeling.use_charges(5)

	if(H.sight & SEE_MOBS)
		H.sight &= ~SEE_MOBS
		changeling.using_thermals = FALSE
		H.stop_sight_update = FALSE
		to_chat(H, SPAN_NOTICE("We have turned off our heat receptors. We are now more vulnerable to sudden lights."))
	else
		H.sight |= SEE_MOBS
		changeling.using_thermals = TRUE
		H.stop_sight_update = TRUE
		to_chat(H, SPAN_NOTICE("We have turned on our heat receptors."))

/mob/living/carbon/human/get_flash_protection(ignore_inherent = FALSE)
	var/datum/changeling/changeling = changeling_power(0, 0, 0)
	if(changeling && changeling.using_thermals)
		return FLASH_PROTECTION_REDUCED
	else
		. = ..()

/mob/proc/changeling_electric_lockpick()
	set category = "Changeling"
	set name = "Electric Lockpick (5 + 10/use)"
	set desc = "Bruteforces open most electrical locking systems, at 10 chemicals per use."

	var/datum/changeling/changeling = changeling_power(5,0,100,CONSCIOUS)

	var/mob/living/carbon/human/H = src

	if(!changeling || !ishuman(H))
		return FALSE

	var/obj/held_item = H.get_active_hand()
	if(!held_item)
		var/obj/item/finger_lockpick/FL = new(H)
		H.put_in_hands(FL)
		to_chat(H, SPAN_NOTICE("We have recreated our finger to act like an electric lockpick."))
		changeling.use_charges(5)


