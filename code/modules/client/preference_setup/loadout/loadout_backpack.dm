/datum/gear/backpack
	display_name = "leather satchel"
	description = "It's a very fancy satchel made with fine leather."
	path = /obj/item/storage/backpack/satchel
	slot = slot_back
	sort_category = "Bags"
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION

/datum/gear/backpack/bag
	display_name = "bag selection"
	description = "A selection of bags."
	path = /obj/item/storage/backpack
	slot = slot_back
	sort_category = "Bags"
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/backpack/bag/New()
	..()
	var/bags = list()
	bags["backpack"] = /obj/item/storage/backpack/col
	bags["satchel"] = /obj/item/storage/backpack/satchel_col
	bags["duffel bag"] = /obj/item/storage/backpack/duffel/col
	bags["messenger bag"] = /obj/item/storage/backpack/messenger/col
	gear_tweaks += new/datum/gear_tweak/path(bags)

/datum/gear/backpack/medic
	display_name = "medical bag selection"
	description = "A selection of medical bags."
	path = /obj/item/storage/backpack/medic
	slot = slot_back
	allowed_roles = list("Chief Medical Officer", "Physician", "Surgeon", "Psychiatrist", "Emergency Medical Technician", "Medical Resident")
	sort_category = "Bags"
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION

/datum/gear/backpack/medic/New()
	..()
	var/bags = list()
	bags["backpack"] = /obj/item/storage/backpack/medic
	bags["satchel"] = /obj/item/storage/backpack/satchel_med
	bags["duffel bag"] = /obj/item/storage/backpack/duffel/med
	bags["messenger bag"] = /obj/item/storage/backpack/messenger/med
	gear_tweaks += new/datum/gear_tweak/path(bags)

/datum/gear/backpack/security
	display_name = "security bag selection"
	description = "A selection of security bags."
	path = /obj/item/storage/backpack/security
	slot = slot_back
	allowed_roles = list("Head of Security", "Warden", "Detective", "Forensic Technician", "Security Officer", "Security Cadet")
	sort_category = "Bags"
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION

/datum/gear/backpack/security/New()
	..()
	var/bags = list()
	bags["backpack"] = /obj/item/storage/backpack/security
	bags["satchel"] = /obj/item/storage/backpack/satchel_sec
	bags["duffel bag"] = /obj/item/storage/backpack/duffel/sec
	bags["messenger bag"] = /obj/item/storage/backpack/messenger/sec
	gear_tweaks += new/datum/gear_tweak/path(bags)

/datum/gear/backpack/captain
	display_name = "captain bag selection"
	description = "A selection of captain bags."
	path = /obj/item/storage/backpack/captain
	slot = slot_back
	allowed_roles = list("Captain")
	sort_category = "Bags"
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION

/datum/gear/backpack/captain/New()
	..()
	var/bags = list()
	bags["backpack"] = /obj/item/storage/backpack/captain
	bags["satchel"] = /obj/item/storage/backpack/satchel_cap
	bags["duffel bag"] = /obj/item/storage/backpack/duffel/cap
	bags["messenger bag"] = /obj/item/storage/backpack/messenger/com
	gear_tweaks += new/datum/gear_tweak/path(bags)

/datum/gear/backpack/industrial
	display_name = "engineering bag selection"
	description = "A selection of engineering bags."
	path = /obj/item/storage/backpack/industrial
	slot = slot_back
	allowed_roles = list("Chief Engineer", "Station Engineer", "Atmospheric Technician", "Engineering Apprentice", "Shaft Miner")
	sort_category = "Bags"
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION

/datum/gear/backpack/industrial/New()
	..()
	var/bags = list()
	bags["backpack"] = /obj/item/storage/backpack/industrial
	bags["satchel"] = /obj/item/storage/backpack/satchel_eng
	bags["duffel bag"] = /obj/item/storage/backpack/duffel/eng
	bags["messenger bag"] = /obj/item/storage/backpack/messenger/engi
	gear_tweaks += new/datum/gear_tweak/path(bags)

/datum/gear/backpack/toxins
	display_name = "science bag selection"
	description = "A selection of science bags."
	path = /obj/item/storage/backpack/toxins
	slot = slot_back
	allowed_roles = list("Research Director", "Scientist", "Xenobiologist", "Roboticist", "Lab Assistant")
	sort_category = "Bags"
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION

/datum/gear/backpack/toxins/New()
	..()
	var/bags = list()
	bags["backpack"] = /obj/item/storage/backpack/toxins
	bags["satchel"] = /obj/item/storage/backpack/satchel_tox
	bags["duffel bag"] = /obj/item/storage/backpack/duffel/tox
	bags["messenger bag"] = /obj/item/storage/backpack/messenger/tox
	gear_tweaks += new/datum/gear_tweak/path(bags)

/datum/gear/backpack/hydroponics
	display_name = "hyrdoponics bag selection"
	description = "A selection of hydroponics bags."
	path = /obj/item/storage/backpack/hydroponics
	slot = slot_back
	allowed_roles = list("Gardener")
	sort_category = "Bags"
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION

/datum/gear/backpack/hydroponics/New()
	..()
	var/bags = list()
	bags["backpack"] = /obj/item/storage/backpack/hydroponics
	bags["satchel"] = /obj/item/storage/backpack/satchel_hyd
	bags["duffel bag"] = /obj/item/storage/backpack/duffel/hyd
	bags["messenger bag"] = /obj/item/storage/backpack/messenger/hyd
	gear_tweaks += new/datum/gear_tweak/path(bags)

/datum/gear/backpack/pharmacy
	display_name = "pharmacy bag selection"
	description = "A selection of pharmacy bags."
	path = /obj/item/storage/backpack/pharmacy
	slot = slot_back
	allowed_roles = list("Pharmacist")
	sort_category = "Bags"
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION

/datum/gear/backpack/pharmacy/New()
	..()
	var/bags = list()
	bags["backpack"] = /obj/item/storage/backpack/pharmacy
	bags["satchel"] = /obj/item/storage/backpack/satchel_pharm
	bags["duffel bag"] = /obj/item/storage/backpack/duffel/pharm
	bags["messenger bag"] = /obj/item/storage/backpack/messenger/pharm
	gear_tweaks += new/datum/gear_tweak/path(bags)