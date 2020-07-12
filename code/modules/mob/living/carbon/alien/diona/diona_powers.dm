//Merge:
//Joins yourself into an existing gestalt, becoming just a small part of it
//The nymph player moves inside the gestalt and no longer has control of movement or actions
/mob/living/carbon/alien/diona/proc/merge()
	set category = "Abilities"
	set name = "Merge with gestalt"
	set desc = "Merge yourself into a larger gestalt, you will no longer retain control."

	if(use_check_and_message(usr))
		return FALSE

	var/list/choices = list()
	for(var/mob/living/carbon/human/H in view(1, src))
		if(!Adjacent(H) || !H.client)
			continue
		if(is_diona(H) == DIONA_WORKER)
			choices += H

	var/mob/living/M = input(src, "Who do you wish to merge with?") in null|choices

	if(!M)
		to_chat(src, SPAN_WARNING("There are no active gestalts nearby to merge with."))
	else if(!do_merge(M))
		to_chat(src, SPAN_WARNING("You fail to merge with \the [M]..."))


/mob/living/carbon/alien/diona/proc/do_merge(var/mob/living/carbon/human/H)
	if(!istype(H) || !Adjacent(H))
		return FALSE

	to_chat(src, SPAN_WARNING("Requesting consent from [H]"))
	var/r = alert(H, "[src] wishes to join your collective, and become a part of your gestalt. If you accept they will become an equal part of you, though you will remain in control.", "[src] wishes to join you", "Welcome!", "No, leave us..")
	if(r != "Welcome!")
		to_chat(src, SPAN_WARNING("[H.name] has rejected your wish to merge!"))
		return FALSE

	H.visible_message(SPAN_WARNING("[H] starts absorbing [src] into its body."), SPAN_WARNING("You start absorbing [src]. This will take 15 seconds and both of you must remain still."), SPAN_WARNING("You hear a strange, alien, sucking noise."))
	to_chat(src, SPAN_NOTICE("You feel yourself slowly becoming part of something greater, remain still to finish."))
	face_atom(H)
	H.face_atom(get_turf(src))
	if(do_mob(src, H, 150, needhand = FALSE))
		if(!Adjacent(H) || !isturf(loc)) //The loc check prevents us from absorbing the same nymph multiple times at once
			to_chat(src, SPAN_WARNING("Something went wrong while trying to merge into [H], cancelling."))
			return FALSE

		gestalt = H
		sync_languages(gestalt)
		update_verbs()
		sleep(2) //Altering the verbs list takes some time and it wont complete after the nymph is moved in. This sleep is necessary
		to_chat(H, SPAN_NOTICE("You feel your being twine with that of \the [src] as it merges with your biomass."))
		H.status_flags |= PASSEMOTES
		to_chat(src, SPAN_NOTICE("You feel your being twine with that of \the [H] as you merge with its biomass."))
		for(var/obj/O in src.contents)
			drop_from_inventory(O)
		src.forceMove(H)
	else
		to_chat(src, SPAN_WARNING("Something went wrong while trying to merge into [H], cancelling."))
		return FALSE
	return TRUE



//This verb allows a diona to absorb nymphs - both gestalts and nymphs can use this
//If the target nymph is dead, they are simply recycled as biomass, adding some nutrition
//If the target is alive, they go inside the user, granting a larger amount of biomass and continuing to exist within them
	//If the target is controlled by a player, they will be asked permission first.
	//Absorbing them forcibly is not possible while alive, but they can be killed and recycled if the nymph is ruthless
	//The absorbing player will act as the host, and will remain in control, as well as controlling the eventual gestalt
/mob/living/carbon/proc/absorb_nymph()
	set category = "Abilities"
	set name = "Absorb Nymph"
	set desc = "Absorb a diona nymph into yourself, you will remain in control and gain any biomass it has absorbed."

	var/list/choices = list()
	for(var/mob/living/carbon/alien/diona/C in view(1, src))
		if(!Adjacent(C) || C.gestalt || C == src) //cant steal nymphs right out of other gestalts
			continue
		choices += C

	var/mob/living/carbon/alien/diona/M = input(src, "Which nymph do you wish to absorb?") in null|choices

	if(!M)
		to_chat(src, SPAN_WARNING("There are no nymphs in your vicinity."))
	else if(!do_absorb(M))
		to_chat(src, SPAN_WARNING("You fail to merge with \the [M]..."))



