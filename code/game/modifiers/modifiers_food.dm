/datum/modifier/food
	var/regen_added = 0
	var/stamina_added = 0
	var/message = null

/datum/modifier/food/activate()
	..()
	var/mob/living/L = target
	if(istype(L))
		regen_added += strength*0.03
		stamina_added += strength
		L.stamina_recovery += strength*0.03
		L.max_stamina += strength
		if(message)
			L << message

/datum/modifier/food/deactivate()
	..()
	var/mob/living/L = target
	if(istype(L))
		L.stamina_recovery -= regen_added
		L.max_stamina -= stamina_added
		regen_added = 0
		stamina_added = 0

/datum/modifier/food/custom_override(var/datum/modifier/existing)
	existing.duration += duration
	qdel(src)
	return existing

/datum/modifier/food/positive
	//Blank

/datum/modifier/food/negative
	//Blank

/datum/modifier/food/sugarcrash
	//Blank

/datum/modifier/food/sugarcrash/custom_validity()

	if (!isnull(duration) && duration <= 0)
		return 0

	if (target.reagents && target.reagents.has_reagent("sugar"))
		return 0

	return 1