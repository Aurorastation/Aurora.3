/datum/map_template/ruin/exoplanet/moghes_dead_guwandi
	name = "Dead Guwandi"
	id = "moghes_dead_guwandi"
	description = "A Guwandi warrior, who found an honorable death"

	template_flags = TEMPLATE_FLAG_NO_RUINS|TEMPLATE_FLAG_RUIN_STARTS_DISALLOWED
	sectors = list(SECTOR_UUEOAESA)
	prefix = "moghes/"
	suffix = "moghes_dead_guwandi.dmm"
	unit_test_groups = list(2)

/obj/effect/landmark/corpse/moghes_dead_guwandi
	name = "Guwandi"
	corpseuniform = /obj/item/clothing/under/unathi/zazali
	corpsesuit = /obj/item/clothing/suit/unathi/robe/kilt
	corpseshoes = /obj/item/clothing/shoes/sandals/caligae
	corpsehelmet = /obj/item/clothing/accessory/sinta_hood
	corpsebelt = /obj/item/material/sword/longsword

/obj/effect/landmark/corpse/moghes_dead_guwandi/do_extra_customization(mob/living/carbon/human/M)
	M.ChangeToHusk()
	M.adjustBruteLoss(rand(200,400))
	M.dir = pick(GLOB.cardinals)
	if(M?.w_uniform)
		M.w_uniform.color = "#181a19"
	if(M?.wear_suit)
		M.wear_suit.color = "#d4d3ab"
	if(M?.head)
		M.head.color = "#d4d3ab"


/obj/item/paper/fluff/guwandi
	name = "final words"
	desc = "A scrap of paper, with a few words jotted down on it."
	info = "A drum with no head,<BR>\
	A blade with no hilt,<BR>\
	A song with no voice,<BR>\
	Still, it is mine."
	language = LANGUAGE_AZAZIBA

/obj/effect/landmark/corpse/moghes_dead_raider
	name = "Wasteland Raider"
	corpseuniform = /obj/item/clothing/under/unathi
	corpseshoes = /obj/item/clothing/shoes/sandals/caligae
	corpsesuit = /obj/item/clothing/accessory/poncho/unathimantle
	corpseglasses = /obj/item/clothing/glasses/safety/goggles/wasteland

/obj/effect/landmark/corpse/moghes_dead_raider/do_extra_customization(mob/living/carbon/human/M)
	M.ChangeToHusk()
	M.adjustBruteLoss(rand(200,400))
	M.dir = pick(GLOB.cardinals)
	var/uniform_color = "[pick("#42330f", "#DBC684")]"
	if(M?.w_uniform)
		M.w_uniform.color = uniform_color
	if(M?.wear_suit)
		M.wear_suit.color = uniform_color
