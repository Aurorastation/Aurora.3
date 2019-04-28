/datum/reagent/drink/tea/messastea
	name = "Messa's Warmth"
	id = "messa_tea"
	description = "A form of tea. From Adhomai. Descriptive."
	color = "#101000"
	taste_description = "bitter, with a sweet aftertaste"

	glass_icon_state = "bigteacup"
	glass_name = "Messa's Warmth"
	glass_desc = "A form of tea. From Adhomai, typically."

/datum/reagent/drink/tea/messastea/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.drowsyness = max(0, M.drowsyness - 6 * removed)
	M.hallucination = max(0, M.hallucination - 9 * removed)
	M.heal_organ_damage(0, 3 * removed)
	M.adjustToxLoss(-1 * removed)

/datum/chemical_reaction/messastea
	name = "messa's warmth"
	id = "messa_tea"
	result = "messa_tea"
	result_amount = 15
	required_reagents = list("kelotane" = 3, "honey" = 2, "water" = 10)

/datum/reagent/drink/tea/srendarrtea
	name = "S'rrendar's Light"
	id = "srrendar_tea"
	description = "A form of tea. From Adhomai. Descriptive."
	color = "#d0f0c0"
	taste_description = "sharp and strong peppery tea"

	glass_icon_state = "bigteacup"
	glass_name = "S'rrendar's Light"
	glass_desc = "A form of tea. From Adhomai, typically."

/datum/reagent/drink/tea/srendarrtea/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.drowsyness = max(0, M.drowsyness - 6 * removed)
	M.hallucination = max(0, M.hallucination - 9 * removed)
	M.heal_organ_damage(5 * removed, 0)
	M.add_chemical_effect(CE_PAINKILLER, 5)

/datum/chemical_reaction/srendarrtea
	name = "S'rrendar's Light"
	id = "srrendar_tea"
	result = "srrendar_tea"
	result_amount = 20
	required_reagents = list("bicaridine" = 3, "nicotine" = 3, "water" = 9)