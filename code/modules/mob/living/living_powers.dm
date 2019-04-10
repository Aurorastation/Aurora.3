/mob/living/proc/hide()
	set name = "Hide"
	set desc = "Allows to hide beneath tables or certain items. Toggled on or off."
	set category = "Abilities"

	if(stat == DEAD || paralysis || weakened || stunned || restrained())
		return

	if (layer != 2.45)
		layer = 2.45 //Just above cables with their 2.44
		to_chat(src, text("<span class='notice'>You are now hiding.</span>"))
	else
		layer = MOB_LAYER
		to_chat(src, text("<span class='notice'>You have stopped hiding.</span>"))

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

		if (C in src)	// Just no.
			continue

		choices += C

	var/mob/living/L = input(src,"Which creature do you wish to consume?") in null|choices

	attempt_devour(L, eat_types, mouth_size)

/mob/living/verb/set_walk_speed()
	set category = "IC"
	set name = "Adjust walk speed"
	set desc = "Allows you to adjust your walking speed to a slower value than normal, or reset it. Does not make you faster."


	//First a quick block of code to calculate our normal/best movedelay
	var/delay = config.walk_speed + movement_delay()
	var/speed = 1 / (delay/10)
	var/newspeed
	var/list/options = list("No limit",speed*0.95,speed*0.9,speed*0.85,speed*0.8,speed*0.7,speed*0.6,speed*0.5, "Custom")


	var/response = input(src, "Your current walking speed is [speed] tiles per second. This menu allows you to limit it to a lower value, by applying a multiplier to that. Please choose a value, select custom to enter your own, or No limit to set your walk speed to the maximum. This menu will not make you move any faster than usual, it is only for allowing you to move at a slower pace than normal, for roleplay purposes. Values set here will not affect your sprinting speed", "Limit Walking speed") as null|anything in options

	if (isnull(response))
		return
	else if (response == "No limit")
		to_chat(src, "Movement speed has now been set to normal, limits removed.")
		src.min_walk_delay = 0
		return
	else if (response == "Custom")
		response = input(src, "Please enter the exact speed you want to walk at, in tiles per second. This value must be less than [speed] and greater than zero", "Limit Walking speed") as num
		newspeed = response
	else
		newspeed = text2num(response)

	if (!newspeed || newspeed >= speed || newspeed <= 0.2)
		to_chat(src, "Error, invalid value entered. Walk speed has not been changed")
		return


	to_chat(src, "Walking speed has now been limited to [newspeed] tiles per second, which is [(newspeed/speed)*100]% of your normal walking speed.")
	src.min_walk_delay = (10 / newspeed)
