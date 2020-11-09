/* General medicine */

/datum/reagent/inaprovaline
	name = "Inaprovaline"
	description = "Inaprovaline is a cardiostimulant which stabilises myocardial contractility, working towards maintaining a steady pulse and blood pressure. Inaprovaline also acts as a weak analgesic."
	reagent_state = LIQUID
	color = "#00BFFF"
	overdose = REAGENTS_OVERDOSE
	metabolism = REM * 0.5
	metabolism_min = REM * 0.125
	breathe_mul = 0.5
	scannable = TRUE
	taste_description = "bitterness"

/datum/reagent/inaprovaline/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.add_chemical_effect(CE_STABLE)
	M.add_chemical_effect(CE_PAINKILLER, 25)

/datum/reagent/inaprovaline/overdose(var/mob/living/carbon/M, var/alien, var/removed)	
	if(prob(2))
		to_chat(M, SPAN_WARNING(pick("Your chest feels tight.", "Your chest is aching a bit.", "You have a stabbing pain in your chest.")))
		M.adjustHalLoss(5)

/datum/reagent/bicaridine
	name = "Bicaridine"
	description = "Bicaridine is a complex medication which specifically targets damaged tissues and damaged blood vessels by encouraging the rate at which the damaged tissues are regenerated. Overdosing bicaridine allows the drug to take effect on damaged muscular tissues of arteries."
	reagent_state = LIQUID
	color ="#BF0000"
	scannable = TRUE
	overdose = REAGENTS_OVERDOSE
	metabolism = REM * 0.5
	taste_description = "bitterness"
	fallback_specific_heat = 1
	taste_mult = 3

/datum/reagent/bicaridine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.heal_organ_damage(5 * removed, 0)
	if((locate(/datum/reagent/butazoline) in M.reagents.reagent_list))
		M.add_chemical_effect(CE_ITCH, dose * 2)
		M.adjustHydrationLoss(2*removed)
		M.adjustCloneLoss(2.5*removed) // Cell regeneration spiralling out of control resulting in genetic damage.

/datum/reagent/bicaridine/overdose(var/mob/living/carbon/M, var/alien, var/removed)
	M.dizziness = max(100, M.dizziness)
	M.make_dizzy(5)
	M.adjustHydrationLoss(5*removed)
	M.adjustNutritionLoss(5*removed)
	
	var/mob/living/carbon/human/H = M 
	if(dose > 30) //Bicaridine treats arterial bleeding when dose is greater than 30u and when the drug is overdosing (chemical volume in blood greater than 20).
		for(var/obj/item/organ/external/E in H.organs)
			if(E.status & ORGAN_ARTERY_CUT && prob(2))
				E.status &= ~ORGAN_ARTERY_CUT

/datum/reagent/butazoline
	name = "Butazoline"
	description = "Butazoline, a recent improvement upon Bicaridine, is specialised at treating the most traumatic of wounds, though less so for treating severe bleeding."
	reagent_state = LIQUID
	color = "#ff5555"
	overdose = 15
	scannable = TRUE
	metabolism = REM * 0.5
	taste_description = "bitterness"
	taste_mult = 3

/datum/reagent/butazoline/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.heal_organ_damage(8 * removed, 0)
	M.add_chemical_effect(CE_ITCH, dose)
	M.adjustHydrationLoss(1*removed)

/datum/reagent/kelotane
	name = "Kelotane"
	description = "Kelotane is a complex medication which specifically targets tissues which have been lost to severe burning by encouraging the rate at which these damaged tissues are regenerated."
	reagent_state = LIQUID
	color = "#FFA800"
	overdose = REAGENTS_OVERDOSE
	scannable = TRUE
	metabolism = REM * 0.5
	taste_description = "bitterness"

/datum/reagent/kelotane/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.heal_organ_damage(0, 6 * removed)
	if((locate(/datum/reagent/dermaline) in M.reagents.reagent_list))
		M.add_chemical_effect(CE_ITCH, dose * 2)
		M.adjustHydrationLoss(2*removed)
		M.adjustCloneLoss(2.5*removed) //Cell regeneration spiralling out of control resulting in genetic damage.

/datum/reagent/kelotane/overdose(var/mob/living/carbon/M, var/alien)
	var/mob/living/carbon/human/H = M
	var/obj/item/organ/external/head = H.get_organ(BP_HEAD)
	if(!(head.disfigured))
		if(prob(10))
			to_chat(M, SPAN_WARNING(pick("Blisters start forming on your face.", "Your face feels numb.", "Your face feels swollen.", "You face hurts to touch.")))
		if(prob(2))
			to_chat(M, SPAN_DANGER("Your face has swollen and blistered to such a degree that you are no longer recognisable!"))
			head.disfigured = TRUE

/datum/reagent/dermaline
	name = "Dermaline"
	description = "Dermaline is a recent improvement of kelotane, working in a similar way, though twice as effective. Dermaline is capable of recovering even the most dire of burnt tissues, being able to treat full-thickness burning."
	reagent_state = LIQUID
	color = "#FF8000"
	taste_description = "bitterness"
	fallback_specific_heat = 1
	scannable = TRUE
	metabolism = REM * 0.5
	overdose = 15
	taste_mult = 1.5

/datum/reagent/dermaline/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.heal_organ_damage(0, 12 * removed)
	M.add_chemical_effect(CE_ITCH, dose)
	M.adjustHydrationLoss(1*removed)

/datum/reagent/dylovene
	name = "Dylovene"
	description = "Dylovene is a broad-spectrum over-the-counter antitoxin. It is used in response to a variety of poisoning cases, being able to neutralise and remove harmful toxins from the bloodstream."
	reagent_state = LIQUID
	color = "#00A000"
	overdose = REAGENTS_OVERDOSE
	scannable = TRUE
	metabolism = REM * 0.5
	taste_description = "a roll of gauze"

	var/remove_generic = TRUE
	var/list/remove_toxins = list(
		/datum/reagent/toxin/zombiepowder
	)

/datum/reagent/dylovene/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return

	if(remove_generic)
		M.drowsyness = max(0, M.drowsyness - 6 * removed)
		M.hallucination -= (2 * removed)
		M.add_up_to_chemical_effect(CE_ANTITOXIN, 1)

	var/removing = (4 * removed)
	var/datum/reagents/ingested = M.get_ingested_reagents()
	for(var/datum/reagent/R in ingested.reagent_list)
		if((remove_generic && istype(R, /datum/reagent/toxin)) || (R.type in remove_toxins))
			ingested.remove_reagent(R.type, removing)
			return
	for(var/datum/reagent/R in M.reagents.reagent_list)
		if((remove_generic && istype(R, /datum/reagent/toxin)) || (R.type in remove_toxins))
			M.reagents.remove_reagent(R.type, removing)
			return

/datum/reagent/dylovene/overdose(var/mob/living/carbon/M, var/alien, var/removed)
	M.adjustNutritionLoss(5 * removed)
	M.adjustHydrationLoss(5 * removed)

/datum/reagent/dexalin
	name = "Dexalin"
	description = "Dexalin is a complex oxygen therapeutic and is available OTC. The chemical utilises carbon nanostructures which cling to oxygen and, in pathological conditions where tissues are hypoxic, will oxygenate these regions. Dexalin is twice as efficient when inhaled."
	reagent_state = LIQUID
	color = "#0080FF"
	overdose = REAGENTS_OVERDOSE
	scannable = TRUE
	taste_description = "bitterness"
	metabolism = REM
	breathe_met = REM * 0.5
	breathe_mul = 2
	var/strength = 6

/datum/reagent/dexalin/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_VOX)
		M.adjustToxLoss(removed * strength)
	M.add_chemical_effect(CE_OXYGENATED, strength/6) // 1 for dexalin, 2 for dexplus
	holder.remove_reagent(/datum/reagent/lexorin, strength/3 * removed)

//Hyperoxia causes brain and eye damage
/datum/reagent/dexalin/overdose(var/mob/living/carbon/M, var/alien, var/removed)
	M.add_chemical_effect(CE_NEUROTOXIC, removed * (strength / 6))
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/internal/eyes/E = H.get_eyes(no_synthetic = TRUE)
		if(E && istype(E))
			E.take_damage(removed * (strength / 12))
	if(alien == IS_VAURCA) //Vaurca need a mixture of phoron and oxygen. Too much dexalin likely imbalances that.
		M.adjustToxLoss(removed * strength / 2)
		M.eye_blurry = max(M.eye_blurry, 5)

/datum/reagent/dexalin/plus
	name = "Dexalin Plus"
	fallback_specific_heat = 1
	description = "Dexalin Plus was a ground-breaking improvement of Dexalin, capable of transporting several times the amount of oxygen, allowing it to have more clinical uses in treating hypoxia. Dexalin Plus is twice as efficient when inhaled."
	color = "#0040FF"
	overdose = 15
	strength = 12

/datum/reagent/tricordrazine
	name = "Tricordrazine"
	description = "Tricordrazine is an old, though still useful, medication largely set aside following bicaridine and kelotane's development. The drug increases the rate at which tissues regenerate, though far slower than modern medications."
	reagent_state = LIQUID
	color = "#8040FF"
	overdose = 30
	scannable = TRUE
	fallback_specific_heat = 1
	taste_description = "bitterness"
	breathe_mul = 0
	metabolism = REM * 0.25

/datum/reagent/tricordrazine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	var/power = 1 + Clamp((get_temperature() - (T0C + 20))*0.1,-0.5,0.5)
	//Heals 10% more brute and less burn for every 1 celcius above 20 celcius, up 50% more/less.
	//Heals 10% more burn and less brute for every 1 celcius below 20 celcius, up to 50% more/less.
	M.heal_organ_damage(3 * removed * power,3 * removed * power)

/datum/reagent/tricordrazine/overdose(var/mob/living/carbon/M, var/alien)
	M.add_chemical_effect(CE_ITCH, dose)

