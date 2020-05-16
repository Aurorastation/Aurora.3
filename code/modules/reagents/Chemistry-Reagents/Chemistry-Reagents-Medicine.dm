/* General medicine */

/datum/reagent/norepinephrine
	name = "Norepinephrine"
	id = "norepinephrine"
	description = "Norepinephrine is a chemical that narrows blood vessels, raises blood pressure, and helps the blood pump more efficiently. Commonly used to stabilize patients."
	reagent_state = LIQUID
	color = "#00BFFF"
	overdose = REAGENTS_OVERDOSE * 2
	metabolism = REM * 0.5
	metabolism_min = REM * 0.125
	breathe_mul = 0.5
	scannable = 1
	taste_description = "bitterness"
	var/datum/modifier/modifier

/datum/reagent/norepinephrine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.add_chemical_effect(CE_STABLE)
	M.add_chemical_effect(CE_PAINKILLER, 25)

/datum/reagent/norepinephrine/Destroy()
	QDEL_NULL(modifier)
	return ..()

/datum/reagent/bicaridine
	name = "Bicaridine"
	id = "bicaridine"
	description = "Bicaridine is an analgesic medication and can be used to treat blunt trauma. Lasts twice as long when inhaled, however it is generally twice as weak."
	reagent_state = LIQUID
	color = "#BF0000"
	overdose = REAGENTS_OVERDOSE
	scannable = 1
	metabolism = REM * 0.5
	taste_description = "bitterness"
	taste_mult = 3

/datum/reagent/bicaridine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.heal_organ_damage(5 * removed, 0)

/datum/reagent/bicaridine/overdose(var/mob/living/carbon/M, var/alien)
	..()//Bicard overdose heals arterial bleeding
	var/mob/living/carbon/human/H = M
	for(var/obj/item/organ/external/E in H.organs)
		if(E.status & ORGAN_ARTERY_CUT && prob(2))
			E.status &= ~ORGAN_ARTERY_CUT

/datum/reagent/kelotane
	name = "Kelotane"
	id = "kelotane"
	description = "Kelotane is a drug used to treat burns."
	reagent_state = LIQUID
	color = "#FFA800"
	overdose = REAGENTS_OVERDOSE
	scannable = TRUE
	metabolism = REM * 0.5
	taste_description = "bitterness"

/datum/reagent/kelotane/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(!(locate(/datum/reagent/dermaline) in M.reagents.reagent_list))
		M.heal_organ_damage(0, 6 * removed)

/datum/reagent/dermaline
	name = "Dermaline"
	id = "dermaline"
	description = "Dermaline is the next step in burn medication. Works twice as good as kelotane and enables the body to restore even the direst heat-damaged tissue."
	reagent_state = LIQUID
	color = "#FF8000"
	fallback_specific_heat = 1
	scannable = TRUE
	metabolism = REM * 0.5
	overdose = REAGENTS_OVERDOSE * 0.5
	taste_mult = 1.5

/datum/reagent/dermaline/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.heal_organ_damage(0, 12 * removed)

/datum/reagent/dylovene
	name = "Dylovene"
	id = "dylovene"
	description = "Dylovene is a broad-spectrum antitoxin."
	reagent_state = LIQUID
	color = "#00A000"
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
			ingested.remove_reagent(R.id, removing)
			return
	for(var/datum/reagent/R in M.reagents.reagent_list)
		if((remove_generic && istype(R, /datum/reagent/toxin)) || (R.type in remove_toxins))
			M.reagents.remove_reagent(R.id, removing)
			return

/datum/reagent/dexalin
	name = "Dexalin"
	id = "dexalin"
	description = "Dexalin is used in the treatment of oxygen deprivation. The medication is twice as powerful and lasts twice as long when inhaled."
	reagent_state = LIQUID
	color = "#0080FF"
	overdose = REAGENTS_OVERDOSE
	scannable = 1
	taste_description = "bitterness"
	metabolism = REM
	breathe_met = REM * 0.5
	breathe_mul = 2
	var/strength = 6

/datum/reagent/dexalin/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_VOX)
		M.adjustToxLoss(removed * strength)
	M.add_chemical_effect(CE_OXYGENATED, strength/6) // 1 for dexalin, 2 for dexplus
	holder.remove_reagent("lexorin", strength/3 * removed)

//Hyperoxia causes brain and eye damage
/datum/reagent/dexalin/overdose(var/mob/living/carbon/M, var/alien, var/removed)
	M.add_chemical_effect(CE_NEUROTOXIC, removed * (strength / 6))
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/internal/eyes/E = H.get_eyes(no_synthetic = TRUE)
		if(E && istype(E))
			E.take_damage(removed * (strength / 12))

/datum/reagent/dexalin/plus
	name = "Dexalin Plus"
	id = "dexalinp"
	fallback_specific_heat = 1
	description = "Dexalin Plus is used in the treatment of oxygen deprivation. It is highly effective, and is twice as powerful and lasts twice as long when inhaled."
	color = "#0040FF"
	overdose = REAGENTS_OVERDOSE * 0.5
	strength = 12

/datum/reagent/tricordrazine
	name = "Tricordrazine"
	id = "tricordrazine"
	description = "Tricordrazine is a highly potent stimulant, originally derived from cordrazine. Can be used to treat a wide range of injuries, however it does not work when inhaled. Has different healing properties depending on the chemical's temperature."
	reagent_state = LIQUID
	color = "#8040FF"
	scannable = 1
	fallback_specific_heat = 1
	taste_description = "bitterness"
	breathe_mul = 0
	metabolism = REM * 0.25

