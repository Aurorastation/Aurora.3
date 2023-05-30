// Shoelocker
/datum/gear/shoes
	display_name = "sandals"
	path = /obj/item/clothing/shoes/sandal
	slot = slot_shoes
	sort_category = "Shoes and Footwear"

/datum/gear/shoes/New()
	..()
	gear_tweaks += list(gear_tweak_shoe_layer)

/datum/gear/shoes/color
	display_name = "shoe selection"
	path = /obj/item/clothing/shoes/black

/datum/gear/shoes/color/New()
	..()
	var/list/shoes = list()
	shoes["black shoes"] = /obj/item/clothing/shoes/black
	shoes["blue shoes"] = /obj/item/clothing/shoes/blue
	shoes["brown shoes"] = /obj/item/clothing/shoes/brown
	shoes["green shoes"] = /obj/item/clothing/shoes/green
	shoes["orange shoes"] = /obj/item/clothing/shoes/orange
	shoes["purple shoes"] = /obj/item/clothing/shoes/purple
	shoes["rainbow shoes"] = /obj/item/clothing/shoes/rainbow
	shoes["red shoes"] = /obj/item/clothing/shoes/red
	shoes["white shoes"] = /obj/item/clothing/shoes/white
	shoes["yellow shoes"] = /obj/item/clothing/shoes/yellow
	gear_tweaks += new /datum/gear_tweak/path(shoes)

/datum/gear/shoes/dress
	display_name = "oxford shoe selection"
	path = /obj/item/clothing/shoes/laceup

/datum/gear/shoes/dress/New()
	..()
	var/list/shoes = list()
	shoes["black oxford shoes"] = /obj/item/clothing/shoes/laceup
	shoes["grey oxford shoes"] = /obj/item/clothing/shoes/laceup/grey
	shoes["brown oxford shoes"] = /obj/item/clothing/shoes/laceup/brown
	gear_tweaks += new /datum/gear_tweak/path(shoes)

/datum/gear/shoes/flats
	display_name = "flats selection"
	description = "Low-heeled dress flats, in a selection of colors."
	path = /obj/item/clothing/shoes/flats

/datum/gear/shoes/flats/New()
	..()
	var/list/shoes = list()
	shoes["dress flats, black"] = /obj/item/clothing/shoes/flats
	shoes["dress flats, white"] = /obj/item/clothing/shoes/flats/white
	shoes["dress flats, red"] = /obj/item/clothing/shoes/flats/red
	shoes["dress flats, blue"] = /obj/item/clothing/shoes/flats/blue
	shoes["dress flats, green"] = /obj/item/clothing/shoes/flats/green
	shoes["dress flats, purple"] = /obj/item/clothing/shoes/flats/purple
	gear_tweaks += new /datum/gear_tweak/path(shoes)

/datum/gear/shoes/heels
	display_name = "high heels"
	path = /obj/item/clothing/shoes/heels
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/shoes/tongs
	display_name = "flip flops"
	path = /obj/item/clothing/shoes/sandal/flipflop
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/shoes/woodensandals
	display_name = "wooden sandals"
	path = /obj/item/clothing/shoes/sandal/wooden
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/shoes/hitops
	display_name = "high-top selection"
	description = "High-top sneakers, in a selection of colors."
	path = /obj/item/clothing/shoes/hitops

/datum/gear/shoes/hitops/New()
	..()
	var/list/shoes = list()
	shoes["high-tops, white"] = /obj/item/clothing/shoes/hitops
	shoes["high-tops, red"] = /obj/item/clothing/shoes/hitops/red
	shoes["high-tops, black"] = /obj/item/clothing/shoes/hitops/black
	shoes["high-tops, blue"] = /obj/item/clothing/shoes/hitops/blue
	shoes["high-tops, green"] = /obj/item/clothing/shoes/hitops/green
	shoes["high-tops, purple"] = /obj/item/clothing/shoes/hitops/purple
	shoes["high-tops, yellow"] = /obj/item/clothing/shoes/hitops/yellow
	gear_tweaks += new /datum/gear_tweak/path(shoes)