/datum/reagent/cryoxadone
	name = "Cryoxadone"
	description = "Cryoxadone is a ground-breaking and complex medication that, when acting on bodies cooler than 170K, is capable of increasing the rate at which wounds regenerate, as well as treating genetic damage. Cryoxadone, alongside Clonexadone, are the backbones of the cloning industry."
	reagent_state = LIQUID
	color = "#8080FF"
	metabolism = REM * 0.5
	scannable = TRUE
	taste_description = "sludge"

/datum/reagent/cryoxadone/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.add_chemical_effect(CE_CRYO, 1)
	if(M.bodytemperature < 170)
		M.add_chemical_effect(CE_PULSE, -2)
		M.adjustCloneLoss(-10 * removed)
		M.adjustOxyLoss(-10 * removed)
		M.heal_organ_damage(10 * removed, 10 * removed)

/datum/reagent/clonexadone
	name = "Clonexadone"
	description = "Clonexadone is a ground-breaking, complex medication that improved upon Cryoxadone. When acting on bodies cooler than 170K, the drug is capable of increasing the rate at which wounds regenerate, as well as treating genetic damage. Clonexadone, alongside Cryoxadone, are the backbones of the cloning industry."
	reagent_state = LIQUID
	color = "#80BFFF"
	metabolism = REM * 0.5
	scannable = TRUE
	taste_description = "slime"

/datum/reagent/clonexadone/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.add_chemical_effect(CE_CRYO, 1)
	if(M.bodytemperature < 170)
		M.add_chemical_effect(CE_PULSE, -2)
		M.adjustCloneLoss(-30 * removed)
		M.adjustOxyLoss(-30 * removed)
		M.heal_organ_damage(30 * removed, 30 * removed)

/* Painkillers */

/datum/reagent/perconol
	name = "Perconol"
	description = "Perconol is an advanced, analgesic medication which is highly effective at treating minor-mild pain, inflammation and high fevers. The drug is available over-the-counter for treating minor illnesses and mild pain. Perconol is not effective when inhaled."
	reagent_state = LIQUID
	color = "#C8A5DC"
	overdose = REAGENTS_OVERDOSE
	od_minimum_dose = 2
	scannable = TRUE
	metabolism = REM/10 // same as before when in blood, 0.02 units per tick
	ingest_met = REM * 2 // .4 units per tick
	breathe_met = REM * 4 // .8 units per tick
	taste_description = "sickness"
	metabolism_min = 0.005
	breathe_mul = 0

/datum/reagent/perconol/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.add_chemical_effect(CE_PAINKILLER, 50)
	M.add_chemical_effect(CE_NOFEVER, ((max_dose/2)^2-(dose-max_dose/2))/(max_dose/4)) // creates a smooth curve peaking at half the dose metabolised

/datum/reagent/perconol/overdose(var/mob/living/carbon/M, var/alien)
	..()
	M.hallucination = max(M.hallucination, 25)

/datum/reagent/mortaphenyl
	name = "Mortaphenyl"
	description = "Mortaphenyl is an advanced, powerful analgesic medication which is highly effective at treating mild-severe pain as a result of severe, physical injury. Mortaphenyl is not effective when inhaled."
	reagent_state = LIQUID
	color = "#CB68FC"
	overdose = 15
	scannable = TRUE
	od_minimum_dose = 2
	metabolism = REM/10 // same as before when in blood, 0.02 units per tick
	ingest_met = REM * 2 // .4 units per tick
	breathe_met = REM * 4 // .8 units per tick
	taste_description = "sourness"
	metabolism_min = 0.005
	breathe_mul = 0

/datum/reagent/mortaphenyl/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.add_chemical_effect(CE_PAINKILLER, 80)
	M.eye_blurry = max(M.eye_blurry, 5)
	M.confused = max(M.confused, 10)

	var/mob/living/carbon/human/H = M
	if(!istype(H))
		return
	var/bac = H.get_blood_alcohol()
	if(bac >= 0.03)
		M.hallucination = max(M.hallucination, bac * 300)
		M.add_chemical_effect(CE_EMETIC, dose/6)
	if(bac >= 0.08)
		if(M.losebreath < 15)
			M.losebreath++

	if((locate(/datum/reagent/oxycomorphine) in M.reagents.reagent_list))
		overdose = volume/2 //Straight to overdose.

/datum/reagent/mortaphenyl/overdose(var/mob/living/carbon/M, var/alien)
	..()
	M.hallucination = max(M.hallucination, 40)
	M.add_chemical_effect(CE_EMETIC, dose/6)
	if(M.losebreath < 15)
		M.losebreath++

/datum/reagent/mortaphenyl/aphrodite
	name = "Aphrodite"
	description = "Aphrodite is the name given to the chemical diona inject into organics soon after biting them. It serves a dual purpose of dulling the pain of the wound, and gathering deep-seated fragments of learned skills and memories, such as languages."
	color = "#a59153"
	overdose = 10
	scannable = TRUE
	fallback_specific_heat = 1
	taste_description = "euphoric acid"

/datum/reagent/mortaphenyl/aphrodite/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.add_chemical_effect(CE_PAINKILLER, 70)
	M.eye_blurry = max(M.eye_blurry, 3)
	M.confused = max(M.confused, 6)

/datum/reagent/oxycomorphine
	name = "Oxycomorphine"
	description = "Oxycomorphine is a highly advanced, powerful analgesic medication which is extremely effective at treating severe-agonising pain as a result of injuries usually incompatible with life. The drug is highly addictive and sense-numbing. Oxycomorphine is not effective when inhaled."
	reagent_state = LIQUID
	color = "#800080"
	overdose = 10
	od_minimum_dose = 2
	scannable = TRUE
	metabolism = REM/10 // same as before when in blood, 0.02 units per tick
	ingest_met = REM * 2 // .4 units per tick
	breathe_met = REM * 4 // .8 units per tick
	taste_description = "bitterness"
	metabolism_min = 0.005
	breathe_mul = 0

/datum/reagent/oxycomorphine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.add_chemical_effect(CE_PAINKILLER, 200)
	M.eye_blurry = max(M.eye_blurry, 5)
	M.confused = max(M.confused, 20)

	var/mob/living/carbon/human/H = M
	if(!istype(H))
		return
	var/bac = H.get_blood_alcohol()
	if(bac >= 0.02)
		M.hallucination = max(M.hallucination, bac * 300)
		M.druggy = max(M.druggy, bac * 100)
		M.add_chemical_effect(CE_EMETIC, dose/6)
	if(bac >= 0.04)
		if(prob(3))
			to_chat(M, SPAN_WARNING(pick("You're having trouble breathing.", "You begin to feel a bit light headed.", "Your breathing is very shallow.", "")))
		if(M.losebreath < 15)
			M.losebreath++

/datum/reagent/oxycomorphine/overdose(var/mob/living/carbon/M, var/alien)
	..()
	M.druggy = max(M.druggy, 20)
	M.hallucination = max(M.hallucination, 60)
	M.add_chemical_effect(CE_EMETIC, dose/6)
	if(M.losebreath < 15)
		M.losebreath++

/* Other medicine */

/datum/reagent/synaptizine
	name = "Synaptizine"
	description = "Synaptizine is an advanced synaptic stimulant and nootropic which improves synaptic transmission and keeps one alert, giving it many clinical uses in the treatment of paralysis, weakness, narcolepsy and hallucinations. Synaptizine is difficult to metabolise and is hard on the liver."
	reagent_state = LIQUID
	color = "#99CCFF"
	metabolism = REM * 0.05
	overdose = 10
	od_minimum_dose = 1
	scannable = TRUE
	var/datum/modifier/modifier
	taste_description = "bitterness"
	metabolism_min = REM * 0.0125

/datum/reagent/synaptizine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.drowsyness = max(M.drowsyness - 5, 0)
	if(!(volume > 10)) // Will prevent synaptizine interrupting a seizure caused by its own overdose.
		M.AdjustParalysis(-1) 
	M.AdjustStunned(-1)
	M.AdjustWeakened(-1)
	holder.remove_reagent(/datum/reagent/mindbreaker, 5)
	M.hallucination = max(0, M.hallucination - 10)
	M.eye_blurry = max(M.eye_blurry - 5, 0)
	M.confused = max(M.confused - 10, 0)
	M.adjustToxLoss(5 * removed) // It used to be incredibly deadly due to an oversight. Not anymore!
	M.add_chemical_effect(CE_PAINKILLER, 40)
	M.add_chemical_effect(CE_HALLUCINATE, -1)
	if (!modifier)
		modifier = M.add_modifier(/datum/modifier/adrenaline, MODIFIER_REAGENT, src, _strength = 1, override = MODIFIER_OVERRIDE_STRENGTHEN)

/datum/reagent/synaptizine/overdose(var/mob/living/carbon/M, var/alien)
	if(prob(dose / 2))
		to_chat(M, SPAN_WARNING(pick("You feel a tingly sensation in your body.", "You can smell something unusual.", "You can taste something unusual.")))
	if(prob(dose / 3))
		if(prob(75))
			M.emote(pick("twitch", "shiver"))
		else
			M.seizure()

/datum/reagent/synaptizine/Destroy()
	QDEL_NULL(modifier)
	return ..()

/datum/reagent/alkysine
	name = "Alkysine"
	description = "Alkysine is a complex drug which increases cerebral circulation, ensuring the brain does not become hypoxic and increasing the rate at which neurological function returns after a catastrophic injury."
	reagent_state = LIQUID
	color = "#FFFF66"
	metabolism = REM //0.2u/tick
	overdose = 10
	scannable = TRUE
	taste_description = "bitterness"
	metabolism_min = REM * 0.075

