/datum/responseteam/mercenary
	name = "Independent Mercenaries"
	chance = 15
	spawner = /datum/ghostspawner/human/ert/mercenary
	equipment_map = /datum/map_template/distress_freelancers
	possible_space_sector = list(SECTOR_ROMANOVICH, SECTOR_TAU_CETI, SECTOR_CORP_ZONE, SECTOR_VALLEY_HALE)

/datum/responseteam/kataphracts
	name = "Kataphracts"
	chance = 15
	spawner = /datum/ghostspawner/human/ert/kataphract
	equipment_map = /datum/map_template/distress_kataphract
	possible_space_sector = list(SECTOR_ROMANOVICH, SECTOR_CORP_ZONE, SECTOR_BADLANDS, SECTOR_UUEOAESA)

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

/datum/responseteam/kosmostrelki
	name = "Kosmostrelki"
	chance = 15
	spawner = /datum/ghostspawner/human/ert/pra_cosmonaut
	possible_space_sector = list(SECTOR_BADLANDS, SECTOR_SRANDMARR, SECTOR_NRRAHRAHUL)

/datum/responseteam/elyra
	name = "Elyran Navy"
	chance = 15
	spawner = /datum/ghostspawner/human/ert/elyra
	possible_space_sector = list(SECTOR_BADLANDS, SECTOR_NEW_ANKARA, SECTOR_VALLEY_HALE, SECTOR_AEMAQ)

/datum/responseteam/coalition
	name = "Coalition Rangers"
	chance = 15
	spawner = /datum/ghostspawner/human/ert/coalition
	possible_space_sector = list(SECTOR_COALITION, SECTOR_WEEPING_STARS, SECTOR_LIBERTYS_CRADLE, SECTOR_BADLANDS)

/datum/responseteam/konyang
	name = "Konyang Aerospace Force"
	chance = 15
	spawner = /datum/ghostspawner/human/ert/konyang
	possible_space_sector = list(SECTOR_HANEUNIM)

/datum/responseteam/izweski
	name = "Izweski Hegemony Navy"
	chance = 15
	spawner = /datum/ghostspawner/human/ert/izweski
	possible_space_sector = list(SECTOR_BADLANDS, SECTOR_UUEOAESA)

/datum/responseteam/qukala
	name = "Nralakk Federation Qukala"
	chance = 15
	spawner = /datum/ghostspawner/human/ert/qukala
	possible_space_sector = list(SECTOR_BADLANDS) //Not super lore-friendly but our only sector that could possibly have a Fed presence

/datum/responseteam/dominia
	name = "Dominian Imperial Fleet"
	chance = 15
	spawner = /datum/ghostspawner/human/ert/dominia
	possible_space_sector = list(SECTOR_BADLANDS)
	equipment_map = /datum/map_template/distress_dominia

/datum/responseteam/zora
	name = "Zo'ra Hive Warriors"
	chance = 10
	spawner = /datum/ghostspawner/human/ert/zora
	possible_space_sector = list(SECTOR_TAU_CETI, SECTOR_ROMANOVICH)

/datum/responseteam/klax
	name = "K'lax Hive Warriors"
	chance = 10
	spawner = /datum/ghostspawner/human/ert/klax
	possible_space_sector = list(SECTOR_UUEOAESA)
