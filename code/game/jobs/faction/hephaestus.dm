/datum/faction/hephaestus_industries
	name = "Hephaestus Industries"
	description = {"<p>
	Hephaestus Industries, a sprawling and diverse mega-corporation
	focused on engineering and manufacturing on a massive scale, found their start
	as a conglomerate of several aerospace companies in the 22nd century. Initially
	funded by sales of new designs for warp technology, the company fell on hard times
	during the Second Great Depression in the late 23rd century. Receiving bailouts
	from the Sol Alliance and securing several crucial production contracts, they have slowly
	worked their way to become the dominant manufacturing mega-corporation in the
	Sol Alliance, pioneering interstellar logistics and construction on an awe-inspiring scale.
	</p>"}
	departments = {"Engineering<br>Operations"}
	title_suffix = "Hepht"

	allowed_role_types = HEPH_ROLES

	allowed_species_types = list(
		/datum/species/human,
		/datum/species/skrell,
		/datum/species/machine,
		/datum/species/unathi,
		/datum/species/bug = TRUE,
		/datum/species/bug/type_b = TRUE,
		/datum/species/bug/type_b/type_bb = TRUE,
		/datum/species/bug/type_e = TRUE,
		/datum/species/tajaran,
		/datum/species/diona
	)


	job_species_blacklist = list(
		"Corporate Liaison" = list(
			SPECIES_VAURCA_WORKER,
			SPECIES_VAURCA_WARRIOR,
			SPECIES_VAURCA_ATTENDANT,
			SPECIES_VAURCA_BULWARK,
			SPECIES_VAURCA_BREEDER
		)
	)

	titles_to_loadout = list(
		"Hangar Technician" = /obj/outfit/job/hangar_tech/hephaestus,
		"Shaft Miner" = /obj/outfit/job/mining/hephaestus,
		"Machinist" = /obj/outfit/job/machinist/hephaestus,
		"Engineer" = /obj/outfit/job/engineer/hephaestus,
		"Atmospheric Technician" = /obj/outfit/job/atmos/hephaestus,
		"Engineering Apprentice" = /obj/outfit/job/intern_eng/hephaestus,
		"Atmospherics Apprentice" = /obj/outfit/job/intern_atmos/hephaestus,
		"Corporate Reporter" = /obj/outfit/job/journalist/hephaestus,
		"Corporate Liaison" = /obj/outfit/job/representative/hephaestus,
		"Assistant" = /obj/outfit/job/assistant/hephaestus,
		"Technical Assistant" = /obj/outfit/job/assistant/tech_assistant/hephaestus,
		"Off-Duty Crew Member" = /obj/outfit/job/visitor/hephaestus,
		"Engineering Personnel" = /obj/outfit/job/engineer/event/hephaestus,
		"Operations Personnel" = /obj/outfit/job/hangar_tech/event/hephaestus
	)

/obj/outfit/job/hangar_tech/hephaestus
	name = "Hangar Technician - Hephaestus"

	uniform = /obj/item/clothing/under/rank/hangar_technician/heph
	id = /obj/item/card/id/hephaestus

	backpack_faction = /obj/item/storage/backpack/heph
	satchel_faction = /obj/item/storage/backpack/satchel/heph
	dufflebag_faction = /obj/item/storage/backpack/duffel/heph
	messengerbag_faction = /obj/item/storage/backpack/messenger/heph

/obj/outfit/job/machinist/hephaestus
	name = "Machinist - Hephaestus"

	uniform = /obj/item/clothing/under/rank/machinist/heph
	id = /obj/item/card/id/hephaestus

	backpack_faction = /obj/item/storage/backpack/heph
	satchel_faction = /obj/item/storage/backpack/satchel/heph
	dufflebag_faction = /obj/item/storage/backpack/duffel/heph
	messengerbag_faction = /obj/item/storage/backpack/messenger/heph

/obj/outfit/job/mining/hephaestus
	name = "Shaft Miner - Hephaestus"

	uniform = /obj/item/clothing/under/rank/miner/heph
	id = /obj/item/card/id/hephaestus

	backpack_faction = /obj/item/storage/backpack/heph
	satchel_faction = /obj/item/storage/backpack/satchel/heph
	dufflebag_faction = /obj/item/storage/backpack/duffel/heph
	messengerbag_faction = /obj/item/storage/backpack/messenger/heph

/obj/outfit/job/engineer/hephaestus
	name = "Engineer - Hephaestus"

	uniform = /obj/item/clothing/under/rank/engineer/heph
	head = /obj/item/clothing/head/hardhat/green
	id = /obj/item/card/id/hephaestus

	backpack_faction = /obj/item/storage/backpack/heph
	satchel_faction = /obj/item/storage/backpack/satchel/heph
	dufflebag_faction = /obj/item/storage/backpack/duffel/heph
	messengerbag_faction = /obj/item/storage/backpack/messenger/heph

/obj/outfit/job/atmos/hephaestus
	name = "Atmospheric Technician - Hephaestus"

	uniform = /obj/item/clothing/under/rank/atmospheric_technician/heph
	head = /obj/item/clothing/head/hardhat/green
	id = /obj/item/card/id/hephaestus

	backpack_faction = /obj/item/storage/backpack/heph
	satchel_faction = /obj/item/storage/backpack/satchel/heph
	dufflebag_faction = /obj/item/storage/backpack/duffel/heph
	messengerbag_faction = /obj/item/storage/backpack/messenger/heph

/obj/outfit/job/intern_eng/hephaestus
	name = "Engineering Apprentice - Hephaestus"

	uniform = /obj/item/clothing/under/rank/engineer/apprentice/heph
	head = /obj/item/clothing/head/beret/corporate/heph
	id = /obj/item/card/id/hephaestus

	backpack_faction = /obj/item/storage/backpack/heph
	satchel_faction = /obj/item/storage/backpack/satchel/heph
	dufflebag_faction = /obj/item/storage/backpack/duffel/heph
	messengerbag_faction = /obj/item/storage/backpack/messenger/heph

/obj/outfit/job/intern_atmos/hephaestus
	name = "Atmospherics Apprentice - Hephaestus"

	uniform = /obj/item/clothing/under/rank/engineer/apprentice/heph
	head = /obj/item/clothing/head/beret/corporate/heph
	id = /obj/item/card/id/hephaestus

	backpack_faction = /obj/item/storage/backpack/heph
	satchel_faction = /obj/item/storage/backpack/satchel/heph
	dufflebag_faction = /obj/item/storage/backpack/duffel/heph
	messengerbag_faction = /obj/item/storage/backpack/messenger/heph

/obj/outfit/job/representative/hephaestus
	name = "Hephaestus Corporate Liaison"

	head = /obj/item/clothing/head/beret/corporate/heph
	uniform = /obj/item/clothing/under/rank/liaison/heph
	suit = /obj/item/clothing/suit/storage/liaison/heph
	id = /obj/item/card/id/hephaestus
	accessory = /obj/item/clothing/accessory/tie/corporate/heph
	suit_accessory = /obj/item/clothing/accessory/pin/corporate/heph

	backpack_faction = /obj/item/storage/backpack/heph
	satchel_faction = /obj/item/storage/backpack/satchel/heph
	dufflebag_faction = /obj/item/storage/backpack/duffel/heph
	messengerbag_faction = /obj/item/storage/backpack/messenger/heph

	backpack_contents = list(
		/obj/item/device/camera = 1,
		/obj/item/gun/energy/pistol = 1,
		/obj/item/stamp/hephaestus = 1
	)

/obj/outfit/job/journalist/hephaestus
	name = "Corporate Reporter - Hephaestus"

	uniform = /obj/item/clothing/under/librarian/heph
	id = /obj/item/card/id/hephaestus

	backpack_faction = /obj/item/storage/backpack/heph
	satchel_faction = /obj/item/storage/backpack/satchel/heph
	dufflebag_faction = /obj/item/storage/backpack/duffel/heph
	messengerbag_faction = /obj/item/storage/backpack/messenger/heph

/obj/outfit/job/assistant/hephaestus
	name = "Assistant - Hephaestus"

	id = /obj/item/card/id/hephaestus

	backpack_faction = /obj/item/storage/backpack/heph
	satchel_faction = /obj/item/storage/backpack/satchel/heph
	dufflebag_faction = /obj/item/storage/backpack/duffel/heph
	messengerbag_faction = /obj/item/storage/backpack/messenger/heph

/obj/outfit/job/assistant/tech_assistant/hephaestus
	name = "Technical Assistant - Hephaestus"

	id = /obj/item/card/id/hephaestus

	backpack_faction = /obj/item/storage/backpack/heph
	satchel_faction = /obj/item/storage/backpack/satchel/heph
	dufflebag_faction = /obj/item/storage/backpack/duffel/heph
	messengerbag_faction = /obj/item/storage/backpack/messenger/heph


/obj/outfit/job/visitor/hephaestus
	name = "Off-Duty Crew Member - Hephaestus"

	id = /obj/item/card/id/hephaestus

	backpack_faction = /obj/item/storage/backpack/heph
	satchel_faction = /obj/item/storage/backpack/satchel/heph
	dufflebag_faction = /obj/item/storage/backpack/duffel/heph
	messengerbag_faction = /obj/item/storage/backpack/messenger/heph

/obj/outfit/job/hangar_tech/event/hephaestus
	name = "Operations Personnel - Hephaestus"

	uniform = /obj/item/clothing/under/rank/hangar_technician/heph
	id = /obj/item/card/id/hephaestus

	backpack_faction = /obj/item/storage/backpack/heph
	satchel_faction = /obj/item/storage/backpack/satchel/heph
	dufflebag_faction = /obj/item/storage/backpack/duffel/heph
	messengerbag_faction = /obj/item/storage/backpack/messenger/heph

/obj/outfit/job/engineer/event/hephaestus
	name = "Engineering Personnel - Hephaestus"

	uniform = /obj/item/clothing/under/rank/engineer/heph
	head = /obj/item/clothing/head/hardhat/green
	id = /obj/item/card/id/hephaestus

	backpack_faction = /obj/item/storage/backpack/heph
	satchel_faction = /obj/item/storage/backpack/satchel/heph
	dufflebag_faction = /obj/item/storage/backpack/duffel/heph
	messengerbag_faction = /obj/item/storage/backpack/messenger/heph