/datum/reagent/alkysine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(volume < 2) //Increased effectiveness & no side-effects if given via IV drip with low transfer rate.
		M.add_chemical_effect(CE_BRAIN_REGEN, 40) //1 unit of Alkysine fed via drip at a low transfer rate will raise activity by 10%.
	else 
		M.add_chemical_effect(CE_BRAIN_REGEN, 30) //1 unit of Alkysine will raise brain activity by 7.5%.
		M.add_chemical_effect(CE_PAINKILLER, 10)
		M.dizziness = max(125, M.dizziness)
		M.make_dizzy(5)
		if(!(volume > 10))
			var/obj/item/organ/internal/brain/B = M.internal_organs_by_name[BP_BRAIN]
			if(B && M.species && M.species.has_organ[BP_BRAIN] && !isipc(M))
				if(prob(dose/5) && !B.has_trauma_type(BRAIN_TRAUMA_MILD))
					B.gain_trauma_type(pick(/datum/brain_trauma/mild/dumbness, /datum/brain_trauma/mild/muscle_weakness, /datum/brain_trauma/mild/colorblind)) //Handpicked suggested traumas considered less disruptive and conducive to roleplay.

/datum/reagent/alkysine/overdose(var/mob/living/carbon/M, var/alien, var/removed)
	M.hallucination = max(M.hallucination, 15)
	var/obj/item/organ/internal/brain/B = M.internal_organs_by_name[BP_BRAIN]
	if(B && M.species && M.species.has_organ[BP_BRAIN] && !isipc(M))
		if(prob(dose / 2) && !B.has_trauma_type(BRAIN_TRAUMA_SEVERE) && !B.has_trauma_type(BRAIN_TRAUMA_MILD) && !B.has_trauma_type(BRAIN_TRAUMA_SPECIAL))
			B.gain_trauma_type(/datum/brain_trauma/severe/paralysis, /datum/brain_trauma/severe/aphasia, /datum/brain_trauma/special/imaginary_friend)
	if(prob(dose))
		to_chat(M, SPAN_WARNING(pick("You have a painful headache!", "You feel a throbbing pain behind your eyes!")))
	..()

/datum/reagent/oculine
	name = "Oculine"
	description = "Oculine is a complex organ-regenerative medication which increases the rate at which cells can differentiate into those required to recover damage to ocular tissues."
	reagent_state = LIQUID
	color = "#C8A5DC"
	overdose = REAGENTS_OVERDOSE
	scannable = TRUE
	taste_mult = 0.33 //Specifically to cut the dull toxin taste out of foods using carrot
	taste_description = "dull toxin"

/datum/reagent/oculine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.eye_blurry = max(M.eye_blurry - 5 * removed, 0)
	M.eye_blind = max(M.eye_blind - 5 * removed, 0)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/internal/eyes/E = H.get_eyes(no_synthetic = TRUE)
		if(E && istype(E))
			if(E.damage > 0)
				E.damage = max(E.damage - 5 * removed, 0)

/datum/reagent/oculine/overdose(var/mob/living/carbon/M, var/alien, var/removed)
	M.hallucination = max(M.hallucination, 15)
	..()

/datum/reagent/peridaxon
	name = "Peridaxon"
	description = "Peridaxon is complex, broad-spectrum organ-regenerative medication which increases the rate at which cells can differentiate into organ cells to recover damaged organ tissues. The drug is hard on the body, leading to confusion and drowsiness."
	reagent_state = LIQUID
	color = "#561EC3"
	overdose = 10
	scannable = TRUE
	taste_description = "bitterness"

/datum/reagent/peridaxon/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		H.add_chemical_effect(CE_CLUMSY, 1)
		for(var/obj/item/organ/internal/I in H.internal_organs)
			if(I.organ_tag == BP_BRAIN)
				if(I.damage >= I.min_bruised_damage)
					continue
			if((I.damage > 0) && (I.robotic != 2)) //Peridaxon heals only non-robotic organs
				I.damage = max(I.damage - removed, 0)

/datum/reagent/peridaxon/overdose(var/mob/living/carbon/M, var/alien)
	M.dizziness = max(150, M.dizziness)
	M.make_dizzy(5)
	if(prob(dose / 2))
		to_chat(M, SPAN_DANGER("You feel your insides twisting and burning."))
		M.adjustHalLoss(5)

/datum/reagent/ryetalyn
	name = "Ryetalyn"
	description = "Ryetalyn is a novel, highly advanced, broad-spectrum medication, developed by Dominian scientists, which has varying clinical uses in treating genetic abnormalities including certain cancers, autoimmune conditions, and Hulk Syndrome."
	reagent_state = SOLID
	color = "#004000"
	overdose = REAGENTS_OVERDOSE
	taste_description = "acid"
	metabolism = 1
	metabolism_min = 0.25

/datum/reagent/ryetalyn/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	var/needs_update = M.mutations.len > 0

	M.mutations = list()
	M.disabilities = 0
	M.sdisabilities = 0

	// Might need to update appearance for hulk etc.
	if(needs_update && ishuman(M))
		var/mob/living/carbon/human/H = M
		H.update_mutations()

/datum/reagent/hyperzine
	name = "Hyperzine"
	description = "Hyperzine is a complex cardio-synaptic stimulant drug designed to increase the performance of the body. Downsides include violent muscle spasms and tremors."
	reagent_state = LIQUID
	color = "#FF3300"
	metabolism = REM * 0.15
	overdose = 15
	var/datum/modifier = null
	taste_description = "acid"
	metabolism_min = REM * 0.025
	breathe_met = REM * 0.15 * 0.5

/datum/reagent/hyperzine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(prob(5))
		M.emote(pick("twitch", "blink_r", "shiver"))
	M.add_chemical_effect(CE_SPEEDBOOST, 1)
	M.add_chemical_effect(CE_PULSE, 1)
	if (!modifier)
		modifier = M.add_modifier(/datum/modifier/stimulant, MODIFIER_REAGENT, src, _strength = 1, override = MODIFIER_OVERRIDE_STRENGTHEN)
	
	if((locate(/datum/reagent/adrenaline) in M.reagents.reagent_list))
		if(M.reagents.get_reagent_amount(/datum/reagent/adrenaline) > 5) //So you can tolerate being attacked whilst hyperzine is in your system.
			overdose = volume/2 //Straight to overdose.

/datum/reagent/hyperzine/overdose(var/mob/living/carbon/M, var/alien, var/removed)
	M.adjustNutritionLoss(5*removed)	
	M.add_chemical_effect(CE_PULSE, 2)
	if(prob(5))
		to_chat(M, SPAN_DANGER(pick("Your heart is beating rapidly!", "Your chest hurts!")))
	if(prob(dose / 3))
		M.visible_message("<b>[M]</b> twitches violently, grimacing.", "You twitch violently and feel yourself sprain a joint.")
		M.take_organ_damage(5 * removed, 0)
		M.adjustHalLoss(15)

/datum/reagent/hyperzine/Destroy()
	QDEL_NULL(modifier)
	return ..()

#define ETHYL_INTOX_COST	3 //The cost of power to remove one unit of intoxication from the patient
#define ETHYL_REAGENT_POWER	20 //The amount of power in one unit of ethyl

//Ethylredoxrazine will remove a number of units of alcoholic substances from the patient's blood and stomach, equal to its pow
//Once all alcohol in the body is neutralised, it will then cure intoxication and sober the patient up
/datum/reagent/ethylredoxrazine
	name = "Ethylredoxrazine"
	description = "Ethylredoxrazine is a powerful medication which oxidises ethanol in the bloodstream, reducing the burden on the liver to complete this task. Ethylredoxrazine also blocks the reuptake of neurotransmitters responsible for symptoms of alcohol intoxication."
	reagent_state = SOLID
	color = "#605048"
	metabolism = REM * 0.3
	overdose = REAGENTS_OVERDOSE
	scannable = TRUE
	taste_description = "bitterness"

/datum/reagent/ethylredoxrazine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	var/P = removed * ETHYL_REAGENT_POWER
	var/DP = dose * ETHYL_REAGENT_POWER//tiny optimisation

	//These status effects will now take a little while for the dose to build up and remove them
	M.dizziness = max(0, M.dizziness - DP)
	M.drowsyness = max(0, M.drowsyness - DP)
	M.stuttering = max(0, M.stuttering - DP)
	M.confused = max(0, M.confused - DP)

	var/datum/reagents/ingested = M.get_ingested_reagents()
	if(ingested)
		for(var/datum/reagent/R in ingested.reagent_list)
			if(istype(R, /datum/reagent/alcohol/ethanol))
				var/amount = min(P, R.volume)
				ingested.remove_reagent(R.type, amount)
				P -= amount
				if (P <= 0)
					return

	//Even though alcohol is not supposed to be injected, ethyl removes it from the blood too,
	//as a treatment option if someone was dumb enough to do this
	if(M.bloodstr)
		for(var/datum/reagent/R in M.bloodstr.reagent_list)
			if(istype(R, /datum/reagent/alcohol/ethanol))
				var/amount = min(P, R.volume)
				M.bloodstr.remove_reagent(R.type, amount)
				P -= amount
				if (P <= 0)
					return

	if (M.intoxication && P > 0)
		var/amount = min(M.intoxication * ETHYL_INTOX_COST, P)
		M.intoxication = max(0, (M.intoxication - (amount / ETHYL_INTOX_COST)))
		P -= amount

/datum/reagent/hyronalin
	name = "Hyronalin"
	description = "Hyronalin is a complex anti-radiation medication which specifically targets ionised cells, reducing their cell division rate to prevent their growth before gradually destroying these afflicted cells."
	reagent_state = LIQUID
	color = "#408000"
	metabolism = REM * 0.25
	overdose = REAGENTS_OVERDOSE
	scannable = TRUE
	taste_description = "bitterness"
	unaffected_species = IS_MACHINE
	var/last_taste_time = -10000