/datum/gear/shoes/boots
	display_name = "boot selection"
	description = "Boots, in a variety of styles."
	path = /obj/item/clothing/shoes/jackboots

/datum/gear/shoes/boots/New()
	..()
	var/list/shoes = list()
	shoes["black boots, short"] = /obj/item/clothing/shoes/jackboots
	shoes["black boots, knee"] = /obj/item/clothing/shoes/jackboots/knee
	shoes["black boots, thigh"] = /obj/item/clothing/shoes/jackboots/thigh
	shoes["cowboy boots"] = /obj/item/clothing/shoes/cowboy
	shoes["classic cowboy boots"] = /obj/item/clothing/shoes/cowboy/classic
	shoes["snakeskin cowboy boots"] = /obj/item/clothing/shoes/cowboy/snakeskin
	shoes["brown workboots"] = /obj/item/clothing/shoes/workboots
	shoes["grey workboots"] = /obj/item/clothing/shoes/workboots/grey
	shoes["dark workboots"] = /obj/item/clothing/shoes/workboots/dark
	shoes["winter boots"] = /obj/item/clothing/shoes/winter
	gear_tweaks += new /datum/gear_tweak/path(shoes)

/datum/gear/shoes/lyodsuit_boots
	display_name = "lyodsuit boots"
	path = /obj/item/clothing/shoes/lyodsuit

/datum/gear/shoes/konyang_gomusin
	display_name = "gomusin"
	path = /obj/item/clothing/shoes/konyang
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/shoes/vysoka
	display_name = "gurmori hide boots"
	description = "A pair of hide boots produced from the mantle of a Vysokan Gurmori."
	path = /obj/item/clothing/shoes/gurmori
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION

/datum/gear/shoes/circuitry
	display_name = "boots, circuitry (empty)"
	path = /obj/item/clothing/shoes/circuitry

/datum/gear/shoes/slippers
	display_name = "bunny slippers"
	path = /obj/item/clothing/shoes/slippers

/datum/gear/shoes/slippers/New()
	..()
	var/list/slippers = list()
	slippers["bunny slippers"] = /obj/item/clothing/shoes/slippers
	slippers["worn bunny slippers"] = /obj/item/clothing/shoes/slippers/worn
	gear_tweaks += new /datum/gear_tweak/path(slippers)

/datum/gear/shoes/clog
	display_name = "plastic clogs"
	path = /obj/item/clothing/shoes/sandal/clogs
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/shoes/recolourable_shoes
	display_name = "shoe selection (colourable)"
	path = /obj/item/clothing/shoes/sneakers
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/shoes/recolourable_shoes/New()
	..()
	var/list/recolourable_shoes = list()
	recolourable_shoes["sneakers"] = /obj/item/clothing/shoes/sneakers
	recolourable_shoes["sneakers (white tip)"] = /obj/item/clothing/shoes/sneakers/whitetip
	recolourable_shoes["oxfords"] = /obj/item/clothing/shoes/laceup/colourable
	gear_tweaks += new /datum/gear_tweak/path(recolourable_shoes)

/*
	Shoe Layer Adjustment
*/
var/datum/gear_tweak/shoe_layer/gear_tweak_shoe_layer = new()

/datum/gear_tweak/shoe_layer/get_contents(var/metadata)
	return "Shoe Layer: [metadata] Uniform"

/datum/gear_tweak/shoe_layer/get_default()
	return "Over"

/datum/gear_tweak/shoe_layer/get_metadata(var/user, var/metadata)
	return input(user, "Choose whether you want the shoe to go over or under the uniform.", "Shoe Layer", metadata) as anything in list("Over", "Under")

/datum/gear_tweak/shoe_layer/tweak_item(var/obj/item/clothing/shoes/S, var/metadata)
	if(!istype(S))
		return
	if(S.shoes_under_pants == -1)
		return
	if(metadata == "Over")
		S.shoes_under_pants = FALSE
	else
		S.shoes_under_pants = TRUE
