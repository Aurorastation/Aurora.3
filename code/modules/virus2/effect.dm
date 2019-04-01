/datum/disease2/effectholder
	var/name = "Holder"
	var/datum/disease2/effect/effect
	var/chance = 0 //Chance in percentage each tick
	var/cure = "" //Type of cure it requires
	var/happensonce = 0
	var/multiplier = 1 //The chance the effects are WORSE
	var/stage = 0

/datum/disease2/effectholder/proc/runeffect(var/mob/living/carbon/human/mob,var/stage)
	if(happensonce > -1 && effect.stage <= stage && prob(chance))
		effect.activate(mob, multiplier)
		if(happensonce == 1)
			happensonce = -1

/datum/disease2/effectholder/proc/getrandomeffect(var/badness = 1, exclude_types=list())
	var/list/datum/disease2/effect/list = list()
	for(var/e in (typesof(/datum/disease2/effect) - /datum/disease2/effect))
		var/datum/disease2/effect/f = e
		if(e in exclude_types)
			continue
		if(initial(f.badness) > badness)	//we don't want such strong effects
			continue
		if(initial(f.stage) <= src.stage)
			list += f
	var/type = pick(list)
	effect = new type()
	effect.generate()
	chance = rand(0,effect.chance_maxm)
	multiplier = rand(1,effect.maxm)

/datum/disease2/effectholder/proc/minormutate()
	switch(pick(1,2,3,4,5))
		if(1)
			chance = rand(0,effect.chance_maxm)
		if(2)
			multiplier = rand(1,effect.maxm)

/datum/disease2/effectholder/proc/majormutate(exclude_types=list())
	getrandomeffect(3, exclude_types)

////////////////////////////////////////////////////////////////
////////////////////////EFFECTS/////////////////////////////////
////////////////////////////////////////////////////////////////

/datum/disease2/effect
	var/chance_maxm = 50 //note that disease effects only proc once every 3 ticks for humans
	var/name = "Blanking effect"
	var/stage = 4
	var/maxm = 1
	var/badness = 1
	var/data = null // For semi-procedural effects; this should be generated in generate() if used

/datum/disease2/effect/proc/activate(var/mob/living/carbon/mob,var/multiplier)
/datum/disease2/effect/proc/deactivate(var/mob/living/carbon/mob)
/datum/disease2/effect/proc/generate(copy_data) // copy_data will be non-null if this is a copy; it should be used to initialise the data for this effect if present

/datum/disease2/effect/invisible
	name = "Incubation Period"
	stage = 1

/datum/disease2/effect/invisible/activate(var/mob/living/carbon/mob,var/multiplier)
	return

////////////////////////STAGE 4/////////////////////////////////

/datum/disease2/effect/nothing
	name = "Carrier Syndrome"
	stage = 4
	badness = 1
	chance_maxm = 0

/datum/disease2/effect/gibbingtons
	name = "Rapid Limb Necrosis"
	stage = 4
	badness = 3

