/mob/living/carbon/human/skeleton/New(var/new_loc)
	..(new_loc, "Skeleton")

/datum/species/skeleton //SPOOKY
	name = "Skeleton"
	name_plural = "skeletons"

	icobase = 'icons/mob/human_races/r_skeleton.dmi'
	deform = 'icons/mob/human_races/r_skeleton.dmi'

	default_language = "Ceti Basic"
	language = "Cult"
	unarmed_types = list(/datum/unarmed_attack/claws/strong, /datum/unarmed_attack/bite/sharp)
	darksight = 8
	has_organ = list()
	siemens_coefficient = 0

	rarity_value = 2
	blurb = "Skeletons are undead brought back to life through dark wizardry, \
	they are empty shells fueled by sheer obscure power and blood-magic. \
	However, some men are cursed to carry such burden due to vile curses."

	warning_low_pressure = 50
	hazard_low_pressure = 0

	cold_level_1 = 80
	cold_level_2 = 50
	cold_level_3 = 0

	blood_color = "#CCCCCC"
	flesh_color = "#AAAAAA"

	death_message = "collapses, their bones clattering in a symphony of demise."

	breath_type = null
	poison_type = null

	flags = IS_RESTRICTED | NO_BLOOD | NO_SCAN | NO_SLIP | NO_POISON | NO_PAIN | NO_BREATHE
