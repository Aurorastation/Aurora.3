// Eyes
/datum/gear/eyes
	display_name = "eyepatch"
	path = /obj/item/clothing/glasses/eyepatch
	slot = slot_glasses
	sort_category = "Glasses and Eyewear"

/datum/gear/eyes/whitepatch
	display_name = "simple eyepatch (colorable)"
	path = /obj/item/clothing/glasses/eyepatch/white
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/eyes/glasses
	display_name = "glasses selection"
	description = "A selection of glasses."
	path = /obj/item/clothing/glasses/regular

/datum/gear/eyes/glasses/New()
	..()
	var/list/glasses = list()
	glasses["glasses, regular"] = /obj/item/clothing/glasses/regular
	glasses["glasses, hipster"] = /obj/item/clothing/glasses/regular/hipster
	glasses["glasses, circle"] = /obj/item/clothing/glasses/regular/circle
	glasses["glasses, jamjar"] = /obj/item/clothing/glasses/regular/jamjar
	glasses["glasses, monocle"] = /obj/item/clothing/glasses/monocle
	glasses["glasses, safety"] = /obj/item/clothing/glasses/safety
	glasses["glasses, safety (prescription)"] = /obj/item/clothing/glasses/safety/prescription
	gear_tweaks += new /datum/gear_tweak/path(glasses)

/datum/gear/eyes/fakesunglasses
	display_name = "sunglasses selection"
	description = "A selection of sunglasses."
	path = /obj/item/clothing/glasses/sunglasses

/datum/gear/eyes/fakesunglasses/New()
	..()
	var/list/glasses = list()
	glasses["sunglasses, regular"] = /obj/item/clothing/glasses/fakesunglasses
	glasses["sunglasses, aviator"] = /obj/item/clothing/glasses/fakesunglasses/aviator
	glasses["sunglasses, prescription"] = /obj/item/clothing/glasses/fakesunglasses/prescription
	glasses["sunglasses, fat"] = /obj/item/clothing/glasses/fakesunglasses/big
	glasses["sunglasses, visor"] = /obj/item/clothing/glasses/fakesunglasses/visor
	gear_tweaks += new /datum/gear_tweak/path(glasses)

/datum/gear/eyes/sunglasses
	display_name = "flash-proof sunglasses selection (Security/Command)"
	description = "A selection of flash-proof sunglasses."
	path = /obj/item/clothing/glasses/sunglasses
	allowed_roles = list("Security Officer", "Head of Security", "Warden", "Captain", "Executive Officer", "Operations Manager", "Investigator", "Bridge Crew")

/datum/gear/eyes/sunglasses/New()
	..()
	var/list/glasses = list()
	glasses["flash-proof sunglasses, regular"] = /obj/item/clothing/glasses/sunglasses
	glasses["flash-proof sunglasses, aviator"] = /obj/item/clothing/glasses/sunglasses/aviator
	glasses["flash-proof sunglasses, prescription"] = /obj/item/clothing/glasses/sunglasses/prescription
	glasses["flash-proof sunglasses, fat"] = /obj/item/clothing/glasses/sunglasses/big
	glasses["flash-proof sunglasses, visor"] = /obj/item/clothing/glasses/sunglasses/visor
	gear_tweaks += new /datum/gear_tweak/path(glasses)

/datum/gear/eyes/goggles
	display_name = "goggles selection"
	description = "A selection of safer eyewear."
	path = /obj/item/clothing/glasses/safety/goggles

/datum/gear/eyes/goggles/New()
	..()
	var/list/goggles = list()
	goggles["goggles, safety"] = /obj/item/clothing/glasses/safety/goggles
	goggles["goggles, safety (prescription)"] = /obj/item/clothing/glasses/safety/goggles/prescription
	goggles["goggles, scanning"] = /obj/item/clothing/glasses/regular/scanners
	goggles["goggles, science"] = /obj/item/clothing/glasses/science
	goggles["goggles, orange"] = /obj/item/clothing/glasses/spiffygogs
	gear_tweaks += new /datum/gear_tweak/path(goggles)

/datum/gear/eyes/medhuds
	display_name = "medical HUD selection"
	description = "A selection of medical HUDs."
	path = /obj/item/clothing/glasses/hud/health/aviator
	allowed_roles = list("Physician", "Surgeon", "Chief Medical Officer", "Pharmacist", "First Responder", "Psychiatrist", "Medical Intern")

