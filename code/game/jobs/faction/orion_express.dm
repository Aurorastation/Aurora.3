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
		"Hangar Technician" = /obj/outfit/job/hangar_tech/orion,
		"Shaft Miner" = /obj/outfit/job/mining/orion,
		"Machinist" = /obj/outfit/job/machinist/orion,
		"Bartender" = /obj/outfit/job/bartender/orion,
		"Chef" = /obj/outfit/job/chef/orion,
		"Gardener" = /obj/outfit/job/hydro/orion,
		"Hydroponicist" = /obj/outfit/job/hydro/orion,
		"Janitor" = /obj/outfit/job/janitor/orion,
		"Librarian" = /obj/outfit/job/librarian/orion,
		"Curator" = /obj/outfit/job/librarian/orion/curator,
		"Tech Support" = /obj/outfit/job/librarian/orion/tech_support,
		"Corporate Reporter" = /obj/outfit/job/journalist/orion,
		"Chaplain" = /obj/outfit/job/chaplain/orion,
		"Corporate Liaison" = /obj/outfit/job/representative/orion,
		"Assistant" = /obj/outfit/job/assistant/orion,
		"Wait Staff" = /obj/outfit/job/assistant/waiter/orion,
		"Off-Duty Crew Member" = /obj/outfit/job/visitor/orion,
		"Operations Personnel" = /obj/outfit/job/hangar_tech/event/orion,
		"Service Personnel" = /obj/outfit/job/bartender/orion
	)

/obj/outfit/job/hangar_tech/orion
	name = "Hangar Technician - Orion Express"

	uniform = /obj/item/clothing/under/rank/hangar_technician/orion
	id = /obj/item/card/id/orion

	backpack_faction = /obj/item/storage/backpack/orion
	satchel_faction = /obj/item/storage/backpack/satchel/orion
	dufflebag_faction = /obj/item/storage/backpack/duffel/orion
	messengerbag_faction = /obj/item/storage/backpack/messenger/orion

/obj/outfit/job/machinist/orion
	name = "Machinist - Orion Express"

	uniform = /obj/item/clothing/under/rank/machinist/orion
	id = /obj/item/card/id/orion

	backpack_faction = /obj/item/storage/backpack/orion
	satchel_faction = /obj/item/storage/backpack/satchel/orion
	dufflebag_faction = /obj/item/storage/backpack/duffel/orion
	messengerbag_faction = /obj/item/storage/backpack/messenger/orion

/obj/outfit/job/mining/orion
	name = "Shaft Miner - Orion Express"

	uniform = /obj/item/clothing/under/rank/miner/orion
	id = /obj/item/card/id/orion

	backpack_faction = /obj/item/storage/backpack/orion
	satchel_faction = /obj/item/storage/backpack/satchel/orion
	dufflebag_faction = /obj/item/storage/backpack/duffel/orion
	messengerbag_faction = /obj/item/storage/backpack/messenger/orion

/obj/outfit/job/representative/orion
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

/obj/outfit/job/bartender/orion
	name = "Bartender - Orion Express"

	uniform = /obj/item/clothing/under/rank/bartender/orion
	head = /obj/item/clothing/head/flatcap/bartender/orion
	id = /obj/item/card/id/orion
	suit = /obj/item/clothing/suit/storage/bartender/orion

	backpack_faction = /obj/item/storage/backpack/orion
	satchel_faction = /obj/item/storage/backpack/satchel/orion
	dufflebag_faction = /obj/item/storage/backpack/duffel/orion
	messengerbag_faction = /obj/item/storage/backpack/messenger/orion

/obj/outfit/job/chef/orion
	name = "Chef - Orion Express"

	uniform = /obj/item/clothing/under/rank/chef/orion
	suit = /obj/item/clothing/suit/chef_jacket/orion
	head = /obj/item/clothing/head/chefhat/orion
	id = /obj/item/card/id/orion

	backpack_faction = /obj/item/storage/backpack/orion
	satchel_faction = /obj/item/storage/backpack/satchel/orion
	dufflebag_faction = /obj/item/storage/backpack/duffel/orion
	messengerbag_faction = /obj/item/storage/backpack/messenger/orion

/obj/outfit/job/hydro/orion
	name = "Gardener - Orion Express"

	uniform = /obj/item/clothing/under/rank/hydroponics/orion
	head = /obj/item/clothing/head/bandana/hydro/orion
	id = /obj/item/card/id/orion

	backpack_faction = /obj/item/storage/backpack/orion
	satchel_faction = /obj/item/storage/backpack/satchel/orion
	dufflebag_faction = /obj/item/storage/backpack/duffel/orion
	messengerbag_faction = /obj/item/storage/backpack/messenger/orion