/mob/living/carbon/proc/do_absorb(var/mob/living/carbon/alien/diona/D)
	if(D.key)
		//Code for requesting permission goes here. We will return if its denied or ignored
		to_chat(src, SPAN_WARNING("Requesting consent from [D]."))
		var/r = alert(D,"[src] wishes to absorb your being, and make you a part of their gestalt. If you accept you will join with them, and give up control to be a part of their collective. \nYou will be part of their larger gestalt if they grow later, too, and all of your stored biomass will be transferred to them. You can split away at anytime, but you cannot reclaim the biomass. Do you wish to be absorbed?", "[src] wishes to absorb you", "Yes, I will join!", "No, I wish to remain alone!")
		if(r != "Yes, I will join!")
			to_chat(src, SPAN_WARNING("[D] has refused to join you!"))
			return
		else if(!Adjacent(D) || !isturf(D.loc))
			to_chat(src, SPAN_WARNING("\The [D] must remain close to the collective if \he wishes to be part of us."))
			return

	src.visible_message(SPAN_WARNING("[src] starts absorbing [D] into its body."), SPAN_WARNING("You start absorbing [D]. This will take 15 seconds and both of you must remain still."), SPAN_WARNING("You hear a strange, alien, sucking noise."))
	to_chat(D, SPAN_NOTICE("You feel yourself slowly becoming part of something greater, remain still to finish."))
	face_atom(D)
	D.face_atom(get_turf(src))
	if(do_mob(src, D, 150, needhand = FALSE))
		if(!Adjacent(D) || !isturf(D.loc)) //The loc check prevents us from absorbing the same nymph multiple times at once
			to_chat(src, SPAN_WARNING("\The [D] must remain close to the collective if \he wishes to be part of us."))
			return

		if(D.stat == DEAD)
			src.adjustNutritionLoss(-NYMPH_ABSORB_NUTRITION * NYMPH_ABSORB_DEAD_FACTOR)
			qdel(D)
			return TRUE
		else
			D.gestalt = src
			D.sync_languages(D.gestalt)
			D.update_verbs()
			sleep(2)
			if(is_diona() == DIONA_NYMPH) //We only care about biomass if we're a nymph
				src.adjustNutritionLoss(-NYMPH_ABSORB_NUTRITION)
				src.adjustNutritionLoss(-D.nutrition)
				D.nutrition = FALSE
			to_chat(D, SPAN_NOTICE("You feel your being entwine with that of \the [src] as you merge with its biomass."))
			to_chat(src, SPAN_NOTICE("You feel your being entwine with that of \the [D] as it merges with your biomass."))
			for(var/obj/O in D.contents)
				D.drop_from_inventory(O)
			D.forceMove(src)
			D.stat = CONSCIOUS
			status_flags |= PASSEMOTES
			return TRUE
	else
		return FALSE

//Split allows a nymph to peel away from a gestalt and be a lone agent
/mob/living/carbon/alien/diona/proc/split()
	set category = "Abilities"
	set name = "Break from gestalt"
	set desc = "Split away from your gestalt as a lone nymph."

	if(use_check_and_message(usr))
		return FALSE

	if(echo)
		to_chat(src, SPAN_NOTICE("Your host is still storing you as a nymphatic husk and preventing your departure."))
		return

	if(!iscarbon(loc))
		verbs -= /mob/living/carbon/alien/diona/proc/split
		return

	var/r = alert(src, "Splitting will remove you from your gestalt and deposit you on the ground, allowing you continue alone. If you had any stored biomass before you joined the gestalt, you will not get it back. Are you sure you wish to split?", "Confirm Split", "I am ready to leave.", "I'll stick around.")
	if(r != "I am ready to leave.")
		return

	to_chat(gestalt, SPAN_WARNING("You feel a pang of loss as [src] splits away from your biomass."))
	to_chat(src, SPAN_NOTICE("You wiggle out of the depths of [gestalt]'s biomass and plop to the ground."))

	if(gestalt.is_diona() == DIONA_NYMPH)
		gestalt.adjustNutritionLoss(NYMPH_ABSORB_NUTRITION)

	split_languages(gestalt)
	forceMove(get_turf(src))
	stat = CONSCIOUS
	gestalt = null
	update_verbs()