/datum/gear/eyes/medhuds/New()
	..()
	var/list/medhud = list()
	medhud["aviators, medical"] = /obj/item/clothing/glasses/hud/health/aviator
	medhud["HUD, medical"] = /obj/item/clothing/glasses/hud/health
	medhud["HUDpatch, medical"] = /obj/item/clothing/glasses/eyepatch/hud/medical
	medhud["prescription HUD, medical"] = /obj/item/clothing/glasses/hud/health/prescription
	medhud["visor sunglasses, medical"] = /obj/item/clothing/glasses/hud/health/aviator/visor
	gear_tweaks += new /datum/gear_tweak/path(medhud)

/datum/gear/eyes/sechuds
	display_name = "security HUD selection"
	description = "A selection of security HUDs."
	path = /obj/item/clothing/glasses/sunglasses/sechud/aviator
	allowed_roles = list("Security Officer", "Head of Security", "Warden", "Security Cadet", "Investigator")

/datum/gear/eyes/sechuds/New()
	..()
	var/list/sechud = list()
	sechud["sunglasses, security"] = /obj/item/clothing/glasses/sunglasses/sechud
	sechud["fat sunglasses, security"] = /obj/item/clothing/glasses/sunglasses/sechud/big
	sechud["aviators, security"] = /obj/item/clothing/glasses/sunglasses/sechud/aviator
	sechud["HUD, security"] = /obj/item/clothing/glasses/hud/security
	sechud["HUDpatch, security"] = /obj/item/clothing/glasses/eyepatch/hud/security
	sechud["prescription HUD, security"] = /obj/item/clothing/glasses/hud/security/prescription
	sechud["visor sunglasses, security"] = /obj/item/clothing/glasses/sunglasses/sechud/aviator/visor
	gear_tweaks += new /datum/gear_tweak/path(sechud)

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

/datum/gear/eyes/blindfolds
	display_name = "blindfold selection"
	description = "A selection of blindfolds."
	path = /obj/item/clothing/glasses/sunglasses/blindfold
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION

/datum/gear/eyes/blindfolds/New()
	..()
	var/list/blindfold = list()
	blindfold["blindfold"] = /obj/item/clothing/glasses/sunglasses/blindfold/white
	blindfold["blindfold, transparent"] = /obj/item/clothing/glasses/sunglasses/blindfold/white/seethrough
	gear_tweaks += new /datum/gear_tweak/path(blindfold)

/datum/gear/eyes/goon_goggles
	display_name = "tactical HUD goggles selection (security)"
	description = "A selection of tactical eyewear. Note that factional ones can only be taken by members of that faction."
	path = /obj/item/clothing/glasses/safety/goggles/goon

/datum/gear/eyes/goon_goggles/New()
	..()
	allowed_roles = security_positions
	var/list/goggles = list()
	goggles["goggles, tactical"] = list(/obj/item/clothing/glasses/safety/goggles/goon, null)
	goggles["goggles, tactical (PMCG)"] = list(/obj/item/clothing/glasses/safety/goggles/goon/pmc, "Private Military Contracting Group")
	goggles["goggles, tactical (Zavodskoi)"] = list(/obj/item/clothing/glasses/safety/goggles/goon/zavod, "Zavodskoi Interstellar")
	goggles["goggles, tactical (Idris)"] = list(/obj/item/clothing/glasses/safety/goggles/goon/idris, "Idris Incorporated")
	gear_tweaks += new /datum/gear_tweak/path/faction(goggles)

/datum/gear/eyes/medical_goggles
	display_name = "HUD goggles selection (medical)"
	description = "A selection of medical goggles. Note that factional ones can only be taken by members of that faction."
	path = /obj/item/clothing/glasses/safety/goggles/medical
	allowed_roles = list("First Responder")

/datum/gear/eyes/medical_goggles/New()
	..()
	var/list/goggles = list()
	goggles["goggles, medical"] = list(/obj/item/clothing/glasses/safety/goggles/medical, null)
	goggles["goggles, medical (PMCG)"] = list(/obj/item/clothing/glasses/safety/goggles/medical/pmc, "Private Military Contracting Group")
	goggles["goggles, medical (Zeng-Hu)"] = list(/obj/item/clothing/glasses/safety/goggles/medical/zeng, "Zeng-Hu Pharmaceuticals")
	gear_tweaks += new /datum/gear_tweak/path/faction(goggles)

/datum/gear/eyes/colorable
	display_name = "colorable glasses"
	path = /obj/item/clothing/glasses/colorable
	flags = GEAR_HAS_COLOR_SELECTION | GEAR_HAS_ALPHA_SELECTION | GEAR_HAS_ACCENT_COLOR_SELECTION