/datum/reagent/tricordrazine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	var/power = 1 + Clamp((get_temperature() - (T0C + 20))*0.1,-0.5,0.5)
	//Heals 10% more brute and less burn for every 1 celcius above 20 celcius, up 50% more/less.
	//Heals 10% more burn and less brute for every 1 celcius below 20 celcius, up to 50% more/less.
	M.adjustOxyLoss(-6 * removed)
	M.heal_organ_damage(3 * removed * power,3 * removed * power)
	M.adjustToxLoss(-3 * removed)

/datum/reagent/atropine
	name = "Atropine"
	id = "atropine"
	description = "Atropine is an emergency stabilizing reagent designed to heal suffocation, blunt trauma, and burns in critical condition. Side effects include toxins increase, muscle weakness, and increased heartrate."
	reagent_state = LIQUID
	metabolism = 1
	color = "#FF40FF"
	scannable = 1
	taste_description = "bitterness"
	breathe_mul = 0

/datum/reagent/atropine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	var/reagent_strength = Clamp(1 - (M.health/100),0.1,2)
	M.adjustOxyLoss(-8 * removed * reagent_strength)
	M.adjustBruteLoss(-8 * removed * reagent_strength)
	M.adjustFireLoss(-8 * removed * reagent_strength)
	M.adjustToxLoss(2 * removed)
	M.add_chemical_effect(CE_PULSE, 1)
	if(prob(10))
		to_chat(M, span("warning", "Your muscles spasm and you find yourself unable to stand!"))
		M.Weaken(3)

/datum/reagent/cryoxadone
	name = "Cryoxadone"
	id = "cryoxadone"
	description = "A chemical mixture with almost magical healing powers. Its main limitation is that the targets body temperature must be under 170K for it to metabolise correctly."
	reagent_state = LIQUID
	color = "#8080FF"
	metabolism = REM * 0.5
	scannable = 1
	taste_description = "sludge"

/datum/reagent/cryoxadone/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(M.bodytemperature < 170)
		M.add_chemical_effect(CE_PULSE, -2)
		M.adjustCloneLoss(-10 * removed)
		M.adjustOxyLoss(-10 * removed)
		M.heal_organ_damage(10 * removed, 10 * removed)

/datum/reagent/clonexadone
	name = "Clonexadone"
	id = "clonexadone"
	description = "A liquid compound similar to that used in the cloning process. Can be used to 'finish' the cloning process when used in conjunction with a cryo tube. Its main limitation is that the targets body temperature must be under 170K for it to metabolise correctly."
	reagent_state = LIQUID
	color = "#80BFFF"
	metabolism = REM * 0.5
	scannable = 1
	taste_description = "slime"

/datum/reagent/clonexadone/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(M.bodytemperature < 170)
		M.add_chemical_effect(CE_PULSE, -2)
		M.adjustCloneLoss(-30 * removed)
		M.adjustOxyLoss(-30 * removed)
		M.heal_organ_damage(30 * removed, 30 * removed)

/* Painkillers */

/datum/reagent/paracetamol
	name = "Paracetamol"
	id = "paracetamol"
	description = "Most probably know this as Tylenol, but this chemical is a mild, simple painkiller. Does not work when inhaled."
	reagent_state = LIQUID
	color = "#C8A5DC"
	overdose = 60
	scannable = 1
	metabolism = REM/10 // same as before when in blood, 0.02 units per tick
	ingest_met = REM * 2 // .4 units per tick
	breathe_met = REM * 4 // .8 units per tick
	taste_description = "sickness"
	metabolism_min = 0.005
	breathe_mul = 0

/datum/reagent/paracetamol/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.add_chemical_effect(CE_PAINKILLER, 50)
	M.add_chemical_effect(CE_NOFEVER, ((max_dose/2)^2-(dose-max_dose/2))/(max_dose/4)) // creates a smooth curve peaking at half the dose metabolised

/datum/reagent/paracetamol/overdose(var/mob/living/carbon/M, var/alien)
	..()
	M.hallucination = max(M.hallucination, 25)

/datum/reagent/tramadol
	name = "Tramadol"
	id = "tramadol"
	description = "Tramadol is a very effective painkiller designed for victims of heavy physical trauma. Does not work when inhaled."
	reagent_state = LIQUID
	color = "#CB68FC"
	overdose = 30
	scannable = 1
	metabolism = REM/10 // same as before when in blood, 0.02 units per tick
	ingest_met = REM * 2 // .4 units per tick
	breathe_met = REM * 4 // .8 units per tick
	taste_description = "sourness"
	metabolism_min = 0.005
	breathe_mul = 0

/datum/reagent/tramadol/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.add_chemical_effect(CE_PAINKILLER, 80)

/datum/reagent/tramadol/overdose(var/mob/living/carbon/M, var/alien)
	..()
	M.hallucination = max(M.hallucination, 40)

/datum/reagent/oxycodone
	name = "Oxycodone"
	id = "oxycodone"
	description = "Oxycodone is incredibly potent and very addictive painkiller. Do not mix with alcohol. Does not work when inhaled."
	reagent_state = LIQUID
	color = "#800080"
	overdose = 20
	metabolism = REM/10 // same as before when in blood, 0.02 units per tick
	ingest_met = REM * 2 // .4 units per tick
	breathe_met = REM * 4 // .8 units per tick
	taste_description = "bitterness"
	metabolism_min = 0.005
	breathe_mul = 0

