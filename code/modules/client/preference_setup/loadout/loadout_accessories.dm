/datum/gear/accessory
	display_name = "silver locket"
	path = /obj/item/clothing/accessory/locket
	slot = slot_tie
	sort_category = "Accessories"

/datum/gear/accessory/suspenders
	display_name = "suspenders"
	path = /obj/item/clothing/accessory/suspenders

/datum/gear/accessory/suspenders/New()
	..()
	gear_tweaks = list(gear_tweak_free_color_choice)

/datum/gear/accessory/waistcoat
	display_name = "waistcoat"
	path = /obj/item/clothing/accessory/wcoat_rec

/datum/gear/accessory/waistcoat/New()
	..()
	gear_tweaks = list(gear_tweak_free_color_choice)


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
	ties["horrible tie"] = /obj/item/clothing/accessory/horrible
	ties["blue tie with a clip"] = /obj/item/clothing/accessory/tie/blue_clip
	ties["blue long tie"] = /obj/item/clothing/accessory/tie/blue_long
	ties["red tie with a clip"] = /obj/item/clothing/accessory/tie/red_clip
	ties["red long tie"] = /obj/item/clothing/accessory/tie/red_long
	ties["dark green tie"] = /obj/item/clothing/accessory/tie/darkgreen
	gear_tweaks += new/datum/gear_tweak/path(ties)

/datum/gear/accessory/rectie
	display_name = "colorful tie"
	path = /obj/item/clothing/accessory/rectie

/datum/gear/accessory/rectie/New()
	..()
	gear_tweaks = list(gear_tweak_free_color_choice)

/datum/gear/accessory/ribbon
	display_name = "ribbon bow"
	path = /obj/item/clothing/accessory/ribbon

/datum/gear/accessory/ribbon/New()
	..()
	gear_tweaks = list(gear_tweak_free_color_choice)

/datum/gear/accessory/bowtie
	display_name = "bowtie"
	path = /obj/item/clothing/accessory/tie/bowtie

/datum/gear/accessory/bowtie/New()
	..()
	gear_tweaks = list(gear_tweak_free_color_choice)

/datum/gear/accessory/webbing
	display_name = "webbing"
	path = /obj/item/clothing/accessory/storage/webbing
	cost = 2

/datum/gear/accessory/black_pouches
	display_name = "drop pouches, security"
	path = /obj/item/clothing/accessory/storage/black_pouches
	allowed_roles = list("Security Officer","Head of Security", "Warden", "Security Cadet", "Detective", "Forensic Technician")

/datum/gear/accessory/white_pouches
	display_name = "drop pouches, medical"
	path = /obj/item/clothing/accessory/storage/white_pouches
	allowed_roles = list("Chief Medical Officer", "Medical Doctor", "Pharmacist","Psychiatrist", "Paramedic", "Medical Resident")

/datum/gear/accessory/pouches
	display_name = "drop pouches"
	path = /obj/item/clothing/accessory/storage/pouches
	cost = 2

/datum/gear/accessory/sweater
	display_name = "sweater"
	path = /obj/item/clothing/accessory/sweater

/datum/gear/accessory/sweater/New()
	..()
	var/sweater = list()
	sweater["plain"] = /obj/item/clothing/accessory/sweater
	sweater["striped"] = /obj/item/clothing/accessory/sweater/stripes
	sweater["tricolor"] = /obj/item/clothing/accessory/sweater/tricolor
	gear_tweaks += new/datum/gear_tweak/path(sweater)
	gear_tweaks += list(gear_tweak_free_color_choice)

/datum/gear/accessory/dressshirt
	display_name = "dress shirt"
	path = /obj/item/clothing/accessory/dressshirt

/datum/gear/accessory/dressshirt/New()
	..()
	gear_tweaks = list(gear_tweak_free_color_choice)

/datum/gear/accessory/dressshirt_r
	display_name = "dress shirt, rolled up"
	path = /obj/item/clothing/accessory/dressshirt_r