//Draws a sizeable blood sample from a victim to read their DNA and learn languages
/mob/living/carbon/alien/diona/proc/sample()
	set category = "Abilities"
	set name = "Sample DNA"
	set desc = "Learn languages by draining some blood from a nearby lifeform. You will partially learn any language it knows."

	//For fun factor, we'll allow the nymph to choose nonvalid targets
	var/list/choices = list()
	for(var/mob/living/L in view(1, src))
		if(L == src)
			continue
		if(!Adjacent(L))
			continue
		if(L.is_diona())
			continue
		choices += L

	if(!length(choices))
		to_chat(src, SPAN_WARNING("There are no life forms nearby to sample!"))
		return
	else
		choices += "Cancel"

	var/mob/living/donor = input(src, "Who do you wish to sample?") in null|choices

	if(!donor || donor == "Cancel") //they cancelled
		return

	face_atom(donor)
	var/types = donor.find_type()

	if(types & TYPE_SYNTHETIC)
		src.visible_message(SPAN_DANGER("[src] attempts to bite into [donor.name] but leaps back in surprise as its fangs hit metal."), SPAN_DANGER("You attempt to sink your fangs into [donor.name] and get a faceful of unyielding steel as the force breaks several fine protrusions in your mouth."))
		donor.adjustBruteLoss(2)
		src.adjustBruteLoss(15) //biting metal hurts!
		return

	else if (isanimal(donor) && (types & TYPE_ORGANIC) && donor.stat != DEAD)
		src.visible_message(SPAN_DANGER("[src] bites into [donor.name] and drains some of their blood."), SPAN_DANGER("You bite into [donor.name] and drain some of their blood."))
		to_chat(src, SPAN_DANGER("This simple creature has insufficient intelligence for you to learn anything!"))
		donor.adjustBruteLoss(4)
		adjustNutritionLoss(-20)
		return
	else if (types & TYPE_WEIRD)
		src.visible_message(SPAN_DANGER("[src] attempts to bite into [donor.name] but passes right through it!."), SPAN_DANGER("You attempt to sink your fangs into [donor.name] but pass right through it!"))
		return
	else if (iscarbon(donor))
		var/mob/living/carbon/D = donor
		//If we get here, it's -probably- valid

		src.visible_message(SPAN_DANGER("[src] is trying to bite [D.name]."), SPAN_DANGER("You start biting [D.name], you both must stay still!"))
		face_atom(get_turf(D))
		if(do_mob(src, D, 40, needhand = FALSE))
			//Attempt to find the blood vessel, but don't create a fake one if its not there.
			//If the target doesn't have a vessel its probably due to someone not implementing it properly, like xenos
			//We'll still allow it
			var/datum/reagents/vessel = D.get_vessel(1)
			var/newDNA
			var/datum/reagent/blood/B = vessel.get_master_reagent()
			var/total_blood = B.volume
			var/remove_amount = total_blood * 0.05
			if(ishuman(D))
				var/mob/living/carbon/human/H = D
				remove_amount = H.species.blood_volume * 0.05
			if(remove_amount > 0)
				vessel.remove_reagent(/datum/reagent/blood, remove_amount, TRUE)
				adjustNutritionLoss(-remove_amount * 0.5)
			var/list/data = vessel.get_data(/datum/reagent/blood)
			newDNA = data["blood_DNA"]

			if(!newDNA) //Fallback. Adminspawned mobs, and possibly some others, have null dna.
				newDNA = md5("\ref[D]")

			D.adjustBruteLoss(4)
			src.visible_message(SPAN_NOTICE("[src] sucks some blood from [D.name].") , SPAN_NOTICE("You extract a delicious mouthful of blood from [D.name]!"))

			if(newDNA in sampled_DNA)
				to_chat(src, SPAN_DANGER("You have already sampled the DNA of this creature before, you can learn nothing new. Move onto something else."))
				return
			else
				sampled_DNA.Add(newDNA)

				var/learned = 0
				//Learned var:
				//0 = The target has no languages
				//1 = We already everything they know or can't learn
				//2 = We learned something!

				//Now we sample their languages!
				for(var/datum/language/L in D.languages)
					learned = max(learned, 1)
					if (!(L in languages) && !(L in diona_banned_languages))
						//We don't know this language, and we can learn it!
						var/current_progress = language_progress[L.name]
						current_progress += 1
						language_progress[L.name] = current_progress
						to_chat(src, SPAN_NOTICE("<font size=3>You come a little closer to learning [L.name]!</font>"))
						learned = 2

				if(!learned)
					to_chat(src, SPAN_DANGER("This creature doesn't know any languages at all!"))
				else if (learned == 1)
					to_chat(src, SPAN_DANGER("We have nothing more to learn from this creature. Perhaps try a different sample?"))

				update_languages()
		else
			to_chat(src, SPAN_WARNING("Something went wrong while trying to sample [D], both you and the target must remain still."))