/datum/reagent/oxycodone/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.add_chemical_effect(CE_PAINKILLER, 200)
	var/mob/living/carbon/human/H = M
	if(!istype(H))
		return
	var/bac = H.get_blood_alcohol()
	if(bac >= 0.02)
		M.hallucination = max(M.hallucination, bac * 300)
		M.druggy = max(M.druggy, bac * 100)

/datum/reagent/oxycodone/overdose(var/mob/living/carbon/M, var/alien)
	..()
	M.druggy = max(M.druggy, 20)
	M.hallucination = max(M.hallucination, 60)

/* Other medicine */

/datum/reagent/synaptizine
	name = "Synaptizine"
	id = "synaptizine"
	description = "Synaptizine is used to treat a robust array of conditions, such as drowsyness, paralysis, weakness, LSD overdose, hallucinations, and pain. Moderately poisonous, and should only be used as a last resort."
	reagent_state = LIQUID
	color = "#99CCFF"
	metabolism = REM * 0.05
	overdose = REAGENTS_OVERDOSE
	scannable = 1
	var/datum/modifier/modifier
	taste_description = "bitterness"
	metabolism_min = REM * 0.0125

/datum/reagent/synaptizine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.drowsyness = max(M.drowsyness - 5, 0)
	M.AdjustParalysis(-1)
	M.AdjustStunned(-1)
	M.AdjustWeakened(-1)
	holder.remove_reagent("mindbreaker", 5)
	M.hallucination = max(0, M.hallucination - 10)
	M.adjustToxLoss(5 * removed) // It used to be incredibly deadly due to an oversight. Not anymore!
	M.add_chemical_effect(CE_PAINKILLER, 40)
	M.add_chemical_effect(CE_HALLUCINATE, -1)
	if (!modifier)
		modifier = M.add_modifier(/datum/modifier/adrenaline, MODIFIER_REAGENT, src, _strength = 1, override = MODIFIER_OVERRIDE_STRENGTHEN)

/datum/reagent/synaptizine/Destroy()
	QDEL_NULL(modifier)
	return ..()

/datum/reagent/alkysine
	name = "Alkysine"
	id = "alkysine"
	description = "Alkysine is a drug used to lessen the damage to neurological tissue after a catastrophic injury. Can heal brain tissue."
	reagent_state = LIQUID
	color = "#FFFF66"
	metabolism = REM * 0.25
	overdose = REAGENTS_OVERDOSE
	scannable = 1
	taste_description = "bitterness"
	metabolism_min = REM * 0.075

/datum/reagent/alkysine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.add_chemical_effect(CE_BRAIN_REGEN, 30*removed)
	M.add_chemical_effect(CE_PAINKILLER, 10)

/datum/reagent/alkysine/overdose(var/mob/living/carbon/M, var/alien, var/removed)
	M.hallucination = max(M.hallucination, 25)
	..()

/datum/reagent/imidazoline
	name = "Imidazoline"
	id = "imidazoline"
	description = "Heals eye damage"
	reagent_state = LIQUID
	color = "#C8A5DC"
	overdose = REAGENTS_OVERDOSE
	scannable = 1
	taste_mult = 0.33 //Specifically to cut the dull toxin taste out of foods using carrot
	taste_description = "dull toxin"

/datum/reagent/imidazoline/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.eye_blurry = max(M.eye_blurry - 5 * removed, 0)
	M.eye_blind = max(M.eye_blind - 5 * removed, 0)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/internal/eyes/E = H.get_eyes(no_synthetic = TRUE)
		if(E && istype(E))
			if(E.damage > 0)
				E.damage = max(E.damage - 5 * removed, 0)

/datum/reagent/imidazoline/overdose(var/mob/living/carbon/M, var/alien, var/removed)
	M.hallucination = max(M.hallucination, 15)
	..()

/datum/reagent/peridaxon
	name = "Peridaxon"
	id = "peridaxon"
	description = "Used to encourage recovery of internal organs and nervous systems. Medicate cautiously."
	reagent_state = LIQUID
	color = "#561EC3"
	overdose = 10
	scannable = 1
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

/datum/reagent/ryetalyn
	name = "Ryetalyn"
	id = "ryetalyn"
	description = "Ryetalyn can cure all genetic abnomalities via a catalytic process."
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
	id = "hyperzine"
	description = "Hyperzine is a highly effective, long lasting, muscle stimulant. Lasts twice as long when inhaled."
	reagent_state = LIQUID
	color = "#FF3300"
	metabolism = REM * 0.15
	overdose = REAGENTS_OVERDOSE * 0.5
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

/datum/reagent/hyperzine/Destroy()
	QDEL_NULL(modifier)
	return ..()

#define ETHYL_INTOX_COST	3 //The cost of power to remove one unit of intoxication from the patient
#define ETHYL_REAGENT_POWER	20 //The amount of power in one unit of ethyl

