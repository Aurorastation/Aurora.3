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

	<p>Some character examples are:
	<ul>
	<li><b>Surgical Specialist</b>: Unit to unit Zavodskoi ships the most firearms and weapons compared
	to any other corporation in the known galaxy and you're proud of it, but know the business comes with
	its hazards. Your medical experience has allowed you to survive the closing of many genetics testing
	centers during the recent transfer of leadership, and you know it. Zeng-Hu may have a reputation for
	being the best in the Orion Spur, but they are in the past - Zavodskoi is the future. You are a
	professional through-and-through, and consider yourself a (literal) cut above whatever washouts
	NanoTrasen can hire as surgeons. Just remember, you need to prove that you're better than Zeng-Hu.
	We need these medical contracts, lest we have to cut back the medical division just like the genetics one.</li>
	<li><b>Personal Security Professional</b>: Excellent customer service and client
	care is why Zavodskoi's private security personnel win security contracts and
	you know this. A cut above the rest, you are clear, calm, concise and polite when
	working. As a security force you were voted the most professional private security
	force to work for and as such, you have corporate standards to uphold! The protection
	of Zavodskoi staff is your first priority, but every member of the crew
	should be treated as a valued customer. After all, imagine how bad it would look to
	the shareholders if you were found beating a drunk like some kind of NanoTrasen officer.
	The reputation would last, but your career certainly wouldn't.</li>
	</ul></p>"}
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
		"Xenobiologist" = /datum/outfit/job/scientist/zavodskoi/xenobio,
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
	head = /obj/item/clothing/head/warden/zavod

/datum/outfit/job/intern_sec/zavodskoi
	name = "Security Cadet - Zavodskoi Interstellar"

	uniform = /obj/item/clothing/under/rank/cadet/zavod
	id = /obj/item/card/id/zavodskoi/sec
	suit = null
	head = /obj/item/clothing/head/beret/security/zavodskoi/alt

/datum/outfit/job/forensics/zavodskoi
	name = "Investigator - Zavodskoi Interstellar"

	id = /obj/item/card/id/zavodskoi/sec
	uniform = /obj/item/clothing/under/det/zavod
	suit = /obj/item/clothing/suit/storage/det_jacket/zavod
	head = null

/datum/outfit/job/scientist/zavodskoi
	name = "Scientist - Zavodskoi Interstellar"

	uniform = /obj/item/clothing/under/rank/scientist/zavod
	suit = /obj/item/clothing/suit/storage/toggle/labcoat/zavodskoi
	id = /obj/item/card/id/zavodskoi
	suit = null

/datum/outfit/job/scientist/zavodskoi/xenobio
	name = "Xenobiologist - Zavodskoi Interstellar"

	uniform = /obj/item/clothing/under/rank/scientist/xenobio/zavod
	suit = /obj/item/clothing/suit/storage/toggle/labcoat/zavodskoi
	id = /obj/item/card/id/zavodskoi
	suit = null

/datum/outfit/job/scientist/xenoarcheologist/zavodskoi
	name = "Xenoarcheologist - Zavodskoi Interstellar"

	uniform = /obj/item/clothing/under/rank/xenoarcheologist/zavod
	suit = /obj/item/clothing/suit/storage/toggle/labcoat/zavodskoi
	id = /obj/item/card/id/zavodskoi
	suit = null

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