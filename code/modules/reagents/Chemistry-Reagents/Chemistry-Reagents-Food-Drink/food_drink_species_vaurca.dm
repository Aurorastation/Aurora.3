/singleton/reagent/kois
	name = "K'ois"
	description = "A thick goopy substance, rich in K'ois nutrients."
	metabolism = REM * 4
	var/nutriment_factor = 10
	var/injectable = 0
	color = "#dcd9cd"
	taste_description = "boiled cabbage"
	unaffected_species = IS_MACHINE
	var/kois_type = 1
	fallback_specific_heat = 0.75
	value = 0.5

/singleton/reagent/kois/affect_ingest(var/mob/living/carbon/human/M, var/alien, var/removed, var/datum/reagents/holder)
	if(!ishuman(M))
		return
	var/is_vaurcalike = (alien == IS_VAURCA)
	if(!is_vaurcalike)
		var/obj/item/organ/internal/parasite/P = M.internal_organs_by_name["blackkois"]
		if(istype(P) && P.stage >= 3)
			is_vaurcalike = TRUE
	if(is_vaurcalike)
		M.heal_organ_damage(1.4 * removed, 1.6 * removed)
		M.adjustNutritionLoss(-nutriment_factor * removed)
	else
		infect(M, alien, removed)

/singleton/reagent/kois/affect_blood(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	if(ishuman(M))
		infect(M, alien, removed)

/singleton/reagent/kois/affect_chem_effect(mob/living/carbon/M, alien, removed, datum/reagents/holder)
	var/is_vaurcalike = (alien == IS_VAURCA)
	if(!is_vaurcalike)
		var/obj/item/organ/internal/parasite/P = M.internal_organs_by_name["blackkois"]
		if(istype(P) && P.stage >= 3)
			is_vaurcalike = TRUE
	if(is_vaurcalike)
		M.add_chemical_effect(CE_BLOODRESTORE, 6 * removed)

/singleton/reagent/kois/proc/infect(var/mob/living/carbon/human/H, var/alien, var/removed)
	var/obj/item/organ/internal/parasite/P = H.internal_organs_by_name["blackkois"]
	if((alien != IS_VAURCA) && !(istype(P) && P.stage >= 3))
		H.adjustToxLoss(1 * removed)
		switch(kois_type)
			if(1) //Normal
				if(!H.internal_organs_by_name["kois"] && prob(5*removed))
					var/obj/item/organ/external/affected = H.get_organ(BP_CHEST)
					var/obj/item/organ/internal/parasite/kois/infest = new()
					infest.replaced(H, affected)
			if(2) //Modified
				if(!H.internal_organs_by_name["blackkois"] && prob(10*removed))
					var/obj/item/organ/external/affected = H.get_organ(BP_HEAD)
					var/obj/item/organ/internal/parasite/blackkois/infest = new()
					infest.replaced(H, affected)

/singleton/reagent/kois/clean
	name = "Filtered K'ois"
	description = "A strange, ketchup-like substance, filled with K'ois nutrients."
	color = "#dce658"
	taste_description = "cabbage soup"
	kois_type = 0
	fallback_specific_heat = 1

	glass_icon_state = "glass_kois"
	glass_name = "glass of filtered k'ois"
	glass_desc = "A strange, ketchup-like substance, filled with K'ois nutrients."

/singleton/reagent/kois/black
	name = "Modified K'ois"
	description = "A thick goopy substance, rich in K'ois nutrients. This sample appears to be modified."
	color = "#31004A"
	taste_description = "tar"
	kois_type = 2
	fallback_specific_heat = 0.5

//
// Food
//
/singleton/reagent/nakarka
	name = "Nakarka Cheese"
	color = "#5bbd22"
	taste_description = "sharp tangy cheese"
	reagent_state = SOLID
	taste_mult = 3

/singleton/reagent/nakarka/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed, var/datum/reagents/holder)
	..()
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(prob(10) && !(alien in list(IS_VAURCA, IS_SKRELL, IS_DIONA, IS_UNATHI)))
			var/list/nemiik_messages = list(
				"Your stomache feels a bit unsettled...",
				"Your throat tingles slightly...",
				"You feel like you may need the restroom soon...",
				"Your stomach hurts a little bit...",
				"You feel the need to burp."
			)
			to_chat(H, SPAN_WARNING(pick(nemiik_messages)))
