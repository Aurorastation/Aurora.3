ABSTRACT_TYPE(/datum/gear/pants)
	sort_category = "Skirts and Trousers" //wikipedia definition puts shorts under trousers category, so.
	slot = slot_pants

/datum/gear/pants/trousers
	display_name = "pants and shorts selection"
	description = "A selection of pants and shorts."
	path = /obj/item/clothing/pants

/datum/gear/pants/trousers/New()
	..()
	var/list/pants = list()

	// Pants
	pants["jeans"] = /obj/item/clothing/pants/jeans
	pants["classic jeans"] = /obj/item/clothing/pants/classic
	pants["mustang jeans"] = /obj/item/clothing/pants/mustang
	pants["black jeans"] = /obj/item/clothing/pants/jeansblack
	pants["white pants"] = /obj/item/clothing/pants/white
	pants["black pants"] = /obj/item/clothing/pants/black
	pants["red pants"] = /obj/item/clothing/pants/red
	pants["tan pants"] = /obj/item/clothing/pants/tan
	pants["khaki pants"] = /obj/item/clothing/pants/khaki
	pants["high visibility pants"] = /obj/item/clothing/pants/highvis
	pants["high visibility pants, alt"] = /obj/item/clothing/pants/highvis_alt
	pants["high visibility pants, red"] = /obj/item/clothing/pants/highvis_red
	pants["track pants"] = /obj/item/clothing/pants/track
	pants["blue track pants"] = /obj/item/clothing/pants/track/blue
	pants["green track pants"] = /obj/item/clothing/pants/track/green
	pants["white track pants"] = /obj/item/clothing/pants/track/white
	pants["red track pants"] = /obj/item/clothing/pants/track/red
	pants["camo pants"] = /obj/item/clothing/pants/camo
	pants["tacticool pants"] = /obj/item/clothing/pants/tacticool
	pants["designer jeans"] = /obj/item/clothing/pants/designer
	pants["ripped jeans"] = /obj/item/clothing/pants/ripped
	pants["black ripped jeans"] = /obj/item/clothing/pants/blackripped

	// Shorts
	pants["black shorts"] = /obj/item/clothing/pants/shorts/black
	pants["black short shorts"] = /obj/item/clothing/pants/shorts/black/short
	pants["khaki shorts"] = /obj/item/clothing/pants/shorts/khaki
	pants["khaki short shorts"] = /obj/item/clothing/pants/shorts/khaki/short

	// Jeans Shorts
	pants["jeans shorts"] = /obj/item/clothing/pants/shorts/jeans
	pants["jeans short shorts"] = /obj/item/clothing/pants/shorts/jeans/short
	pants["classic jeans shorts"] = /obj/item/clothing/pants/shorts/jeans/classic
	pants["classic jeans short shorts"] = /obj/item/clothing/pants/shorts/jeans/classic/short
	pants["mustang jeans shorts"] = /obj/item/clothing/pants/shorts/jeans/mustang
	pants["mustang jeans short shorts"] = /obj/item/clothing/pants/shorts/jeans/mustang/short
	pants["black jeans shorts"] = /obj/item/clothing/pants/shorts/jeans/black
	pants["black jeans short shorts"] = /obj/item/clothing/pants/shorts/jeans/black/short
	pants["grey jeans shorts"] = /obj/item/clothing/pants/shorts/jeans/grey
	pants["grey jeans short shorts"] = /obj/item/clothing/pants/shorts/jeans/grey/short

	// Athletic Shorts
	pants["black athletic shorts"] = /obj/item/clothing/pants/shorts/athletic/black
	pants["red athletic shorts"] = /obj/item/clothing/pants/shorts/athletic/red
	pants["green athletic shorts"] = /obj/item/clothing/pants/shorts/athletic/green
	pants["grey athletic shorts"] = /obj/item/clothing/pants/shorts/athletic/grey
	pants["SCC-branded athletic shorts"] = /obj/item/clothing/pants/shorts/athletic/scc

	gear_tweaks += new /datum/gear_tweak/path(pants)

/datum/gear/pants/colorpants
	display_name = "pants and shorts selection (colourable)"
	description = "A selection of colourable pants and shorts."
	path = /obj/item/clothing/pants/dress
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/pants/colorpants/New()
	..()
	var/list/colorpants = list()

	// Pants
	colorpants["dress pants"] = /obj/item/clothing/pants/dress
	colorpants["dress pants, with belt"] = /obj/item/clothing/pants/dress/belt
	colorpants["striped pants"] = /obj/item/clothing/pants/striped
	colorpants["flared pants"] = /obj/item/clothing/pants/flared
	colorpants["mustang jeans"] = /obj/item/clothing/pants/mustang/colourable
	colorpants["tailored jeans"] = /obj/item/clothing/pants/tailoredjeans

	// Shorts
	colorpants["shorts"] = /obj/item/clothing/pants/shorts/colourable
	colorpants["short shorts"] = /obj/item/clothing/pants/shorts/colourable/short
	colorpants["athletic shorts"] = /obj/item/clothing/pants/shorts/athletic/colourable

	gear_tweaks += new /datum/gear_tweak/path(colorpants)

/datum/gear/pants/skirt
	display_name = "skirt selection"
	description = "A selection of skirts."
	path = /obj/item/clothing/pants/skirt
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/pants/skirt/New()
	..()
	var/list/skirts = list()
	skirts["casual skirt"] = /obj/item/clothing/pants/skirt
	skirts["puffy skirt"] = /obj/item/clothing/pants/skirt/puffy
	skirts["long skirt"] = /obj/item/clothing/pants/skirt/long
	skirts["pencil skirt"] = /obj/item/clothing/pants/skirt/pencil
	skirts["swept skirt"] = /obj/item/clothing/pants/skirt/swept
	skirts["plaid skirt"] = /obj/item/clothing/pants/skirt/plaid
	skirts["pleated skirt"] = /obj/item/clothing/pants/skirt/pleated
	skirts["high skirt"] = /obj/item/clothing/pants/skirt/high
	skirts["skater skirt"] = /obj/item/clothing/pants/skirt/skater
	skirts["tube skirt"] = /obj/item/clothing/pants/skirt/tube
	skirts["jumper skirt"] = /obj/item/clothing/pants/skirt/jumper
	skirts["jumper dress"] = /obj/item/clothing/pants/skirt/jumper_highcut
	skirts["long straight skirt"] = /obj/item/clothing/pants/skirt/straightlong
	gear_tweaks += new /datum/gear_tweak/path(skirts)
