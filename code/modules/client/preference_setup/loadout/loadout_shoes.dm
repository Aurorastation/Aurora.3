// Shoelocker
/datum/gear/shoes
	display_name = "jackboots"
	path = /obj/item/clothing/shoes/jackboots
	slot = slot_shoes
	sort_category = "Shoes and Footwear"

/datum/gear/shoes/workboots
	display_name = "workboots (selection)"
	path = /obj/item/clothing/shoes/workboots

/datum/gear/shoes/workboots/New()
	..()
	var/shoes = list()
	shoes["brown workboots"] = /obj/item/clothing/shoes/workboots
	shoes["grey workboots"] = /obj/item/clothing/shoes/workboots/grey
	shoes["dark workboots"] = /obj/item/clothing/shoes/workboots/dark
	shoes["winter workboots"] = /obj/item/clothing/shoes/winter/explorer
	gear_tweaks += new/datum/gear_tweak/path(shoes)

/datum/gear/shoes/winterboots
	display_name = "winter boots"
	path = /obj/item/clothing/shoes/winter

/datum/gear/shoes/sandals
	display_name = "sandals"
	path = /obj/item/clothing/shoes/sandal

/datum/gear/shoes/color
	display_name = "shoe (selection)"
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
	display_name = "oxford shoe (selection)"
	path = /obj/item/clothing/shoes/laceup

/datum/gear/shoes/dress/New()
	..()
	var/shoes = list()
	shoes["black oxford shoes"] = /obj/item/clothing/shoes/laceup
	shoes["grey oxford shoes"] = /obj/item/clothing/shoes/laceup/grey
	shoes["brown oxford shoes"] = /obj/item/clothing/shoes/laceup/brown
	gear_tweaks += new/datum/gear_tweak/path(shoes)

/datum/gear/shoes/flats
	display_name = "dress flats (selection)"
	description = "Low-heeled dress flats, in a selection of colors."
	path = /obj/item/clothing/shoes/flats

/datum/gear/shoes/flats/New()
	..()
	var/shoes = list()
	shoes["black dress flats"] = /obj/item/clothing/shoes/flats
	shoes["white dress flats"] = /obj/item/clothing/shoes/flats/white
	shoes["red dress flats"] = /obj/item/clothing/shoes/flats/red
	shoes["blue dress flats"] = /obj/item/clothing/shoes/flats/blue
	shoes["green dress flats"] = /obj/item/clothing/shoes/flats/green
	shoes["purple dress flats"] = /obj/item/clothing/shoes/flats/purple
	gear_tweaks += new/datum/gear_tweak/path(shoes)

/datum/gear/shoes/flats_colour
	display_name = "dress flats (colourable)
	path = /obj/item/clothing/shoes/flats/colour
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/shoes/loafers
	display_name = "loafers"
	path = /obj/item/clothing/shoes/flats/loafers
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/shoes/cowboy
	display_name = "cowboy boots (selection)"
	path = /obj/item/clothing/shoes/cowboy

/datum/gear/shoes/cowboy/New()
	..()
	var/shoes = list()
	shoes["cowboy boots"] = /obj/item/clothing/shoes/cowboy
	shoes["classic cowboy boots"] = /obj/item/clothing/shoes/cowboy/classic
	shoes["snakeskin cowboy boots"] = /obj/item/clothing/shoes/cowboy/snakeskin
	gear_tweaks += new/datum/gear_tweak/path(shoes)

/datum/gear/shoes/heels
	display_name = "high heels (colourable)"
	path = /obj/item/clothing/shoes/heels
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/shoes/tongs
	display_name = "flip flops (colourable)"
	path = /obj/item/clothing/shoes/sandal/flipflop
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/shoes/hitops
	display_name = "high-top (selection)"
	description = "High-top sneakers, in a selection of colors."
	path = /obj/item/clothing/shoes/hitops

