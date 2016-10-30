/mob/living/proc/hide()
	set name = "Hide"
	set desc = "Allows to hide beneath tables or certain items. Toggled on or off."
	set category = "Abilities"

	if(stat == DEAD || paralysis || weakened || stunned || restrained())
		return

	if (layer != 2.45)
		layer = 2.45 //Just above cables with their 2.44
		src << text("\blue You are now hiding.")
	else
		layer = MOB_LAYER
		src << text("\blue You have stopped hiding.")

/mob/living/proc/devour()
	set category = "Abilities"
	set name = "Devour Creature"
	set desc = "Attempt to eat a nearby creature, swallowing it whole if small enough, or eating it piece by piece otherwise"
	var/list/choices = list()
	for(var/mob/living/C in view(1,src))

		if((!(src.Adjacent(C)) || C == src)) continue//cant steal nymphs right out of other gestalts

		if (C.is_diona() == DIONA_NYMPH)
			var/mob/living/carbon/alien/diona/D = C
			if (D.gestalt)
				continue
		choices.Add(C)

	var/mob/living/L = input(src,"Which creature do you wish to consume?") in null|choices

	attempt_devour(L, eat_types, mouth_size)

/*
/mob/living/verb/devourverb(var/mob/living/victim)//For situations where species inherent verbs isnt suitable
	set category = "Abilities"
	set name = "Devour Creature"
	set desc = "Attempt to eat a nearby creature, swallowing it whole if small enough, or eating it piece by piece otherwise"
	attempt_devour(victim, eat_types, mouth_size)
*/