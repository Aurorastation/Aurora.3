/datum/modifier/food
	var/regen_added = 0
	var/stamina_added = 0
	var/nutrition_added = 0

/datum/modifier/food/activate()
	..()
	var/mob/living/L = target
	if(istype(L))
		regen_added = L.stamina_recovery + strength*0.03
		stamina_added = L.max_stamina + strength
		if(strength < 0)
			nutrition_added = -strength
		L.stamina_recovery += regen_added
		L.max_stamina += stamina_added
		L.nutrition += nutrition_added

/datum/modifier/food/deactivate()
	..()
	var/mob/living/L = target
	if(istype(L))
		L.stamina_recovery -= regen_added
		L.max_stamina -= stamina_added
		L.nutrition -= nutrition_added

/datum/modifier/food/custom_override(var/datum/modifier/existing)
	if((strength > 0 && existing.strength) > 0 || (strength < 0 && existing.strength < 0))
		existing.duration += duration
		existing.strength = (existing.strength + strength) / 2
		qdel(src)
		return existing
	else
		START_PROCESSING(SSmodifiers, src)
		LAZYADD(target.modifiers, src)
		activate()
		return src