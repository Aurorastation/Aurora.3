/datum/responseteam/mercenary
	name = "Independent Mercenaries"
	chance = 15
	spawner = /datum/ghostspawner/human/ert/mercenary
	equipment_map = /datum/map_template/distress_freelancers
	possible_space_sector = list(SECTOR_ROMANOVICH, SECTOR_TAU_CETI, SECTOR_CORP_ZONE)

/datum/responseteam/kataphracts
	name = "Kataphracts"
	chance = 15
	spawner = /datum/ghostspawner/human/ert/kataphract
	equipment_map = /datum/map_template/distress_kataphract
	possible_space_sector = list(SECTOR_ROMANOVICH, SECTOR_CORP_ZONE)

/datum/responseteam/iac
	name = "Interstellar Aid Corps"
	chance = 1
	spawner = /datum/ghostspawner/human/ert/iac
	equipment_map = /datum/map_template/distress_iac

/datum/responseteam/ap_eridani
	name = "Eridani Asset Protection Team"
	chance = 15
	spawner = /datum/ghostspawner/human/ert/ap_eridani
	equipment_map = /datum/map_template/distress_iac
	possible_space_sector = list(SECTOR_ROMANOVICH, SECTOR_TAU_CETI, SECTOR_CORP_ZONE)

/datum/responseteam/fsf
	name = "Free Solarian Fleets Fireteam"
	chance = 15
	spawner = /datum/ghostspawner/human/ert/fsf
	possible_space_sector = list(SECTOR_ROMANOVICH, SECTOR_CORP_ZONE)

/datum/responseteam/syndicate
	name = "Syndicate Commandos"
	spawner = /datum/ghostspawner/human/ert/commando
	chance = 1
