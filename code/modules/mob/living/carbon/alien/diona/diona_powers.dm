//Verbs after this point.


//Merge:
//Joins yourself into an existing gestalt, becoming just a small part of it
//The nymph player moves inside the gestalt and no longer has control of movement or actions
/mob/living/carbon/alien/diona/proc/merge()

	set category = "Abilities"
	set name = "Merge with gestalt"
	set desc = "Merge yourself into a larger gestalt, you will no longer retain control."

	if(stat == DEAD || paralysis || weakened || stunned || restrained())
		return



	var/list/choices = list()
	for(var/mob/living/carbon/C in view(1,src))

		if(!(src.Adjacent(C)) || !(C.client)) continue

		if(istype(C,/mob/living/carbon/human))
			var/mob/living/carbon/human/H = C
			if(H.species && H.species.name == "Diona" && H.client)
				choices += H

	var/mob/living/M = input(src,"Who do you wish to merge with?") in null|choices

	if(!M)
		src << span("warning", "There are no active gestalts nearby to merge with.")
	else if(!do_merge(M))
		src << span("warning", "You fail to merge with \the [M]...")


/mob/living/carbon/alien/diona/proc/do_merge(var/mob/living/carbon/human/H)
	if(!istype(H) || !src || !(src.Adjacent(H)))
		return 0

	src << span("warning", "Requesting consent from [H]")
	var/r = alert(H,"[src] wishes to join your collective, and become a part of your gestalt. If you accept they will become an equal part of you, though you will remain in control?", "[src] wishes to join you", "Welcome!", "No, leave us..")
	if (r != "Welcome!")
		src << span("warning", "[H.name] has rejected your wish to merge!")
		return	0

	H.visible_message(span("warning", "[H] starts absorbing [src] into its body"), span("warning", "You start absorbing [src]. This will take 15 seconds and both of you must remain still"), span("warning", "You hear a strange, alien. sucking sound"))
	src << "<span class='notice'>You feel yourself slowly becoming part of something greater, remain still to finish.</span>"
	face_atom(H)
	H.face_atom(get_turf(src))
	if(do_mob(src, H, 150, needhand = 0))
		if (!(src.Adjacent(H)) || !(istype(src.loc, /turf)))//The loc check prevents us from absorbing the same nymph multiple times at once
			src << span("warning", "Something went wrong while trying to merge into [H], cancelling.")
			return 0

		gestalt = H
		sync_languages(gestalt)
		update_verbs()
		sleep(2)//Altering the verbs list takes some time and it wont complete after the nymph is moved in. This sleep is necessary
		H << "<span class='notice'>You feel your being twine with that of \the [src] as it merges with your biomass.</span>"
		H.status_flags |= PASSEMOTES
		src << "<span class='notice'>You feel your being twine with that of \the [H] as you merge with its biomass.</span>"
		for(var/obj/O in src.contents)
			drop_from_inventory(O)
		loc = H
	else
		src << span("warning", "Something went wrong while trying to merge into [H], cancelling.")
		return 0


	return 1



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
	for(var/mob/living/carbon/alien/diona/C in view(1,src))

		if((!(src.Adjacent(C)) || C.gestalt || C == src)) continue//cant steal nymphs right out of other gestalts
		choices.Add(C)

	var/mob/living/carbon/alien/diona/M = input(src,"Which nymph do you wish to absorb?") in null|choices

	if(!M)
		src << span("warning", "There is nothing nearby to absorb")
	else if(!do_absorb(M))
		src << span("warning", "You fail to merge with \the [M]...")



