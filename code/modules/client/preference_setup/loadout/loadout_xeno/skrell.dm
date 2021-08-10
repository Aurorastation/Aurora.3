/datum/gear/ears/skrell/chains	//Chains
	display_name = "headtail chain selection"
	path = /obj/item/clothing/ears/skrell/chain
	sort_category = "Xenowear - Skrell"
	whitelisted = list(SPECIES_SKRELL)

/datum/gear/ears/skrell/chains/New()
	..()
	var/list/chaintypes = list()
	for(var/chain_style in typesof(/obj/item/clothing/ears/skrell/chain))
		var/obj/item/clothing/ears/skrell/chain/chain = chain_style
		chaintypes[initial(chain.name)] = chain
	gear_tweaks += new /datum/gear_tweak/path(sortAssoc(chaintypes))

/datum/gear/ears/skrell/bands
	display_name = "headtail band selection"
	path = /obj/item/clothing/ears/skrell/band
	sort_category = "Xenowear - Skrell"
	whitelisted = list(SPECIES_SKRELL)

/datum/gear/ears/skrell/bands/New()
	..()
	var/list/bandtypes = list()
	for(var/band_style in typesof(/obj/item/clothing/ears/skrell/band))
		var/obj/item/clothing/ears/skrell/band/band = band_style
		bandtypes[initial(band.name)] = band
	gear_tweaks += new /datum/gear_tweak/path(sortAssoc(bandtypes))

/datum/gear/ears/skrell/cloth/short
	display_name = "short headtail cloth"
	path = /obj/item/clothing/ears/skrell/cloth_short/black
	sort_category = "Xenowear - Skrell"
	whitelisted = list(SPECIES_SKRELL)

/datum/gear/ears/skrell/cloth/short/New()
	..()
	var/list/shorttypes = list()
	for(var/short_style in typesof(/obj/item/clothing/ears/skrell/cloth_short))
		var/obj/item/clothing/ears/skrell/cloth_short/short = short_style
		shorttypes[initial(short.name)] = short
	gear_tweaks += new /datum/gear_tweak/path(sortAssoc(shorttypes))

/datum/gear/ears/skrell/cloth/average
	display_name = "average headtail cloth"
	path = /obj/item/clothing/ears/skrell/cloth_average/black
	sort_category = "Xenowear - Skrell"
	whitelisted = list(SPECIES_SKRELL)

/datum/gear/ears/skrell/cloth/average/New()
	..()
	var/list/averagetypes = list()
	for(var/average_style in typesof(/obj/item/clothing/ears/skrell/cloth_average))
		var/obj/item/clothing/ears/skrell/cloth_average/average = average_style
		averagetypes[initial(average.name)] = average
	gear_tweaks += new /datum/gear_tweak/path(sortAssoc(averagetypes))

/datum/gear/accessory/capes
	display_name = "shoulder capes"
	path = /obj/item/clothing/accessory/poncho/shouldercape
	whitelisted = list(SPECIES_SKRELL)
	sort_category = "Xenowear - Skrell"

/datum/gear/accessory/capes/New()
	..()
	var/list/capes = list()
	capes["star cape"] = /obj/item/clothing/accessory/poncho/shouldercape/star
	capes["nebula cape"] = /obj/item/clothing/accessory/poncho/shouldercape/nebula
	capes["nova cape"] = /obj/item/clothing/accessory/poncho/shouldercape/nova
	capes["galaxy cape"] = /obj/item/clothing/accessory/poncho/shouldercape/galaxy
	gear_tweaks += new /datum/gear_tweak/path(capes)

/datum/gear/uniform/skrell
	display_name = "qeblak ceremonial garment"
	path = /obj/item/clothing/under/skrell/qeblak
	whitelisted = list(SPECIES_SKRELL)
	sort_category = "Xenowear - Skrell"
	flags = GEAR_HAS_DESC_SELECTION

