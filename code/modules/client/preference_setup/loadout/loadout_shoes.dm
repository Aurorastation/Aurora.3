// Shoelocker
/datum/gear/shoes
	display_name = "jackboots"
	path = /obj/item/clothing/shoes/jackboots
	slot = slot_shoes
	sort_category = "Shoes and Footwear"

/datum/gear/shoes/workboots
	display_name = "workboots selection"
	path = /obj/item/clothing/shoes/workboots

/datum/gear/shoes/workboots/New()
	..()
	var/shoes = list()
	shoes["brown workboots"] = /obj/item/clothing/shoes/workboots
	shoes["grey workboots"] = /obj/item/clothing/shoes/workboots/grey
	shoes["dark workboots"] = /obj/item/clothing/shoes/workboots/dark
	gear_tweaks += new/datum/gear_tweak/path(shoes)

/datum/gear/shoes/winterboots
	display_name = "winter boots"
	path = /obj/item/clothing/shoes/winter

/datum/gear/shoes/sandals
	display_name = "sandals"
	path = /obj/item/clothing/shoes/sandal

/datum/gear/shoes/color
	display_name = "shoe selection"
	path = /obj/item/clothing/shoes/black

/datum/gear/shoes/color/New()
	..()
	var/shoes = list()
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
	gear_tweaks += new/datum/gear_tweak/path(shoes)

/datum/gear/shoes/dress
	display_name = "oxford shoe selection"
	path = /obj/item/clothing/shoes/laceup

/datum/gear/shoes/dress/New()
	..()
	var/shoes = list()
	shoes["black oxford shoes"] = /obj/item/clothing/shoes/laceup
	shoes["grey oxford shoes"] = /obj/item/clothing/shoes/laceup/grey
	shoes["brown oxford shoes"] = /obj/item/clothing/shoes/laceup/brown
	gear_tweaks += new/datum/gear_tweak/path(shoes)

/datum/gear/shoes/flats
	display_name = "flats selection"
	description = "Low-heeled dress flats, in a selection of colors."
	path = /obj/item/clothing/shoes/flats

/datum/gear/shoes/flats/New()
	..()
	var/shoes = list()
	shoes["dress flats, black"] = /obj/item/clothing/shoes/flats
	shoes["dress flats, white"] = /obj/item/clothing/shoes/flats/white
	shoes["dress flats, red"] = /obj/item/clothing/shoes/flats/red
	shoes["dress flats, blue"] = /obj/item/clothing/shoes/flats/blue
	shoes["dress flats, green"] = /obj/item/clothing/shoes/flats/green
	shoes["dress flats, purple"] = /obj/item/clothing/shoes/flats/purple
	gear_tweaks += new/datum/gear_tweak/path(shoes)

/datum/gear/shoes/cowboy
	display_name = "cowboy boots selection"
	path = /obj/item/clothing/shoes/cowboy

/datum/gear/shoes/cowboy/New()
	..()
	var/shoes = list()
	shoes["cowboy boots"] = /obj/item/clothing/shoes/cowboy
	shoes["classic cowboy boots"] = /obj/item/clothing/shoes/cowboy/classic
	shoes["snakeskin cowboy boots"] = /obj/item/clothing/shoes/cowboy/snakeskin
	gear_tweaks += new/datum/gear_tweak/path(shoes)

/datum/gear/shoes/heels
	display_name = "high heels"
	path = /obj/item/clothing/shoes/heels
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/shoes/tongs
	display_name = "flip flops"
	path = /obj/item/clothing/shoes/sandal/flipflop
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/shoes/hitops
	display_name = "high-top selection"
	description = "High-top sneakers, in a selection of colors."
	path = /obj/item/clothing/shoes/hitops

/datum/gear/shoes/hitops/New()
	..()
	var/shoes = list()
	shoes["high-tops, white"] = /obj/item/clothing/shoes/hitops
	shoes["high-tops, red"] = /obj/item/clothing/shoes/hitops/red
	shoes["high-tops, black"] = /obj/item/clothing/shoes/hitops/black
	shoes["high-tops, blue"] = /obj/item/clothing/shoes/hitops/blue
	shoes["high-tops, green"] = /obj/item/clothing/shoes/hitops/green
	shoes["high-tops, purple"] = /obj/item/clothing/shoes/hitops/purple
	shoes["high-tops, yellow"] = /obj/item/clothing/shoes/hitops/yellow
	gear_tweaks += new/datum/gear_tweak/path(shoes)

/datum/gear/shoes/black_boots
	display_name = "black boots"
	path = /obj/item/clothing/shoes/black_boots

/datum/gear/shoes/lyodsuit_boots
	display_name = "lyodsuit boots"
	path = /obj/item/clothing/shoes/lyodsuit

/datum/gear/shoes/circuitry
	display_name = "boots, circuitry (empty)"
	path = /obj/item/clothing/shoes/circuitry

/datum/gear/shoes/slippers
	display_name = "bunny slippers"
	path = /obj/item/clothing/shoes/slippers

/datum/gear/shoes/slippers/New()
	..()
	var/slippers = list()
	slippers["bunny slippers"] = /obj/item/clothing/shoes/slippers
	slippers["worn bunny slippers"] = /obj/item/clothing/shoes/slippers_worn
	gear_tweaks += new/datum/gear_tweak/path(slippers)

/datum/gear/shoes/clog
	display_name = "plastic clogs"
	path = /obj/item/clothing/shoes/sandal/clogs
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION
