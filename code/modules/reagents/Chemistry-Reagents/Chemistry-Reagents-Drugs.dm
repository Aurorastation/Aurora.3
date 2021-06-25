/decl/reagent/space_drugs
	name = "Space Drugs"
	description = "Mercury Monolithium Sucrose, or space drugs, is a potent relaxant commonly found in Ambrosia plants. Lasts twice as long when inhaled."
	reagent_state = LIQUID
	color = "#60A584"
	metabolism = REM * 0.5
	overdose = REAGENTS_OVERDOSE
	taste_description = "bitterness"
	taste_mult = 0.4
	breathe_met = REM * 0.5 * 0.5

/decl/reagent/space_drugs/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	var/mob/living/carbon/human/H = M
	if(istype(H) && (H.species.flags & NO_BLOOD))
		return
	M.add_chemical_effect(CE_PULSE, -1)

	var/power = (M.chem_doses[type] + REAGENT_VOLUME(holder, type))/2 //Larger the dose and volume, the more affected you are by the chemical.

	M.druggy = max(M.druggy, power)
	M.add_chemical_effect(CE_PAINKILLER, 5 + round(power,5))

	if(power > 5)
		M.drowsiness = min(20,max(M.drowsiness,power - 5))

	if(power > 10)
		var/nutrition_percent = M.nutrition/M.max_nutrition
		M.adjustNutritionLoss(power*removed*nutrition_percent)
		var/hunger_strength = 1 - nutrition_percent
		if(prob( round(hunger_strength*removed) ))
			to_chat(M, SPAN_NOTICE(pick("You could really go for some munchies.","You feel the need to eat more.","You crave chips for some reason.","You kind of really want pizza.")))

	if(power > 20)
		var/probmod = 5 + (power-20)
		if(prob(probmod) && isturf(M.loc) && !istype(M.loc, /turf/space) && M.canmove && !M.restrained())
			step(M, pick(cardinal))

	if(prob(3))
		M.emote(pick("smile","giggle","moan","yawn","laugh","drool","twitch"))

/decl/reagent/space_drugs/overdose(var/mob/living/carbon/M, var/alien, var/removed = 0, var/scale = 1, var/datum/reagents/holder)
	. = ..()
	M.hallucination = max(M.hallucination, 30 * scale)

/decl/reagent/serotrotium
	name = "Serotrotium"
	description = "A chemical compound that promotes concentrated production of the serotonin neurotransmitter in humans."
	reagent_state = LIQUID
	color = "#202040"
	metabolism = REM * 0.25
	overdose = REAGENTS_OVERDOSE
	taste_description = "bitterness"
	fallback_specific_heat = 1.2

/decl/reagent/serotrotium/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	var/mob/living/carbon/human/H = M
	if(istype(H) && (H.species.flags & NO_BLOOD))
		return
	if(prob(7))
		M.emote(pick("twitch", "drool", "moan", "gasp"))
	return

/decl/reagent/cryptobiolin
	name = "Cryptobiolin"
	description = "Cryptobiolin causes confusion and dizzyness."
	reagent_state = LIQUID
	color = "#000055"
	metabolism = REM * 0.5
	overdose = REAGENTS_OVERDOSE
	taste_description = "sourness"

/decl/reagent/cryptobiolin/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	var/mob/living/carbon/human/H = M
	if(istype(H) && (H.species.flags & NO_BLOOD))
		return
	M.dizziness = max(150, M.dizziness)//Setting dizziness directly works as long as the make_dizzy proc is called after to spawn the process
	M.make_dizzy(4)
	M.add_chemical_effect(CE_HALLUCINATE, 1)
	M.confused = max(M.confused, 20)

/decl/reagent/impedrezene
	name = "Impedrezene"
	description = "Impedrezene is a narcotic that impedes one's ability by slowing down the higher brain cell functions."
	reagent_state = LIQUID
	color = "#C8A5DC"
	overdose = REAGENTS_OVERDOSE
	taste_description = "numbness"

/decl/reagent/impedrezene/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	M.jitteriness = max(M.jitteriness - 5, 0)
	M.confused = max(M.confused, 10)
	if(prob(80))
		M.add_chemical_effect(CE_NEUROTOXIC, 3*removed)
	if(prob(50))
		M.drowsiness = max(M.drowsiness, 3)
	if(prob(10))
		M.emote("drool")

/decl/reagent/mindbreaker
	name = "Mindbreaker Toxin"
	description = "An incredibly potent hallucinogen designed to wreak havoc on the brain, resulting in disturbing hallucinations with long-term impacts on those given the drug - this drug is not pleasant, thus the name, and only hardcore addicts use the drug recreationally."
	reagent_state = LIQUID
	color = "#B31008"
	metabolism = REM * 0.25
	overdose = REAGENTS_OVERDOSE
	taste_description = "sourness"

