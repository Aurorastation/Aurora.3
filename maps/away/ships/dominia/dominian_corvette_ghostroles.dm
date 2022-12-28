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


/datum/ghostspawner/human/imperial_fleet_voidsman/nco
	short_name = "imperial_fleet_voidsman_nco"
	name = "Elyran Naval Infantry Fireteam Leader"
	desc = "Lead the Elyran naval infantry strike craft's riflemen. Serve as the Ensign's second-in-command, and follow their orders. (OOC Note: All characters must be of Elyran ethnic origin and background, this is enforceable by admin/moderator action.)"
	mob_name_prefix = "PO3. "

	max_count = 1

	outfit = /datum/outfit/admin/imperial_fleet_voidsman/nco

	assigned_role = "Elyran Naval Infantry Fireteam Leader"
	special_role = "Elyran Naval Infantry Fireteam Leader"


/datum/outfit/admin/imperial_fleet_voidsman/nco
	name = "Elyran Naval Infantry Fireteam Leader"

//items

/obj/item/card/id/imperial_fleet
	name = "imperial fleet id"
	access = list(access_imperial_fleet, access_external_airlocks)