/datum/reagent/hyronalin/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(M.is_diona())
		if(last_taste_time + 950 < world.time) // Not to spam message
			to_chat(M, SPAN_DANGER("Your body withers as you feel a searing pain throughout."))
			last_taste_time = world.time
		metabolism = REM * 0.22
		M.adjustToxLoss(45 * removed) // Tested numbers myself
	else
		M.apply_radiation(-30 * removed)

/datum/reagent/hyronalin/overdose(var/mob/living/carbon/M, var/alien, var/removed)	
	if(prob(60))
		M.take_organ_damage(4 * removed, 0) //Hyronaline OD deals brute damage to the same degree as Arithrazine

/datum/reagent/arithrazine
	name = "Arithrazine"
	description = "Arithrazine is a recent improvement of Hyronalin, rapidly destroying any ionised cells, though this often leads to collateral cell damage, resulting in contusions across affected parts of the body."
	reagent_state = LIQUID
	color = "#008000"
	metabolism = REM * 0.25
	overdose = REAGENTS_OVERDOSE
	scannable = TRUE
	taste_description = "bitterness"
	unaffected_species = IS_MACHINE
	var/last_taste_time = -10000

/datum/reagent/arithrazine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(M.is_diona())
		if(last_taste_time + 450 < world.time) // Not to spam message
			to_chat(M, SPAN_DANGER("Your body withers as you feel a searing pain throughout."))
			last_taste_time = world.time
		metabolism = REM * 0.195
		M.adjustToxLoss(115 * removed) // Tested numbers myself
	else
		M.apply_radiation(-70 * removed)
		M.add_chemical_effect(CE_ITCH, dose/2)
		if(prob(60))
			M.take_organ_damage(4 * removed, 0)

/datum/reagent/arithrazine/overdose(var/mob/living/carbon/M, var/alien, var/removed)
	if(prob(50))
		M.take_organ_damage(6 * removed, 0) //Even more collateral damage dealt by arithrazine when overdosed.

/datum/reagent/thetamycin
	name = "Thetamycin"
	description = "Thetamycin is a complex, broad-spectrum antibiotic developed to treat wound infections, organ infections, and septicaemia, even those caused by superbugs with high anti-bacterial resistances."
	reagent_state = LIQUID
	color = "#41C141"
	od_minimum_dose = 1
	metabolism = REM * 0.05
	breathe_met = REM * 2 // .4 units per tick
	// touch is slow
	overdose = REAGENTS_OVERDOSE
	scannable = TRUE
	taste_description = "bitter gauze soaked in rubbing alcohol"
	fallback_specific_heat = 0.605 // assuming it's ethanol-based

/datum/reagent/thetamycin/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.add_chemical_effect(CE_EMETIC, dose/8) // chance per 2 second tick to cause vomiting
	M.add_chemical_effect(CE_ANTIBIOTIC, dose) // strength of antibiotics; amount absorbed, need >5 to be effective. takes 50 seconds to work

/datum/reagent/thetamycin/overdose(var/mob/living/carbon/M, var/alien)
	M.dizziness = max(150, M.dizziness)
	M.make_dizzy(5)

/datum/reagent/asinodryl
	name = "Asinodryl"
	description = "Asinodryl is an anti-emetic medication which acts by preventing the two regions in the brain responsible for vomiting from controlling the act of emesis."
	color = "#f5f2d0"
	taste_description = "bitterness"
	scannable = TRUE
	metabolism = REM * 0.25
	fallback_specific_heat = 1

/datum/reagent/asinodryl/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return
	M.add_chemical_effect(CE_ANTIEMETIC, dose/4) // 1u should suppress 2u thetamycin

/datum/reagent/coughsyrup
	name = "Cough Syrup"
	description = "A complex antitussive medication available OTC which is very effective at suppressing cough reflexes. The medication also acts as a very weak analgesic medication, leading to it being a very cheap recreational drug or precursor to other recreational drugs."
	scannable = TRUE
	reagent_state = LIQUID
	taste_description = "bitterness"
	color = "#402060"
	fallback_specific_heat = 0.605 // assuming it's ethanol-based
	breathe_met = REM * 2 // .4 units per tick
	// touch is slow

	glass_name = "glass of cough syrup"
	glass_desc = "You'd better not."

/datum/reagent/coughsyrup/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.add_chemical_effect(CE_PAINKILLER, 5) // very slight painkiller effect at low doses

/datum/reagent/coughsyrup/overdose(var/mob/living/carbon/human/M, var/alien, var/removed) // effects based loosely on DXM
	M.hallucination = max(M.hallucination, 40)
	M.add_chemical_effect(CE_PAINKILLER, 20) // stronger at higher doses
	if(prob(dose))
		M.vomit()
	if(prob(7))
		M.emote(pick("twitch", "drool", "moan", "giggle"))
	if(prob(7))
		M.add_chemical_effect(CE_NEUROTOXIC, 3 * removed)
	if(prob(50))
		M.drowsyness = max(M.drowsyness, 3)

/datum/reagent/cetahydramine
	name = "Cetahydramine"
	description = "Cetahydramine is a complex antihistamine medication available OTC which blocks the release of histamine, thus making it effective at suppressing allergies and sneezing. Cetahydramine can cause drowsiness in larger doses, making it an effective sleep aid."
	scannable = TRUE
	reagent_state = LIQUID
	taste_description = "bitterness"
	metabolism = REM * 0.05 // only performs its effects while in blood
	ingest_met = REM // .2 units per tick
	breathe_met = REM * 2 // .4 units per tick
	// touch is slow
	ingest_mul = 1
	fallback_specific_heat = 0.605 // assuming it's ethanol-based

/datum/reagent/cetahydramine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.add_chemical_effect(CE_NOITCH, dose * 2) // 5 units of cetahydramine will counter 10 units of dermaline/butazoline itching.
	if(prob(dose/2))
		M.drowsyness += 2

/datum/reagent/sterilizine
	name = "Sterilizine"
	description = "Sterilizine is a chemical product composed of bleach and anti-toxins which can thoroughly disinfect wound sites and any biohazardous waste."
	reagent_state = LIQUID
	color = "#C8A5DC"
	touch_met = 5
	taste_description = "burning bleach"
	germ_adjust = 20

/datum/reagent/sterilizine/affect_touch(var/mob/living/carbon/M, var/alien, var/removed)
	M.germ_level -= min(removed*20, M.germ_level)
	for(var/obj/item/I in M.contents)
		I.was_bloodied = null
	M.was_bloodied = null
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		for (var/obj/item/organ/external/E in H.organs)//For each external bodypart
			for (var/datum/wound/W in E.wounds)//We check each wound on that bodypart
				W.germ_level -= min(removed*germ_adjust, W.germ_level)//Clean the wound a bit. Note we only clean wounds on the part, not the part itself.
				if (W.germ_level <= 0)
					W.disinfected = 1//The wound becomes disinfected if fully cleaned

/datum/reagent/sterilizine/touch_obj(var/obj/O)
	O.germ_level -= min(volume*20, O.germ_level)
	O.was_bloodied = null

/datum/reagent/sterilizine/touch_turf(var/turf/T)
	T.germ_level -= min(volume*20, T.germ_level)
	for(var/obj/item/I in T.contents)
		I.was_bloodied = null
	for(var/obj/effect/decal/cleanable/blood/B in T)
		qdel(B)

/datum/reagent/leporazine
	name = "Leporazine"
	description = "Leporazine is a complex medication which improves thermal homeostasis, stabilising and regulating the body's core temperature. Leporazine often results in hyperventilation which should be monitored."
	reagent_state = LIQUID
	color = "#C8A5DC"
	overdose = REAGENTS_OVERDOSE
	scannable = TRUE
	taste_description = "bitterness"

/datum/reagent/leporazine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(!(volume > 20))
		if(M.bodytemperature > 310)
			M.bodytemperature = max(310, M.bodytemperature - (40 * TEMPERATURE_DAMAGE_COEFFICIENT))
		else if(M.bodytemperature < 311)
			M.bodytemperature = min(310, M.bodytemperature + (40 * TEMPERATURE_DAMAGE_COEFFICIENT))

/datum/reagent/leporazine/overdose(var/mob/living/carbon/M, var/alien)
	M.bodytemperature = max(M.bodytemperature - 2 * TEMPERATURE_DAMAGE_COEFFICIENT, 0)
	if(prob(2))
		M.emote("shiver")
	if(prob(2))
		to_chat(M, SPAN_WARNING("You feel very cold..."))

/* mental */

#define ANTIDEPRESSANT_MESSAGE_DELAY 1800 //3 minutes

/datum/reagent/mental
	name = null //Just like alcohol
	description = "Some nameless, experimental antidepressant that you should obviously not have your hands on."
	reagent_state = LIQUID
	color = "#FFFFFF"
	metabolism = 0.001 * REM
	metabolism_min = 0
	data = 0
	scannable = TRUE
	overdose = REAGENTS_OVERDOSE
	od_minimum_dose = 0.02
	taste_description = "bugs"
	ingest_mul = 1
	var/alchohol_affected = 1
	var/min_dose = 1
	var/messagedelay = ANTIDEPRESSANT_MESSAGE_DELAY
	var/list/goodmessage = list() //Messages when all your brain traumas are cured.
	var/list/badmessage = list() //Messages when you still have at least one brain trauma it's suppose to cure.
	var/list/worstmessage = list() //Messages when the user is at possible risk for more trauma
	var/list/suppress_traumas  //List of brain traumas that the medication temporarily suppresses, with the key being the brain trauma and the value being the minimum dosage required to cure. Negative values means that the trauma is temporarily gained on the value instead.
	var/list/dosage_traumas //List of brain traumas that the medication permanently adds at these dosages, with the key being the brain trauma and the value being base percent chance to add.
	var/list/withdrawal_traumas //List of withdrawl effects that the medication permanently adds during withdrawl, with the key being the brain trauma, and the value being the base percent chance to add.
	var/list/suppressing_reagents = list() // List of reagents that suppress the withdrawal effects, with the key being the reagent and the vlue being the minimum dosage required to suppress.

	fallback_specific_heat = 1.5

