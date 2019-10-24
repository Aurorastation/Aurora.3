// Eyes
/datum/gear/eyes
	display_name = "eyepatch"
	path = /obj/item/clothing/glasses/eyepatch
	slot = slot_glasses
	sort_category = "Glasses and Eyewear"

/datum/gear/eyes/glasses
	display_name = "glasses, prescription"
	path = /obj/item/clothing/glasses/regular

/datum/gear/eyes/glasses/green
	display_name = "glasses, green"
	path = /obj/item/clothing/glasses/gglasses

/datum/gear/eyes/glasses/prescriptionhipster
	display_name = "glasses, hipster"
	path = /obj/item/clothing/glasses/regular/hipster

/datum/gear/eyes/glasses/monocle
	display_name = "monocle"
	path = /obj/item/clothing/glasses/monocle
	cost = 3/2 // it's a monocle

/datum/gear/eyes/glasses/goggles
	display_name = "goggles"
	path = /obj/item/clothing/glasses/goggles

/datum/gear/eyes/scanning_goggles
	display_name = "scanning goggles"
	path = /obj/item/clothing/glasses/regular/scanners

/datum/gear/eyes/sciencegoggles
	display_name = "goggles, science"
	path = /obj/item/clothing/glasses/science

/datum/gear/eyes/material
	display_name = "goggles, material"
	path = /obj/item/clothing/glasses/material
	allowed_roles = list("Station Engineer","Atmospheric Technician","Chief Engineer","Engineering Apprentice","Shaft Miner")
	cost = 2 // even though they're job-restricted, material scanners are powerful

/datum/gear/eyes/material/aviators
	display_name = "aviators, material"
	path = /obj/item/clothing/glasses/material/aviator

/datum/gear/eyes/meson
	display_name = "goggles, meson"
	path = /obj/item/clothing/glasses/meson/aviator
	allowed_roles = list("Station Engineer","Atmospheric Technician","Chief Engineer","Engineering Apprentice", "Research Director","Scientist", "Shaft Miner")
	cost = 3/2 // balance re: mesons

/datum/gear/eyes/meson/aviators
	display_name = "aviators, meson"
	path = /obj/item/clothing/glasses/meson/aviator

/datum/gear/eyes/meson/prescription
	display_name = "goggles, meson, prescription"
	path = /obj/item/clothing/glasses/meson/prescription

/datum/gear/eyes/security
	display_name = "security HUD"
	path = /obj/item/clothing/glasses/hud/security
	allowed_roles = list("Security Officer", "Head of Security", "Warden", "Security Cadet", "Detective", "Forensic Technician")

/datum/gear/eyes/security/aviator
	display_name = "aviators, security"
	path = /obj/item/clothing/glasses/sunglasses/sechud/aviator

/datum/gear/eyes/medical
	display_name = "medical HUD"
	path = /obj/item/clothing/glasses/hud/health
	allowed_roles = list("Medical Doctor", "Chief Medical Officer", "Pharmacist", "Paramedic", "Psychiatrist", "Medical Resident")
	cost = 1 // special functionality but job restricted

/datum/gear/eyes/medical/aviator
	display_name = "aviators, medical"
	path = /obj/item/clothing/glasses/hud/health/aviator

/datum/gear/eyes/shades
	display_name = "sunglasses, fat (Security/Command)"
	path = /obj/item/clothing/glasses/sunglasses/big
	allowed_roles = list("Security Officer", "Head of Security", "Warden", "Captain", "Head of Personnel", "Quartermaster", "Internal Affairs Agent", "Detective", "Forensic Technician")
	cost = 1 // special functionality but job restricted

/datum/gear/eyes/shades/prescriptionsun
	display_name = "sunglasses, presciption (Security/Command)"
	path = /obj/item/clothing/glasses/sunglasses/prescription

/datum/gear/eyes/shades/aviator
	display_name = "sunglasses, aviator (Security/Command)"
	path = /obj/item/clothing/glasses/sunglasses/aviator

/datum/gear/eyes/glasses/fakesun
	display_name = "sunglasses, stylish"
	path = /obj/item/clothing/glasses/fakesunglasses

/datum/gear/eyes/glasses/fakesun/prescription
	display_name = "prescription sunglasses, stylish"
	path = /obj/item/clothing/glasses/fakesunglasses/prescription

/datum/gear/eyes/glasses/fakesun/aviator
	display_name = "aviators, stylish"
	path = /obj/item/clothing/glasses/fakesunglasses/aviator

/datum/gear/eyes/hudpatch
	display_name = "iPatch"
	path = /obj/item/clothing/glasses/eyepatch/hud
	cost = 1 // does nothing, not job-restricted

/datum/gear/eyes/secpatch
	display_name = "HUDpatch, Security"
	path= /obj/item/clothing/glasses/eyepatch/hud/security
	allowed_roles = list("Security Officer", "Head of Security", "Warden", "Security Cadet", "Detective", "Forensic Technician")
	cost = 1 //snowflake tax

/datum/gear/eyes/medpatch
	display_name = "HUDpatch, Medical"
	path = /obj/item/clothing/glasses/eyepatch/hud/medical
	allowed_roles = list("Medical Doctor", "Chief Medical Officer", "Pharmacist", "Paramedic", "Psychiatrist", "Medical Resident")
	cost = 1

/datum/gear/eyes/mespatch
	display_name = "HUDpatch, Mesons"
	path = /obj/item/clothing/glasses/eyepatch/hud/meson
	allowed_roles = list("Station Engineer","Atmospheric Technician","Chief Engineer","Engineering Apprentice", "Research Director","Scientist", "Shaft Miner")
	cost = 3/2 // balance re: mesons

/datum/gear/eyes/matpatch
	display_name = "HUDpatch, Material"
	path = /obj/item/clothing/glasses/eyepatch/hud/material
	allowed_roles = list("Station Engineer","Atmospheric Technician","Chief Engineer","Engineering Apprentice", "Shaft Miner")
	cost = 3/2

/datum/gear/eyes/scipatch
	display_name = "HUDpatch, Science"
	path = /obj/item/clothing/glasses/eyepatch/hud/science
	cost = 1 // they do nothing but aren't job-restricted

/datum/gear/eyes/weldpatch
	display_name = "HUDpatch, Welding"
	path = /obj/item/clothing/glasses/eyepatch/hud/welder
	allowed_roles = list("Station Engineer","Atmospheric Technician","Chief Engineer","Engineering Apprentice","Research Director","Roboticist")
	cost = 3/2

/datum/gear/eyes/spiffygogs
	display_name = "orange goggles"
	path = /obj/item/clothing/glasses/spiffygogs

/datum/gear/eyes/circuitry
	display_name = "goggles, circuitry (empty)"
	path = /obj/item/clothing/glasses/circuitry
	cost = 3/2 // special functionality but doesn't replace uniform items