//Ethylredoxrazine will remove a number of units of alcoholic substances from the patient's blood and stomach, equal to its pow
//Once all alcohol in the body is neutralised, it will then cure intoxication and sober the patient up
/datum/reagent/ethylredoxrazine
	name = "Ethylredoxrazine"
	id = "ethylredoxrazine"
	description = "A powerful oxidizer that reacts with ethanol."
	reagent_state = SOLID
	color = "#605048"
	metabolism = REM * 0.3
	overdose = REAGENTS_OVERDOSE
	scannable = 1
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
				ingested.remove_reagent(R.id, amount)
				P -= amount
				if (P <= 0)
					return

	//Even though alcohol is not supposed to be injected, ethyl removes it from the blood too,
	//as a treatment option if someone was dumb enough to do this
	if(M.bloodstr)
		for(var/datum/reagent/R in M.bloodstr.reagent_list)
			if(istype(R, /datum/reagent/alcohol/ethanol))
				var/amount = min(P, R.volume)
				M.bloodstr.remove_reagent(R.id, amount)
				P -= amount
				if (P <= 0)
					return

	if (M.intoxication && P > 0)
		var/amount = min(M.intoxication * ETHYL_INTOX_COST, P)
		M.intoxication = max(0, (M.intoxication - (amount / ETHYL_INTOX_COST)))
		P -= amount

/datum/reagent/hyronalin
	name = "Hyronalin"
	id = "hyronalin"
	description = "Hyronalin is a medicinal drug used to counter the effect of radiation poisoning."
	reagent_state = LIQUID
	color = "#408000"
	metabolism = REM * 0.25
	overdose = REAGENTS_OVERDOSE
	scannable = 1
	taste_description = "bitterness"
	unaffected_species = IS_MACHINE
	var/last_taste_time = -10000

/datum/reagent/hyronalin/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(M.is_diona())
		if(last_taste_time + 950 < world.time) // Not to spam message
			to_chat(M, "<span class='danger'>Your body withers as you feel a searing pain throughout.</span>")
			last_taste_time = world.time
		metabolism = REM * 0.22
		M.adjustToxLoss(45 * removed) // Tested numbers myself
	else
		M.apply_radiation(-30 * removed)

/datum/reagent/arithrazine
	name = "Arithrazine"
	id = "arithrazine"
	description = "Arithrazine is an unstable medication used for the most extreme cases of radiation poisoning."
	reagent_state = LIQUID
	color = "#008000"
	metabolism = REM * 0.25
	overdose = REAGENTS_OVERDOSE
	scannable = 1
	taste_description = "bitterness"
	unaffected_species = IS_MACHINE
	var/last_taste_time = -10000

/datum/reagent/arithrazine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(M.is_diona())
		if(last_taste_time + 450 < world.time) // Not to spam message
			to_chat(M, "<span class='danger'>Your body withers as you feel a searing pain throughout.</span>")
			last_taste_time = world.time
		metabolism = REM * 0.195
		M.adjustToxLoss(115 * removed) // Tested numbers myself
	else
		M.apply_radiation(-70 * removed)
		M.adjustToxLoss(-10 * removed)
		if(prob(60))
			M.take_organ_damage(4 * removed, 0)

/datum/reagent/deltamivir
	name = "Deltamivir"
	id = "deltamivir"
	description = "An interferon-delta type III antiviral agent."
	reagent_state = LIQUID
	color = "#C1C1C1"
	metabolism = REM * 0.05 // only performs its effects while in blood
	ingest_met = REM // .2 units per tick
	breathe_met = REM * 2 // .4 units per tick
	// touch is slow
	overdose = REAGENTS_OVERDOSE
	scannable = 1
	taste_description = "bitterness"
	fallback_specific_heat = 0.605 // assuming it's ethanol-based

/datum/reagent/deltamivir/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.add_chemical_effect(CE_FEVER, dose/12)

/datum/reagent/thetamycin
	name = "Thetamycin"
	id = "thetamycin"
	description = "A theta-lactam antibiotic, effective against wound and organ bacterial infections."
	reagent_state = LIQUID
	color = "#41C141"
	metabolism = REM * 0.05
	breathe_met = REM * 2 // .4 units per tick
	// touch is slow
	overdose = REAGENTS_OVERDOSE
	scannable = 1
	taste_description = "bitter gauze soaked in rubbing alcohol"
	fallback_specific_heat = 0.605 // assuming it's ethanol-based

/datum/reagent/thetamycin/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.add_chemical_effect(CE_EMETIC, dose/8) // chance per 2 second tick to cause vomiting
	M.add_chemical_effect(CE_ANTIBIOTIC, dose) // strength of antibiotics; amount absorbed, need >5 to be effective. takes 50 seconds to work

/datum/reagent/ondansetron
	name = "Ondansetron"
	id = "ondansetron"
	description = "Ondansetron is a medication used to prevent nausea and vomiting."
	color = "#f5f2d0"
	taste_description = "bitterness"
	metabolism = REM * 0.25
	fallback_specific_heat = 1

/datum/reagent/ondansetron/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return
	M.add_chemical_effect(CE_ANTIEMETIC, dose/4) // 1u should suppress 2u thetamycin

/datum/reagent/coughsyrup
	name = "Cough Syrup"
	id = "coughsyrup"
	description = "A chemical that is used as a cough suppressant in low doses, and in higher doses it can be recreationally (ab)used."
	scannable = 1
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

