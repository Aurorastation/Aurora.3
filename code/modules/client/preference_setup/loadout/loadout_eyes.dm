// Eyes
/datum/gear/eyes
	display_name = "eyepatch"
	path = /obj/item/clothing/glasses/eyepatch
	slot = slot_glasses
	sort_category = "Glasses and Eyewear"

/datum/gear/eyes/glasses
	display_name = "glasses, prescription"
	path = /obj/item/clothing/glasses/regular

/datum/gear/eyes/glasses/hipster
	display_name = "glasses, hipster"
	path = /obj/item/clothing/glasses/regular/hipster

/datum/gear/eyes/glasses/circle
	display_name = "glasses, circle"
	path = /obj/item/clothing/glasses/regular/circle

/datum/gear/eyes/glasses/jamjar
	display_name = "glasses, jamjar"
	path = /obj/item/clothing/glasses/regular/jamjar

/datum/gear/eyes/glasses/rimless
	display_name = "Glasses, prescription rimless"
	path = /obj/item/clothing/glasses/regular/rimless

/datum/gear/eyes/glasses/thin
	display_name = "Glasses, thin frame"
	path = /obj/item/clothing/glasses/regular/thin

/datum/gear/eyes/glasses/monocle
	display_name = "monocle"
	path = /obj/item/clothing/glasses/monocle

/datum/gear/eyes/glasses/safety
	display_name = "safety glasses"
	path = /obj/item/clothing/glasses/safety

/datum/gear/eyes/glasses/safety/goggles
	display_name = "safety goggles"
	path = /obj/item/clothing/glasses/safety/goggles

/datum/gear/eyes/scanning_goggles
	display_name = "scanning goggles"
	path = /obj/item/clothing/glasses/regular/scanners

/datum/gear/eyes/sciencegoggles
	display_name = "science goggles"
	path = /obj/item/clothing/glasses/science

/datum/gear/eyes/materialaviators
	display_name = "aviators, material"
	path = /obj/item/clothing/glasses/material/aviator
	allowed_roles = list("Station Engineer","Atmospheric Technician","Chief Engineer","Engineering Apprentice","Shaft Miner")

/datum/gear/eyes/materialgoggles
	display_name = "material scanner"
	path = /obj/item/clothing/glasses/material
	allowed_roles = list("Station Engineer","Atmospheric Technician","Chief Engineer","Engineering Apprentice","Shaft Miner")

/datum/gear/eyes/materialprescription
	display_name = "material scanner, prescription"
	path = /obj/item/clothing/glasses/material/prescription
	allowed_roles = list("Station Engineer","Atmospheric Technician","Chief Engineer","Engineering Apprentice","Shaft Miner")

/datum/gear/eyes/mesonaviators
	display_name = "aviators, meson"
	path = /obj/item/clothing/glasses/meson/aviator
	allowed_roles = list("Station Engineer","Atmospheric Technician","Chief Engineer","Engineering Apprentice", "Research Director","Scientist", "Shaft Miner")

/datum/gear/eyes/mesonprescription
	display_name = "meson goggles, prescription"
	path = /obj/item/clothing/glasses/meson/prescription
	allowed_roles = list("Station Engineer","Atmospheric Technician","Chief Engineer","Engineering Apprentice", "Research Director","Scientist", "Shaft Miner")

/datum/gear/eyes/mesongoggles
	display_name = "meson goggles"
	path = /obj/item/clothing/glasses/meson
	allowed_roles = list("Station Engineer","Atmospheric Technician","Chief Engineer","Engineering Apprentice", "Research Director","Scientist", "Shaft Miner")

/datum/gear/eyes/security
	display_name = "security HUD"
	path = /obj/item/clothing/glasses/hud/security
	allowed_roles = list("Security Officer", "Head of Security", "Warden", "Security Cadet", "Detective", "Forensic Technician")

/datum/gear/eyes/security/prescription
	display_name = "security HUD, prescription"
	path = /obj/item/clothing/glasses/hud/security/prescription

/datum/gear/eyes/shades/security
	display_name = "sunglasses, security HUD"
	path = /obj/item/clothing/glasses/sunglasses/sechud

/datum/gear/eyes/shades/security/prescription
	display_name = "sunglasses, security HUD prescription"
	path = /obj/item/clothing/glasses/sunglasses/sechud/prescription

/datum/gear/eyes/security/aviator
	display_name = "aviators, security"
	path = /obj/item/clothing/glasses/sunglasses/sechud/aviator

/datum/gear/eyes/medical
	display_name = "medical HUD"
	path = /obj/item/clothing/glasses/hud/health
	allowed_roles = list("Physician", "Surgeon", "Chief Medical Officer", "Pharmacist", "Paramedic", "Psychiatrist", "Medical Resident")

