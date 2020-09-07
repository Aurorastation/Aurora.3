// Eyes
/datum/gear/eyes
	display_name = "eyepatch"
	path = /obj/item/clothing/glasses/eyepatch
	slot = slot_glasses
	sort_category = "Glasses and Eyewear"

/datum/gear/eyes/glasses
	display_name = "glasses selection"
	description = "A selection of eyewear, tinted and tintedn't"
	path = /obj/item/clothing/glasses/regular

/datum/gear/eyes/glasses/New()
	..()
	var/glasses = list()
	glasses["glasses, regular"] = /obj/item/clothing/glasses/regular
	glasses["glasses, hipster"] = /obj/item/clothing/glasses/regular/hipster
	glasses["glasses, circle"] = /obj/item/clothing/glasses/regular/circle
	glasses["glasses, jamjar"] = /obj/item/clothing/glasses/regular/jamjar
	glasses["glasses, monocle"] = /obj/item/clothing/glasses/monocle
	glasses["glasses, safety"] = /obj/item/clothing/glasses/safety
	glasses["sunglasses, fat"] = /obj/item/clothing/glasses/sunglasses/big
	glasses["sunglasses, prescription"] = /obj/item/clothing/glasses/sunglasses/prescription
	glasses["sunglasses, aviator"] = /obj/item/clothing/glasses/sunglasses/aviator
	gear_tweaks += new/datum/gear_tweak/path(glasses)

/datum/gear/eyes/goggles
	display_name = "goggles selection"
	description = "A selection of safer eyewear."
	path = /obj/item/clothing/glasses/safety/goggles

/datum/gear/eyes/goggles/New()
	..()
	var/goggles = list()
	goggles["goggles, safety"] = /obj/item/clothing/glasses/regular
	goggles["goggles, scanning"] = /obj/item/clothing/glasses/regular/hipster
	goggles["goggles, science"] = /obj/item/clothing/glasses/regular/circle
	goggles["goggles, orange"] = /obj/item/clothing/glasses/regular/jamjar
	gear_tweaks += new/datum/gear_tweak/path(goggles)

/datum/gear/eyes/medhuds
	display_name = "medical HUD selection"
	description = "A selection of medical HUDs."
	path = /obj/item/clothing/glasses/hud/health/aviator
	allowed_roles = list("Physician", "Surgeon", "Chief Medical Officer", "Pharmacist", "Emergency Medical Technician", "Psychiatrist", "Medical Resident")

/datum/gear/eyes/medhuds/New()
	..()
	var/medhud = list()
	medhud["aviators, medical"] = /obj/item/clothing/glasses/hud/health/aviator
	medhud["HUD, medical"] = /obj/item/clothing/glasses/hud/health
	medhud["HUDpatch, medical"] = /obj/item/clothing/glasses/eyepatch/hud/medical
	gear_tweaks += new/datum/gear_tweak/path(medhud)

/datum/gear/eyes/sechuds
	display_name = "security HUD selection"
	description = "A selection of security HUDs."
	path = /obj/item/clothing/glasses/sunglasses/sechud/aviator
	allowed_roles = list("Security Officer", "Head of Security", "Warden", "Security Cadet", "Detective", "Forensic Technician")

/datum/gear/eyes/medhuds/New()
	..()
	var/sechud = list()
	sechud["aviators, security"] = /obj/item/clothing/glasses/sunglasses/sechud/aviator
	sechud["HUD, security"] = /obj/item/clothing/glasses/hud/security
	sechud["HUDpatch, security"] = /obj/item/clothing/glasses/eyepatch/hud/security
	gear_tweaks += new/datum/gear_tweak/path(sechud)

/datum/gear/eyes/hudpatch
	display_name = "iPatch"
	path = /obj/item/clothing/glasses/eyepatch/hud

/datum/gear/eyes/scipatch
	display_name = "HUDpatch, Science"
	path = /obj/item/clothing/glasses/eyepatch/hud/science
	cost = 1

/datum/gear/eyes/circuitry
	display_name = "goggles, circuitry (empty)"
	path = /obj/item/clothing/glasses/circuitry
