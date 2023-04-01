/mob/living/carbon/teshari/Value(var/base)
	. = ..()
	if(species)
		. *= species.rarity_value