/datum/reagent/mental/affect_blood(var/mob/living/carbon/human/H, var/alien, var/removed)

	if(!istype(H) || max_dose < min_dose || (world.time < data && volume > removed) || messagedelay == -1)
		return
	//max_dose < min_dose and volume > removed prevents message startup/startdown spam if you're using something like a cigarette or similiar device that transfers a little bit of reagents at a time.
	//If in the case that a cigarette has a lower transfer rate than the metabolism rate, then message spam will occur since it's starting and stopping constantly.
	//This also prevents the whole code from working if the dosage is very small.

	var/hastrauma = 0 //whether or not the brain has trauma
	var/obj/item/organ/internal/brain/B = H.internal_organs_by_name[BP_BRAIN]
	var/bac = H.get_blood_alcohol()

	if(alchohol_affected && bac > 0.03)
		H.hallucination = max(H.hallucination, bac * 400)

	if(B) //You won't feel anything if you don't have a brain.
		for(var/datum/brain_trauma/BT in B.traumas)
			var/goal_volume = suppress_traumas[BT]
			if (volume >= goal_volume) // If the dosage is greater than the goal, then suppress the trauma.
				if(!BT.suppressed && !BT.permanent)
					BT.suppressed = 1
					BT.on_lose()
			else if(volume < goal_volume-1 && goal_volume > 0) // -1 So it doesn't spam back and forth constantly if reagents are being metabolized
				if(BT.suppressed)
					BT.suppressed = 0
					BT.on_gain()
					hastrauma = 1
		for(var/datum/brain_trauma/BT in dosage_traumas)
			var/percentchance = max(0,dosage_traumas[BT] - dose*10) // If you've been taking this medication for a while then side effects are rarer.
			if(!H.has_trauma_type(BT) && prob(percentchance))
				B.gain_trauma(BT,FALSE)
		if(volume < max_dose*0.25) //If you haven't been taking your regular dose, then cause issues.
			var/suppress_withdrawl = FALSE
			for(var/k in suppressing_reagents)
				var/datum/reagent/v = suppressing_reagents[k]
				if(H.reagents.has_reagent(v,k))
					suppress_withdrawl = TRUE
					break
			if(!suppress_withdrawl)
				if (H.shock_stage < 20 && worstmessage.len)
					to_chat(H, SPAN_DANGER("[pick(worstmessage)]"))
				messagedelay = initial(messagedelay) * 0.25
				for(var/k in withdrawal_traumas)
					var/datum/brain_trauma/BT = k
					var/percentchance = max(withdrawal_traumas[k] * (dose/20)) //The higher the dosage, the more likely it is do get withdrawal traumas.
					if(!H.has_trauma_type(BT) && prob(percentchance))
						B.gain_trauma(BT,FALSE)
		else if(hastrauma || volume < max_dose*0.5) //If your current dose is not high enough, then alert the player.
			if (H.shock_stage < 10 && badmessage.len)
				to_chat(H, SPAN_WARNING("[pick(badmessage)]"))
			messagedelay = initial(messagedelay) * 0.5
		else
			if (H.shock_stage < 5 && goodmessage.len)
				to_chat(H, SPAN_GOOD("[pick(goodmessage)]"))
			messagedelay = initial(messagedelay)

	data = world.time + (messagedelay SECONDS)

/datum/reagent/mental/nicotine
	name = "Nicotine"
	description = "Nicotine is an ancient stimulant and relaxant commonly found in tobacco products. It is very poisonous, unless at very low doses."
	reagent_state = LIQUID
	color = "#333333"
	metabolism = 0.0016 * REM
	overdose = 5
	od_minimum_dose = 3
	data = 0
	taste_description = "bitterness"
	goodmessage = list("You feel good.","You feel relaxed.","You feel alert and focused.")
	badmessage = list("You start to crave nicotine...")
	worstmessage = list("You need your nicotine fix!")
	suppress_traumas  = list(
		/datum/brain_trauma/mild/phobia = 0.1,
		/datum/brain_trauma/mild/muscle_weakness/ = 0.05
	)
	conflicting_reagent = null
	min_dose = 0.0064 * REM
	var/datum/modifier/modifier

/datum/reagent/mental/nicotine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	. = ..()
	M.add_chemical_effect(CE_PAINKILLER, 5)

/datum/reagent/mental/nicotine/overdose(var/mob/living/carbon/M, var/alien, var/removed, var/scale)
	. = ..()
	M.adjustOxyLoss(10 * removed * scale)
	M.Weaken(10 * removed * scale)
	M.add_chemical_effect(CE_PULSE, 0.5)

/datum/reagent/mental/corophenidate
	name = "Corophenidate"
	description = "Corophenidate is a new generation, psychoactive stimulant used in the treatment of ADHD and ADD. It has far fewer side effects than previous generations of CNS stimulants. Withdrawal symptoms include hallucinations and disruption of focus."
	reagent_state = LIQUID
	color = "#8888AA"
	metabolism = 0.01 * REM
	od_minimum_dose = 0.2
	data = 0
	taste_description = "paper"
	goodmessage = list("You feel focused.","You feel like you have no distractions.","You feel willing to work.")
	badmessage = list("You feel a little distracted...","You feel slight agitation...","You feel a dislike towards work...")
	worstmessage = list("You feel completely distrtacted...","You feel like you don't want to work...","You think you see things...")
	suppress_traumas  = list(
		/datum/brain_trauma/special/imaginary_friend = 20,
		/datum/brain_trauma/mild/hallucinations = 10,
		/datum/brain_trauma/mild/phobia/ = 10
	)
	dosage_traumas = list(
		/datum/brain_trauma/mild/hallucinations = 5
	)
	withdrawal_traumas = list(
		/datum/brain_trauma/mild/phobia/ = 5,
		/datum/brain_trauma/mild/hallucinations = 2
	)

/datum/reagent/mental/corophenidate/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.add_chemical_effect(CE_HALLUCINATE, -1)
	..()

/datum/reagent/mental/corophendiate/overdose(var/mob/living/carbon/M, var/alien)
	M.add_chemical_effect(CE_EMETIC, dose / 6)

/datum/reagent/mental/neurostabin
	name = "Neurostabin"
	description = "Neurostabin is a new generation, psychoactive drug used in the treatment of psychoses, and also has clinical significance in treating muscle weakness. It has far fewer side effects than previous generations of psychoactive drugs. Withdrawal symptoms include hallucinations and the development of phobias."
	reagent_state = LIQUID
	color = "#888888"
	metabolism = 0.01 * REM
	od_minimum_dose = 0.2
	data = 0
	taste_description = "bitterness"
	goodmessage = list("You do not feel the need to worry about simple things.","You feel calm and level-headed.","You feel fine.")
	badmessage = list("You feel a little blue.","You feel slight agitation...","You feel a little nervous...")
	worstmessage = list("You worry about the littlest thing...","You feel like you are at risk...","You think you see things...")
	suppress_traumas  = list(
		/datum/brain_trauma/mild/phobia/ = 2,
		/datum/brain_trauma/severe/split_personality = 10,
		/datum/brain_trauma/special/imaginary_friend = 20,
		/datum/brain_trauma/mild/muscle_weakness = 10
	)
	dosage_traumas = list(
		/datum/brain_trauma/mild/hallucinations = 5
	)
	withdrawal_traumas = list(
		/datum/brain_trauma/mild/phobia/ = 5,
		/datum/brain_trauma/mild/hallucinations = 2
	)

/datum/reagent/mental/neurostabin/overdose(var/mob/living/carbon/M, var/alien)
	M.add_chemical_effect(CE_EMETIC, dose / 6)

/datum/reagent/mental/parvosil
	name = "Parvosil"
	description = "Parvosil is a new generation, psychoactive drug used in the treatment of anxiety disorders such as phobias and social anxiety. It has far fewer side effects than previous generations of psychoactive drugs. Withdrawal symptoms include hallucinations and heightened anxiety."
	reagent_state = LIQUID
	color = "#88AA88"
	metabolism = 0.02 * REM
	od_minimum_dose = 0.4
	data = 0
	taste_description = "paper"
	goodmessage = list("You feel fine.","You feel rational.","You feel decent.")
	badmessage = list("You feel a little blue.","You feel slight agitation...","You feel a little nervous...")
	worstmessage = list("You worry about the littlest thing...","You feel like you are at risk...","You think you see things...")
	suppress_traumas  = list(
		/datum/brain_trauma/mild/phobia/ = 2
	)
	dosage_traumas = list(
		/datum/brain_trauma/mild/hallucinations = 5
	)
	withdrawal_traumas = list(
		/datum/brain_trauma/mild/phobia/ = 10,
		/datum/brain_trauma/mild/hallucinations = 5
	)
	suppressing_reagents = list(/datum/reagent/mental/neurostabin = 5)

/datum/reagent/mental/parvosil/overdose(var/mob/living/carbon/M, var/alien)
	M.add_chemical_effect(CE_EMETIC, dose / 6)

/datum/reagent/mental/minaphobin
	name = "Minaphobin"
	description = "Minaphobin is a new generation, psychoactive drug used in the treatment of anxiety disorders such as phobias and social anxiety. It has far fewer side effects than previous generations of psychoactive drugs. Withdrawal symptoms include hallucinations and heightened anxiety."
	reagent_state = LIQUID
	color = "#FF8888"
	metabolism = 0.01 * REM
	od_minimum_dose = 0.2
	data = 0
	taste_description = "duct tape"
	goodmessage = list("You feel relaxed.","You feel at ease.","You feel care free.")
	badmessage = list("You feel worried.","You feel slight agitation.","You feel nervous.")
	worstmessage = list("You worry about the littlest thing...","You feel like you are at risk...","You think you see things...")
	suppress_traumas  = list(
		/datum/brain_trauma/mild/phobia/ = 1,
		/datum/brain_trauma/severe/monophobia = 5
	)
	dosage_traumas = list(
		/datum/brain_trauma/mild/hallucinations = 5
	)
	withdrawal_traumas = list(
		/datum/brain_trauma/mild/phobia/ = 10,
		/datum/brain_trauma/mild/hallucinations = 10
	)
	suppressing_reagents = list(
		/datum/reagent/mental/neurostabin = 5,
		/datum/reagent/mental/parvosil = 5
	)

