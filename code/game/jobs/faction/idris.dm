/datum/faction/idris_incorporated
	name = "Idris Incorporated"
	description = {"<p>
	The Orion Spur's largest interstellar banking conglomerate, Idris Incorporated
	is operated by the mysterious Idris family. Idris Incorporated's influence
	can be found in nearly every corner of human space with their financing of
	nearly every type of business and enterprise. Their higher risk ventures have
	payment enforced by the infamous Idris Reclamation Units, shell IPCs sent to
	claim payment from negligent loan takers. In recent years, they have begun
	diversifying into more service-based industries.
	</p>"}
	departments = {"Security<br>Service"}
	title_suffix = "Idris"

	allowed_role_types = IDRIS_ROLES

	allowed_species_types = list(
		/datum/species/human,
		/datum/species/skrell,
		/datum/species/machine,
		/datum/species/tajaran,
		/datum/species/diona
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
			SPECIES_TAJARA,
			SPECIES_TAJARA_MSAI,
			SPECIES_TAJARA_ZHAN,
			SPECIES_DIONA,
			SPECIES_DIONA_COEUS,
			SPECIES_UNATHI,
			SPECIES_VAURCA_WORKER,
			SPECIES_VAURCA_WARRIOR,
			SPECIES_VAURCA_ATTENDANT,
			SPECIES_VAURCA_BULWARK,
			SPECIES_VAURCA_BREEDER
		)
	)

	titles_to_loadout = list(
		"Security Officer" = /obj/outfit/job/officer/idris,
		"Warden" = /obj/outfit/job/warden/idris,
		"Security Cadet" = /obj/outfit/job/intern_sec/officer/idris,
		"Investigator Intern" = /obj/outfit/job/intern_sec/forensics/idris,
		"Investigator" =/obj/outfit/job/forensics/idris,
		"Bartender" = /obj/outfit/job/bartender/idris,
		"Chef" = /obj/outfit/job/chef/idris,
		"Gardener" = /obj/outfit/job/hydro/idris,
		"Hydroponicist" = /obj/outfit/job/hydro/idris,
		"Janitor" = /obj/outfit/job/janitor/idris,
		"Librarian" = /obj/outfit/job/librarian/idris,
		"Curator" = /obj/outfit/job/librarian/idris/curator,
		"Tech Support" = /obj/outfit/job/librarian/idris/tech_support,
		"Corporate Reporter" = /obj/outfit/job/journalist/idris,
		"Chaplain" = /obj/outfit/job/chaplain/idris,
		"Corporate Liaison" = /obj/outfit/job/representative/idris,
		"Assistant" = /obj/outfit/job/assistant/idris,
		"Wait Staff" = /obj/outfit/job/assistant/waiter/idris,
		"Off-Duty Crew Member" = /obj/outfit/job/visitor/idris,
		"Security Personnel" = /obj/outfit/job/officer/event/idris,
		"Service Personnel" = /obj/outfit/job/bartender/idris
	)

/obj/outfit/job/officer/idris
	name = "Security Officer - Idris"

	uniform = /obj/item/clothing/under/rank/security/idris
	id = /obj/item/card/id/idris/sec

	backpack_faction = /obj/item/storage/backpack/idris
	satchel_faction = /obj/item/storage/backpack/satchel/idris
	dufflebag_faction = /obj/item/storage/backpack/duffel/idris
	messengerbag_faction = /obj/item/storage/backpack/messenger/idris

/obj/outfit/job/warden/idris
	name = "Warden - Idris"

	head = /obj/item/clothing/head/warden/idris
	uniform = /obj/item/clothing/under/rank/warden/idris
	suit = /obj/item/clothing/suit/storage/toggle/warden/idris
	id = /obj/item/card/id/idris/sec
	glasses = /obj/item/clothing/glasses/sunglasses/sechud/aviator/idris

	backpack_faction = /obj/item/storage/backpack/idris
	satchel_faction = /obj/item/storage/backpack/satchel/idris
	dufflebag_faction = /obj/item/storage/backpack/duffel/idris
	messengerbag_faction = /obj/item/storage/backpack/messenger/idris