/datum/gear/eyes/medical/prescription
	display_name = "medical HUD, prescription"
	path = /obj/item/clothing/glasses/hud/health/prescription

/datum/gear/eyes/medical/aviator
	display_name = "aviators, medical"
	path = /obj/item/clothing/glasses/hud/health/aviator

/datum/gear/eyes/medical/fakesunglasses
	display_name = "medical HUD, sunglasses"
	path = /obj/item/clothing/glasses/hud/health/fakesunglasses

/datum/gear/eyes/medical/fakesunglasses/prescription
	display_name = "medical HUD, sunglasses prescription"
	path = /obj/item/clothing/glasses/hud/health/fakesunglasses/prescription

/datum/gear/eyes/shades
	display_name = "sunglasses, fat"
	path = /obj/item/clothing/glasses/sunglasses/big
	allowed_roles = list("Security Officer", "Head of Security", "Warden", "Captain", "Head of Personnel", "Quartermaster", "Internal Affairs Agent", "Detective", "Forensic Technician")

/datum/gear/eyes/shades/prescriptionsun
	display_name = "sunglasses, presciption"
	path = /obj/item/clothing/glasses/sunglasses/prescription

/datum/gear/eyes/shades/prescriptionsun/fat
	display_name = "sunglasses, fat prescription"
	path = /obj/item/clothing/glasses/sunglasses/big/prescription

/datum/gear/eyes/shades/aviator
	display_name = "sunglasses, aviator"
	path = /obj/item/clothing/glasses/sunglasses/aviator

/datum/gear/eyes/glasses/fakesun
	display_name = "sunglasses, stylish"
	path = /obj/item/clothing/glasses/fakesunglasses

/datum/gear/eyes/glasses/fakesun/prescription
	display_name = "sunglasses, stylish prescription"
	path = /obj/item/clothing/glasses/fakesunglasses/prescription

/datum/gear/eyes/glasses/fakesun/aviator
	display_name = "aviators, stylish"
	path = /obj/item/clothing/glasses/fakesunglasses/aviator

/datum/gear/eyes/glasses/fakesun/fat
	display_name = "sunglasses, stylish fat
	path = /obj/item/clothing/glasses/fakesunglasses/big

/datum/gear/eyes/hudpatch
	display_name = "iPatch"
	path = /obj/item/clothing/glasses/eyepatch/hud

/datum/gear/eyes/secpatch
	display_name = "HUDpatch, Security"
	path= /obj/item/clothing/glasses/eyepatch/hud/security
	allowed_roles = list("Security Officer", "Head of Security", "Warden", "Security Cadet", "Detective", "Forensic Technician")
	cost = 2 //snowflake tax

/datum/gear/eyes/medpatch
	display_name = "HUDpatch, Medical"
	path = /obj/item/clothing/glasses/eyepatch/hud/medical
	allowed_roles = list("Physician", "Surgeon", "Chief Medical Officer", "Pharmacist", "Paramedic", "Psychiatrist", "Medical Resident")
	cost = 2

/datum/gear/eyes/mespatch
	display_name = "HUDpatch, Mesons"
	path = /obj/item/clothing/glasses/eyepatch/hud/meson
	allowed_roles = list("Station Engineer","Atmospheric Technician","Chief Engineer","Engineering Apprentice", "Research Director","Scientist", "Shaft Miner")
	cost = 2

/datum/gear/eyes/matpatch
	display_name = "HUDpatch, Material"
	path = /obj/item/clothing/glasses/eyepatch/hud/material
	allowed_roles = list("Station Engineer","Atmospheric Technician","Chief Engineer","Engineering Apprentice", "Shaft Miner")
	cost = 2

/datum/gear/eyes/scipatch
	display_name = "HUDpatch, Science"
	path = /obj/item/clothing/glasses/eyepatch/hud/science
	cost = 2

/datum/gear/eyes/weldpatch
	display_name = "HUDpatch, Welding"
	path = /obj/item/clothing/glasses/eyepatch/hud/welder
	allowed_roles = list("Station Engineer","Atmospheric Technician","Chief Engineer","Engineering Apprentice","Research Director","Roboticist")
	cost = 2

/datum/gear/eyes/spiffygogs
	display_name = "orange goggles"
	path = /obj/item/clothing/glasses/spiffygogs

/datum/gear/eyes/circuitry
	display_name = "goggles, circuitry (empty)"
	path = /obj/item/clothing/glasses/circuitry

/datum/gear/eyes/blindfold
	display_name = "blindfold (colourable)"
	path = /obj/item/clothing/glasses/blindfold/colour
	flags = GEAR_HAS_NAME_SELECTION | GEAR_HAS_DESC_SELECTION | GEAR_HAS_COLOR_SELECTION