/mob/living/carbon/proc/do_absorb(var/mob/living/carbon/alien/diona/D)
	if (D.key)
		//Code for requesting permission goes here. We will return if its denied or ignored
		src << span("warning", "Requesting consent from [D]")
		var/r = alert(D,"[src] wishes to absorb your being, and make you a part of their gestalt. If you accept you will join with them, and give up control to be a part of their collective. \nYou will be part of their larger gestalt if they grow later, too, and all of your stored biomass will be transferred to them. You can split away at anytime, but you cannot reclaim the biomass. Do you wish to be absorbed?", "[src] wishes to absorb you", "Yes, we will join!", "No, i wish to remain alone")
		if (r != "Yes, we will join!")
			src << span("warning", "[D] has refused to join you!")
			return
		else
			if (!(src.Adjacent(D)) || !(istype(D.loc, /turf)))
				src << span("warning", "Something went wrong while trying to absorb [D], cancelling.")
				return

	src.visible_message(span("warning", "[src] starts absorbing [D] into its body"), span("warning", "You start absorbing [D]. This will take 15 seconds and both of you must remain still"), span("warning", "You hear a strange, alien. sucking sound"))
	D << "<span class='notice'>You feel yourself slowly becoming part of something greater, remain still to finish.</span>"
	face_atom(D)
	D.face_atom(get_turf(src))
	if(do_mob(src, D, 150, needhand = 0))
		if (!(src.Adjacent(D)) || !(istype(D.loc, /turf)))//The loc check prevents us from absorbing the same nymph multiple times at once
			src << span("warning", "Something went wrong while trying to absorb [D], cancelling.")
			return

		if (D.stat == DEAD)
			src.nutrition += NYMPH_ABSORB_NUTRITION * NYMPH_ABSORB_DEAD_FACTOR //Consuming dead nymphs gives far less nutrition
			qdel(D)
			return 1
		else

			D.gestalt = src
			D.sync_languages(D.gestalt)
			D.update_verbs()
			sleep(2)
			if (is_diona() == DIONA_NYMPH)//We only care about biomass if we're a nymph
				src.nutrition += NYMPH_ABSORB_NUTRITION
				src.nutrition += D.nutrition //Any biomass in the absorbed nymph is transferred to the host
				D.nutrition = 0

			D << "<span class='notice'>You feel your being twine with that of \the [src] as you merge with its biomass.</span>"
			src << "<span class='notice'>You feel your being twine with that of \the [D] as it merges with your biomass.</span>"
			for(var/obj/O in D.contents)
				D.drop_from_inventory(O)
			D.forceMove(src)

			D.stat = CONSCIOUS
			status_flags |= PASSEMOTES
			return 1

	else
		return 0





