//elyran naval infantry

/datum/ghostspawner/human/imperial_fleet_voidsman
	short_name = "imperial_fleet_voidsman"
	name = "Imperial Fleet Voidsman"
	desc = "Crew the Imperial Fleet Corvette. Follow your Ensign's orders. (OOC Note: Players should be familiar with Dominian lore and play a character with a background appropriate to a Dominian Ma'zal.)"
	tags = list("External")
	mob_name_prefix = "VDSMN. " //Voidsman

	spawnpoints = list("imperial_fleet_voidsman")
	max_count = 3

	outfit = /datum/outfit/admin/imperial_fleet_voidsman
	possible_species = list(SPECIES_HUMAN)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Imperial Fleet Voidsman"
	special_role = "Imperial Fleet Voidsman"
	respawn_flag = null


/datum/outfit/admin/imperial_fleet_voidsman
	name = "Imperial Fleet Voidsman"

	uniform = /obj/item/clothing/under/dominia/fleet
	head = /obj/item/clothing/head/dominia/fleet
	shoes = /obj/item/clothing/shoes/jackboots
	back = /obj/item/storage/backpack/satchel

	id = /obj/item/card/id/imperial_fleet

	l_ear = /obj/item/device/radio/headset/ship

	backpack_contents = list(/obj/item/storage/box/survival = 1)

/datum/outfit/admin/imperial_fleet_voidsman/get_id_access()
	return list(access_imperial_fleet_voidsman_ship, access_external_airlocks)

/datum/ghostspawner/human/imperial_fleet_voidsman/officer
	short_name = "imperial_fleet_voidsman_officer"
	name = "Imperial Fleet Officer"
	desc = "Command and pilot the Imperial Fleet corvette. (OOC Note: Players should be familiar with Dominian lore and play a character with a background appropriate to a Dominian Ma'zal.)"
	mob_name_prefix = "ENS. "

	spawnpoints = list("imperial_fleet_voidsman_officer")
	max_count = 1

	outfit = /datum/outfit/admin/imperial_fleet_voidsman/officer

	assigned_role = "Imperial Fleet Officer"
	special_role = "Imperial Fleet Officer"


/datum/outfit/admin/imperial_fleet_voidsman/officer
	name = "Imperial Fleet Officer"
	head = /obj/item/clothing/head/dominia/fleet/officer
	uniform = /obj/item/clothing/under/dominia/fleet/officer
	suit = /obj/item/clothing/suit/storage/dominia/fleet


/datum/ghostspawner/human/imperial_fleet_voidsman/armsman
	short_name = "imperial_fleet_armsman"
	name = "Imperial Fleet Armsman"
	desc = "Protect the Imperial Fleet ship. (OOC Note: Players should be familiar with Dominian lore and play a character with a background appropriate to a Dominian Ma'zal.)"
	mob_name_prefix = "ARMSN. " //Armsman

	max_count = 2

	outfit = /datum/outfit/admin/imperial_fleet_voidsman/armsman

	assigned_role = "Imperial Fleet Armsman"
	special_role = "Imperial Fleet Armsman"


/datum/outfit/admin/imperial_fleet_voidsman/armsman
	name = "Imperial Fleet Armsman"
	head = /obj/item/clothing/head/dominia/fleet/armsman
	uniform = /obj/item/clothing/under/dominia/fleet/armsman

/datum/ghostspawner/human/imperial_fleet_voidsman/priest
	short_name = "imperial_fleet_priest"
	name = "Imperial Fleet Priest"
	desc = "Administer spiritual guidance to the Imperial Fleet corvette. (OOC Note: Players should be familiar with Dominian lore and play a character with a background appropriate to a Dominian Ma'zal.)"
	mob_name_prefix = null

	max_count = 1

	outfit = /datum/outfit/admin/imperial_fleet_voidsman/priest

	assigned_role = "Imperial Fleet Priest"
	special_role = "Imperial Fleet Priest"


/datum/outfit/admin/imperial_fleet_voidsman/priest
	name = "Imperial Fleet Priest"
	head = /obj/item/clothing/head/beret/dominia/priest
	uniform = /obj/item/clothing/under/dominia/priest
	accessory = /obj/item/clothing/accessory/poncho/dominia/red/surcoat

//items

/obj/item/card/id/imperial_fleet
	name = "imperial fleet id"
	access = list(access_imperial_fleet, access_external_airlocks)