/decl/reagent/mindbreaker/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	M.hallucination = max(M.hallucination, 100)
	M.add_chemical_effect(CE_HALLUCINATE, 2)
	if(prob(10))
		M.add_chemical_effect(CE_NEUROTOXIC, 5*removed)

/decl/reagent/psilocybin
	name = "Psilocybin"
	description = "A strong psychotropic derived from certain species of mushroom."
	color = "#E700E7"
	overdose = REAGENTS_OVERDOSE
	metabolism = REM * 0.5
	taste_description = "mushroom"
	fallback_specific_heat = 1.2

/decl/reagent/psilocybin/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	var/mob/living/carbon/human/H = M
	if(istype(H) && (H.species.flags & NO_BLOOD))
		return
	M.druggy = max(M.druggy, 30)
	M.add_chemical_effect(CE_HALLUCINATE, 1)
	var/dose = M.chem_doses[type]
	if(dose < 1)
		M.apply_effect(3, STUTTER)
		M.make_dizzy(5)
		if(prob(5))
			M.emote(pick("twitch", "giggle"))
	else if(dose < 2)
		M.apply_effect(3, STUTTER)
		M.make_jittery(5)
		M.dizziness = max(150, M.dizziness)
		M.make_dizzy(5)
		M.druggy = max(M.druggy, 35)
		if(prob(10))
			M.emote(pick("twitch", "giggle"))
	else
		M.apply_effect(3, STUTTER)
		M.make_jittery(10)
		M.dizziness = max(150, M.dizziness)
		M.make_dizzy(10)
		M.druggy = max(M.druggy, 40)
		if(prob(15))
			M.emote(pick("twitch", "giggle"))

/decl/reagent/raskara_dust
	name = "Raskara Dust"
	description = "A powdery narcotic found in the gang-ridden slums of Biesel and Sol. Known for it's relaxing poperties that cause trance-like states when inhaled. Casual users tend to snort or inhale, while hardcore users inject."
	reagent_state = SOLID
	color = "#AABBAA"
	overdose = REAGENTS_OVERDOSE
	taste_description = "baking soda"
	metabolism = REM * 0.1
	breathe_met = REM * 0.2
	ingest_met = REM * 0.3

/decl/reagent/raskara_dust/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	M.add_chemical_effect(CE_PAINKILLER, 10)
	M.drowsiness += 1 * removed