/datum/reagent/antihistamine
	name = "Diphenhydramine"
	id = "diphenhydramine"
	description = "A common antihistamine medication, also known as Benadryl. Known for causing drowsiness in larger doses."
	scannable = 1
	reagent_state = LIQUID
	taste_description = "bitterness"
	metabolism = REM * 0.05 // only performs its effects while in blood
	ingest_met = REM // .2 units per tick
	breathe_met = REM * 2 // .4 units per tick
	// touch is slow
	ingest_mul = 1
	fallback_specific_heat = 0.605 // assuming it's ethanol-based

/datum/reagent/antihistamine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(prob(dose/2))
		M.drowsyness += 2

/datum/reagent/sterilizine
	name = "Sterilizine"
	id = "sterilizine"
	description = "Sterilizes wounds in preparation for surgery and thoroughly removes blood."
	reagent_state = LIQUID
	color = "#C8A5DC"
	touch_met = 5
	taste_description = "bitterness"
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
	id = "leporazine"
	description = "Leporazine can be use to stabilize an individual's body temperature."
	reagent_state = LIQUID
	color = "#C8A5DC"
	overdose = REAGENTS_OVERDOSE
	scannable = 1
	taste_description = "bitterness"

/datum/reagent/leporazine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(M.bodytemperature > 310)
		M.bodytemperature = max(310, M.bodytemperature - (40 * TEMPERATURE_DAMAGE_COEFFICIENT))
	else if(M.bodytemperature < 311)
		M.bodytemperature = min(310, M.bodytemperature + (40 * TEMPERATURE_DAMAGE_COEFFICIENT))

/* mental */

#define ANTIDEPRESSANT_MESSAGE_DELAY 1800 //3 minutes

/datum/reagent/mental
	name = null //Just like alcohol
	id = "mental"
	description = "Some nameless, experimental antidepressant that you should obviously not have your hands on."
	reagent_state = LIQUID
	color = "#FFFFFF"
	metabolism = 0.001 * REM
	metabolism_min = 0
	data = 0
	scannable = 1
	overdose = REAGENTS_OVERDOSE
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

	if(alchohol_affected && bac > 0.01)
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
					to_chat(H,"<span class='danger'>[pick(worstmessage)]</span>")
				messagedelay = initial(messagedelay) * 0.25
				for(var/k in withdrawal_traumas)
					var/datum/brain_trauma/BT = k
					var/percentchance = max(withdrawal_traumas[k] * (dose/20)) //The higher the dosage, the more likely it is do get withdrawal traumas.
					if(!H.has_trauma_type(BT) && prob(percentchance))
						B.gain_trauma(BT,FALSE)
		else if(hastrauma || volume < max_dose*0.5) //If your current dose is not high enough, then alert the player.
			if (H.shock_stage < 10 && badmessage.len)
				to_chat(H,"<span class='warning'>[pick(badmessage)]</span>")
			messagedelay = initial(messagedelay) * 0.5
		else
			if (H.shock_stage < 5 && goodmessage.len)
				to_chat(H,"<span class='good'>[pick(goodmessage)]</span>")
			messagedelay = initial(messagedelay)

	data = world.time + (messagedelay SECONDS)

/datum/reagent/mental/nicotine
	name = "Nicotine"
	id = "nicotine"
	description = "Nicotine is a stimulant and relaxant commonly found in tobacco products. It is very poisonous, unless at very low doses."
	reagent_state = LIQUID
	color = "#333333"
	metabolism = 0.0016 * REM
	overdose = 3
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

/datum/reagent/tobacco
	name = "Tobacco"
	id = "tobacco"
	description = "Cut and processed tobacco leaves."
	taste_description = "tobacco"
	reagent_state = SOLID
	color = "#684b3c"
	data = 0
	scannable = 1
	var/nicotine = REM * 0.2
	fallback_specific_heat = 1
	value = 3

/datum/reagent/tobacco/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	M.reagents.add_reagent("nicotine")

/datum/reagent/tobacco/fine
	name = "Fine Tobacco"
	id = "tobaccofine"
	taste_description = "fine tobacco"
	data = 0
	value = 5

/datum/reagent/tobacco/bad
	name = "Terrible Tobacco"
	id = "tobaccobad"
	taste_description = "acrid smoke"
	data = 0
	value = 0

/datum/reagent/mental/methylphenidate
	name = "Methylphenidate"
	id = "methylphenidate"
	description = "Methylphenidate is an AHDH treatment drug that treats basic distractions such as phobias and hallucinations at moderate doses. Withdrawl effects are rare. Side effects are rare, and include hallucinations."
	reagent_state = LIQUID
	color = "#8888AA"
	metabolism = 0.01 * REM
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

/datum/reagent/mental/methylphenidate/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.add_chemical_effect(CE_HALLUCINATE, -1)
	..()

/datum/reagent/mental/fluvoxamine
	name = "Fluvoxamine"
	id = "fluvoxamine"
	description = "Fluvoxamine is safe and effective at treating basic phobias, as well as schizophrenia and muscle weakness at higher doses. Withdrawl effects are rare. Side effects are rare, and include hallucinations."
	reagent_state = LIQUID
	color = "#888888"
	metabolism = 0.01 * REM
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

/datum/reagent/mental/sertraline
	name = "Sertraline"
	id = "sertraline"
	description = "Sertraline is cheap, safe, and effective at treating basic phobias, however it does not last as long as other drugs of it's class. Withdrawl effects are uncommon. Side effects are rare."
	reagent_state = LIQUID
	color = "#88AA88"
	metabolism = 0.02 * REM
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
	suppressing_reagents = list(/datum/reagent/mental/fluvoxamine = 5)

