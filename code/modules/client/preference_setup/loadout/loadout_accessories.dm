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
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/accessory/waistcoat
	display_name = "waistcoat"
	path = /obj/item/clothing/accessory/wcoat_rec

/datum/gear/accessory/waistcoat/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice


/datum/gear/accessory/armband
	display_name = "armband selection"
	path = /obj/item/clothing/accessory/armband

/datum/gear/accessory/armband/New()
	..()
	var/armbands = list()
	armbands["red armband"] = /obj/item/clothing/accessory/armband
	armbands["security armband"] = /obj/item/clothing/accessory/armband/sec
	armbands["cargo armband"] = /obj/item/clothing/accessory/armband/cargo
	armbands["EMT armband"] = /obj/item/clothing/accessory/armband/medgreen
	armbands["medical armband"] = /obj/item/clothing/accessory/armband/med
	armbands["engineering armband"] = /obj/item/clothing/accessory/armband/engine
	armbands["hydroponics armband"] = /obj/item/clothing/accessory/armband/hydro
	armbands["science armband"] = /obj/item/clothing/accessory/armband/science
	armbands["IAC armband"] = /obj/item/clothing/accessory/armband/iac
	gear_tweaks += new/datum/gear_tweak/path(armbands)

/datum/gear/accessory/holster
	display_name = "holster selection"
	path = /obj/item/clothing/accessory/holster/armpit

/datum/gear/accessory/holster/New()
	..()
	var/holsters = list()
	holsters["black holster, armpit"] = /obj/item/clothing/accessory/holster/armpit
	holsters["black holster, hip"] = /obj/item/clothing/accessory/holster/hip
	holsters["black holster, waist"] = /obj/item/clothing/accessory/holster/waist
	holsters["black holster, thigh"] = /obj/item/clothing/accessory/holster/thigh
	holsters["brown holster, armpit"] = /obj/item/clothing/accessory/holster/armpit/brown
	holsters["brown holster, hip"] = /obj/item/clothing/accessory/holster/hip/brown
	holsters["brown holster, waist"] = /obj/item/clothing/accessory/holster/waist/brown
	holsters["brown holster, thigh"] = /obj/item/clothing/accessory/holster/thigh/brown
	gear_tweaks += new/datum/gear_tweak/path(holsters)

/datum/gear/accessory/tie
	display_name = "tie selection"
	path = /obj/item/clothing/accessory/blue

/datum/gear/accessory/tie/New()
	..()
	var/ties = list()
	ties["red tie"] = /obj/item/clothing/accessory/red
	ties["red tie with a clip"] = /obj/item/clothing/accessory/tie/red_clip
	ties["orange tie"] = /obj/item/clothing/accessory/tie/orange
	ties["yellow tie"] = /obj/item/clothing/accessory/tie/yellow
	ties["horrible tie"] = /obj/item/clothing/accessory/horrible
	ties["green tie"] = /obj/item/clothing/accessory/tie/green
	ties["dark green tie"] = /obj/item/clothing/accessory/tie/darkgreen
	ties["blue tie"] = /obj/item/clothing/accessory/blue
	ties["blue tie with a clip"] = /obj/item/clothing/accessory/tie/blue_clip
	ties["navy tie"] = /obj/item/clothing/accessory/tie/navy
	ties["purple tie"] = /obj/item/clothing/accessory/tie/purple
	ties["black tie"] = /obj/item/clothing/accessory/tie/black
	ties["white tie"] = /obj/item/clothing/accessory/tie/white
	gear_tweaks += new/datum/gear_tweak/path(ties)

/datum/gear/accessory/bowtie
	display_name = "bowtie"
	path = /obj/item/clothing/accessory/tie/bowtie

/datum/gear/accessory/bowtie/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

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
	allowed_roles = list("Chief Medical Officer", "Physician", "Surgeon", "Pharmacist", "Psychiatrist", "Paramedic", "Medical Resident")

/datum/gear/accessory/webbing
	display_name = "webbing, simple"
	path = /obj/item/clothing/accessory/storage/webbing
	cost = 2

/datum/gear/accessory/brown_pouches
	display_name = "drop pouches, engineering"
	path = /obj/item/clothing/accessory/storage/pouches/brown
	allowed_roles = list("Station Engineer", "Atmospheric Technician", "Chief Engineer", "Engineering Apprentice")

/datum/gear/accessory/black_pouches
	display_name = "drop pouches, security"
	path = /obj/item/clothing/accessory/storage/pouches/black
	allowed_roles = list("Security Officer","Head of Security", "Warden", "Security Cadet", "Detective", "Forensic Technician")

/datum/gear/accessory/white_pouches
	display_name = "drop pouches, medical"
	path = /obj/item/clothing/accessory/storage/pouches/white
	allowed_roles = list("Chief Medical Officer", "Physician", "Surgeon", "Pharmacist", "Psychiatrist", "Paramedic", "Medical Resident")

/datum/gear/accessory/pouches
	display_name = "drop pouches, simple"
	path = /obj/item/clothing/accessory/storage/pouches/colour
	cost = 2

