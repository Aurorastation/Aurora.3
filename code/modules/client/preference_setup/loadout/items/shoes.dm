// Shoelocker
/datum/gear/shoes
	display_name = "boots, circuitry (empty)"
	path = /obj/item/clothing/shoes/circuitry
	slot = slot_shoes
	sort_category = "Shoes and Footwear"

/datum/gear/shoes/New()
	..()
	gear_tweaks += list(GLOB.gear_tweak_shoe_layer)

/datum/gear/shoes/color
	display_name = "sneakers selection"
	description = "Sneakers, in a selection of colors."
	path = /obj/item/clothing/shoes/sneakers

/datum/gear/shoes/color/New()
	..()
	var/list/color = list()
	color["white shoes"] = /obj/item/clothing/shoes/sneakers
	color["red shoes"] = /obj/item/clothing/shoes/sneakers/red
	color["orange shoes"] = /obj/item/clothing/shoes/sneakers/orange
	color["yellow shoes"] = /obj/item/clothing/shoes/sneakers/yellow
	color["green shoes"] = /obj/item/clothing/shoes/sneakers/green
	color["blue shoes"] = /obj/item/clothing/shoes/sneakers/blue
	color["purple shoes"] = /obj/item/clothing/shoes/sneakers/purple
	color["brown shoes"] = /obj/item/clothing/shoes/sneakers/brown
	color["black shoes"] = /obj/item/clothing/shoes/sneakers/black
	color["rainbow shoes"] = /obj/item/clothing/shoes/sneakers/rainbow
	gear_tweaks += new /datum/gear_tweak/path(color)

/datum/gear/shoes/dress
	display_name = "oxford shoe selection"
	path = /obj/item/clothing/shoes/laceup

/datum/gear/shoes/dress/New()
	..()
	var/list/dress = list()
	dress["black oxford shoes"] = /obj/item/clothing/shoes/laceup
	dress["grey oxford shoes"] = /obj/item/clothing/shoes/laceup/grey
	dress["brown oxford shoes"] = /obj/item/clothing/shoes/laceup/brown
	dress["steel-toed oxford shoes"] = /obj/item/clothing/shoes/laceup/steeltoed
	dress["lizardskin oxford shoes"] = /obj/item/clothing/shoes/laceup/lizardskin
	gear_tweaks += new /datum/gear_tweak/path(dress)

/datum/gear/shoes/flats
	display_name = "flats selection"
	description = "Low-heeled dress flats, in a selection of colors."
	path = /obj/item/clothing/shoes/flats

/datum/gear/shoes/flats/New()
	..()
	var/list/flats = list()
	flats["dress flats, black"] = /obj/item/clothing/shoes/flats
	flats["dress flats, white"] = /obj/item/clothing/shoes/flats/white
	flats["dress flats, red"] = /obj/item/clothing/shoes/flats/red
	flats["dress flats, blue"] = /obj/item/clothing/shoes/flats/blue
	flats["dress flats, green"] = /obj/item/clothing/shoes/flats/green
	flats["dress flats, purple"] = /obj/item/clothing/shoes/flats/purple
	gear_tweaks += new /datum/gear_tweak/path(flats)

/datum/gear/shoes/colorable_flats
	display_name = "flats (colorable)"
	path = /obj/item/clothing/shoes/flats/color
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/shoes/heels
	display_name = "high heels"
	path = /obj/item/clothing/shoes/heels
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/shoes/sandals
	display_name = "sandals selection"
	path = /obj/item/clothing/shoes/sandals
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/shoes/sandals/New()
	..()
	var/list/sandals = list()
	sandals["sandals"] = /obj/item/clothing/shoes/sandals
	sandals["rubber clogs"] = /obj/item/clothing/shoes/sandals/clogs
	sandals["flip flops"] = /obj/item/clothing/shoes/sandals/flipflop
	sandals["geta"] = /obj/item/clothing/shoes/sandals/geta
	gear_tweaks += new /datum/gear_tweak/path(sandals)

/datum/gear/shoes/hitops
	display_name = "high-top selection"
	description = "High-top sneakers, in a selection of colors."
	path = /obj/item/clothing/shoes/sneakers/hitops

/datum/gear/shoes/hitops/New()
	..()
	var/list/hitops = list()
	hitops["high-tops, white"] = /obj/item/clothing/shoes/sneakers/hitops
	hitops["high-tops, red"] = /obj/item/clothing/shoes/sneakers/hitops/red
	hitops["high-tops, orange"] = /obj/item/clothing/shoes/sneakers/hitops/orange
	hitops["high-tops, yellow"] = /obj/item/clothing/shoes/sneakers/hitops/yellow
	hitops["high-tops, green"] = /obj/item/clothing/shoes/sneakers/hitops/green
	hitops["high-tops, blue"] = /obj/item/clothing/shoes/sneakers/hitops/blue
	hitops["high-tops, purple"] = /obj/item/clothing/shoes/sneakers/hitops/purple
	hitops["high-tops, brown"] = /obj/item/clothing/shoes/sneakers/hitops/brown
	hitops["high-tops, black"] = /obj/item/clothing/shoes/sneakers/hitops/black
	hitops["high-tops, rainbow"] = /obj/item/clothing/shoes/sneakers/hitops/rainbow
	gear_tweaks += new /datum/gear_tweak/path(hitops)