/datum/reagent/mental/escitalopram
	name = "Escitalopram"
	id = "escitalopram"
	description = "Escitalopram is expensive, safe and very effective at treating basic phobias as well as advanced phobias like monophobia. A common side effect is drowsiness, and a rare side effect is hallucinations. Withdrawl effects are uncommon."
	reagent_state = LIQUID
	color = "#FF8888"
	metabolism = 0.01 * REM
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
		/datum/reagent/mental/fluvoxamine = 5,
		/datum/reagent/mental/sertraline = 5
	)

/datum/reagent/mental/paroxetine
	name = "Paroxetine"
	id = "paroxetine"
	description = "Paroxetine is effective at treating basic phobias while also preventing the body from overheating. Side effects are rare, and include hallucinations. Withdrawl effects are frequent and unsafe."
	reagent_state = LIQUID
	color = "#AA8866"
	metabolism = 0.01 * REM
	data = 0
	taste_description = "bandaid"
	goodmessage = list("You do not feel the need to worry about simple things.","You feel calm and level-headed.","You feel decent.")
	badmessage = list("You worry about the littlest thing.","You feel like you are at risk.","You think you see things.")
	worstmessage = list("You start to overreact to sounds and movement...","Your hear dangerous thoughts in your head...","You are really starting to see things...")
	messagedelay = ANTIDEPRESSANT_MESSAGE_DELAY * 0.75
	suppress_traumas  = list(
		/datum/brain_trauma/mild/phobia/ = 5
	)
	dosage_traumas = list(
		/datum/brain_trauma/mild/hallucinations = 5
	)
	withdrawal_traumas = list(
		/datum/brain_trauma/mild/phobia/ = 25,
		/datum/brain_trauma/mild/hallucinations = 50
	)
	suppressing_reagents = list(
		/datum/reagent/mental/escitalopram = 5,
		/datum/reagent/mental/fluvoxamine = 10,
		/datum/reagent/mental/sertraline = 10
	)

/datum/reagent/mental/paroxetine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(M.bodytemperature > 310)
		M.bodytemperature = max(310, M.bodytemperature - removed*100)
	. = ..()

/datum/reagent/mental/duloxetine
	name = "Duloxetine"
	id = "duloxetine"
	description = "Duloxetine is effective at treating basic phobias and concussions. A rare side effect is hallucinations. Withdrawl effects are common."
	reagent_state = LIQUID
	color = "#88FFFF"
	metabolism = 0.01 * REM
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
		/datum/reagent/mental/paroxetine = 5,
		/datum/reagent/mental/escitalopram = 5,
		/datum/reagent/mental/fluvoxamine = 10,
		/datum/reagent/mental/sertraline = 10
	)

/datum/reagent/mental/venlafaxine
	name = "Venlafaxine"
	id = "venlafaxine"
	description = "Venlafaxine is effective at treating basic phobias, monophobia, and stuttering. Side effects are uncommon and include hallucinations. Withdrawl effects are common."
	reagent_state = LIQUID
	color = "#FF88FF"
	metabolism = 0.01 * REM
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
		/datum/reagent/mental/duloxetine = 5,
		/datum/reagent/mental/paroxetine = 5,
		/datum/reagent/mental/escitalopram = 5,
		/datum/reagent/mental/fluvoxamine = 10,
		/datum/reagent/mental/sertraline = 10
	)

/datum/reagent/mental/risperidone
	name = "Risperidone"
	id = "risperidone"
	description = "Risperidone is a potent antipsychotic medication used to treat schizophrenia, stuttering, speech impediment, monophobia, hallucinations, tourettes, and muscle spasms. Side effects are common and include pacifism. Withdrawl symptoms are dangerous and almost always occur."
	reagent_state = LIQUID
	color = "#FF4444"
	metabolism = 0.02 * REM
	data = 0
	taste_description = "cardboard"
	goodmessage = list("Your mind feels as one.","You feel comfortable speaking.","Your body feels good.","Your thoughts are pure.")
	badmessage = list("You start hearing voices...","You think you see things...","You feel really upset...","You want attention...")
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
		/datum/reagent/mental/venlafaxine = 20,
		/datum/reagent/mental/duloxetine = 20,
		/datum/reagent/mental/paroxetine = 20,
		/datum/reagent/mental/escitalopram = 20
	)

/datum/reagent/mental/risperidone/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.add_chemical_effect(CE_HALLUCINATE, -2)
	..()

/datum/reagent/mental/olanzapine
	name = "Olanzapine"
	id = "olanzapine"
	description = "Olanzapine is a high-strength, expensive antipsychotic medication used to treat schizophrenia, stuttering, speech impediment, monophobia, hallucinations, tourettes, and muscle spasms. Side effects are common and include pacifism. The medication metabolizes quickly, and withdrawl is dangerous."
	reagent_state = LIQUID
	color = "#FF8844"
	metabolism = 0.02 * REM
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
		/datum/reagent/mental/venlafaxine = 20,
		/datum/reagent/mental/duloxetine = 20,
		/datum/reagent/mental/paroxetine = 20,
		/datum/reagent/mental/escitalopram = 20
	)

/datum/reagent/mental/olanzapine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.add_chemical_effect(CE_HALLUCINATE, -2)
	..()

