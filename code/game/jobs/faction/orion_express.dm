/datum/faction/orin_express
	name = "Orion Express"
	description = {"<p>
	Founded in 2464, the Orion Express is a corporation designed to handle logistics for the
	Stellar Corporate Conglomerate in the wake of the Phoron Scarcity and the sudden issues
	the Conglomeration of the megacorporations presented. It consists of its main branch, dedicated
	to cargo services and transport, but also features a fledgling robotics division, mainly focused
	on industrial synthetics to aid in its logistics missions. The Orion Express is expected to become an
	integral part of the Stellar Corporate Conglomerate's future through delivering supplies and merchandise throughout the Orion Spur.
	</p>"}
	departments = {"Operations<br>Service"}
	title_suffix = "Orion"

	allowed_role_types = ORION_ROLES

	allowed_species_types = list(
		/datum/species/human,
		/datum/species/skrell,
		/datum/species/machine,
		/datum/species/unathi,
		/datum/species/bug = TRUE,
		/datum/species/bug/type_b = TRUE,
		/datum/species/bug/type_e = TRUE,
		/datum/species/tajaran,
		/datum/species/diona
	)


	job_species_blacklist = list(
		"Corporate Liaison" = list(
			SPECIES_VAURCA_WORKER,
			SPECIES_VAURCA_WARRIOR,
			SPECIES_VAURCA_BULWARK,
			SPECIES_VAURCA_BREEDER
		)
	)
	titles_to_loadout = list(
		"Hangar Technician" = /datum/outfit/job/hangar_tech/orion,
		"Shaft Miner" = /datum/outfit/job/mining/orion,
		"Machinist" = /datum/outfit/job/machinist/orion,
		"Bartender" = /datum/outfit/job/bartender/orion,
		"Chef" = /datum/outfit/job/chef/orion,
		"Gardener" = /datum/outfit/job/hydro/orion,
		"Hydroponicist" = /datum/outfit/job/hydro/orion,
		"Janitor" = /datum/outfit/job/janitor/orion,
		"Librarian" = /datum/outfit/job/librarian/orion,
		"Curator" = /datum/outfit/job/librarian/orion/curator,
		"Tech Support" = /datum/outfit/job/librarian/orion/tech_support,
		"Corporate Liaison" = /datum/outfit/job/representative/orion,
		"Off-Duty Crew Member" = /datum/outfit/job/visitor/orion
	)

/datum/outfit/job/hangar_tech/orion
	name = "Hangar Technician - Orion Express"

	uniform = /obj/item/clothing/under/rank/hangar_technician/orion
	id = /obj/item/card/id/orion

	backpack_faction = /obj/item/storage/backpack/orion
	satchel_faction = /obj/item/storage/backpack/satchel/orion
	dufflebag_faction = /obj/item/storage/backpack/duffel/orion
	messengerbag_faction = /obj/item/storage/backpack/messenger/orion

/datum/outfit/job/machinist/orion
	name = "Machinist - Orion Express"

	uniform = /obj/item/clothing/under/rank/machinist/orion
	id = /obj/item/card/id/orion

	backpack_faction = /obj/item/storage/backpack/orion
	satchel_faction = /obj/item/storage/backpack/satchel/orion
	dufflebag_faction = /obj/item/storage/backpack/duffel/orion
	messengerbag_faction = /obj/item/storage/backpack/messenger/orion

/datum/outfit/job/mining/orion
	name = "Shaft Miner - Orion Express"

	uniform = /obj/item/clothing/under/rank/miner/orion
	id = /obj/item/card/id/orion

	backpack_faction = /obj/item/storage/backpack/orion
	satchel_faction = /obj/item/storage/backpack/satchel/orion
	dufflebag_faction = /obj/item/storage/backpack/duffel/orion
	messengerbag_faction = /obj/item/storage/backpack/messenger/orion

/datum/outfit/job/representative/orion
	name = "Orion Express Corporate Liaison"

	head = /obj/item/clothing/head/beret/corporate/orion
	uniform = /obj/item/clothing/under/rank/liaison/orion
	suit = /obj/item/clothing/suit/storage/liaison/orion
	id = /obj/item/card/id/orion
	accessory = /obj/item/clothing/accessory/tie/corporate/orion
	suit_accessory = /obj/item/clothing/accessory/pin/corporate/orion

	backpack_faction = /obj/item/storage/backpack/orion
	satchel_faction = /obj/item/storage/backpack/satchel/orion
	dufflebag_faction = /obj/item/storage/backpack/duffel/orion
	messengerbag_faction = /obj/item/storage/backpack/messenger/orion

/datum/outfit/job/bartender/orion
	name = "Bartender - Orion Express"

	uniform = /obj/item/clothing/under/rank/bartender/orion
	head = /obj/item/clothing/head/flatcap/bartender/orion
	id = /obj/item/card/id/orion
	suit = /obj/item/clothing/suit/storage/bartender/orion

	backpack_faction = /obj/item/storage/backpack/orion
	satchel_faction = /obj/item/storage/backpack/satchel/orion
	dufflebag_faction = /obj/item/storage/backpack/duffel/orion
	messengerbag_faction = /obj/item/storage/backpack/messenger/orion

/datum/outfit/job/chef/orion
	name = "Chef - Orion Express"

	uniform = /obj/item/clothing/under/rank/chef/orion
	suit = /obj/item/clothing/suit/chef_jacket/orion
	head = /obj/item/clothing/head/chefhat/orion
	id = /obj/item/card/id/orion

	backpack_faction = /obj/item/storage/backpack/orion
	satchel_faction = /obj/item/storage/backpack/satchel/orion
	dufflebag_faction = /obj/item/storage/backpack/duffel/orion
	messengerbag_faction = /obj/item/storage/backpack/messenger/orion

/datum/outfit/job/hydro/orion
	name = "Gardener - Orion Express"

	uniform = /obj/item/clothing/under/rank/hydroponics/orion
	head = /obj/item/clothing/head/bandana/hydro/orion
	id = /obj/item/card/id/orion

	backpack_faction = /obj/item/storage/backpack/orion
	satchel_faction = /obj/item/storage/backpack/satchel/orion
	dufflebag_faction = /obj/item/storage/backpack/duffel/orion
	messengerbag_faction = /obj/item/storage/backpack/messenger/orion

/datum/outfit/job/janitor/orion
	name = "Janitor - Orion Express"

	uniform = /obj/item/clothing/under/rank/janitor/orion
	head = /obj/item/clothing/head/softcap/orion_custodian
	id = /obj/item/card/id/orion

	backpack_faction = /obj/item/storage/backpack/orion
	satchel_faction = /obj/item/storage/backpack/satchel/orion
	dufflebag_faction = /obj/item/storage/backpack/duffel/orion
	messengerbag_faction = /obj/item/storage/backpack/messenger/orion

/datum/outfit/job/librarian/orion
	name = "Librarian - Orion Express"

	uniform = /obj/item/clothing/under/librarian/orion
	id = /obj/item/card/id/orion

	backpack_faction = /obj/item/storage/backpack/orion
	satchel_faction = /obj/item/storage/backpack/satchel/orion
	dufflebag_faction = /obj/item/storage/backpack/duffel/orion
	messengerbag_faction = /obj/item/storage/backpack/messenger/orion

/datum/outfit/job/librarian/orion/curator
	name = "Curator - Orion Express"
	jobtype = /datum/job/librarian

	r_pocket = /obj/item/device/price_scanner
	l_hand = null

/datum/outfit/job/librarian/orion/tech_support
	name = "Tech Support - Orion Express"
	jobtype = /datum/job/librarian

	l_pocket = /obj/item/modular_computer/handheld/preset
	r_pocket = /obj/item/card/tech_support
	r_hand = /obj/item/storage/bag/circuits/basic
	l_hand = /obj/item/modular_computer/laptop/preset
	gloves = /obj/item/modular_computer/handheld/wristbound/preset/advanced/civilian


/datum/outfit/job/visitor/orion
	name = "Off-Duty Crew Member - Orion Express"

	id = /obj/item/card/id/orion

	backpack_faction = /obj/item/storage/backpack/orion
	satchel_faction = /obj/item/storage/backpack/satchel/orion
	dufflebag_faction = /obj/item/storage/backpack/duffel/orion
	messengerbag_faction = /obj/item/storage/backpack/messenger/orion