/datum/gear/shoes/boots
	display_name = "boot selection"
	description = "Boots, in a variety of styles."
	path = /obj/item/clothing/shoes/jackboots
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION

/datum/gear/shoes/boots/New()
	..()
	var/list/boots = list()
	boots["jackboots"] = /obj/item/clothing/shoes/jackboots
	boots["jackboots, cavalry"] = /obj/item/clothing/shoes/jackboots/cavalry
	boots["jackboots, riding"] = /obj/item/clothing/shoes/jackboots/riding
	boots["cowboy boots"] = /obj/item/clothing/shoes/cowboy
	boots["classic cowboy boots"] = /obj/item/clothing/shoes/cowboy/classic
	boots["snakeskin cowboy boots"] = /obj/item/clothing/shoes/cowboy/snakeskin
	boots["green snakeskin cowboy boots"] = /obj/item/clothing/shoes/cowboy/lizard
	boots["blue snakeskin cowboy boots"] = /obj/item/clothing/shoes/cowboy/lizard/masterwork
	boots["white cowboy boots"] = /obj/item/clothing/shoes/cowboy/white
	boots["fancy cowboy boots"] = /obj/item/clothing/shoes/cowboy/fancy
	boots["black cowboy boots"] = /obj/item/clothing/shoes/cowboy/black
	boots["vysokan gurmori hide boots"] = /obj/item/clothing/shoes/cowboy/gurmori
	boots["workboots"] = /obj/item/clothing/shoes/workboots
	boots["brown workboots"] = /obj/item/clothing/shoes/workboots/brown
	boots["grey workboots"] = /obj/item/clothing/shoes/workboots/grey
	boots["dark workboots"] = /obj/item/clothing/shoes/workboots/dark
	boots["winter boots"] = /obj/item/clothing/shoes/winter
	boots["aerostatic boots"] = /obj/item/clothing/shoes/aerostatic
	gear_tweaks += new /datum/gear_tweak/path(boots)

/datum/gear/shoes/lyodsuit_boots
	display_name = "lyodsuit boots"
	path = /obj/item/clothing/shoes/lyodsuit

/datum/gear/shoes/konyang_gomusin
	display_name = "gomusin"
	path = /obj/item/clothing/shoes/konyang
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/shoes/slippers
	display_name = "slippers"
	path = /obj/item/clothing/shoes/slippers

/datum/gear/shoes/slippers/New()
	..()
	var/list/slippers = list()
	slippers["carp slippers"] = /obj/item/clothing/shoes/slippers/carp
	slippers["bunny slippers"] = /obj/item/clothing/shoes/slippers
	slippers["worn bunny slippers"] = /obj/item/clothing/shoes/slippers/worn
	gear_tweaks += new /datum/gear_tweak/path(slippers)

/datum/gear/shoes/recolourable_shoes
	display_name = "shoe selection (colourable)"
	description = "Shoes, in a selection of colors."
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
	recolourable_shoes["thigh-high sneakers"] = /obj/item/clothing/shoes/sneakers/hitops/thightops
	recolourable_shoes["thigh-high sneakers (tipped)"] = /obj/item/clothing/shoes/sneakers/hitops/thightops/tip
	gear_tweaks += new /datum/gear_tweak/path(recolourable_shoes)

/datum/gear/shoes/recolourable_boots
	display_name = "boot selection (colourable)"
	description = "Boots, in a selection of colours."
	path = /obj/item/clothing/shoes/heeledboots
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/shoes/recolourable_boots/New()
	..()
	var/list/recolourable_boots = list()
	recolourable_boots["thigh-high boots"] = /obj/item/clothing/shoes/thighboots
	recolourable_boots["full-length boots"] = /obj/item/clothing/shoes/fullboots
	recolourable_boots["mudboots"] = /obj/item/clothing/shoes/mudboots
	recolourable_boots["thigh-high mudboots"] = /obj/item/clothing/shoes/mudboots/thigh
	recolourable_boots["combat boots"] = /obj/item/clothing/shoes/colorcombat
	recolourable_boots["jackboots"] = /obj/item/clothing/shoes/jackboots/color
	recolourable_boots["workboots"] = /obj/item/clothing/shoes/workboots/color
	recolourable_boots["ankle boots"] = /obj/item/clothing/shoes/ankleboots
	gear_tweaks += new /datum/gear_tweak/path(recolourable_boots)

/*
	Shoe Layer Adjustment
*/

GLOBAL_DATUM_INIT(gear_tweak_shoe_layer, /datum/gear_tweak/shoe_layer, new())

/datum/gear_tweak/shoe_layer/get_contents(var/metadata)
	return "Shoe Layer: [metadata] Uniform"

/datum/gear_tweak/shoe_layer/get_default()
	return "Over"

/datum/gear_tweak/shoe_layer/get_metadata(var/user, var/metadata)
	return tgui_input_list(user, "Choose whether you want the shoe to go over or under the uniform.", "Shoe Layer", list("Over", "Under"), metadata)

/datum/gear_tweak/shoe_layer/tweak_item(var/obj/item/clothing/shoes/S, var/metadata)
	if(!istype(S))
		return
	if(S.shoes_under_pants == -1)
		return
	if(metadata == "Over")
		S.shoes_under_pants = FALSE
	else
		S.shoes_under_pants = TRUE