/datum/reagent/mental/truthserum
	name = "Truth serum"
	id = "truthserum"
	description = "This highly illegal, expensive, military strength truth serum is a must have for secret corporate interrogations. Do not ingest."
	reagent_state = LIQUID
	color = "#888888"
	metabolism = 0.05 * REM
	data = 0
	scannable = 0
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
	ingest_mul = 0 //Stomach acid will melt the nanobots

/datum/reagent/mental/bugjuice
	name = "V'krexi Amino Acid Mixture"
	id = "vaam"
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

/datum/reagent/mental/bugjuice/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	. = ..()
	M.add_chemical_effect(CE_PAINKILLER, 5)
	M.drowsyness = 0

/datum/reagent/mental/bugjuice/overdose(var/mob/living/carbon/human/M, var/alien, var/removed, var/scale)
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
	id = "kokoreed"
	description = "Juice from the Koko reed plant. Causes unique mental effects in Unathi."
	reagent_state = LIQUID
	color = "#008000"
	metabolism = 0.0016 * REM
	overdose = 3
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

/datum/reagent/mannitol
	name = "Mannitol"
	id = "mannitol"
	description = "Mannitol is a super strength chemical that heals brain tissue damage and cures dumbness, cerebral blindness, cerebral paralysis, colorblindness, and aphasia. More effective when the patient's body temperature is less than 170K."
	reagent_state = LIQUID
	color = "#FFFF00"
	metabolism = REM * 2 //0.4
	overdose = REAGENTS_OVERDOSE
	scannable = 1
	taste_description = "bitterness"
	metabolism_min = REM * 0.25
	var/list/curable_traumas = list(
		/datum/brain_trauma/mild/dumbness/,
		/datum/brain_trauma/severe/blindness/,
		/datum/brain_trauma/severe/paralysis/,
		/datum/brain_trauma/severe/total_colorblind/,
		/datum/brain_trauma/severe/aphasia/
	)

/datum/reagent/mannitol/affect_blood(var/mob/living/carbon/human/M, var/alien, var/removed)

	M.add_chemical_effect(CE_PAINKILLER, 10)
	var/chance = dose*removed
	if(M.bodytemperature < 170)
		chance = (chance*4) + 5
		M.add_chemical_effect(CE_BRAIN_REGEN, 30*removed)
	else
		M.add_chemical_effect(CE_BRAIN_REGEN, 10*removed)

	if(prob(chance))
		M.cure_trauma_type(pick(curable_traumas))



//Things that are not cured/treated by medication:
//Gerstmann Syndrome
//Cerebral Near-Blindness
//Mutism
//Cerebral Blindness
//Narcolepsy
//Discoordination

/datum/reagent/calomel
	name = "Calomel"
	id = "calomel"
	description = "A highly toxic medicine that quickly purges most chemicals from the bloodstream. Overdose causes bloodloss and more toxin buildup, however works twice as fast."
	color = "#222244"
	metabolism = 0.5 * REM
	overdose = 30
	scannable = 1
	taste_description = "thick salt"
	reagent_state = SOLID

/datum/reagent/calomel/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	var/is_overdosed = overdose && (dose > overdose)
	if(is_overdosed)
		removed *= 2

	var/amount_to_purge = removed*4 //Every unit removes 4 units of other chemicals
	var/amount_purged = 0

	for(var/datum/reagent/selected in M.reagents.reagent_list)
		if(selected == src)
			continue
		if(selected.id == "blood" && !is_overdosed)
			continue
		var/local_amount = min(amount_to_purge, selected.volume)
		M.reagents.remove_reagent(selected.id, local_amount)
		amount_to_purge -= local_amount
		amount_purged += local_amount
		if(amount_to_purge <= 0)
			break

	M.adjustToxLoss(removed + amount_purged*0.5) //15u has the potential to do 15 + 30 toxin damage in 30 seconds

	. = ..()

/datum/reagent/pulmodeiectionem
	name = "Pulmodeiectionem"
	id = "pulmodeiectionem"
	description = "A powdery chemical that damages the mucus lining in the the main broncus and the trachea, allowing particles to easily escape the lungs. Only works when inhaled. May cause long term damage to the lungs, and oxygen deprevation."
	color = "#550055"
	metabolism = 2 * REM
	overdose = 10
	scannable = 1
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
				H.breathing.remove_reagent(selected.id, local_amount)
				amount_to_purge -= local_amount
				if(amount_to_purge <= 0)
					break

			H.adjustOxyLoss(2*removed) //Every unit deals 2 oxy damage
			if(prob(75)) //Cough uncontrolably
				H.emote("cough")
				H.add_chemical_effect(CE_PNEUMOTOXIC, 0.2*removed)
	. = ..()

/datum/reagent/pneumalin
	name = "Pneumalin"
	id = "pneumalin"
	description = "A chemical that, when inhaled, restores tearing and bruising of the lungs. Overdosing can lower a patient's pulse to dangerous levels."
	color = "#8154b4"
	overdose = 15
	scannable = 1
	taste_description = "fine dust"
	reagent_state = SOLID

/datum/reagent/pneumalin/affect_breathe(var/mob/living/carbon/human/H, var/alien, var/removed)
	H.adjustOxyLoss(removed) //Every unit heals 1 oxy damage
	H.add_chemical_effect(CE_PNEUMOTOXIC, -removed * 1.5)
	H.add_chemical_effect(CE_PULSE, -1)
	. = ..()