/decl/reagent/raskara_dust/affect_breathe(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	M.add_chemical_effect(CE_PAINKILLER, 25)
	M.drowsiness += 2 * removed
	if(prob(5))
		M.emote("cough")

/decl/reagent/raskara_dust/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	M.add_chemical_effect(CE_PAINKILLER, 50)
	M.drowsiness += 3 * removed
	if(prob(5))
		M.emote("twitch")

/decl/reagent/night_juice
	name = "Nightlife"
	description = "A liquid narcotic commonly used by the more wealthy drug-abusing citizens of the Eridani Federation. Works as a potent stimulant that causes extreme awakefulness. Lethal in high doses."
	reagent_state = LIQUID
	color = "#FFFF44"
	taste_description = "salted sugar"
	metabolism = REM * 0.2
	breathe_met = REM * 0.1
	breathe_mul = 0.5
	ingest_mul = 0.125

/decl/reagent/night_juice/initialize_data(newdata, datum/reagents/holder)
	. = ..()
	LAZYSET(., "special", 0)

/decl/reagent/night_juice/affect_blood(var/mob/living/carbon/human/M, var/alien, var/removed, var/datum/reagents/holder)
	if(!istype(M))
		return

	holder.reagent_data[type]["special"] += (REAGENT_VOLUME(holder, type)/10)*removed

	M.make_jittery(5 + holder.reagent_data[type]["special"])
	M.drowsiness = max(0,M.drowsiness - (1 + holder.reagent_data[type]["special"]*0.1))
	if(holder.reagent_data[type]["special"] > 5)
		M.add_chemical_effect(CE_SPEEDBOOST, 1)
		M.apply_effect(1 + holder.reagent_data[type]["special"]*0.25, STUTTER)
		M.druggy = max(M.druggy, holder.reagent_data[type]["special"]*0.25)
		M.hallucination = max(M.hallucination, holder.reagent_data[type]["special"]*5 - 100)
		M.make_jittery(holder.reagent_data[type]["special"])
		if(prob(holder.reagent_data[type]["special"]))
			M.emote("twitch")
		var/obj/item/organ/H = M.internal_organs_by_name[BP_HEART]
		H.take_damage(holder.reagent_data[type]["special"] * removed * 0.025)

/decl/reagent/guwan_painkillers
	name = "Tremble"
	description = "An ancient tribal Unathi narcotic based on the outer gel layer of the seeds of a poisonous flower. The chemical itself acts as a very potent omni-healer when consumed, however as the chemical metabolizes, it causes immense and cripling pain."
	reagent_state = LIQUID
	color = "#FFFF44"
	taste_description = "sunflower seeds"
	metabolism = REM * 0.25
	overdose = 10
	fallback_specific_heat = 1

/decl/reagent/guwan_painkillers/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	affect_ingest(M, alien, removed*0.5, holder)

/decl/reagent/guwan_painkillers/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	var/dose = M.chem_doses[type]
	if(dose > 5 && REAGENT_VOLUME(holder, type) <= 3)
		M.adjustHalLoss(removed*300) //So oxycomorphine can't be used with it.
	else
		if(dose > 5)
			M.add_chemical_effect(CE_PAINKILLER, 50)
			M.heal_organ_damage(5 * removed,5 * removed)
		else
			M.add_chemical_effect(CE_PAINKILLER, 10)
			M.heal_organ_damage(2 * removed,2 * removed)

/decl/reagent/toxin/stimm	//Homemade Hyperzine, ported from Polaris
	name = "Stimm"
	description = "A homemade stimulant with some serious side-effects."
	taste_description = "sweetness"
	taste_mult = 1.8
	color = "#d0583a"
	metabolism = REM * 3
	overdose = 10
	strength = 3

/decl/reagent/toxin/stimm/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	if(alien == IS_TAJARA)
		removed *= 1.25
	..()
	if(prob(15))
		M.emote(pick("twitch", "blink_r", "shiver"))
	if(prob(5)) // average of 6 brute every 20 seconds.
		M.visible_message("[M] shudders violently.", "You shudder uncontrollably, it hurts.")
		M.take_organ_damage(6 * removed, 0)
	M.add_up_to_chemical_effect(CE_SPEEDBOOST, 1)

/decl/reagent/toxin/lean
	name = "Lean"
	description = "A mixture of cough syrup, space-up, and sugar."
	taste_description = "sickly-sweet soda"
	taste_mult = 1.5
	color = "#600060"
	metabolism = REM // twice as fast as space drugs
	overdose = 10
	strength = 1.5 // makes up for it with slight suffocation damage

	glass_name = "glass of purple drank"
	glass_desc = "Bottoms up."

/decl/reagent/toxin/lean/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	M.hallucination = max(M.hallucination, 40)
	M.add_chemical_effect(CE_PAINKILLER, 40) // basically like Perconol, but a bit worse
	// doesn't make you vomit, though
	if(prob(7))
		M.emote(pick("twitch", "drool", "moan", "giggle"))
		to_chat(M, SPAN_WARNING(pick("You feel great!", "You don't have a care in the world.", "You couldn't care less about anything.", "You feel so relaxed...")))
	M.adjustOxyLoss(0.01 * removed)
	if(M.losebreath < 5)
		M.losebreath++
	if(prob(50))
		M.drowsiness = max(M.drowsiness, 3)

/decl/reagent/toxin/krok
	name = "Krok Juice"
	description = "An advanced Eridanian variant of ancient krokodil, known for causing prosthetic malfunctions."
	strength = 3
	metabolism = REM
	overdose = 15

/decl/reagent/toxin/krok/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	var/mob/living/carbon/human/H = M
	if(!istype(H))
		return
	var/robo = FALSE
	for (var/obj/item/organ/external/E in H.organs)
		if(!E || !(E.status & ORGAN_ROBOT))
			continue
		robo = TRUE
		if(prob(80)) // 20% chance of making robot limbs malfuction
			continue
		switch(E.body_part)
			if(HAND_LEFT, ARM_LEFT)
				H.drop_l_hand()
			if(HAND_RIGHT, ARM_RIGHT)
				H.drop_r_hand()
	if(robo)
		H.add_chemical_effect(CE_PAINKILLER, 80) // equivalent to mortaphenyl
	var/obj/item/organ/internal/eyes/eyes = H.internal_organs_by_name[H.species.vision_organ || BP_EYES]
	if(eyes.status & ORGAN_ROBOT)
		M.hallucination = max(M.hallucination, 40)

/decl/reagent/wulumunusha
	name = "Wulumunusha Extract"
	description = "The extract of the wulumunusha fruit, it can cause hallucinations and muteness."
	color = "#61E2EC"
	taste_description = "sourness"
	fallback_specific_heat = 1
	overdose = 10

/decl/reagent/wulumunusha/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	M.druggy = max(M.druggy, 100)
	M.silent = max(M.silent, 5)

/decl/reagent/wulumunusha/overdose(var/mob/living/carbon/M, var/alien, var/removed = 0, var/scale = 1, var/datum/reagents/holder)
	if(isskrell(M))
		M.hallucination = max(M.hallucination, 10 * scale)	//light hallucinations that afflict skrell
