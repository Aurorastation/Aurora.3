/datum/gear/ears/skrell/chains	//Chains
	display_name = "headtail chain selection"
	path = /obj/item/clothing/ears/skrell/chain
	sort_category = "Xenowear - Skrell"
	whitelisted = list("Skrell")

/datum/gear/ears/skrell/chains/New()
	..()
	var/list/chaintypes = list()
	for(var/chain_style in typesof(/obj/item/clothing/ears/skrell/chain))
		var/obj/item/clothing/ears/skrell/chain/chain = chain_style
		chaintypes[initial(chain.name)] = chain
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(chaintypes))

/datum/gear/ears/skrell/bands
	display_name = "headtail band selection"
	path = /obj/item/clothing/ears/skrell/band
	sort_category = "Xenowear - Skrell"
	whitelisted = list("Skrell")

/datum/gear/ears/skrell/bands/New()
	..()
	var/list/bandtypes = list()
	for(var/band_style in typesof(/obj/item/clothing/ears/skrell/band))
		var/obj/item/clothing/ears/skrell/band/band = band_style
		bandtypes[initial(band.name)] = band
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(bandtypes))

/datum/gear/ears/skrell/cloth/short
	display_name = "short headtail cloth"
	path = /obj/item/clothing/ears/skrell/cloth_short/black
	sort_category = "Xenowear - Skrell"
	whitelisted = list("Skrell")

/datum/gear/ears/skrell/cloth/short/New()
	..()
	var/list/shorttypes = list()
	for(var/short_style in typesof(/obj/item/clothing/ears/skrell/cloth_short))
		var/obj/item/clothing/ears/skrell/cloth_short/short = short_style
		shorttypes[initial(short.name)] = short
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(shorttypes))

/datum/gear/ears/skrell/cloth/average
	display_name = "average headtail cloth"
	path = /obj/item/clothing/ears/skrell/cloth_average/black
	sort_category = "Xenowear - Skrell"
	whitelisted = list("Skrell")

/datum/gear/ears/skrell/cloth/average/New()
	..()
	var/list/averagetypes = list()
	for(var/average_style in typesof(/obj/item/clothing/ears/skrell/cloth_average))
		var/obj/item/clothing/ears/skrell/cloth_average/average = average_style
		averagetypes[initial(average.name)] = average
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(averagetypes))

/datum/gear/accessory/capes
	display_name = "shoulder capes"
	path = /obj/item/clothing/accessory/poncho/shouldercape
	whitelisted = list("Skrell")
	sort_category = "Xenowear - Skrell"

/datum/gear/accessory/capes/New()
	..()
	var/capes = list()
	capes["star cape"] = /obj/item/clothing/accessory/poncho/shouldercape/star
	capes["nebula cape"] = /obj/item/clothing/accessory/poncho/shouldercape/nebula
	capes["nova cape"] = /obj/item/clothing/accessory/poncho/shouldercape/nova
	capes["galaxy cape"] = /obj/item/clothing/accessory/poncho/shouldercape/galaxy
	gear_tweaks += new/datum/gear_tweak/path(capes)

/datum/gear/uniform/skrell
	display_name = "qeblak ceremonial garment"
	path = /obj/item/clothing/under/skrell/qeblak
	whitelisted = list("Skrell")
	sort_category = "Xenowear - Skrell"
	flags = GEAR_HAS_DESC_SELECTION

/datum/gear/stellascope
	display_name = "stellascope"
	path = /obj/item/stellascope
	whitelisted = list("Skrell")
	sort_category = "Xenowear - Skrell"

/datum/gear/skrell_projector
	display_name = "nralakk projector"
	path = /obj/item/skrell_projector
	whitelisted = list("Skrell")
	sort_category = "Xenowear - Skrell"

/datum/gear/ears/skrell/goop
	display_name = "glowing algae"
	path = /obj/item/clothing/ears/skrell/goop
	whitelisted = list("Skrell")
	sort_category = "Xenowear - Skrell"
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/ears/skrell/goop/New()
	..()
	var/algae = list()
	algae["glowing algae(dots)"] = /obj/item/clothing/ears/skrell/goop
	algae["glowing algae(stripes)"] = /obj/item/clothing/ears/skrell/goop/stripes
	algae["glowing algae(circles)"] = /obj/item/clothing/ears/skrell/goop/circles
	gear_tweaks += new/datum/gear_tweak/path(algae)

/datum/gear/mask/skrell
	display_name = "skrell gill cover"
	path = /obj/item/clothing/mask/breath/skrell
	whitelisted = list("Skrell")
	sort_category = "Xenowear - Skrell"