/datum/reagent/pneumalin/overdose(var/mob/living/carbon/human/H, var/alien, var/removed)
	H.add_chemical_effect(CE_PULSE, -dose * 0.33)

/datum/reagent/rezadone
	name = "Rezadone"
	id = "rezadone"
	description = "A powder with almost magical properties, this substance can effectively treat genetic damage in humanoids, though excessive consumption has side effects."
	reagent_state = SOLID
	color = "#669900"
	overdose = REAGENTS_OVERDOSE
	scannable = 1
	taste_description = "sickness"

/datum/reagent/rezadone/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.adjustCloneLoss(-20 * removed)
	M.adjustOxyLoss(-2 * removed)
	M.heal_organ_damage(20 * removed, 20 * removed)
	M.adjustToxLoss(-20 * removed)
	if(dose > 3)
		M.status_flags &= ~DISFIGURED
	if(dose > 10)
		M.make_dizzy(5)
		M.make_jittery(5)

/datum/reagent/ipecac
	name = "Ipecac"
	id = "ipecac"
	description = "A simple emetic, Induces vomiting in the patient, emptying stomach contents"
	reagent_state = LIQUID
	color = "#280f0b"
	overdose = REAGENTS_OVERDOSE
	scannable = 1
	taste_description = "sweet syrup"

/datum/reagent/ipecac/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	if (prob(10+dose))
		to_chat(M, pick("You feel nauseous!", "Your stomach churns uncomfortably.", "You feel like you're about to throw up.", "You feel queasy.", "You feel bile in your throat."))

	M.add_chemical_effect(CE_EMETIC, dose)

/datum/reagent/ipecac/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.adjustToxLoss(2 * removed) //If you inject it you're doing it wrong

/datum/reagent/azoth
	name = "Azoth"
	id = "azoth"
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

/datum/reagent/adipemcina //Based on quinapril
	name = "Adipemcina"
	id = "adipemcina"
	description = "Adipemcina is a heart medication used for treating high blood pressure, heart failure, and diabetes. Causes vomiting and liver damage when overdosed."
	reagent_state = LIQUID
	color = "#008000"
	overdose = REAGENTS_OVERDOSE
	scannable = 1
	taste_description = "bitterness"

/datum/reagent/adipemcina/affect_blood(var/mob/living/carbon/human/M, var/alien, var/removed)
	M.add_chemical_effect(CE_CARDIOTOXIC, -removed*2)
	..()

/datum/reagent/adipemcina/overdose(var/mob/living/carbon/human/M, var/alien)
	if(istype(M))
		if(prob(25))
			M.add_chemical_effect(CE_HEPATOTOXIC, 1)
			M.vomit()

/datum/reagent/saline
	name = "Saline"
	id = "saline"
	description = "A liquid compound that restores hydration when injected directly into the bloodstream. Excellent at solving severe hydration problems. Yes, it's literally just saline."
	reagent_state = LIQUID
	color = "#1ca9c9"
	taste_description = "salty water"
	unaffected_species = IS_MACHINE

/datum/reagent/saline/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if( (M.hydration > M.max_hydration) > CREW_HYDRATION_OVERHYDRATED)
		M.adjustHydrationLoss(-removed*2)
	else
		M.adjustHydrationLoss(-removed*5)

/datum/reagent/coagulant
	name = "Coagulant"
	id = "coagulant"
	description = "A chemical that can temporarily stop the blood loss caused by internal wounds."
	reagent_state = LIQUID
	color = "#8b0000"
	overdose = REAGENTS_OVERDOSE
	taste_description = "bitterness"
	fallback_specific_heat = 1

/datum/reagent/adrenaline
	name = "Adrenaline"
	id = "adrenaline"
	description = "Adrenaline is a hormone used as a drug to treat cardiac arrest and other cardiac dysrhythmias resulting in diminished or absent cardiac output."
	taste_description = "rush"
	fallback_specific_heat = 1
	reagent_state = LIQUID
	color = "#c8a5dc"
	scannable = 1
	overdose = 20
	metabolism = 0.1
	value = 2

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
	id = "elixir_life"
	description = "A mythical substance, the cure for the ultimate illness."
	color = "#ffd700"
	affects_dead = 1
	taste_description = "eternal blissfulness"
	fallback_specific_heat = 2

/datum/reagent/elixir/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(ishuman(M))
		if(M && M.stat == DEAD)
			M.adjustOxyLoss(-rand(15,20))
			M.visible_message("<span class='danger'>\The [M] shudders violently!</span>")
			M.stat = 0

/datum/reagent/pacifier
	name = "Paxazide"
	id = "paxazide"
	description = "A mind altering chemical compound capable of suppressing violent tendencies."
	reagent_state = LIQUID
	color = "#1ca9c9"
	taste_description = "numbness"

/datum/reagent/pacifier/affect_blood(var/mob/living/carbon/H, var/alien, var/removed)
	H.add_chemical_effect(CE_PACIFIED, 1)

/datum/reagent/rmt
	name = "Regenerative-Muscular Tissue Supplements"
	id = "rmt"
	description = "A chemical rampantly used by those seeking to remedy the effects of prolonged zero-gravity adaptations."
	reagent_state = LIQUID
	color = "#AA8866"
	metabolism = 0.2 * REM
	taste_description = "sourness"
	fallback_specific_heat = 1