/datum/reagent/mental/minaphobin/overdose(var/mob/living/carbon/M, var/alien)
	M.add_chemical_effect(CE_EMETIC, dose / 6)

/datum/reagent/mental/emoxanyl
	name = "Emoxanyl"
	description = "Emoxanyl is a novel, psychoactive medication which increases cerebral circulation and is used to treat anxiety, depression, concussion, and epilepsy. It has fewer side effects than many other forms of psychoactive drugs. Withdrawal symptoms include hallucinations and heightened anxiety."
	reagent_state = LIQUID
	color = "#88FFFF"
	metabolism = 0.01 * REM
	od_minimum_dose = 0.2
	data = 0
	taste_description = "scotch tape"
	goodmessage = list("You feel at ease.","Your mind feels healthy..")
	badmessage = list("You worry about the littlest thing.","Your head starts to feel weird...","You think you see things.")
	worstmessage = list("You start to overreact to sounds and movement...","Your head feels really weird.","You are really starting to see things...")
	messagedelay = ANTIDEPRESSANT_MESSAGE_DELAY * 0.75
	suppress_traumas  = list(
		/datum/brain_trauma/mild/concussion = 5,
		/datum/brain_trauma/mild/phobia/ = 5
	)
	dosage_traumas = list(
		/datum/brain_trauma/mild/hallucinations = 5
	)
	withdrawal_traumas = list(
		/datum/brain_trauma/mild/phobia/ = 25,
		/datum/brain_trauma/mild/hallucinations = 25,
		/datum/brain_trauma/mild/concussion = 10
	)
	suppressing_reagents = list(
		/datum/reagent/mental/neurapan = 5,
		/datum/reagent/mental/minaphobin = 5,
		/datum/reagent/mental/neurostabin = 10,
		/datum/reagent/mental/parvosil = 10
	)

/datum/reagent/mental/emoxanyl/overdose(var/mob/living/carbon/M, var/alien)
	M.add_chemical_effect(CE_EMETIC, dose / 6)

/datum/reagent/mental/orastabin
	name = "Orastabin"
	description = "Orastabin is a new generation, complex psychoactive medication used in the treatment of anxiety disorders and speech impediments. It has fewer side effects than many other forms of psychoactive drugs. Withdrawal symptoms include hallucinations and heightened anxiety."
	reagent_state = LIQUID
	color = "#FF88FF"
	metabolism = 0.01 * REM
	od_minimum_dose = 0.2
	data = 0
	taste_description = "glue"
	goodmessage = list("You feel at ease.","Your mind feels healthy..","You feel unafraid to speak...")
	badmessage = list("You worry about the littlest thing.","You think you see things.")
	worstmessage = list("You start to overreact to sounds and movement...","You are really starting to see things...")
	messagedelay = ANTIDEPRESSANT_MESSAGE_DELAY * 0.75
	suppress_traumas  = list(
		/datum/brain_trauma/mild/phobia = 5,
		/datum/brain_trauma/mild/stuttering = 2,
		/datum/brain_trauma/severe/monophobia = 5
	)
	dosage_traumas = list(
		/datum/brain_trauma/mild/hallucinations = 10
	)
	withdrawal_traumas = list(
		/datum/brain_trauma/mild/phobia/ = 25,
		/datum/brain_trauma/mild/hallucinations = 25
	)
	suppressing_reagents = list(
		/datum/reagent/mental/emoxanyl = 5,
		/datum/reagent/mental/neurapan = 5,
		/datum/reagent/mental/minaphobin = 5,
		/datum/reagent/mental/neurostabin = 10,
		/datum/reagent/mental/parvosil = 10
	)

/datum/reagent/mental/orastabin/overdose(var/mob/living/carbon/M, var/alien)
	M.add_chemical_effect(CE_EMETIC, dose / 6)

/datum/reagent/mental/neurapan
	name = "Neurapan"
	description = "Neurapan is a groundbreaking, expensive antipsychotic medication capable of treating a whole spectrum of mental illnesses, including psychoses, anxiety disorders, Tourette Syndrome and depression, and can alleviate symptoms of stress. Neurapan can be addictive due to its tranquilising effects, and withdrawal symptoms are dangerous."
	reagent_state = LIQUID
	color = "#FF4444"
	overdose = 10 
	metabolism = 0.02 * REM
	od_minimum_dose = 0.4
	data = 0
	taste_description = "tranquility"
	goodmessage = list("Your mind feels as one.","You feel incredibly comfortable.","Your body feels good.","Your thoughts are clear.", "You feel stress free.", "Nothing is bothering you anymore.")
	badmessage = list("The tranquility fades and you start hearing voices...","You think you see things...","You remember the stress you left behind...","You want attention...")
	worstmessage = list("You think you start seeing things...","You swear someone inside you spoke to you...","You hate feeling alone...","You feel really upset...")
	messagedelay = ANTIDEPRESSANT_MESSAGE_DELAY * 0.5
	suppress_traumas  = list(
		/datum/brain_trauma/severe/split_personality = 5,
		/datum/brain_trauma/special/imaginary_friend = 10,
		/datum/brain_trauma/mild/stuttering = 2,
		/datum/brain_trauma/mild/speech_impediment = 5,
		/datum/brain_trauma/severe/monophobia = 5,
		/datum/brain_trauma/mild/hallucinations = 5,
		/datum/brain_trauma/mild/muscle_spasms = 10,
		/datum/brain_trauma/mild/tourettes = 10
	)
	dosage_traumas = list(
		/datum/brain_trauma/severe/pacifism = 25
	)
	withdrawal_traumas = list(
		/datum/brain_trauma/mild/hallucinations = 100,
		/datum/brain_trauma/severe/split_personality = 10,
		/datum/brain_trauma/special/imaginary_friend = 20,
		/datum/brain_trauma/mild/tourettes = 50,
		/datum/brain_trauma/severe/monophobia = 50
	)
	suppressing_reagents = list(
		/datum/reagent/mental/orastabin = 20,
		/datum/reagent/mental/emoxanyl = 20,
		/datum/reagent/mental/neurapan = 20,
		/datum/reagent/mental/minaphobin = 20
	)

/datum/reagent/mental/neurapan/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.add_chemical_effect(CE_HALLUCINATE, -2)
	..()

/datum/reagent/mental/neurapan/overdose(var/mob/living/carbon/M, var/alien)
	M.add_chemical_effect(CE_PACIFIED, 1)
	M.eye_blurry = max(M.eye_blurry, 30)
	if((locate(/datum/reagent/oxycomorphine) in M.reagents.reagent_list))
		M.ear_deaf = 20
		M.drowsyness = max(M.drowsyness, 10)
		M.make_dizzy(15)
		if(prob(3))
			to_chat(M, SPAN_GOOD(pick("You lose all sense of connection to the real world.", "Everything is so tranquil.", "You feel dettached from reality.", "Your feel disconnected from your body.", "You are aware of nothing but your conscious thoughts.")))
	else
		if(prob(3))
			to_chat(M, SPAN_GOOD(pick("Stress was an inconvenience that you are now free of.", "You feel somewhat dettached from reality.", "You can feel time passing by and it no longer bothers you.")))

/datum/reagent/mental/nerospectan
	name = "Nerospectan"
	description = "Nerospectan is an expensive, new generation anti-psychotic medication capable of treating a whole spectrum of mental illnesses, including psychoses, anxiety disorders, Tourette Syndrome and depression, and can alleviate symptoms of stress. Nerospectan can be addictive due to its tranquilising effects, and withdrawal symptoms are dangerous."
	reagent_state = LIQUID
	color = "#FF8844"
	metabolism = 0.02 * REM
	od_minimum_dose = 0.4
	data = 0
	taste_description = "paint"
	goodmessage = list("Your mind feels as one.","You feel comfortable speaking.","Your body feels good.","Your thoughts are pure.","Your body feels responsive.","You can handle being alone.")
	badmessage = list("You start hearing voices...","You think you see things...","You want a friend...")
	worstmessage = list("You think you start seeing things...","You swear someone inside you spoke to you...")
	messagedelay = ANTIDEPRESSANT_MESSAGE_DELAY * 0.5
	suppress_traumas  = list(
		/datum/brain_trauma/severe/split_personality = 5,
		/datum/brain_trauma/special/imaginary_friend = 10,
		/datum/brain_trauma/mild/stuttering = 1,
		/datum/brain_trauma/mild/speech_impediment = 2,
		/datum/brain_trauma/severe/monophobia = 2,
		/datum/brain_trauma/mild/muscle_spasms = 5,
		/datum/brain_trauma/mild/tourettes = 10
	)
	dosage_traumas = list(
		/datum/brain_trauma/severe/pacifism = 25
	)
	withdrawal_traumas = list(
		/datum/brain_trauma/mild/hallucinations = 200,
		/datum/brain_trauma/severe/split_personality = 50,
		/datum/brain_trauma/special/imaginary_friend = 50
	)
	suppressing_reagents = list(
		/datum/reagent/mental/orastabin = 20,
		/datum/reagent/mental/emoxanyl = 20,
		/datum/reagent/mental/neurapan = 20,
		/datum/reagent/mental/minaphobin = 20
	)