//Checks progress on learned languages
/mob/living/carbon/alien/diona/proc/update_languages()
	for(var/i in language_progress)
		if(language_progress[i] >= LANGUAGE_POINTS_TO_LEARN)
			add_language(i)
			to_chat(src, SPAN_NOTICE("<font size=3>You have mastered the [i] language!</font>"))
			language_progress.Remove(i)

/mob/living/carbon/alien/diona/proc/transferMind(var/atom/A)
	set category = "Abilities"
	set name = "Switch Nymph"
	set desc = "Transfer your control manually to another nymph in sight."

	for(var/mob/living/carbon/alien/diona/D in view(7))
		if(D.master_nymph == src && mind && !client) //if the nymph is subservient to you
			mind.transfer_to(D)
			D.stunned = 0 //Switching mind seems to temporarily stun mobs
			for(var/mob/living/carbon/alien/diona/DIO in src.birds_of_feather) //its me!
				DIO.master_nymph = D
			break
		return TRUE

/mob/living/carbon/proc/echo_eject()
	set category = "Abilities"
	set name = "Eject Echo"
	set desc = "Eject any nymphatic husks."

	if(use_check_and_message(usr))
		return FALSE

	var/energy = FALSE
	var/r = alert(src, "Do you choose to eject echoes as nymphs or energy?", "Identify Waste", "Energy", "Nymphs")
	if(r == "Energy")
		energy = TRUE

	for(var/mob/living/carbon/alien/diona/D in src)
		if(D.mind && D.echo)
			if(energy)
				var/mob/living/simple_animal/shade/bluespace/BS = new /mob/living/simple_animal/shade/bluespace(get_turf(D))
				to_chat(D, SPAN_DANGER("You feel your nymphatic husk split as you are released again as pure energy!"))
				D.mind.transfer_to(BS)
				to_chat(BS, "<b>You are now a bluespace echo - consciousness imprinted upon wavelengths of bluespace energy. You currently retain no memories of your previous life, but do express a strong desire to return to corporeality. You will die soon, fading away forever. Good luck!</b>")
				qdel(D)
			else
				to_chat(src, SPAN_WARNING("You feel a pang of loss as [src] splits away from your biomass."))
				to_chat(D, SPAN_NOTICE("You wiggle out of the depths of [src.loc]'s biomass and plop to the ground."))

				if(D.gestalt.is_diona() == DIONA_NYMPH)
					D.gestalt.adjustNutritionLoss(NYMPH_ABSORB_NUTRITION)

				D.split_languages(D.gestalt)
				D.forceMove(get_turf(src))
				D.gestalt = null
				D.update_verbs()

	verbs.Remove(/mob/living/carbon/proc/echo_eject)