/obj/outfit/job/forensics/idris
	name = "Investigator - Idris"

	uniform = /obj/item/clothing/under/det/idris
	suit = /obj/item/clothing/suit/storage/security/investigator/idris
	id = /obj/item/card/id/idris/sec

	backpack_faction = /obj/item/storage/backpack/idris
	satchel_faction = /obj/item/storage/backpack/satchel/idris
	dufflebag_faction = /obj/item/storage/backpack/duffel/idris
	messengerbag_faction = /obj/item/storage/backpack/messenger/idris

/obj/outfit/job/intern_sec/officer/idris
	name = "Security Cadet - Idris"

	uniform = /obj/item/clothing/under/rank/cadet/idris
	id = /obj/item/card/id/idris/sec

	backpack_faction = /obj/item/storage/backpack/idris
	satchel_faction = /obj/item/storage/backpack/satchel/idris
	dufflebag_faction = /obj/item/storage/backpack/duffel/idris
	messengerbag_faction = /obj/item/storage/backpack/messenger/idris

/obj/outfit/job/intern_sec/forensics/idris
	name = "Investigator Intern - Idris"

	uniform = /obj/item/clothing/under/rank/cadet/idris
	id = /obj/item/card/id/idris/sec

	backpack_faction = /obj/item/storage/backpack/idris
	satchel_faction = /obj/item/storage/backpack/satchel/idris
	dufflebag_faction = /obj/item/storage/backpack/duffel/idris
	messengerbag_faction = /obj/item/storage/backpack/messenger/idris

/obj/outfit/job/bartender/idris
	name = "Bartender - Idris"

	uniform = /obj/item/clothing/under/rank/bartender/idris
	head = /obj/item/clothing/head/flatcap/bartender/idris
	id = /obj/item/card/id/idris
	suit = /obj/item/clothing/suit/storage/bartender/idris

	backpack_faction = /obj/item/storage/backpack/idris
	satchel_faction = /obj/item/storage/backpack/satchel/idris
	dufflebag_faction = /obj/item/storage/backpack/duffel/idris
	messengerbag_faction = /obj/item/storage/backpack/messenger/idris

/obj/outfit/job/chef/idris
	name = "Chef - Idris"

	uniform = /obj/item/clothing/under/rank/chef/idris
	suit = /obj/item/clothing/suit/chef_jacket/idris
	head = /obj/item/clothing/head/chefhat/idris
	id = /obj/item/card/id/idris

	backpack_faction = /obj/item/storage/backpack/idris
	satchel_faction = /obj/item/storage/backpack/satchel/idris
	dufflebag_faction = /obj/item/storage/backpack/duffel/idris
	messengerbag_faction = /obj/item/storage/backpack/messenger/idris

/obj/outfit/job/hydro/idris
	name = "Gardener - Idris"

	uniform = /obj/item/clothing/under/rank/hydroponics/idris
	head = /obj/item/clothing/head/bandana/hydro/idris
	id = /obj/item/card/id/idris

	backpack_faction = /obj/item/storage/backpack/idris
	satchel_faction = /obj/item/storage/backpack/satchel/idris
	dufflebag_faction = /obj/item/storage/backpack/duffel/idris
	messengerbag_faction = /obj/item/storage/backpack/messenger/idris

/obj/outfit/job/janitor/idris
	name = "Janitor - Idris"

	uniform = /obj/item/clothing/under/rank/janitor/idris
	head = /obj/item/clothing/head/softcap/idris/custodian
	id = /obj/item/card/id/idris

	backpack_faction = /obj/item/storage/backpack/idris
	satchel_faction = /obj/item/storage/backpack/satchel/idris
	dufflebag_faction = /obj/item/storage/backpack/duffel/idris
	messengerbag_faction = /obj/item/storage/backpack/messenger/idris

/obj/outfit/job/librarian/idris
	name = "Librarian - Idris"

	uniform = /obj/item/clothing/under/librarian/idris
	id = /obj/item/card/id/idris

	backpack_faction = /obj/item/storage/backpack/idris
	satchel_faction = /obj/item/storage/backpack/satchel/idris
	dufflebag_faction = /obj/item/storage/backpack/duffel/idris
	messengerbag_faction = /obj/item/storage/backpack/messenger/idris