/datum/disease2/effect/gibbingtons/activate(var/mob/living/carbon/mob,var/multiplier)
	// Probabilities have been tweaked to kill in ~2-3 minutes, giving 5-10 messages.
	// Probably needs more balancing, but it's better than LOL U GIBBED NOW, especially now that viruses can potentially have no signs up until Gibbingtons.
	mob.adjustBruteLoss(10*multiplier)
	if(istype(mob, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = mob
		var/obj/item/organ/external/O = pick(H.organs)
		if(prob(25))
			to_chat(mob, "<span class='warning'>Your [O.name] feels as if it might burst!</span>")
		if(prob(10))
			spawn(50)
				if(O)
					O.droplimb(0,DROPLIMB_BLUNT)
	else
		if(prob(75))
			to_chat(mob, "<span class='warning'>Your whole body feels like it might fall apart!</span>")
		if(prob(10))
			mob.adjustBruteLoss(25*multiplier)

/datum/disease2/effect/radian
	name = "Radian's Syndrome"
	stage = 4
	maxm = 3
	badness = 2

/datum/disease2/effect/radian/activate(var/mob/living/carbon/mob,var/multiplier)
	mob.apply_effect(2*multiplier, IRRADIATE, blocked = 0)

/datum/disease2/effect/deaf_major
	name = "Deafness"
	stage = 4
	badness = 2

/datum/disease2/effect/deaf_major/activate(var/mob/living/carbon/mob,var/multiplier)
	mob.ear_deaf += 20

/datum/disease2/effect/monkey
	name = "Monkism Syndrome"
	stage = 4
	badness = 3

/datum/disease2/effect/monkey/activate(var/mob/living/carbon/mob,var/multiplier)
	if(istype(mob,/mob/living/carbon/human))
		var/mob/living/carbon/human/h = mob
		h.monkeyize()

/datum/disease2/effect/killertoxins
	name = "Sepsis"
	stage = 4
	badness = 2

/datum/disease2/effect/killertoxins/activate(var/mob/living/carbon/mob,var/multiplier)
	mob.adjustToxLoss(15*multiplier)

/datum/disease2/effect/dna
	name = "DNA Shift"
	stage = 4
	badness = 2
/datum/disease2/effect/dna/activate(var/mob/living/carbon/mob,var/multiplier)
	mob.bodytemperature = max(mob.bodytemperature, 350)
	scramble(0,mob,10)
	mob.apply_damage(10, CLONE)

/datum/disease2/effect/organs
	name = "Peripheral Neuropathy"
	stage = 4
	badness = 2

/datum/disease2/effect/organs/activate(var/mob/living/carbon/mob,var/multiplier)
	if(istype(mob, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = mob
		var/organ = pick(list("r_arm","l_arm","r_leg","r_leg"))
		var/obj/item/organ/external/E = H.organs_by_name[organ]
		if (!(E.status & ORGAN_DEAD))
			E.status |= ORGAN_DEAD
			to_chat(H, "<span class='notice'>You can't feel your [E.name] anymore...</span>")
			for (var/obj/item/organ/external/C in E.children)
				C.status |= ORGAN_DEAD
		H.update_body(1)
	mob.adjustToxLoss(15*multiplier)

/datum/disease2/effect/organs/deactivate(var/mob/living/carbon/mob,var/multiplier)
	if(istype(mob, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = mob
		for (var/obj/item/organ/external/E in H.organs)
			E.status &= ~ORGAN_DEAD
			for (var/obj/item/organ/external/C in E.children)
				C.status &= ~ORGAN_DEAD
		H.update_body(1)

/datum/disease2/effect/organs/vampire
	stage = 3

/datum/disease2/effect/immortal
	name = "Longevity Syndrome"
	stage = 4
	badness = 2

/datum/disease2/effect/immortal/activate(var/mob/living/carbon/mob,var/multiplier)
	if(istype(mob, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = mob
		for (var/obj/item/organ/external/E in H.organs)
			if (E.status & ORGAN_BROKEN && prob(30))
				E.status ^= ORGAN_BROKEN
	var/heal_amt = -5*multiplier
	mob.apply_damages(heal_amt,heal_amt,heal_amt,heal_amt)

/datum/disease2/effect/immortal/deactivate(var/mob/living/carbon/mob,var/multiplier)
	if(istype(mob, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = mob
		to_chat(H, "<span class='notice'>You suddenly feel hurt and old...</span>")
		H.age += 8
	var/backlash_amt = 5*multiplier
	mob.apply_damages(backlash_amt,backlash_amt,backlash_amt,backlash_amt)

/datum/disease2/effect/bones
	name = "Osteoporosis"
	stage = 4
	badness = 2

/datum/disease2/effect/bones/activate(var/mob/living/carbon/mob,var/multiplier)
	if(istype(mob, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = mob
		for (var/obj/item/organ/external/E in H.organs)
			E.min_broken_damage = max(5, E.min_broken_damage - 30)

/datum/disease2/effect/bones/deactivate(var/mob/living/carbon/mob,var/multiplier)
	if(istype(mob, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = mob
		for (var/obj/item/organ/external/E in H.organs)
			E.min_broken_damage = initial(E.min_broken_damage)

////////////////////////STAGE 3/////////////////////////////////

/datum/disease2/effect/toxins
	name = "Blood Toxicity"
	stage = 3
	maxm = 3

/datum/disease2/effect/toxins/activate(var/mob/living/carbon/mob,var/multiplier)
	mob.adjustToxLoss((2*multiplier))

/datum/disease2/effect/shakey
	name = "Vertigo"
	stage = 3
	maxm = 3

/datum/disease2/effect/shakey/activate(var/mob/living/carbon/mob,var/multiplier)
	shake_camera(mob,5*multiplier)

/datum/disease2/effect/telepathic
	name = "Telepathy Syndrome"
	stage = 3

/datum/disease2/effect/telepathic/activate(var/mob/living/carbon/mob,var/multiplier)
	mob.dna.SetSEState(REMOTETALKBLOCK,1)
	domutcheck(mob, null, MUTCHK_FORCED)

/datum/disease2/effect/mind
	name = "Meningitis"
	stage = 3

/datum/disease2/effect/mind/activate(var/mob/living/carbon/mob,var/multiplier)
	if(istype(mob, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = mob
		var/obj/item/organ/brain/B = H.internal_organs_by_name["brain"]
		if (B && B.damage < B.min_broken_damage)
			B.take_damage(5)
	else
		mob.setBrainLoss(50)

/datum/disease2/effect/hallucinations
	name = "Hallucinations"
	stage = 3

/datum/disease2/effect/hallucinations/activate(var/mob/living/carbon/mob,var/multiplier)
	mob.hallucination += 25

/datum/disease2/effect/deaf
	name = "Hearing Impairment"
	stage = 3

/datum/disease2/effect/deaf/activate(var/mob/living/carbon/mob,var/multiplier)
	mob.ear_deaf = 5

/datum/disease2/effect/giggle
	name = "Pseudobulbar Affect"
	stage = 3

/datum/disease2/effect/giggle/activate(var/mob/living/carbon/mob,var/multiplier)
	mob.say("*giggle")

/datum/disease2/effect/confusion
	name = "Left-Right Disorientation"
	stage = 3

/datum/disease2/effect/confusion/activate(var/mob/living/carbon/mob,var/multiplier)
	to_chat(mob, "<span class='notice'>You have trouble telling right and left apart all of a sudden.</span>")
	mob.confused += 10

/datum/disease2/effect/mutation
	name = "DNA Degradation"
	stage = 3

/datum/disease2/effect/mutation/activate(var/mob/living/carbon/mob,var/multiplier)
	mob.apply_damage(2, CLONE)

/datum/disease2/effect/groan
	name = "Groaning Syndrome"
	stage = 3
	chance_maxm = 25
/datum/disease2/effect/groan/activate(var/mob/living/carbon/mob,var/multiplier)
	mob.say("*groan")

/datum/disease2/effect/chem_synthesis
	name = "Chemical Synthesis"
	stage = 3
	chance_maxm = 25

/datum/disease2/effect/chem_synthesis/generate(c_data)
	if(c_data)
		data = c_data
	else
		data = pick("bicaridine", "kelotane", "anti_toxin", "inaprovaline", "space_drugs", "sugar",
					"tramadol", "dexalin", "cryptobiolin", "impedrezene", "hyperzine", "ethylredoxrazine",
					"mindbreaker", "glucose")
	var/datum/reagent/R = SSchemistry.chemical_reagents[data]
	name = "[initial(name)] ([initial(R.name)])"

/datum/disease2/effect/chem_synthesis/activate(var/mob/living/carbon/mob,var/multiplier)
	if (mob.reagents.get_reagent_amount(data) < 5)
		mob.reagents.add_reagent(data, 2)

////////////////////////STAGE 2/////////////////////////////////

/datum/disease2/effect/scream
	name = "Vocal Outbursts"
	stage = 2
	chance_maxm = 25

/datum/disease2/effect/scream/activate(var/mob/living/carbon/mob,var/multiplier)
	mob.say("*scream")

/datum/disease2/effect/drowsness
	name = "Narcolepsy"
	stage = 2

/datum/disease2/effect/drowsness/activate(var/mob/living/carbon/mob,var/multiplier)
	mob.drowsyness += 10

/datum/disease2/effect/sleepy
	name = "Syncope"
	stage = 2
	chance_maxm = 15

/datum/disease2/effect/sleepy/activate(var/mob/living/carbon/mob,var/multiplier)
	mob.say("*collapse")

/datum/disease2/effect/blind
	name = "Blindness"
	stage = 2

/datum/disease2/effect/blind/activate(var/mob/living/carbon/mob,var/multiplier)
	mob.eye_blind = max(mob.eye_blind, 4)

/datum/disease2/effect/cough
	name = "Coughing"
	stage = 2

/datum/disease2/effect/cough/activate(var/mob/living/carbon/mob,var/multiplier)
	mob.say("*cough")
	for(var/mob/living/carbon/M in oview(2,mob))
		mob.spread_disease_to(M)

/datum/disease2/effect/hungry
	name = "Cachexia"
	stage = 2

/datum/disease2/effect/hungry/activate(var/mob/living/carbon/mob,var/multiplier)
	mob.adjustNutritionLoss(200)

/datum/disease2/effect/fridge
	name = "Chills"
	stage = 2
	chance_maxm = 25

/datum/disease2/effect/fridge/activate(var/mob/living/carbon/mob,var/multiplier)
	mob.say("*shiver")

/datum/disease2/effect/hair
	name = "Alopecia"
	stage = 2

/datum/disease2/effect/hair/activate(var/mob/living/carbon/mob,var/multiplier)
	if(istype(mob, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = mob
		if(H.species.name == "Human" && !(H.h_style == "Bald") && !(H.h_style == "Balding Hair"))
			to_chat(H, "<span class='danger'>Your hair starts to fall out in clumps...</span>")
			spawn(50)
				H.h_style = "Balding Hair"
				H.update_hair()

/datum/disease2/effect/stimulant
	name = "Hyperactivity"
	stage = 2



/datum/disease2/effect/stimulant/activate(var/mob/living/carbon/mob,var/multiplier)
	to_chat(mob, "<span class='notice'>You feel a rush of energy inside you!</span>")
	if (mob.reagents.get_reagent_amount("hyperzine") < 10)
		mob.reagents.add_reagent("hyperzine", 4)
	if (prob(30))
		mob.jitteriness += 10

////////////////////////STAGE 1/////////////////////////////////

/datum/disease2/effect/sneeze
	name = "Sneezing"
	stage = 1

/datum/disease2/effect/sneeze/activate(var/mob/living/carbon/mob, var/multiplier)
	if (prob(30))
		to_chat(mob, "<span class='warning'>You feel like you are about to sneeze!</span>")
	addtimer(CALLBACK(src, .proc/do_sneeze, mob, multiplier), 5)

/datum/disease2/effect/sneeze/proc/do_sneeze(mob/living/carbon/mob, multiplier)
	if (QDELETED(mob))
		return

	mob.say("*sneeze")
	for(var/mob/living/carbon/M in get_step(mob, mob.dir))
		mob.spread_disease_to(M)
	if (prob(50))
		var/obj/effect/decal/cleanable/mucus/M = new(get_turf(mob))
		M.virus2 = virus_copylist(mob.virus2)

/datum/disease2/effect/gunck
	name = "Congestion"
	stage = 1

/datum/disease2/effect/gunck/activate(var/mob/living/carbon/mob,var/multiplier)
	to_chat(mob, "<span class='warning'>Mucous runs down the back of your throat.</span>")

/datum/disease2/effect/drool
	name = "Salivary Incontinence"
	stage = 1
	chance_maxm = 25

/datum/disease2/effect/drool/activate(var/mob/living/carbon/mob,var/multiplier)
	mob.say("*drool")

/datum/disease2/effect/twitch
	name = "Convulsions"
	stage = 1
	chance_maxm = 25

/datum/disease2/effect/twitch/activate(var/mob/living/carbon/mob,var/multiplier)
	mob.say("*twitch")

/datum/disease2/effect/headache
	name = "Headache"
	stage = 1

/datum/disease2/effect/headache/activate(var/mob/living/carbon/mob,var/multiplier)
	to_chat(mob, "<span class='warning'>Your head hurts a bit.</span>")
