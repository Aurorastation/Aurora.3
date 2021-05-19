// Mechanical mobs don't care about the atmosphere and cannot be hurt by tasers.
// They're also immune to poisons as they're entirely metal, however this also makes most of them vulnerable to shocks.
// They can also be hurt by EMP.

/mob/living/simple_animal/mechanical
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0

/mob/living/simple_animal/mechanical/isSynthetic()
	return TRUE

/mob/living/simple_animal/mechanical/adjustHalLoss(amount)
	return FALSE

/mob/living/simple_animal/mechanical/adjustToxLoss(amount)
	return FALSE

/mob/living/simple_animal/mechanical/adjustOxyLoss(amount)
	return FALSE