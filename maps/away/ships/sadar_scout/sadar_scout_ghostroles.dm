/datum/ghostspawner/human/sadar_crew
	short_name = "sadar_crew"
	name = "Unified Sadar Fleet Crewman"
	desc = "Crew the Unified Sadar Fleet Scout vessel and be a scarab rogue! Take what you can, give nothing back! (OOC Note: All characters must be of Scarab origin and background, this is enforceable by admin/moderator action)"
	welcome_message = "You are part of a small but tightly-knit crew onboard a scouting vessel of the Unified Sadar Fleet. Some may call you pirates, but truly your only goal is to keep you and your fleet of fellow outcasts supplied to survive no matter what it takes. The ends always justify the means, just don't be stupid. You've sworn to never abandon another Sadar in need, and it just so happens the fleet needs a whole lot of everything. (OOC Note: You are not an antagonist, any conflict must be escalated reasonably)"
	tags = list("External")

	spawnpoints = list("sadar_crew")
	max_count = 4

	mob_name_suffix = " Sadar"
	mob_name_pick_message = "Enter ONLY a first name."

	outfit = /obj/outfit/admin/sadar_crew
	possible_species = list(SPECIES_HUMAN_OFFWORLD)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Independent Spacer"
	special_role = "Unified Sadar Fleet Crewman"
	respawn_flag = null

	culture_restriction = list(/singleton/origin_item/culture/coalition)
	origin_restriction = list(/singleton/origin_item/origin/coa_spacer)


/obj/outfit/admin/sadar_crew
	name = "Unified Sadar Fleet Crewman"

	uniform = /obj/item/clothing/under/syndicate/tacticool
	shoes = /obj/item/clothing/shoes/jackboots
	back = /obj/item/storage/backpack/satchel

	l_pocket = /obj/item/storage/wallet/random
	r_pocket = /obj/item/clothing/accessory/badge/passcard/scarab

	id = /obj/item/card/id/sadar_scout

	l_ear = /obj/item/device/radio/headset/ship

	accessory = /obj/item/clothing/accessory/offworlder/bracer/grey
	backpack_contents = list(
		/obj/item/storage/box/survival = 1,
		/obj/item/clothing/accessory/offworlder/dark_red = 1,
		/obj/item/clothing/accessory/offworlder/bracer/neckbrace/dark_red = 1
	)

/obj/outfit/admin/sadar_crew/get_id_access()
	return list(ACCESS_EXTERNAL_AIRLOCKS)

/datum/ghostspawner/human/sadar_crew/captain
	short_name = "sadar_crew_captain"
	name = "Unified Sadar Fleet Captain"
	desc = "Command the Unified Sadar Fleet Scout vessel and be a scarab rogue! Take what you can, give nothing back! (OOC Note: All characters must be of Scarab origin and background, this is enforceable by admin/moderator action)"
	welcome_message = "You command a small but tightly-knit crew onboard a scouting vessel of the Unified Sadar Fleet. Some may call you pirates, but truly your only goal is to keep you and your fleet of fellow outcasts supplied to survive no matter what it takes. The ends always justify the means, just don't be stupid. You've sworn to never abandon another Sadar in need, and it just so happens the fleet needs a whole lot of everything. (OOC Note: You are not an antagonist, any conflict must be escalated reasonably)"

	spawnpoints = list("sadar_crew_captain")
	max_count = 1

	outfit = /obj/outfit/admin/sadar_crew/captain
	possible_species = list(SPECIES_HUMAN_OFFWORLD)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Independent Captain"
	special_role = "Unified Sadar Fleet Captain"


/obj/outfit/admin/sadar_crew/captain
	name = "Unified Sadar Fleet Captain"

/obj/item/card/id/sadar_scout
	name = "unified sadar fleet id"
	access = list(ACCESS_EXTERNAL_AIRLOCKS)