/datum/reagent/mental/nerospectan/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.add_chemical_effect(CE_HALLUCINATE, -2)
	..()

/datum/reagent/mental/nerospectan/overdose(var/mob/living/carbon/M, var/alien)
	M.add_chemical_effect(CE_EMETIC, dose / 6)

/datum/reagent/mental/truthserum
	name = "Truth Serum"
	description = "Truth Serum is an expensive and very unethical psychoactive drug capable of inhibiting defensive measures and reasoning in regards to communication, resulting in those under the effects of the drug to be very open to telling the truth."
	reagent_state = LIQUID
	color = "#888888"
	metabolism = 0.05 * REM
	od_minimum_dose = 1
	data = 0
	taste_description = "something"
	goodmessage = list("You feel like you have nothing to hide.","You feel compelled to spill your secrets.","You feel like you can trust those around you.")
	badmessage = list()
	worstmessage = list()
	suppress_traumas  = list(
		/datum/brain_trauma/mild/tourettes = 1
	)
	dosage_traumas = list(
		/datum/brain_trauma/severe/pacifism = 25
	)
	messagedelay = 30
	ingest_mul = 1

/datum/reagent/mental/truthserum/overdose(var/mob/living/carbon/M, var/alien)
	M.add_chemical_effect(CE_EMETIC, dose / 6)

/datum/reagent/mental/vaam
	name = "V'krexi Amino Acid Mixture"
	description = "A mixture of several high-energy amino acids, based on the secretions and saliva of V'krexi larvae."
	reagent_state = LIQUID
	color = "#bcd827"
	metabolism = 0.4 * REM
	overdose = 20
	data = 0
	taste_description = "bitterness"
	metabolism_min = 0.5
	breathe_mul = 0
	goodmessage = list("You feel great.","You feel full of energy.","You feel alert and focused.")
	badmessage = list("You can't think straight...","You're sweating heavily...","Your heart is racing...")
	worstmessage = list("You feel incredibly lightheaded!","You feel incredibly dizzy!")
	suppress_traumas  = list(
		/datum/brain_trauma/mild/muscle_weakness/ = 0.01
	)
	var/datum/modifier/modifier

/datum/reagent/mental/vaam/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	. = ..()
	M.add_chemical_effect(CE_PAINKILLER, 5)
	M.drowsyness = 0

/datum/reagent/mental/vaam/overdose(var/mob/living/carbon/human/M, var/alien, var/removed, var/scale)
	. = ..()
	M.adjustOxyLoss(1 * removed * scale)
	M.Weaken(10 * removed * scale)
	M.make_jittery(20)
	M.make_dizzy(10)

	if (prob(10))
		to_chat(M, pick("You feel nauseous", "Ugghh....", "Your stomach churns uncomfortably", "You feel like you're about to throw up", "You feel queasy","You feel pressure in your abdomen"))

	if (prob(dose))
		M.vomit()


/datum/reagent/mental/kokoreed
	name = "Koko Reed Juice"
	description = "Juice from the Koko reed plant. Causes unique mental effects in Unathi."
	reagent_state = LIQUID
	color = "#008000"
	metabolism = 0.0016 * REM
	overdose = 5
	od_minimum_dose = 3
	data = 0
	taste_description = "sugar"
	goodmessage = list("You feel pleasantly warm.","You feel like you've been basking in the sun.","You feel focused and warm...")
	badmessage = list()
	worstmessage = list()
	suppress_traumas  = list()
	conflicting_reagent = null
	min_dose = 0.0064 * REM
	var/datum/modifier/modifier

/datum/reagent/mental/kokoreed/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	. = ..()
	if(M.bodytemperature > 310)
		M.bodytemperature = max(310, M.bodytemperature - (5 * TEMPERATURE_DAMAGE_COEFFICIENT))

/datum/reagent/mental/kokoreed/overdose(var/mob/living/carbon/M, var/alien, var/removed, var/scale)
	. = ..()
	if(isunathi(M))
		if (!modifier)
			modifier = M.add_modifier(/datum/modifier/stimulant, MODIFIER_REAGENT, src, _strength = 1, override = MODIFIER_OVERRIDE_STRENGTHEN)

/datum/reagent/cataleptinol
	name = "Cataleptinol"
	description = "Cataleptinol is a highly advanced, expensive medication capable of regenerating the most damaged of brain tissues. Cataleptinol is used in the treatment of dumbness, cerebral blindness, cerebral paralysis and aphasia. The drug is more effective when the patient's core temperature is below 170K."
	reagent_state = LIQUID
	color = "#FFFF00"
	metabolism = REM //0.2u/tick
	overdose = 15
	scannable = TRUE
	taste_description = "bitterness"
	metabolism_min = REM * 0.25
	var/list/curable_traumas = list(
		/datum/brain_trauma/mild/dumbness/,
		/datum/brain_trauma/severe/blindness/,
		/datum/brain_trauma/severe/paralysis/,
		/datum/brain_trauma/severe/total_colorblind/,
		/datum/brain_trauma/severe/aphasia/
	)

/datum/reagent/cataleptinol/affect_blood(var/mob/living/carbon/human/M, var/alien, var/removed)
	M.add_chemical_effect(CE_PAINKILLER, 10)
	M.dizziness = max(100, M.dizziness)
	M.make_dizzy(5)
	var/chance = dose*removed
	if(M.bodytemperature < 170)
		chance = (chance*4) + 5
		M.add_chemical_effect(CE_BRAIN_REGEN, 30) //1 unit of cryo-tube Cataleptinol will raise brain activity by 10%.
	else
		M.add_chemical_effect(CE_BRAIN_REGEN, 20) //1 unit of Cataleptinol will raise brain activity by 5%.

	if(prob(chance))
		M.cure_trauma_type(pick(curable_traumas))

/datum/reagent/cataleptinol/overdose(var/mob/living/carbon/M, var/alien, var/removed)
	M.hallucination = max(M.hallucination, 15)
	var/obj/item/organ/internal/brain/B = M.internal_organs_by_name[BP_BRAIN]
	if(B && M.species && M.species.has_organ[BP_BRAIN] && !isipc(M))
		if(prob(dose / 2) && !B.has_trauma_type(BRAIN_TRAUMA_SEVERE) && !B.has_trauma_type(BRAIN_TRAUMA_MILD) && !B.has_trauma_type(BRAIN_TRAUMA_SPECIAL))
			B.gain_trauma_type(pick(/datum/brain_trauma/severe/paralysis, /datum/brain_trauma/severe/aphasia, /datum/brain_trauma/mild/dumbness, /datum/brain_trauma/mild/muscle_weakness, /datum/brain_trauma/mild/colorblind, /datum/brain_trauma/special/imaginary_friend))
	if(prob(5))
		to_chat(M, SPAN_WARNING(pick("You have a painful headache!", "You feel a throbbing pain behind your eyes!")))
	..()


//Things that are not cured/treated by medication:
//Gerstmann Syndrome
//Cerebral Near-Blindness
//Mutism
//Cerebral Blindness
//Narcolepsy
//Discoordination

/datum/reagent/fluvectionem
	name = "Fluvectionem"
	description = "Fluvectionem is a complex anti-toxin medication that is capable of purging the bloodstream of toxic reagents. The drug is capable of neutralising the most difficult of compounds and acts very fast, however it is inefficient and results in benign waste products that can be damaging to the liver."
	color = "#222244"
	metabolism = 0.5 * REM
	overdose = REAGENTS_OVERDOSE
	scannable = TRUE
	taste_description = "thick salt"
	reagent_state = SOLID

/datum/reagent/fluvectionem/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	var/is_overdosed = overdose && (volume > overdose) && (dose > od_minimum_dose)
	if(is_overdosed)
		removed *= 2

	var/amount_to_purge = removed*4 //Every unit removes 4 units of other chemicals
	var/amount_purged = 0

	for(var/datum/reagent/selected in M.reagents.reagent_list)
		if(selected == src)
			continue
		if(selected.type == /datum/reagent/blood && !is_overdosed)
			continue
		var/local_amount = min(amount_to_purge, selected.volume)
		M.reagents.remove_reagent(selected.type, local_amount)
		amount_to_purge -= local_amount
		amount_purged += local_amount
		if(amount_to_purge <= 0)
			break

	M.adjustToxLoss(removed + amount_purged*0.5) //15u has the potential to do 15 + 30 toxin damage in 30 seconds

	. = ..()

/datum/reagent/pulmodeiectionem
	name = "Pulmodeiectionem"
	description = "Pulmodeiectionem is a complex anti-toxin medication that is capable of purging the lungs of toxic reagents by damaging the mucous lining of the bronchi and trachea, allowing particulate to be coughed out of the lungs. Pulmodeiectionem works only when inhaled and can cause long-term damage to the lungs."
	color = "#550055"
	metabolism = 2 * REM
	overdose = 10
	scannable = TRUE
	taste_description = "coarse dust"
	reagent_state = SOLID

/datum/reagent/pulmodeiectionem/affect_breathe(var/mob/living/carbon/human/H, var/alien, var/removed)
	if(istype(H))
		var/obj/item/organ/L = H.internal_organs_by_name[BP_LUNGS]
		if(istype(L) && !L.robotic && !L.is_broken())
			var/amount_to_purge = removed*5 //Every unit removes 5 units of other chemicals.
			for(var/datum/reagent/selected in H.breathing.reagent_list)
				if(selected == src)
					continue
				var/local_amount = min(amount_to_purge, selected.volume)
				H.breathing.remove_reagent(selected.type, local_amount)
				amount_to_purge -= local_amount
				if(amount_to_purge <= 0)
					break

			H.adjustOxyLoss(2*removed) //Every unit deals 2 oxy damage
			if(prob(50)) //Cough uncontrolably.
				H.emote("cough")
				H.add_chemical_effect(CE_PNEUMOTOXIC, 0.2*removed)
	. = ..()