//Split allows a nymph to peel away from a gestalt and be a lone agent
/mob/living/carbon/alien/diona/proc/split()
	set category = "Abilities"
	set name = "Break from gestalt"
	set desc = "Split away from your gestalt as a lone nymph."

	if(stat == DEAD || paralysis || weakened || stunned || restrained())
		return

	if(!(istype(src.loc,/mob/living/carbon)))
		src.verbs -= /mob/living/carbon/alien/diona/proc/split
		return

	var/r = alert(src,"Splitting will remove you from your gestalt and deposit you on the ground, allowing you to go it alone. If you had any stored biomass before you joined the gestalt, you will not get it back. Are you sure you wish to split?", "Confirm Split", "Time to leaf", "I'll stick around")
	if (r != "Time to leaf")
		return


	src.loc << span("warning", "You feel a pang of loss as [src] splits away from your biomass.")
	src << "<span class='notice'>You wiggle out of the depths of [src.loc]'s biomass and plop to the ground.</span>"

	if (gestalt.is_diona() == DIONA_NYMPH)
		gestalt.nutrition -= NYMPH_ABSORB_NUTRITION//Preventing an exploit with repeatedly absorbing and splitting

	split_languages(gestalt)
	src.forceMove(get_turf(src))
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
	for(var/mob/living/L in view(1,src))

		if((!(src.Adjacent(L)) || L == src)) continue
		choices.Add(L)

	if (!choices.len)
		src << span("warning", "There are no life forms nearby to sample!")
		return

	if (choices.len == 1)
		choices.Add("Cancel")

	var/mob/living/donor = input(src,"Who do you wish to drain?") in null|choices

	if (!donor || donor == "Cancel")//they cancelled
		return

	face_atom(donor)
	var/types = donor.find_type()

	if (types & TYPE_SYNTHETIC)
		src.visible_message("<span class='danger'>[src] attempts to bite into [donor.name] but leaps back in surprise as its fangs hit metal.</span>", "<span class='danger'>You attempt to sink your fangs into [donor.name] and get a faceful of unyielding steel as the force breaks several fine protrusions in your mouth.</span>")
		donor.adjustBruteLoss(2)
		src.adjustBruteLoss(15)//biting metal hurts!
		return

	else if (isanimal(donor) && (types & TYPE_ORGANIC) && donor.stat != DEAD)
		src.visible_message("<span class='danger'>[src] bites into [donor.name] and drains some of their blood</span>", "<span class='danger'>You bite into [donor.name] and drain some blood.</span>")
		src << "<span class='danger'>This simple creature has insufficient intelligence for you to learn anything!</span>"
		donor.adjustBruteLoss(4)
		nutrition += 20
		return
	else if (types & TYPE_WEIRD)
		src.visible_message("<span class='danger'>[src] attempts to bite into [donor.name] but passes right through it!.</span>", "<span class='danger'>You attempt to sink your fangs into [donor.name] but pass right through it!</span>")
		return
	else if (donor.is_diona())
		src << span("warning", "You can't sample the DNA of other diona!")
		return
	else if (istype(donor, /mob/living/carbon))
		//If we get here, it's -probably- valid

		src.visible_message("<span class='danger'>[src] is trying to bite [donor.name]</span>", span("danger", "You start biting [donor.name], you both must stay still!"))
		face_atom(get_turf(donor))
		if (do_mob(src, donor, 40, needhand = 0))

			//Attempt to find the blood vessel, but don't create a fake one if its not there.
			//If the target doesn't have a vessel its probably due to someone not implementing it properly, like xenos
			//We'll still allow it
			var/datum/reagents/vessel = donor.get_vessel(1)
			var/newDNA
			var/datum/reagent/blood/B = vessel.get_master_reagent()
			var/total_blood = B.volume
			var/remove_amount = (total_blood - 280) * 0.3
			if (remove_amount > 0)
				vessel.remove_reagent("blood", remove_amount, 1)//85 units of blood is enough to affect a human and make them woozy
				nutrition += remove_amount*0.5
			var/list/data = vessel.get_data("blood")
			newDNA = data["blood_DNA"]

			if (!newDNA)//Fallback. Adminspawned mobs, and possibly some others, have null dna.
				newDNA = md5("\ref[donor]")

			donor.adjustBruteLoss(4)
			src.visible_message("<span class='notice'>[src] sucks some blood from [donor.name]</span>", "<span class='notice'>You extract a delicious mouthful of blood from [donor.name]!</span>")




			if (newDNA in sampled_DNA)
				src << "<span class='danger'>You have already sampled the DNA of this creature before, you can learn nothing new. Move onto something else.</span>"
				return

			else
				sampled_DNA.Add(newDNA)

				var/learned = 0
				//Learned var:
				//0 = The target has no languages
				//1 = We already everything they know or can't learn
				//2 = We learned something!

				//Now we sample their languages!
				for (var/datum/language/L in donor.languages)
					learned = max(learned, 1)
					if (!(L in languages) && !(L in diona_banned_languages))
						//We don't know this language, and we can learn it!
						var/current_progress = language_progress[L.name]
						current_progress += 1
						language_progress[L.name] = current_progress
						src << "<span class='notice'><font size=3>You come a little closer to learning [L.name]!</font></span>"
						learned = 2

				if (!learned)
					src << "<span class='danger'>This creature doesn't know any languages at all!</span>"
				else if (learned == 1)
					src << "<span class='danger'>We have nothing more to learn from this creature. Perhaps try a different species?</span>"

				update_languages()
		else
			src << span("warning", "Something went wrong while trying to sample [donor], both you and the target must remain still.")

//Checks progress on learned languages
/mob/living/carbon/alien/diona/proc/update_languages()
	for (var/i in language_progress)
		if (language_progress[i] >= LANGUAGE_POINTS_TO_LEARN)
			add_language(i)
			src << "<span class='notice'><font size=3>You have mastered the [i] language!</font></span>"
			language_progress.Remove(i)

/mob/living/carbon/alien/diona/proc/transferMind(var/atom/A)
	set category = "Abilities"
	set name = "Switch Nymph"
	set desc = "Transfer your control manually to another nymph in sight."

	for(var/mob/living/carbon/alien/diona/D in view(7))
		if(D.master_nymph == src && mind && !client) //if the nymph is subservient to you
			mind.transfer_to(D)
			D.stunned = 0//Switching mind seems to temporarily stun mobs
			for(var/mob/living/carbon/alien/diona/DIO in src.birds_of_feather) //its me!
				DIO.master_nymph = D
			break
		return 1
	..()
