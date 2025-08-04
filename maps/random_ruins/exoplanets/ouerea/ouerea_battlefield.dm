/datum/map_template/ruin/exoplanet/ouerea_battlefield
	name = "Ouerean Battlefield"
	id = "ouerea_battlefield"
	description = "A battlefield of the Ouerean Revolution, now long forgotten."
	template_flags = TEMPLATE_FLAG_NO_RUINS|TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED
	sectors = list(SECTOR_UUEOAESA)
	prefix = "ouerea/"
	suffix = "ouerea_battlefield.dmm"
	unit_test_groups = list(2)

/obj/effect/landmark/corpse/ouerea_revolutionary
	name = "Ouerean Revolutionary"
	corpseuniform = /obj/item/clothing/under/unathi
	corpseshoes = /obj/item/clothing/shoes/sandals/caligae
	corpseid = FALSE
	species = SPECIES_UNATHI

/obj/effect/landmark/corpse/ouerea_revolutionary/do_extra_customization(var/mob/living/carbon/human/M)
	M.ChangeToSkeleton()

/obj/item/paper/fluff/ouerea_corpse
	name = "A Final Message"
	info = "To you, who live beyond us. On this day we, the forces of the Ouerean Confederation, sovereign and free, clashed with the thugs of the tyrant Yiztek. We have slain many of their number, but we cannot hold this place any more. I have seen to the burial of the dead, and now I wait for Sk'akh to claim my spirit too. Whoever you may be, remember this place and our names, and the righteous cause of liberty for which we fought. Long live the Confederation, and her people."
	language = LANGUAGE_UNATHI

/obj/structure/gravemarker/ouerea_1
	message = "John Grenfel, son of Mars. He would always sing the loudest, around our fire."

/obj/structure/gravemarker/ouerea_2
	message = "Volqix Qooxuq, child of Qerr'malic. They would stoke the flame of hope in each of us."

/obj/structure/gravemarker/ouerea_3
	message = "Sokha Akaleis, daughter of Skalamar. She saved each of our lives, more times than we could count."

/obj/structure/gravemarker/ouerea_4
	message = "Kuzwe Yulac, son of Kutah. He lept to the fray without hesitation, and the cowards of Yiztek feared his name."

/obj/structure/gravemarker/ouerea_5
	message = "Uezak Ozarma, son of S'th. He was the first of us to stand for freedom, and he died before his knees would bend."