/datum/gear/stellascope
	display_name = "stellascope"
	path = /obj/item/stellascope
	whitelisted = list(SPECIES_SKRELL)
	sort_category = "Xenowear - Skrell"

/datum/gear/skrell_projector
	display_name = "nralakk projector"
	path = /obj/item/skrell_projector
	whitelisted = list(SPECIES_SKRELL)
	sort_category = "Xenowear - Skrell"

/datum/gear/ears/skrell/goop
	display_name = "glowing algae"
	path = /obj/item/clothing/ears/skrell/goop
	whitelisted = list(SPECIES_SKRELL)
	sort_category = "Xenowear - Skrell"
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/ears/skrell/goop/New()
	..()
	var/list/algae = list()
	algae["glowing algae(dots)"] = /obj/item/clothing/ears/skrell/goop
	algae["glowing algae(stripes)"] = /obj/item/clothing/ears/skrell/goop/stripes
	algae["glowing algae(circles)"] = /obj/item/clothing/ears/skrell/goop/circles
	gear_tweaks += new /datum/gear_tweak/path(algae)

/datum/gear/mask/skrell
	display_name = "skrell gill cover"
	path = /obj/item/clothing/mask/breath/skrell
	whitelisted = list(SPECIES_SKRELL)
	sort_category = "Xenowear - Skrell"

/datum/gear/ears/skrell/scrunchy
	display_name = "tentacle tie"
	path = /obj/item/clothing/ears/skrell/scrunchy
	whitelisted = list(SPECIES_SKRELL)
	sort_category = "Xenowear - Skrell"
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/accessory/skrell_passport
	display_name = "jargon federation passport"
	path = /obj/item/clothing/accessory/badge/passport/jargon
	sort_category = "Xenowear - Skrell"
	whitelisted = list(SPECIES_SKRELL, SPECIES_VAURCA_WARRIOR, SPECIES_VAURCA_WORKER, SPECIES_DIONA)
	cost = 0
	flags = 0

/datum/gear/accessory/skrell_passport/New()
	. = ..()
	gear_tweaks += list(social_credit_tweak)

// the whitelisted list ensures only people with skrell, vaurca, or diona whitelists can reach this check
/datum/gear/accessory/skrell_passport/check_species_whitelist(mob/living/carbon/human/H)
	var/static/list/species_list = list(SPECIES_SKRELL, SPECIES_VAURCA_WARRIOR, SPECIES_VAURCA_WORKER, SPECIES_VAURCA_BREEDER, SPECIES_DIONA)
	if(H.species.name in species_list)
		return TRUE
	return FALSE

/datum/gear/accessory/skrell_passport/spawn_item(location, metadata, mob/living/carbon/human/H)
	var/obj/item/clothing/accessory/badge/passport/jargon/J = ..()
	var/static/list/species_name_to_tag = list(SPECIES_SKRELL = "_s", SPECIES_VAURCA_WARRIOR = "_v", SPECIES_VAURCA_WORKER = "_v", SPECIES_VAURCA_BREEDER = "_v", SPECIES_DIONA = "_d")
	var/tag = species_name_to_tag[H.species.name]
	if(tag)
		J.species_tag = tag
	return J

/*
	Skrellian Social Score
*/
var/datum/gear_tweak/social_credit/social_credit_tweak = new()

datum/gear_tweak/social_credit/get_contents(var/metadata)
	return "Social Credit Score: [metadata]"

datum/gear_tweak/social_credit/get_default()
	return 5

datum/gear_tweak/social_credit/get_metadata(var/user, var/metadata)
	var/credit_score = input(user, "Set the credit score your passport will display, refer to the wiki to gauge it. (It will be slightly randomized to simulate Jargon calculations.)", "Social Credit Score") as null|num
	if(credit_score)
		return round(credit_score, 0.01)
	return metadata

datum/gear_tweak/social_credit/tweak_item(var/obj/item/clothing/accessory/badge/passport/jargon/PP, var/metadata)
	if(!istype(PP))
		return
	PP.credit_score = metadata + pick(-0.01, 0, 0.01)