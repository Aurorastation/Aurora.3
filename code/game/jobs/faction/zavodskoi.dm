/datum/faction/zavodskoi_interstellar
	name = "Zavodskoi Interstellar"
	description = {"<p>
	The largest weapons producer in human space, Zavodskoi Interstellar initially
	found its place with the invention of a militarized voidsuit for use in the Interstellar War.
	With many extraordinarily weapons contracts thanks to the Sol Alliance, as well as acquisitions of
	other major armaments companies, Zavodskoi weapons can be found in the hands of nearly every
	military force across the Orion Spur. They are the main corporation found in the Empire of
	Dominia, and are at the forefront of weapons development technology.
	</p>
	<p>Zavodskoi Interstellar employees can be in the following departments:
	<ul>
	<li><b>Security</b>
	<li><b>Research</b>
	<li><b>Engineering</b>
	</ul></p>
	"}

	title_suffix = "Zavod"

	allowed_role_types = ZAVOD_ROLES

	allowed_species_types = list(
		/datum/species/human,
		/datum/species/skrell,
		/datum/species/unathi,
		/datum/species/diona,
		/datum/species/machine
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
			SPECIES_TAJARA_ZHAN
		)
	)

	titles_to_loadout = list(
		"Security Officer" = /datum/outfit/job/officer/zavodskoi,
		"Warden" = /datum/outfit/job/warden/zavodskoi,
		"Security Cadet" = /datum/outfit/job/intern_sec/zavodskoi,
		"Investigator" =/datum/outfit/job/forensics/zavodskoi,
		"Scientist" = /datum/outfit/job/scientist/zavodskoi,
		"Xenobiologist" = /datum/outfit/job/scientist/zavodskoi,
		"Xenobotanist" = /datum/outfit/job/scientist/zavodskoi,
		"Lab Assistant" = /datum/outfit/job/intern_sci/zavodskoi,
		"Xenoarcheologist"= /datum/outfit/job/scientist/xenoarcheologist/zavodskoi,
		"Engineer" = /datum/outfit/job/engineer/zavodskoi,
		"Atmospheric Technician" = /datum/outfit/job/atmos/zavodskoi,
		"Engineering Apprentice" = /datum/outfit/job/intern_eng/zavodskoi,
		"Corporate Liaison" = /datum/outfit/job/representative/zavodskoi
	)

/datum/outfit/job/officer/zavodskoi
	name = "Security Officer - Zavodskoi Interstellar"

	uniform = /obj/item/clothing/under/rank/security/zavod
	id = /obj/item/card/id/zavodskoi/sec
	head = /obj/item/clothing/head/beret/security/zavodskoi/alt

/datum/outfit/job/warden/zavodskoi
	name = "Warden - Zavodskoi Interstellar"

	uniform = /obj/item/clothing/under/rank/warden/zavod
	id = /obj/item/card/id/zavodskoi/sec
	head = /obj/item/clothing/head/beret/security/zavodskoi/alt

/datum/outfit/job/intern_sec/zavodskoi
	name = "Security Cadet - Zavodskoi Interstellar"

	uniform = /obj/item/clothing/under/rank/cadet/zavod
	id = /obj/item/card/id/zavodskoi/sec
	suit = null
	head = /obj/item/clothing/head/beret/security/zavodskoi/alt

/datum/outfit/job/forensics/zavodskoi
	name = "Investigator - Zavodskoi Interstellar"

	id = /obj/item/card/id/zavodskoi/sec
	uniform = /obj/item/clothing/under/det/forensics
	head = /obj/item/clothing/head/softcap/zavod/alt

/datum/outfit/job/scientist/zavodskoi
	name = "Scientist - Zavodskoi Interstellar"

	uniform = /obj/item/clothing/under/rank/scientist/zavod
	suit = /obj/item/clothing/suit/storage/toggle/labcoat/zavodskoi
	id = /obj/item/card/id/zavodskoi

/datum/outfit/job/scientist/xenoarcheologist/zavodskoi
	name = "Xenoarcheologist - Zavodskoi Interstellar"

	uniform = /obj/item/clothing/under/rank/xenoarcheologist/zavod
	suit = /obj/item/clothing/suit/storage/toggle/labcoat/zavodskoi
	id = /obj/item/card/id/zavodskoi

/datum/outfit/job/intern_sci/zavodskoi
	name = "Lab Assistant - Zavodskoi Interstellar"

	uniform = /obj/item/clothing/under/rank/scientist/intern/zavod
	id = /obj/item/card/id/zavodskoi

/datum/outfit/job/engineer/zavodskoi
	name = "Engineer - Zavodskoi Interstellar"

	uniform = /obj/item/clothing/under/rank/engineer/zavod
	id = /obj/item/card/id/zavodskoi

/datum/outfit/job/atmos/zavodskoi
	name = "Atmospheric Technician - Zavodskoi Interstellar"

	uniform = /obj/item/clothing/under/rank/atmospheric_technician/zavod
	id = /obj/item/card/id/zavodskoi

/datum/outfit/job/intern_eng/zavodskoi
	name = "Engineering Apprentice - Zavodskoi Interstellar"

	uniform = /obj/item/clothing/under/rank/engineer/apprentice/zavod
	id = /obj/item/card/id/zavodskoi

/datum/outfit/job/representative/zavodskoi
	name = "Zavodskoi Interstellar Corporate Liaison"
	uniform = /obj/item/clothing/under/rank/zavodskoi
	head = null
	suit = null
	implants = null
	id = /obj/item/card/id/zavodskoi

	backpack_contents = list(
		/obj/item/device/camera = 1,
		/obj/item/gun/projectile/pistol = 1,
		/obj/item/stamp/zavodskoi = 1
	)