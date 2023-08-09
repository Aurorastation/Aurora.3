// Shoelocker
/datum/gear/shoes
	display_name = "boots, circuitry (empty)"
	path = /obj/item/clothing/shoes/circuitry
	slot = slot_shoes
	sort_category = "Shoes and Footwear"

/datum/gear/shoes/New()
	..()
	gear_tweaks += list(gear_tweak_shoe_layer)

/datum/gear/shoes/color
	display_name = "shoe selection"
	path = /obj/item/clothing/shoes/sneakers

/datum/gear/shoes/color/New()
	..()
	var/list/shoes = list()
	shoes["white shoes"] = /obj/item/clothing/shoes/sneakers
	shoes["red shoes"] = /obj/item/clothing/shoes/sneakers/red
	shoes["orange shoes"] = /obj/item/clothing/shoes/sneakers/orange
	shoes["yellow shoes"] = /obj/item/clothing/shoes/sneakers/yellow
	shoes["green shoes"] = /obj/item/clothing/shoes/sneakers/green
	shoes["blue shoes"] = /obj/item/clothing/shoes/sneakers/blue
	shoes["purple shoes"] = /obj/item/clothing/shoes/sneakers/purple
	shoes["brown shoes"] = /obj/item/clothing/shoes/sneakers/brown
	shoes["black shoes"] = /obj/item/clothing/shoes/sneakers/black
	shoes["rainbow shoes"] = /obj/item/clothing/shoes/sneakers/rainbow
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
	shoes["steel-toed oxford shoes"] = /obj/item/clothing/shoes/laceup/steeltoed
	shoes["lizardskin oxford shoes"] = /obj/item/clothing/shoes/laceup/lizardskin
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

/datum/gear/shoes/sandals
	display_name = "sandals selection"
	path = /obj/item/clothing/shoes/sandals
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/shoes/flats/New()
	..()
	var/list/shoes = list()
	shoes["sandals"] = /obj/item/clothing/shoes/sandals
	shoes["rubber clogs"] = /obj/item/clothing/shoes/sandals/clogs
	shoes["flip flops"] = /obj/item/clothing/shoes/sandals/flipflop
	shoes["geta"] = /obj/item/clothing/shoes/sandals/geta
	gear_tweaks += new /datum/gear_tweak/path(shoes)

/datum/gear/shoes/hitops
	display_name = "high-top selection"
	description = "High-top sneakers, in a selection of colors."
	path = /obj/item/clothing/shoes/sneakers/hitops

/datum/gear/shoes/hitops/New()
	..()
	var/list/shoes = list()
	shoes["high-tops, white"] = /obj/item/clothing/shoes/sneakers/hitops
	shoes["high-tops, red"] = /obj/item/clothing/shoes/sneakers/hitops/red
	shoes["high-tops, orange"] = /obj/item/clothing/shoes/sneakers/hitops/orange
	shoes["high-tops, yellow"] = /obj/item/clothing/shoes/sneakers/hitops/yellow
	shoes["high-tops, green"] = /obj/item/clothing/shoes/sneakers/hitops/green
	shoes["high-tops, blue"] = /obj/item/clothing/shoes/sneakers/hitops/blue
	shoes["high-tops, purple"] = /obj/item/clothing/shoes/sneakers/hitops/purple
	shoes["high-tops, brown"] = /obj/item/clothing/shoes/sneakers/hitops/brown
	shoes["high-tops, black"] = /obj/item/clothing/shoes/sneakers/hitops/black
	shoes["high-tops, rainbow"] = /obj/item/clothing/shoes/sneakers/hitops/rainbow
	gear_tweaks += new /datum/gear_tweak/path(shoes)

/datum/gear/shoes/boots
	display_name = "boot selection"
	description = "Boots, in a variety of styles."
	path = /obj/item/clothing/shoes/jackboots

/datum/gear/shoes/boots/New()
	..()
	var/list/shoes = list()
	shoes["jackboots"] = /obj/item/clothing/shoes/jackboots
	shoes["jackboots, cavalry"] = /obj/item/clothing/shoes/jackboots/cavalry
	shoes["cowboy boots"] = /obj/item/clothing/shoes/cowboy
	shoes["classic cowboy boots"] = /obj/item/clothing/shoes/cowboy/classic
	shoes["snakeskin cowboy boots"] = /obj/item/clothing/shoes/cowboy/snakeskin
	shoes["green snakeskin cowboy boots"] = /obj/item/clothing/shoes/cowboy/lizard
	shoes["blue snakeskin cowboy boots"] = /obj/item/clothing/shoes/cowboy/lizard/masterwork
	shoes["white cowboy boots"] = /obj/item/clothing/shoes/cowboy/white
	shoes["fancy cowboy boots"] = /obj/item/clothing/shoes/cowboy/fancy
	shoes["black cowboy boots"] = /obj/item/clothing/shoes/cowboy/black
	shoes["workboots"] = /obj/item/clothing/shoes/workboots
	shoes["brown workboots"] = /obj/item/clothing/shoes/workboots/brown
	shoes["grey workboots"] = /obj/item/clothing/shoes/workboots/grey
	shoes["dark workboots"] = /obj/item/clothing/shoes/workboots/dark
	shoes["winter boots"] = /obj/item/clothing/shoes/winter
	shoes["aerostatic boots"] = /obj/item/clothing/shoes/aerostatic
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
  
/datum/gear/shoes/slippers
	display_name = "slippers"
	path = /obj/item/clothing/shoes/slippers

/datum/gear/shoes/slippers/New()
	..()
	var/list/slippers = list()
	slippers["bunny slippers"] = /obj/item/clothing/shoes/slippers
	slippers["worn bunny slippers"] = /obj/item/clothing/shoes/slippers/worn
	gear_tweaks += new /datum/gear_tweak/path(slippers)

/datum/gear/shoes/recolourable_shoes
	display_name = "shoe selection (colourable)"
	path = /obj/item/clothing/shoes/sneakers
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/shoes/recolourable_shoes/New()
	..()
	var/list/recolourable_shoes = list()
	recolourable_shoes["shoes"] = /obj/item/clothing/shoes/sneakers
	recolourable_shoes["shoes (tipped)"] = /obj/item/clothing/shoes/sneakers/tip
	recolourable_shoes["high-tops"] = /obj/item/clothing/shoes/sneakers/hitops
	recolourable_shoes["high-tops (tipped)"] = /obj/item/clothing/shoes/sneakers/hitops/tip
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