/datum/gear/shoes/hitops/New()
	..()
	var/shoes = list()
	shoes["white high-tops"] = /obj/item/clothing/shoes/hitops
	shoes["red high-tops"] = /obj/item/clothing/shoes/hitops/red
	shoes["black high-tops"] = /obj/item/clothing/shoes/hitops/black
	shoes["blue high-tops"] = /obj/item/clothing/shoes/hitops/blue
	shoes["green high-tops"] = /obj/item/clothing/shoes/hitops/green
	shoes["purple high-tops"] = /obj/item/clothing/shoes/hitops/purple
	shoes["yellow high-tops"] = /obj/item/clothing/shoes/hitops/yellow
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
	display_name = "bunny slippers (selection)"
	path = /obj/item/clothing/shoes/slippers

/datum/gear/shoes/slippers/New()
	..()
	var/slippers = list()
	slippers["bunny slippers"] = /obj/item/clothing/shoes/slippers
	slippers["worn bunny slippers"] = /obj/item/clothing/shoes/slippers_worn
	gear_tweaks += new/datum/gear_tweak/path(slippers)

/datum/gear/shoes/clog
	display_name = "plastic clogs (colourable)"
	path = /obj/item/clothing/shoes/sandal/clogs
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/shoes/athletic
	display_name = "athletic shoes (colourable)"
	path = /obj/item/clothing/shoes/athletic
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/shoes/skater
	display_name = "skater shoes (colourable)"
	path = /obj/item/clothing/shoes/skater
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/shoes/boots/winter/red
	display_name = "winter boots, red"
	path = /obj/item/clopthing/shoes/boots/winter/red

/datum/gear/shoes/boots/winter/security
	display_name = "winter boots, security"
	path = /obj/item/clothing/shoes/boots/winter/security
	allowed_roles = list("Head of Security", "Warden", "Security Officer", "Detective", "Forensic Technician", "Security Cadet")

/datum/gear/shoes/boots/winter/science
	display_name = "winter boots, research"
	path = /obj/item/clothing/shoes/boots/winter/science
	allowed_roles = list("Research Director", "Scientist", "Roboticist", "Xenobiologist", "Lab Assistant")

/datum/gear/shoes/boots/winter/command
	display_name = "winter boots, captain"
	path = /obj/item/clothing/shoes/boots/winter/command
	allowed_roles = list("Captain")

/datum/gear/shoes/boots/winter/engineering
	display_name = "winter boots, engineering"
	path = /obj/item/clothing/shoes/boots/winter/engineering
	allowed_roles = list("Chief Engineer", "Station Engineer", "Engineering Apprentice")

/datum/gear/shoes/boots/winter/atmos
	display_name = "winter boots, atmospherics"
	path = /obj/item/clothing/shoes/boots/winter/atmos
	allowed_roles = list("Chief Engineer", "Atmospheric Technician", "Engineering Apprentice")

/datum/gear/shoes/boots/winter/medical
	display_name = "winter boots, medical"
	path = /obj/item/clothing/shoes/boots/winter/medical
	allowed_roles = list("Chief Medical Officer", "Physician", "Surgeon", "Psychiatrist", "Pharmacist", "Paramedic", "Medical Resident")

/datum/gear/shoes/boots/winter/mining
	display_name = "winter boots, mining"
	path = /obj/item/clothing/shoes/boots/winter/mining
	allowed_roles = list("Quartermaster", "Shaft Miner")

/datum/gear/shoes/boots/winter/supply
	display_name = "winter boots, supply"
	path = /obj/item/clothing/shoes/boots/winter/supply
	allowed_roles = list("Quartermaster", "Cargo Technician")

/datum/gear/shoes/boots/winter/hydro
	display_name = "winter boots, gardening"
	path = /obj/item/clothing/shoes/boots/winter/hydro
	allowed_roles = list("Gardener")

/datum/gear/shoes/duty
	display_name = "duty boots"
	path = 	/obj/item/clothing/shoes/dutyboots