/datum/reagent/pulmodeiectionem/affect_ingest(var/mob/living/carbon/human/H, var/alien, var/removed)
	if(volume > 5)
		if(prob(50))
			H.visible_message("<b>[H]</b> splutters, coughing up a cloud of purple dust.", "You cough up a cloud of purple dust.")
			volume = volume - 10
		else
			H.adjustOxyLoss(2)
			H.add_chemical_effect(CE_PNEUMOTOXIC, 0.1)
		
/datum/reagent/pulmodeiectionem/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.adjustToxLoss(2 * removed)
	M.add_chemical_effect(CE_ITCH, dose)

/datum/reagent/pneumalin
	name = "Pneumalin"
	description = "Pneumalin is a powerful, organ-regenerative medication that increases the rate at which lung tissues are regenerated. Pneumalin only works when inhaled, and overdosing can lead to severe bradycardia."
	color = "#8154b4"
	overdose = 15
	scannable = TRUE
	taste_description = "fine dust"
	reagent_state = SOLID

/datum/reagent/pneumalin/affect_breathe(var/mob/living/carbon/human/H, var/alien, var/removed)
	H.adjustOxyLoss(removed) //Every unit heals 1 oxy damage
	H.add_chemical_effect(CE_PNEUMOTOXIC, -removed * 1.5)
	H.add_chemical_effect(CE_PULSE, -1)

	var/obj/item/organ/internal/lungs/L = H.internal_organs_by_name[BP_LUNGS]
	if(istype(L) && !BP_IS_ROBOTIC(L))
		L.rescued = FALSE
		L.damage = max(L.damage - (removed * 1.5), 0)

	. = ..()

/datum/reagent/pneumalin/overdose(var/mob/living/carbon/human/H, var/alien, var/removed)
	H.add_chemical_effect(CE_PULSE, -dose * 0.33)

/datum/reagent/rezadone
	name = "Rezadone"
	description = "Rezadone is an extremely expensive, ground-breaking miracle drug. The compound is capable of treating all kinds of physical damage, disfiguration, as well as genetic damage. Excessive consumption of rezadone can lead to severe disorientation."
	reagent_state = SOLID
	color = "#669900"
	overdose = REAGENTS_OVERDOSE
	scannable = TRUE
	taste_description = "sickness"

/datum/reagent/rezadone/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.adjustCloneLoss(-20 * removed)
	M.adjustOxyLoss(-2 * removed)
	M.heal_organ_damage(20 * removed, 20 * removed)
	M.adjustToxLoss(-1 * removed)
	if(dose > 3)
		M.status_flags &= ~DISFIGURED
	if(dose > 10)
		M.make_dizzy(5)
		M.make_jittery(5)

/datum/reagent/verunol
	name = "Verunol Syrup"
	description = "A complex emetic medication that causes the patient to vomit due to gastric irritation and the stimulating of the vomit centres of the brain."
	reagent_state = LIQUID
	color = "#280f0b"
	overdose = REAGENTS_OVERDOSE
	scannable = TRUE
	taste_description = "sweet syrup"

/datum/reagent/verunol/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	if (prob(10+dose))
		to_chat(M, pick("You feel nauseous!", "Your stomach churns uncomfortably.", "You feel like you're about to throw up.", "You feel queasy.", "You feel bile in your throat."))

	M.add_chemical_effect(CE_EMETIC, dose)

/datum/reagent/verunol/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.adjustToxLoss(2 * removed) //If you inject it you're doing it wrong

/datum/reagent/azoth
	name = "Azoth"
	description = "Azoth is a miraculous medicine, capable of healing internal injuries."
	reagent_state = LIQUID
	color = "#BF0000"
	taste_description = "bitter metal"
	overdose = 5
	fallback_specific_heat = 1.2

/datum/reagent/azoth/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		for (var/A in H.organs)
			var/obj/item/organ/external/E = A
			if(E.status & ORGAN_TENDON_CUT)
				E.status &= ~ORGAN_TENDON_CUT
				return 1

			if(E.status & ORGAN_ARTERY_CUT)
				E.status &= ~ORGAN_ARTERY_CUT
				return 1

			if(E.status & ORGAN_BROKEN)
				E.status &= ~ORGAN_BROKEN
				E.stage = 0
				return 1

/datum/reagent/azoth/overdose(var/mob/living/carbon/M, var/alien)
	M.adjustBruteLoss(5)

/datum/reagent/adipemcina
	name = "Adipemcina"
	description = "Adipemcina is a complex, organ-regenerative medication that increases the rate at which cells differentiate into myocardial cells. Adipemcina overdoses result in severe liver damage and vomiting."
	reagent_state = LIQUID
	color = "#008000"
	overdose = REAGENTS_OVERDOSE
	scannable = TRUE
	taste_description = "bitterness"

/datum/reagent/adipemcina/affect_blood(var/mob/living/carbon/human/M, var/alien, var/removed)
	M.add_chemical_effect(CE_CARDIOTOXIC, -removed*2)
	var/obj/item/organ/internal/heart/H = M.internal_organs_by_name[BP_HEART]
	if(istype(H) && !BP_IS_ROBOTIC(H))
		H.damage = max(H.damage - (removed * 2), 0)
	..()

/datum/reagent/adipemcina/overdose(var/mob/living/carbon/human/M, var/alien)
	M.add_chemical_effect(CE_EMETIC, dose / 6)
	if(istype(M))
		if(prob(25))
			M.add_chemical_effect(CE_HEPATOTOXIC, 1)

/datum/reagent/saline
	name = "Saline Plus"
	description = "Saline Plus is an expensive improvement upon the various saline solutions of old. Saline Plus has wide clinical applications in the treatment of dehydration and hypovolaemia, with no more debates as to whether it is effective or not."
	reagent_state = LIQUID
	scannable = TRUE
	metabolism = 1.5
	overdose = 5 // Low overdose and fast metabolism to necessitate IV drip usage
	od_minimum_dose = 10
	color = "#0064C877"
	taste_description = "premium salty water"
	unaffected_species = IS_MACHINE
	ingest_mul = 0
	breathe_mul = 0 

/datum/reagent/saline/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if((M.hydration > M.max_hydration) > CREW_HYDRATION_OVERHYDRATED)
		M.adjustHydrationLoss(-removed*2)
	else
		M.adjustHydrationLoss(-removed*5)
	if(volume < 3)
		M.add_chemical_effect(CE_BLOODRESTORE, 4 * removed)
	
/datum/reagent/saline/overdose(var/mob/living/carbon/M, var/alien)
	M.confused = max(M.confused, 20)
	M.make_jittery(5)
	if(prob(2))
		M.emote("twitch")

/datum/reagent/adrenaline
	name = "Adrenaline"
	description = "Adrenaline is a hormone used as a drug to treat cardiac arrest and other cardiac dysrhythmias resulting in diminished or absent cardiac output."
	taste_description = "rush"
	fallback_specific_heat = 1
	reagent_state = LIQUID
	color = "#c8a5dc"
	scannable = TRUE
	overdose = 20
	metabolism = 0.1
	value = 2
	breathe_mul = 0
	ingest_mul = 0

/datum/reagent/adrenaline/affect_blood(var/mob/living/carbon/human/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return
	if(dose < 1)	//not that effective after initial rush
		M.add_chemical_effect(CE_PAINKILLER, min(15*volume, 35))
		M.add_chemical_effect(CE_PULSE, 1)
	else
		M.add_chemical_effect(CE_PAINKILLER, min(10*volume, 15))
		M.add_chemical_effect(CE_PULSE, 2)
	if(dose > 5)
		M.make_jittery(5)
	if(volume >= 5 && M.is_asystole())
		remove_self(5)
		if(M.resuscitate())
			var/obj/item/organ/internal/heart = M.internal_organs_by_name[BP_HEART]
			M.add_chemical_effect(CE_CARDIOTOXIC, heart.max_damage * 0.15)

//Secret Chems
/datum/reagent/elixir
	name = "Elixir of Life"
	description = "A mythical substance, the cure for the ultimate illness."
	color = "#ffd700"
	affects_dead = 1
	taste_description = "eternal blissfulness"
	fallback_specific_heat = 2

/datum/reagent/elixir/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(ishuman(M))
		if(M && M.stat == DEAD)
			M.adjustOxyLoss(-rand(15,20))
			M.visible_message(SPAN_DANGER("\The [M] shudders violently!"))
			M.stat = 0

/datum/reagent/pacifier
	name = "Paxazide"
	description = "Paxazide is an expensive and unethical, psychoactive drug used to pacify people, suppressing regions of the brain responsible for anger and violence. Paxazide can be addictive due to its tranquilising effects, though withdrawal symptoms are scarce."
	reagent_state = LIQUID
	color = "#1ca9c9"
	overdose = REAGENTS_OVERDOSE
	taste_description = "numbness"

/datum/reagent/pacifier/affect_blood(var/mob/living/carbon/H, var/alien, var/removed)
	H.add_chemical_effect(CE_PACIFIED, 1)

/datum/reagent/pacifier/overdose(var/mob/living/carbon/H, var/alien)
	H.add_chemical_effect(CE_EMETIC, dose / 6)

/datum/reagent/rmt
	name = "Regenerative-Muscular Tissue Supplements"
	description = "RMT Supplement is a bioengineered, fast-acting growth factor that specifically helps recover bone and muscle mass caused by prolonged zero-gravity adaptations. It can also be used to treat chronic muscle weakness."
	reagent_state = LIQUID
	scannable = TRUE
	color = "#AA8866"
	overdose = 30
	metabolism = 0.1 * REM
	taste_description = "sourness"
	fallback_specific_heat = 1

/datum/reagent/rmt/overdose(var/mob/living/carbon/H, var/alien)
	if(prob(2))
		to_chat(H, SPAN_WARNING(pick("Your muscles are stinging a bit.", "Your muscles ache.")))