/datum/gear/accessory/dressshirt_r/New()
	..()
	gear_tweaks = list(gear_tweak_free_color_choice)

/datum/gear/accessory/blouse
	display_name = "blouse"
	path = /obj/item/clothing/accessory/blouse

/datum/gear/accessory/blouse/New()
	..()
	gear_tweaks = list(gear_tweak_free_color_choice)

/datum/gear/accessory/shirt
	display_name = "shirt selection"
	path = /obj/item/clothing/accessory/tshirt
	description = "A selection of various t-shirts."

/datum/gear/accessory/shirt/New()
	..()
	var/shirt = list()
	shirt["longsleeve"] = /obj/item/clothing/accessory/longsleeve
	shirt["t-shirt"] = /obj/item/clothing/accessory/tshirt
	shirt["black-striped longsleeve"] = /obj/item/clothing/accessory/longsleeve_s
	shirt["blue-striped longsleeve"] = /obj/item/clothing/accessory/longsleeve_sb
	gear_tweaks += new/datum/gear_tweak/path(shirt)
	gear_tweaks += list(gear_tweak_free_color_choice)

/datum/gear/accessory/scarf
	display_name = "scarf selection"
	path = /obj/item/clothing/accessory/scarf

/datum/gear/accessory/scarf/New()
	..()
	var/scarfs = list()
	scarfs["plain scarf"] = /obj/item/clothing/accessory/scarf
	scarfs["zebra scarf"] = /obj/item/clothing/accessory/scarf/zebra
	gear_tweaks += new/datum/gear_tweak/path(scarfs)
	gear_tweaks += list(gear_tweak_free_color_choice)

/datum/gear/accessory/chaps
	display_name = "chaps"
	path = /obj/item/clothing/accessory/chaps

/datum/gear/accessory/chaps/New()
	..()
	var/chaps = list()
	chaps["chaps, brown"] = /obj/item/clothing/accessory/chaps
	chaps["chaps, black"] = /obj/item/clothing/accessory/chaps/black
	gear_tweaks += new/datum/gear_tweak/path(chaps)

/datum/gear/accessory/badge/contractors
	display_name = "contractor ID selection"
	description = "A selection of contractor IDs."
	path = /obj/item/clothing/accessory/badge/contractor

/datum/gear/accessory/badge/contractors/New()
	..()
	var/badge = list()
	badge["Einstein Engines card"] = /obj/item/clothing/accessory/badge/contractor/einstein
	badge["Necropolis Industries card"] = /obj/item/clothing/accessory/badge/contractor
	badge["Idris Incorporated card"] = /obj/item/clothing/accessory/badge/contractor/idris
	badge["Hephaestus Industries card"] = /obj/item/clothing/accessory/badge/contractor/hephaestus
	badge["Zeng-Hu Pharmaceuticals card"] = /obj/item/clothing/accessory/badge/contractor/zenghu
	gear_tweaks += new/datum/gear_tweak/path(badge)

/datum/gear/accessory/badge/security_contractors
	display_name = "security contractor ID selection"
	description = "A selection of security contractor IDs."
	path = /obj/item/clothing/accessory/badge/contractor/necrosec
	allowed_roles = list("Security Officer", "Warden", "Head of Security","Detective", "Forensic Technician", "Security Cadet")

/datum/gear/accessory/badge/security_contractors/New()
	..()
	var/secbadge = list()
	secbadge["Necropolis Industries security card"] = /obj/item/clothing/accessory/badge/contractor/necrosec
	secbadge["Idris Incorporated security card"] = /obj/item/clothing/accessory/badge/contractor/idrissec
	secbadge["Idris Incorporated IRU card"] = /obj/item/clothing/accessory/badge/contractor/iru
	secbadge["Eridani PMC card"] = /obj/item/clothing/accessory/badge/contractor/eridani
	gear_tweaks += new/datum/gear_tweak/path(secbadge)
