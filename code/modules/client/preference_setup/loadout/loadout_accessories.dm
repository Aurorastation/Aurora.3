/datum/gear/accessory
	display_name = "suspenders"
	path = /obj/item/clothing/accessory/suspenders
	slot = slot_tie
	sort_category = "Accessories"

/datum/gear/accessory/waistcoat
	display_name = "waistcoat"
	path = /obj/item/clothing/accessory/wcoat

/datum/gear/accessory/armband
	display_name = "armband selection"
	path = /obj/item/clothing/accessory/armband

/datum/gear/accessory/armband/New()
	..()
	var/armbands = list()
	armbands["red armband"] = /obj/item/clothing/accessory/armband
	armbands["cargo armband"] = /obj/item/clothing/accessory/armband/cargo
	armbands["EMT armband"] = /obj/item/clothing/accessory/armband/medgreen
	armbands["medical armband"] = /obj/item/clothing/accessory/armband/med
	armbands["engineering armband"] = /obj/item/clothing/accessory/armband/engine
	armbands["hydroponics armband"] = /obj/item/clothing/accessory/armband/hydro
	armbands["science armband"] = /obj/item/clothing/accessory/armband/science
	armbands["synthetic intelligence movement armband"] = /obj/item/clothing/accessory/armband/movement
	armbands["ATLAS armband"] = /obj/item/clothing/accessory/armband/atlas
	armbands["IAC armband"] = /obj/item/clothing/accessory/armband/iac
	gear_tweaks += new/datum/gear_tweak/path(armbands)

/datum/gear/accessory/holster
	display_name = "holster selection"
	path = /obj/item/clothing/accessory/holster/armpit
	allowed_roles = list("Captain", "Head of Personnel", "Security Officer", "Warden", "Head of Security","Detective", "Forensic Technician", "Security Cadet")

/datum/gear/accessory/holster/New()
	..()
	var/holsters = list()
	holsters["holster, armpit"] = /obj/item/clothing/accessory/holster/armpit
	holsters["holster, hip"] = /obj/item/clothing/accessory/holster/hip
	holsters["holster, waist"] = /obj/item/clothing/accessory/holster/waist
	holsters["holster, thigh"] = /obj/item/clothing/accessory/holster/thigh
	gear_tweaks += new/datum/gear_tweak/path(holsters)

/datum/gear/accessory/tie
	display_name = "tie selection"
	path = /obj/item/clothing/accessory/blue

/datum/gear/accessory/tie/New()
	..()
	var/ties = list()
	ties["blue tie"] = /obj/item/clothing/accessory/blue
	ties["red tie"] = /obj/item/clothing/accessory/red
	ties["horrible tie"] = /obj/item/clothing/accessory/horrible
	ties["blue tie with a clip"] = /obj/item/clothing/accessory/tie/blue_clip
	ties["blue long tie"] = /obj/item/clothing/accessory/tie/blue_long
	ties["red tie with a clip"] = /obj/item/clothing/accessory/tie/red_clip
	ties["red long tie"] = /obj/item/clothing/accessory/tie/red_long
	ties["black tie"] = /obj/item/clothing/accessory/tie/black
	ties["dark green tie"] = /obj/item/clothing/accessory/tie/darkgreen
	ties["yellow tie"] = /obj/item/clothing/accessory/tie/yellow
	ties["navy tie"] = /obj/item/clothing/accessory/tie/navy
	ties["white tie"] = /obj/item/clothing/accessory/tie/white
	gear_tweaks += new/datum/gear_tweak/path(ties)

/datum/gear/accessory/brown_vest
	display_name = "webbing, engineering"
	path = /obj/item/clothing/accessory/storage/brown_vest
	allowed_roles = list("Station Engineer", "Atmospheric Technician", "Chief Engineer", "Engineering Apprentice")

/datum/gear/accessory/black_vest
	display_name = "webbing, security"
	path = /obj/item/clothing/accessory/storage/black_vest
	allowed_roles = list("Security Officer","Head of Security","Warden", "Security Cadet", "Detective", "Forensic Technician")

/datum/gear/accessory/white_vest
	display_name = "webbing, medical"
	path = /obj/item/clothing/accessory/storage/white_vest
	allowed_roles = list("Chief Medical Officer", "Medical Doctor", "Chemist", "Psychiatrist", "Paramedic", "Medical Resident")

/datum/gear/accessory/webbing
	display_name = "webbing, simple"
	path = /obj/item/clothing/accessory/storage/webbing
	cost = 2

/datum/gear/accessory/brown_pouches
	display_name = "drop pouches, engineering"
	path = /obj/item/clothing/accessory/storage/brown_pouches
	allowed_roles = list("Station Engineer", "Atmospheric Technician", "Chief Engineer", "Engineering Apprentice")

/datum/gear/accessory/black_pouches
	display_name = "drop pouches, security"
	path = /obj/item/clothing/accessory/storage/black_pouches
	allowed_roles = list("Security Officer","Head of Security", "Warden", "Security Cadet", "Detective", "Forensic Technician")

/datum/gear/accessory/white_pouches
	display_name = "drop pouches, medical"
	path = /obj/item/clothing/accessory/storage/white_pouches
	allowed_roles = list("Chief Medical Officer", "Medical Doctor", "Chemist","Psychiatrist", "Paramedic", "Medical Resident")

/datum/gear/accessory/pouches
	display_name = "drop pouches, simple"
	path = /obj/item/clothing/accessory/storage/pouches
	cost = 2

/datum/gear/accessory/locket
	display_name = "silver locket"
	path = /obj/item/clothing/accessory/locket

/datum/gear/accessory/locket
	display_name = "silver locket"
	path = /obj/item/clothing/accessory/locket

/datum/gear/accessory/sweater
	display_name = "sweater"
	path = /obj/item/clothing/accessory/sweater

/datum/gear/accessory/sweater/New()
	..()
	gear_tweaks = list(gear_tweak_free_color_choice)

/datum/gear/accessory/scarf
	display_name = "scarf selection"
	path = /obj/item/clothing/accessory/scarf

/datum/gear/accessory/scarf/New()
	..()
	var/scarfs = list()
	scarfs["white scarf"] = /obj/item/clothing/accessory/scarf
	scarfs["yellow scarf"] = /obj/item/clothing/accessory/scarf/yellow
	scarfs["green scarf"] = /obj/item/clothing/accessory/scarf/green
	scarfs["purple scarf"] = /obj/item/clothing/accessory/scarf/purple
	scarfs["black scarf"] = /obj/item/clothing/accessory/scarf/black
	scarfs["red scarf"] = /obj/item/clothing/accessory/scarf/red
	scarfs["orange scarf"] = /obj/item/clothing/accessory/scarf/orange
	scarfs["light blue scarf"] = /obj/item/clothing/accessory/scarf/light_blue
	scarfs["dark blue scarf"] = /obj/item/clothing/accessory/scarf/dark_blue
	scarfs["zebra scarf"] = /obj/item/clothing/accessory/scarf/zebra
	gear_tweaks += new/datum/gear_tweak/path(scarfs)

/datum/gear/accessory/chaps
	display_name = "chaps, brown"
	path = /obj/item/clothing/accessory/chaps

/datum/gear/accessory/chaps/black
	display_name = "chaps, black"
	path = /obj/item/clothing/accessory/chaps/black