/datum/gear/accessory/pouches/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/accessory/overalls_mining
	display_name = "overalls, mining"
	path = /obj/item/clothing/accessory/storage/overalls/mining
	allowed_roles = list("Shaft Miner")
	cost = 2

/datum/gear/accessory/overalls_engineer
	display_name = "overalls, engineering"
	path = /obj/item/clothing/accessory/storage/overalls/engineer
	allowed_roles = list("Station Engineer", "Atmospheric Technician", "Chief Engineer", "Engineering Apprentice")
	cost = 2

/datum/gear/accessory/sweater
	display_name = "sweater"
	path = /obj/item/clothing/accessory/sweater

/datum/gear/accessory/sweater/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/accessory/dressshirt
	display_name = "dress shirt"
	path = /obj/item/clothing/accessory/dressshirt

/datum/gear/accessory/dressshirt/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/accessory/dressshirt_r
	display_name = "dress shirt, rolled up"
	path = /obj/item/clothing/accessory/dressshirt_r

/datum/gear/accessory/dressshirt_r/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/accessory/longsleeve
	display_name = "long-sleeved shirt"
	path = /obj/item/clothing/accessory/longsleeve

/datum/gear/accessory/longsleeve/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/accessory/longsleeve_s
	display_name = "long-sleeved shirt, striped"
	path = /obj/item/clothing/accessory/longsleeve_s

/datum/gear/accessory/longsleeve_s/New()
	..()
	var/lshirt = list()
	lshirt["black-striped"] = /obj/item/clothing/accessory/longsleeve_s
	lshirt["blue-striped"] = /obj/item/clothing/accessory/longsleeve_sb
	gear_tweaks += new/datum/gear_tweak/path(lshirt)

/datum/gear/accessory/tshirt
	display_name = "t-shirt"
	path = /obj/item/clothing/accessory/tshirt

/datum/gear/accessory/tshirt/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/accessory/silversun
	display_name = "silversun floral shirt selection"
	path = /obj/item/clothing/accessory/silversun

/datum/gear/accessory/silversun/New()
	..()
	var/shirts = list()
	shirts["cyan silversun shirt"] = /obj/item/clothing/accessory/silversun
	shirts["red silversun shirt"] = /obj/item/clothing/accessory/silversun/red
	shirts["random colored silversun shirt"] = /obj/item/clothing/accessory/silversun/random
	gear_tweaks += new/datum/gear_tweak/path(shirts)

/datum/gear/accessory/scarf
	display_name = "scarf selection"
	path = /obj/item/clothing/accessory/scarf

/datum/gear/accessory/scarf/New()
	..()
	var/scarfs = list()
	scarfs["plain scarf"] = /obj/item/clothing/accessory/scarf
	scarfs["zebra scarf"] = /obj/item/clothing/accessory/scarf/zebra
	gear_tweaks += new/datum/gear_tweak/path(scarfs)
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/accessory/chaps
	display_name = "chaps, brown"
	path = /obj/item/clothing/accessory/chaps

/datum/gear/accessory/chaps/black
	display_name = "chaps, black"
	path = /obj/item/clothing/accessory/chaps/black

/datum/gear/accessory/dogtags
	display_name = "dogtags"
	path = /obj/item/clothing/accessory/dogtags

/datum/gear/accessory/holobadge
	display_name = "badge, holo"
	path = /obj/item/clothing/accessory/badge/holo
	allowed_roles = list("Security Officer","Head of Security", "Warden", "Security Cadet")

/datum/gear/accessory/holobadge/New()
	..()
	var/holobadges = list()
	holobadges["holobadge"] = /obj/item/clothing/accessory/badge/holo
	holobadges["holobadge cord"] = /obj/item/clothing/accessory/badge/holo/cord
	gear_tweaks += new/datum/gear_tweak/path(holobadges)

/datum/gear/accessory/wardenbadge
	display_name = "badge, warden"
	path = /obj/item/clothing/accessory/badge/warden
	allowed_roles = list("Warden")

/datum/gear/accessory/hosbadge
	display_name = "badge, HoS"
	path = /obj/item/clothing/accessory/badge/hos
	allowed_roles = list("Head of Security")

/datum/gear/accessory/detbadge
	display_name = "badge, detective"
	path = /obj/item/clothing/accessory/badge/dia
	allowed_roles = list("Detective")

/datum/gear/accessory/idbadge
	display_name = "badge, identification"
	path = /obj/item/clothing/accessory/badge/idbadge

/datum/gear/accessory/nt_idbadge
	display_name = "badge, NanoTrasen ID"
	path = /obj/item/clothing/accessory/badge/idbadge/nt

/datum/gear/accessory/electronic_idbadge
	display_name = "badge, electronic"
	path = /obj/item/clothing/accessory/badge/idbadge/intel

/datum/gear/accessory/sleeve_patch
	display_name = "shoulder sleeve patch"
	path = /obj/item/clothing/accessory/sleevepatch

/datum/gear/accessory/sleeve_patch/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice