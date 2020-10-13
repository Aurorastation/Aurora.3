/datum/responseteam/mercenary
	name = "Independent Mercenaries"
	chance = 15
	spawner = /datum/ghostspawner/human/ert/mercenary

/datum/responseteam/kataphracts
	name = "Kataphracts"
	chance = 15
	spawner = /datum/ghostspawner/human/ert/kataphract
	equipment_map = /datum/map_template/distress_kataphract

/datum/responseteam/iac
	name = "Interstellar Aid Corps"
	chance = 1
	spawner = /datum/ghostspawner/human/ert/iac
	equipment_map = /datum/map_template/distress_iac
	admin = TRUE

/datum/responseteam/med_eridani
	name = "Eridani Medical Team"
	chance = 10
	spawner = /datum/ghostspawner/human/ert/med_eridani
	equipment_map = /datum/map_template/distress_iac

/datum/responseteam/gun_merchant
	name = "Gun Merchants"
	chance = 10
	spawner = /datum/ghostspawner/human/ert/gun_merchant
	equipment_map = /datum/map_template/distress_gun_merchant

/datum/responseteam/syndicate
	name = "Syndicate Commandos"
	spawner = /datum/ghostspawner/human/ert/commando
	admin = TRUE
	chance = 1