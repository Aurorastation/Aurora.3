/datum/faction/zavodskoi_interstellar
	name = "Zavodskoi Interstellar"
	description = {"<p>
	The largest weapons producer in human space, Zavodskoi Interstellar initially
	found its place with the invention of a militarized voidsuit for use in the Interstellar War.
	With many lucrative weapon contracts thanks to the Sol Alliance, as well as acquisitions of
	other major armaments companies, Zavodskoi weapons can be found in the hands of nearly every
	military force across the Orion Spur. They are the main corporation found in the Empire of
	Dominia, and are at the forefront of weapons development technology.
	</p>"}
	departments = {"Science<br>Security"}
	title_suffix = "Zavod"

	allowed_role_types = ZAVOD_ROLES

	allowed_species_types = list(
		/datum/species/human,
		/datum/species/skrell,
		/datum/species/unathi,
		/datum/species/diona,
		/datum/species/machine,
		/datum/species/bug = TRUE,
		/datum/species/bug/type_b = TRUE,
		/datum/species/bug/type_e = TRUE
	)

	job_species_blacklist = list(
		"Corporate Liaison" = list(
			SPECIES_IPC,
			SPECIES_IPC_G1,
			SPECIES_IPC_G2,
			SPECIES_IPC_XION,
			SPECIES_IPC_ZENGHU,
			SPECIES_IPC_BISHOP,
			SPECIES_IPC_SHELL,
			SPECIES_UNATHI,
			SPECIES_TAJARA,
			SPECIES_TAJARA_MSAI,
			SPECIES_TAJARA_ZHAN,
			SPECIES_VAURCA_WORKER,
			SPECIES_VAURCA_WARRIOR,
			SPECIES_VAURCA_BREEDER,
			SPECIES_VAURCA_BULWARK
		)
	)

	titles_to_loadout = list(
		"Security Officer" = /datum/outfit/job/officer/zavodskoi,
		"Warden" = /datum/outfit/job/warden/zavodskoi,
		"Security Cadet" = /datum/outfit/job/intern_sec/zavodskoi,
		"Investigator" =/datum/outfit/job/forensics/zavodskoi,
		"Scientist" = /datum/outfit/job/scientist/zavodskoi,
		"Xenobiologist" = /datum/outfit/job/scientist/xenobiologist/zavodskoi,
		"Xenobotanist" = /datum/outfit/job/scientist/xenobotanist/zavodskoi,
		"Lab Assistant" = /datum/outfit/job/intern_sci/zavodskoi,
		"Xenoarchaeologist"= /datum/outfit/job/scientist/xenoarchaeologist/zavodskoi,
		"Engineer" = /datum/outfit/job/engineer/zavodskoi,
		"Atmospheric Technician" = /datum/outfit/job/atmos/zavodskoi,
		"Engineering Apprentice" = /datum/outfit/job/intern_eng/zavodskoi,
		"Corporate Liaison" = /datum/outfit/job/representative/zavodskoi
	)

/datum/outfit/job/officer/zavodskoi
	name = "Security Officer - Zavodskoi Interstellar"

	uniform = /obj/item/clothing/under/rank/security/zavod
	id = /obj/item/card/id/zavodskoi/sec

/datum/outfit/job/warden/zavodskoi
	name = "Warden - Zavodskoi Interstellar"

	head = /obj/item/clothing/head/warden/zavod
	uniform = /obj/item/clothing/under/rank/warden/zavod
	suit = /obj/item/clothing/suit/storage/toggle/warden/zavod
	id = /obj/item/card/id/zavodskoi/sec
	glasses = /obj/item/clothing/glasses/sunglasses/sechud/aviator/zavod

/datum/outfit/job/intern_sec/zavodskoi
	name = "Security Cadet - Zavodskoi Interstellar"

	uniform = /obj/item/clothing/under/rank/cadet/zavod
	id = /obj/item/card/id/zavodskoi/sec

/datum/outfit/job/forensics/zavodskoi
	name = "Investigator - Zavodskoi Interstellar"

	id = /obj/item/card/id/zavodskoi/sec
	uniform = /obj/item/clothing/under/det/zavod
	suit = /obj/item/clothing/suit/storage/det_jacket/zavod

/datum/outfit/job/scientist/zavodskoi
	name = "Scientist - Zavodskoi Interstellar"

	uniform = /obj/item/clothing/under/rank/scientist/zavod
	suit = /obj/item/clothing/suit/storage/toggle/labcoat/zavodskoi
	id = /obj/item/card/id/zavodskoi

/datum/outfit/job/scientist/xenobiologist/zavodskoi
	name = "Xenobiologist - Zavodskoi Interstellar"

	uniform = /obj/item/clothing/under/rank/scientist/xenobio/zavod
	suit = /obj/item/clothing/suit/storage/toggle/labcoat/zavodskoi
	id = /obj/item/card/id/zavodskoi

/datum/outfit/job/scientist/xenobotanist/zavodskoi
	name = "Xenobotanist - Zavodskoi Interstellar"

	uniform = /obj/item/clothing/under/rank/scientist/botany/zavod
	suit = /obj/item/clothing/suit/storage/toggle/labcoat/zavodskoi
	id = /obj/item/card/id/zavodskoi

/datum/outfit/job/scientist/xenoarchaeologist/zavodskoi
	name = "Xenoarchaeologist - Zavodskoi Interstellar"

	uniform = /obj/item/clothing/under/rank/scientist/xenoarchaeologist/zavod
	suit = /obj/item/clothing/suit/storage/toggle/labcoat/zavodskoi
	id = /obj/item/card/id/zavodskoi

/datum/outfit/job/intern_sci/zavodskoi
	name = "Lab Assistant - Zavodskoi Interstellar"

	uniform = /obj/item/clothing/under/rank/scientist/intern/zavod
	id = /obj/item/card/id/zavodskoi

/datum/outfit/job/engineer/zavodskoi
	name = "Engineer - Zavodskoi Interstellar"

	uniform = /obj/item/clothing/under/rank/engineer/zavod
	head = /obj/item/clothing/head/hardhat/red
	id = /obj/item/card/id/zavodskoi

/datum/outfit/job/atmos/zavodskoi
	name = "Atmospheric Technician - Zavodskoi Interstellar"

	uniform = /obj/item/clothing/under/rank/atmospheric_technician/zavod
	head = /obj/item/clothing/head/hardhat/red
	id = /obj/item/card/id/zavodskoi

/datum/outfit/job/intern_eng/zavodskoi
	name = "Engineering Apprentice - Zavodskoi Interstellar"

	uniform = /obj/item/clothing/under/rank/engineer/apprentice/zavod
	head = /obj/item/clothing/head/beret/corporate/zavod
	id = /obj/item/card/id/zavodskoi

/datum/outfit/job/representative/zavodskoi
	name = "Zavodskoi Interstellar Corporate Liaison"

	head = /obj/item/clothing/head/beret/corporate/zavod
	uniform = /obj/item/clothing/under/rank/liaison/zavod
	suit = /obj/item/clothing/suit/storage/liaison/zavod
	implants = null
	id = /obj/item/card/id/zavodskoi
	accessory = /obj/item/clothing/accessory/tie/corporate/zavod
	suit_accessory = /obj/item/clothing/accessory/pin/corporate/zavod

	backpack_contents = list(
		/obj/item/device/camera = 1,
		/obj/item/gun/projectile/pistol = 1,
		/obj/item/stamp/zavodskoi = 1
	)