/obj/outfit/job/janitor/orion
	name = "Janitor - Orion Express"

	uniform = /obj/item/clothing/under/rank/janitor/orion
	head = /obj/item/clothing/head/softcap/orion_custodian
	id = /obj/item/card/id/orion

	backpack_faction = /obj/item/storage/backpack/orion
	satchel_faction = /obj/item/storage/backpack/satchel/orion
	dufflebag_faction = /obj/item/storage/backpack/duffel/orion
	messengerbag_faction = /obj/item/storage/backpack/messenger/orion

/obj/outfit/job/librarian/orion
	name = "Librarian - Orion Express"

	uniform = /obj/item/clothing/under/librarian/orion
	id = /obj/item/card/id/orion

	backpack_faction = /obj/item/storage/backpack/orion
	satchel_faction = /obj/item/storage/backpack/satchel/orion
	dufflebag_faction = /obj/item/storage/backpack/duffel/orion
	messengerbag_faction = /obj/item/storage/backpack/messenger/orion

/obj/outfit/job/librarian/orion/curator
	name = "Curator - Orion Express"
	jobtype = /datum/job/librarian

	r_pocket = /obj/item/device/price_scanner
	l_hand = null

/obj/outfit/job/librarian/orion/tech_support
	name = "Tech Support - Orion Express"
	jobtype = /datum/job/librarian

	l_pocket = /obj/item/modular_computer/handheld/preset/generic
	r_pocket = /obj/item/card/tech_support
	r_hand = /obj/item/storage/bag/circuits/basic
	l_hand = /obj/item/device/debugger
	wrist = /obj/item/modular_computer/handheld/wristbound/preset/advanced/civilian

/obj/outfit/job/journalist/orion
	name = "Corporate Reporter - Orion Express"

	uniform = /obj/item/clothing/under/librarian/orion
	id = /obj/item/card/id/orion

	backpack_faction = /obj/item/storage/backpack/orion
	satchel_faction = /obj/item/storage/backpack/satchel/orion
	dufflebag_faction = /obj/item/storage/backpack/duffel/orion
	messengerbag_faction = /obj/item/storage/backpack/messenger/orion

/obj/outfit/job/chaplain/orion
	name = "Chaplain - Orion Express"

	id = /obj/item/card/id/orion

	backpack_faction = /obj/item/storage/backpack/orion
	satchel_faction = /obj/item/storage/backpack/satchel/orion
	dufflebag_faction = /obj/item/storage/backpack/duffel/orion
	messengerbag_faction = /obj/item/storage/backpack/messenger/orion

/obj/outfit/job/assistant/orion
	name = "Assistant - Orion"

	id = /obj/item/card/id/orion

	backpack_faction = /obj/item/storage/backpack/orion
	satchel_faction = /obj/item/storage/backpack/satchel/orion
	dufflebag_faction = /obj/item/storage/backpack/duffel/orion
	messengerbag_faction = /obj/item/storage/backpack/messenger/orion

/obj/outfit/job/assistant/waiter/orion
	name = "Wait Staff - Orion"

	id = /obj/item/card/id/orion

	backpack_faction = /obj/item/storage/backpack/orion
	satchel_faction = /obj/item/storage/backpack/satchel/orion
	dufflebag_faction = /obj/item/storage/backpack/duffel/orion
	messengerbag_faction = /obj/item/storage/backpack/messenger/orion

/obj/outfit/job/visitor/orion
	name = "Off-Duty Crew Member - Orion Express"

	id = /obj/item/card/id/orion

	backpack_faction = /obj/item/storage/backpack/orion
	satchel_faction = /obj/item/storage/backpack/satchel/orion
	dufflebag_faction = /obj/item/storage/backpack/duffel/orion
	messengerbag_faction = /obj/item/storage/backpack/messenger/orion

/obj/outfit/job/hangar_tech/event/orion
	name = "Hangar Technician - Orion Express"

	uniform = /obj/item/clothing/under/rank/hangar_technician/orion
	id = /obj/item/card/id/orion

	backpack_faction = /obj/item/storage/backpack/orion
	satchel_faction = /obj/item/storage/backpack/satchel/orion
	dufflebag_faction = /obj/item/storage/backpack/duffel/orion
	messengerbag_faction = /obj/item/storage/backpack/messenger/orion
