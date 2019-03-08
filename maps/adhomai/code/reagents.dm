/datum/reagent/stone_dust
	name = "Stone Dust"
	id = "stone_dust"
	description = "Crystalline silica dust, harmful when inhaled."
	reagent_state = SOLID
	color = "#5a4d41"
	taste_description = "dust"
	specific_heat = 1

/datum/reagent/stone_dust/affect_breathe(var/mob/living/carbon/human/H, var/alien, var/removed)

/datum/reagent/stone_dust/affect_breathe(var/mob/living/carbon/human/H, var/alien, var/removed)
	. = ..()
	if(istype(H))
		if(prob(5))
			var/obj/item/organ/L = H.internal_organs_by_name["lungs"]
			if(istype(L) && !L.robotic)
				L.take_damage(1)