/obj/outfit/job/librarian/idris/curator
	name = "Curator - Idris"
	jobtype = /datum/job/librarian

	r_pocket = /obj/item/device/price_scanner
	l_hand = null

/obj/outfit/job/librarian/idris/tech_support
	name = "Tech Support - Idris"
	jobtype = /datum/job/librarian

	l_pocket = /obj/item/modular_computer/handheld/preset/generic
	r_pocket = /obj/item/card/tech_support
	r_hand = /obj/item/storage/bag/circuits/basic
	l_hand = /obj/item/device/debugger
	wrist = /obj/item/modular_computer/handheld/wristbound/preset/advanced/civilian

/obj/outfit/job/chaplain/idris
	name = "Chaplain - Idris"

	id = /obj/item/card/id/idris

	backpack_faction = /obj/item/storage/backpack/idris
	satchel_faction = /obj/item/storage/backpack/satchel/idris
	dufflebag_faction = /obj/item/storage/backpack/duffel/idris
	messengerbag_faction = /obj/item/storage/backpack/messenger/idris

/obj/outfit/job/journalist/idris
	name = "Corporate Reporter - Idris"

	uniform = /obj/item/clothing/under/librarian/idris
	id = /obj/item/card/id/idris

	backpack_faction = /obj/item/storage/backpack/idris
	satchel_faction = /obj/item/storage/backpack/satchel/idris
	dufflebag_faction = /obj/item/storage/backpack/duffel/idris
	messengerbag_faction = /obj/item/storage/backpack/messenger/idris

/obj/outfit/job/representative/idris
	name = "Idris Corporate Liaison"

	head = /obj/item/clothing/head/beret/corporate/idris
	uniform = /obj/item/clothing/under/rank/liaison/idris
	suit = /obj/item/clothing/suit/storage/liaison/idris
	id = /obj/item/card/id/idris
	accessory = /obj/item/clothing/accessory/tie/corporate/idris
	suit_accessory = /obj/item/clothing/accessory/pin/corporate/idris

	backpack_faction = /obj/item/storage/backpack/idris
	satchel_faction = /obj/item/storage/backpack/satchel/idris
	dufflebag_faction = /obj/item/storage/backpack/duffel/idris
	messengerbag_faction = /obj/item/storage/backpack/messenger/idris

	backpack_contents = list(
		/obj/item/device/camera = 1,
		/obj/item/gun/energy/pistol = 1,
		/obj/item/stamp/idris = 1
	)

/obj/outfit/job/assistant/idris
	name = "Assistant - Idris"

	id = /obj/item/card/id/idris

	backpack_faction = /obj/item/storage/backpack/idris
	satchel_faction = /obj/item/storage/backpack/satchel/idris
	dufflebag_faction = /obj/item/storage/backpack/duffel/idris
	messengerbag_faction = /obj/item/storage/backpack/messenger/idris

/obj/outfit/job/assistant/waiter/idris
	name = "Wait Staff - Idris"

	id = /obj/item/card/id/idris

	backpack_faction = /obj/item/storage/backpack/idris
	satchel_faction = /obj/item/storage/backpack/satchel/idris
	dufflebag_faction = /obj/item/storage/backpack/duffel/idris
	messengerbag_faction = /obj/item/storage/backpack/messenger/idris

/obj/outfit/job/visitor/idris
	name = "Off-Duty Crew Member - Idris"

	id = /obj/item/card/id/idris

	backpack_faction = /obj/item/storage/backpack/idris
	satchel_faction = /obj/item/storage/backpack/satchel/idris
	dufflebag_faction = /obj/item/storage/backpack/duffel/idris
	messengerbag_faction = /obj/item/storage/backpack/messenger/idris

/obj/outfit/job/officer/event/idris
	name = "Security Personnel - Idris"

	uniform = /obj/item/clothing/under/rank/security/idris
	id = /obj/item/card/id/idris/sec

	backpack_faction = /obj/item/storage/backpack/idris
	satchel_faction = /obj/item/storage/backpack/satchel/idris
	dufflebag_faction = /obj/item/storage/backpack/duffel/idris
	messengerbag_faction = /obj/item/storage/backpack/messenger/idris
