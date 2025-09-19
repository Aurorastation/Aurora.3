/datum/faction/pmc
	name = "Private Military Contracting Group"
	description = {"<p>
	The Private Military Contracting Group is a coalition of security and medical contractors;
	borne from the necessity of protecting the Stellar Corporate Conglomerate and its holdings.
	Following the ever-growing corporate empire, mercenaries and contractors from all across the spur are deployed accordingly;
	from mere office buildings to outposts in the Corporate Reconstruction Zone.
	Unlike the other members of the Corporate Conglomerate, the Private Military Contracting Group has few employees of its own.
	Only some liaisons and bureaucrats work behind the scenes to hire and manage the contractors;
	the rest of its members are part of several organizations contracted to supply the PMCG.
	</p>"}
	departments = {"Medical<br>Security"}
	title_suffix = "PMCG"

	allowed_role_types = PMC_ROLES

	allowed_species_types = list(
		/datum/species/human,
		/datum/species/skrell,
		/datum/species/tajaran,
		/datum/species/unathi,
		/datum/species/bug = TRUE,
		/datum/species/bug/type_b = TRUE,
		/datum/species/bug/type_b/type_bb = TRUE,
		/datum/species/machine
	)

	job_species_blacklist = list(
		"Corporate Liaison" = list(
			SPECIES_DIONA,
			SPECIES_DIONA_COEUS,
			SPECIES_VAURCA_WORKER,
			SPECIES_VAURCA_WARRIOR,
			SPECIES_VAURCA_ATTENDANT
		)
	)

	titles_to_loadout = list(
		"Security Officer" = /obj/outfit/job/officer/pmc,
		"Warden" = /obj/outfit/job/warden/pmc,
		"Security Cadet" = /obj/outfit/job/intern_sec/officer/pmc,
		"Investigator Intern" = /obj/outfit/job/intern_sec/forensics/pmc,
		"Investigator" =/obj/outfit/job/forensics/pmc,
		"Physician" = /obj/outfit/job/doctor/pmc,
		"Surgeon" = /obj/outfit/job/doctor/surgeon/pmc,
		"Pharmacist" = /obj/outfit/job/pharmacist/pmc,
		"Psychiatrist" = /obj/outfit/job/psychiatrist/pmc,
		"Psychologist" = /obj/outfit/job/psychiatrist/pmc,
		"Paramedic" = /obj/outfit/job/med_tech/pmc,
		"Medical Intern" = /obj/outfit/job/intern_med/pmc,
		"Corporate Reporter" = /obj/outfit/job/journalist/pmc,
		"Corporate Liaison" = /obj/outfit/job/representative/pmc,
		"Corporate Aide" = /obj/outfit/job/corporate_aide/pmc,
		"Assistant" = /obj/outfit/job/assistant/pmc,
		"Medical Orderly" = /obj/outfit/job/assistant/med_assistant/pmc,
		"Off-Duty Crew Member" = /obj/outfit/job/visitor/pmc,
		"Security Personnel" = /obj/outfit/job/officer/event/pmc,
		"Medical Personnel" = /obj/outfit/job/med_tech/event/pmc
	)

/obj/outfit/job/officer/pmc
	name = "Security Officer - PMC"

	uniform = /obj/item/clothing/under/rank/security/pmc
	id = /obj/item/card/id/pmc

	backpack_faction = /obj/item/storage/backpack/pmcg
	satchel_faction = /obj/item/storage/backpack/satchel/pmcg
	dufflebag_faction = /obj/item/storage/backpack/duffel/pmcg
	messengerbag_faction = /obj/item/storage/backpack/messenger/pmcg

/obj/outfit/job/warden/pmc
	name = "Warden - PMC"

	head = /obj/item/clothing/head/warden/pmc
	uniform = /obj/item/clothing/under/rank/warden/pmc
	suit = /obj/item/clothing/suit/storage/toggle/warden/pmc
	id = /obj/item/card/id/pmc
	glasses = /obj/item/clothing/glasses/sunglasses/sechud/aviator/pmc

	backpack_faction = /obj/item/storage/backpack/pmcg
	satchel_faction = /obj/item/storage/backpack/satchel/pmcg
	dufflebag_faction = /obj/item/storage/backpack/duffel/pmcg
	messengerbag_faction = /obj/item/storage/backpack/messenger/pmcg

/obj/outfit/job/intern_sec/officer/pmc
	name = "Security Cadet - PMC"

	uniform = /obj/item/clothing/under/rank/cadet/pmc
	id = /obj/item/card/id/pmc

	backpack_faction = /obj/item/storage/backpack/pmcg
	satchel_faction = /obj/item/storage/backpack/satchel/pmcg
	dufflebag_faction = /obj/item/storage/backpack/duffel/pmcg
	messengerbag_faction = /obj/item/storage/backpack/messenger/pmcg

/obj/outfit/job/intern_sec/forensics/pmc
	name = "Investigator Intern - PMC"

	uniform = /obj/item/clothing/under/rank/cadet/pmc
	id = /obj/item/card/id/pmc

	backpack_faction = /obj/item/storage/backpack/pmcg
	satchel_faction = /obj/item/storage/backpack/satchel/pmcg
	dufflebag_faction = /obj/item/storage/backpack/duffel/pmcg
	messengerbag_faction = /obj/item/storage/backpack/messenger/pmcg

/obj/outfit/job/forensics/pmc
	name = "Investigator - PMC"

	uniform = /obj/item/clothing/under/det/pmc
	suit = /obj/item/clothing/suit/storage/security/investigator/pmc
	id = /obj/item/card/id/pmc

	backpack_faction = /obj/item/storage/backpack/pmcg
	satchel_faction = /obj/item/storage/backpack/satchel/pmcg
	dufflebag_faction = /obj/item/storage/backpack/duffel/pmcg
	messengerbag_faction = /obj/item/storage/backpack/messenger/pmcg

/obj/outfit/job/doctor/pmc
	name = "Physician - PMC"

	uniform = /obj/item/clothing/under/rank/medical/pmc
	suit = /obj/item/clothing/suit/storage/toggle/labcoat/pmc
	id = /obj/item/card/id/pmc
	shoes = /obj/item/clothing/shoes/sneakers/medsci/pmc

	backpack_faction = /obj/item/storage/backpack/pmcg
	satchel_faction = /obj/item/storage/backpack/satchel/pmcg
	dufflebag_faction = /obj/item/storage/backpack/duffel/pmcg
	messengerbag_faction = /obj/item/storage/backpack/messenger/pmcg

/obj/outfit/job/doctor/surgeon/pmc
	name = "Surgeon - PMC"

	uniform = /obj/item/clothing/under/rank/medical/surgeon/pmc
	suit = /obj/item/clothing/suit/storage/surgical_gown/pmc/alt
	id = /obj/item/card/id/pmc
	shoes = /obj/item/clothing/shoes/sneakers/medsci/pmc

	backpack_faction = /obj/item/storage/backpack/pmcg
	satchel_faction = /obj/item/storage/backpack/satchel/pmcg
	dufflebag_faction = /obj/item/storage/backpack/duffel/pmcg
	messengerbag_faction = /obj/item/storage/backpack/messenger/pmcg

/obj/outfit/job/doctor/surgeon/pmc/post_equip(mob/living/carbon/human/H, visualsOnly = FALSE)
	if(!isskrell(H))
		H.equip_to_slot_or_del(new /obj/item/clothing/head/surgery/pmc(H), slot_head)

/obj/outfit/job/pharmacist/pmc
	name = "Pharmacist - PMC"

	uniform = /obj/item/clothing/under/rank/medical/pharmacist/pmc
	suit = /obj/item/clothing/suit/storage/toggle/labcoat/pmc
	id = /obj/item/card/id/pmc
	shoes = /obj/item/clothing/shoes/sneakers/medsci/pmc

	backpack_faction = /obj/item/storage/backpack/pmcg
	satchel_faction = /obj/item/storage/backpack/satchel/pmcg
	dufflebag_faction = /obj/item/storage/backpack/duffel/pmcg
	messengerbag_faction = /obj/item/storage/backpack/messenger/pmcg

/obj/outfit/job/psychiatrist/pmc
	name = "Psychiatrist - PMC"

	uniform = /obj/item/clothing/under/rank/medical/psych/pmc
	id = /obj/item/card/id/pmc
	shoes = /obj/item/clothing/shoes/sneakers/medsci/pmc

	backpack_faction = /obj/item/storage/backpack/pmcg
	satchel_faction = /obj/item/storage/backpack/satchel/pmcg
	dufflebag_faction = /obj/item/storage/backpack/duffel/pmcg
	messengerbag_faction = /obj/item/storage/backpack/messenger/pmcg

/obj/outfit/job/med_tech/pmc
	name = "Paramedic - PMC"

	head = /obj/item/clothing/head/softcap/pmc
	uniform = /obj/item/clothing/under/rank/medical/paramedic/pmc
	suit = /obj/item/clothing/suit/storage/toggle/para_jacket/pmc
	id = /obj/item/card/id/pmc

	backpack_faction = /obj/item/storage/backpack/pmcg
	satchel_faction = /obj/item/storage/backpack/satchel/pmcg
	dufflebag_faction = /obj/item/storage/backpack/duffel/pmcg
	messengerbag_faction = /obj/item/storage/backpack/messenger/pmcg

/obj/outfit/job/intern_med/pmc
	name = "Medical Intern - PMC"

	uniform = /obj/item/clothing/under/rank/medical/intern/pmc
	id = /obj/item/card/id/pmc
	shoes = /obj/item/clothing/shoes/sneakers/medsci/pmc

	backpack_faction = /obj/item/storage/backpack/pmcg
	satchel_faction = /obj/item/storage/backpack/satchel/pmcg
	dufflebag_faction = /obj/item/storage/backpack/duffel/pmcg
	messengerbag_faction = /obj/item/storage/backpack/messenger/pmcg

/obj/outfit/job/representative/pmc
	name = "PMC Corporate Liaison"

	head =  /obj/item/clothing/head/beret/corporate/pmc
	uniform = /obj/item/clothing/under/rank/liaison/pmc
	suit = /obj/item/clothing/suit/storage/liaison/pmc
	id = /obj/item/card/id/pmc
	accessory = /obj/item/clothing/accessory/tie/corporate/pmc
	suit_accessory = /obj/item/clothing/accessory/pin/corporate/pmc

	backpack_faction = /obj/item/storage/backpack/pmcg
	satchel_faction = /obj/item/storage/backpack/satchel/pmcg
	dufflebag_faction = /obj/item/storage/backpack/duffel/pmcg
	messengerbag_faction = /obj/item/storage/backpack/messenger/pmcg

/obj/outfit/job/corporate_aide/pmc
	name = "PMC Corporate Aide"

	id = /obj/item/card/id/pmc
	head = /obj/item/clothing/head/beret/corporate/pmc
	suit = /obj/item/clothing/suit/storage/toggle/corp/pmc

	backpack_faction = /obj/item/storage/backpack/pmcg
	satchel_faction = /obj/item/storage/backpack/satchel/pmcg
	dufflebag_faction = /obj/item/storage/backpack/duffel/pmcg
	messengerbag_faction = /obj/item/storage/backpack/messenger/pmcg

/obj/outfit/job/journalist/pmc
	name = "Corporate Reporter - PMC"

	uniform = /obj/item/clothing/under/librarian/pmc
	id = /obj/item/card/id/pmc

	backpack_faction = /obj/item/storage/backpack/pmcg
	satchel_faction = /obj/item/storage/backpack/satchel/pmcg
	dufflebag_faction = /obj/item/storage/backpack/duffel/pmcg
	messengerbag_faction = /obj/item/storage/backpack/messenger/pmcg

/obj/outfit/job/assistant/pmc
	name = "Assistant - PMC"

	id = /obj/item/card/id/pmc

	backpack_faction = /obj/item/storage/backpack/pmcg
	satchel_faction = /obj/item/storage/backpack/satchel/pmcg
	dufflebag_faction = /obj/item/storage/backpack/duffel/pmcg
	messengerbag_faction = /obj/item/storage/backpack/messenger/pmcg

/obj/outfit/job/assistant/med_assistant/pmc
	name = "Medical Orderly - PMC"

	id = /obj/item/card/id/pmc

	backpack_faction = /obj/item/storage/backpack/pmcg
	satchel_faction = /obj/item/storage/backpack/satchel/pmcg
	dufflebag_faction = /obj/item/storage/backpack/duffel/pmcg
	messengerbag_faction = /obj/item/storage/backpack/messenger/pmcg

/obj/outfit/job/visitor/pmc
	name = "Off-Duty Crew Member - PMC"

	id = /obj/item/card/id/pmc

	backpack_faction = /obj/item/storage/backpack/pmcg
	satchel_faction = /obj/item/storage/backpack/satchel/pmcg
	dufflebag_faction = /obj/item/storage/backpack/duffel/pmcg
	messengerbag_faction = /obj/item/storage/backpack/messenger/pmcg

/obj/outfit/job/officer/event/pmc
	name = "Security Personnel - PMC"

	uniform = /obj/item/clothing/under/rank/security/pmc
	id = /obj/item/card/id/pmc

	backpack_faction = /obj/item/storage/backpack/pmcg
	satchel_faction = /obj/item/storage/backpack/satchel/pmcg
	dufflebag_faction = /obj/item/storage/backpack/duffel/pmcg
	messengerbag_faction = /obj/item/storage/backpack/messenger/pmcg

/obj/outfit/job/med_tech/event/pmc
	name = "Medical Personnel - PMC"

	head = /obj/item/clothing/head/softcap/pmc
	uniform = /obj/item/clothing/under/rank/medical/paramedic/pmc
	suit = /obj/item/clothing/suit/storage/toggle/para_jacket/pmc
	id = /obj/item/card/id/pmc

	backpack_faction = /obj/item/storage/backpack/pmcg
	satchel_faction = /obj/item/storage/backpack/satchel/pmcg
	dufflebag_faction = /obj/item/storage/backpack/duffel/pmcg
	messengerbag_faction = /obj/item/storage/backpack/messenger/pmcg