/mob/living/carbon/human/proc/consume_nutrition_from_air()
	set category = "Abilities"
	set name = "Toggle Consuming Air For Nutrition"
	set desc = "Consumes air, restoring part of the nutrition."

	if(stat == DEAD)
		return
	
	if(!consume_nutrition_from_air && (nutrition / max_nutrition > 0.25))
		to_chat(src, SPAN_WARNING("You still have plenty of nutrition left. Consuming air is the last resort."))
		return
	
	consume_nutrition_from_air = !consume_nutrition_from_air
	to_chat(src, SPAN_NOTICE("You [consume_nutrition_from_air ? "started" : "stopped"] consuming air for nutrition."))

/mob/living/carbon/human/proc/create_structure()
	set category = "Abilities"
	set name = "Create Structure"
	set desc = "Expend nymphs or biomass to create structures."

	if(!is_diona(src))
		to_chat(src, SPAN_DANGER("You are not a Diona! You should not have this ability."))
		log_debug("Non-Diona [name] had Create Structure ability.")
		return

	if(use_check_and_message(src))
		return

	var/can_use_biomass
	if(nutrition >= max_nutrition * 0.25)
		can_use_biomass = TRUE

	var/can_use_limbs = TRUE
	var/list/viable_limbs = list(BP_L_ARM, BP_R_ARM)
	for(var/limb in viable_limbs)
		var/obj/item/organ/external/O = organs_by_name[limb]
		if(!O)
			can_use_limbs = FALSE
			break

	var/build_method // What are we using to build this thing?
	if(can_use_biomass)
		to_chat(src, SPAN_NOTICE("We will expend biomass to create this structure."))
		build_method = "biomass"
	else if(can_use_limbs)
		to_chat(src, SPAN_NOTICE("We will detach our arm nymphs and have them form the structure."))
		build_method = "nymphs"
	else
		to_chat(src, SPAN_NOTICE("We do not have the nymphs nor the biomass to do this!"))
		return
	
	var/list/diona_structures = list(
			"Wall" = /turf/simulated/wall/diona,
			"Floor" = /turf/simulated/floor/diona,
			"Glow Bulb" = /obj/structure/diona/bulb/unpowered,
			"Cancel" = null
			)

	var/chosen_structure
	chosen_structure = input("Choose a structure to grow.") in diona_structures
	if(!chosen_structure || chosen_structure == "Cancel")
		to_chat(src, SPAN_WARNING("We have elected to not grow anything right now."))
		return

	if(use_check_and_message(src))
		return
	
	if(chosen_structure)
		to_chat(src, SPAN_NOTICE("We are now creating a [lowertext(chosen_structure)] using our [build_method]..."))

	if(do_after(src, 50))
		if(build_method == "biomass") // checking again, a lot can change in a short amount of time - geeves
			if(nutrition >= max_nutrition * 0.25)
				nutrition -= max_nutrition * 0.25
			else
				to_chat(src, SPAN_WARNING("We do not have enough biomass!"))
				return
		else if(build_method == "nymphs")
			for(var/limb in viable_limbs)
				var/obj/item/organ/external/O = organs_by_name[limb]
				if(!O)
					to_chat(src, SPAN_WARNING("We lost our arm while constructing!"))
					return
				O.droplimb(TRUE, DROPLIMB_EDGE)
				qdel(O)
		var/structure_path = diona_structures[chosen_structure]
		var/turf/T = get_turf(src)
		if(ispath(structure_path, /turf))
			T.ChangeTurf(structure_path)
		else
			new structure_path(T)
			
/mob/living/carbon/alien/diona/proc/remove_hat()
	set category = "Abilities"
	set name = "Remove Hat"
	set desc = " Remove your hat."
	
	if(hat)
		src.drop_from_inventory(hat)
		hat = null
		visible_message("<span class='warning'>[src] removes their hat!</span>")
	else
		to_chat(src, SPAN_WARNING("You have no hat!"))
