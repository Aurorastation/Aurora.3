//elyran naval infantry

/datum/ghostspawner/human/imperial_fleet_voidsman
	short_name = "imperial_fleet_voidsman"
	name = "Imperial Fleet Voidsman"
	desc = "You are an enlisted Ma’zal voidsman of the Imperial Fleet. Voidsmen are generally recruited from the Imperial Frontier and are eager to pay off their Mo’ri’zal (“Blood Debt,” the Empire’s form of taxation) via military service. Few serve more than a few tours of duty due to the lonely and hazardous nature of interstellar military service. You have been trained to obey your superior, and most Primaries, without question or delay. If the Ensign wills it, get it done. (OOC Note: Players should be familiar with Dominian lore and play a character with a background appropriate to a Dominian Ma'zal.)"
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
	desc = "You are a low-ranking Ma’zal Ensign of the Imperial Fleet assigned to captain a corvette. You are not a Primary, but you are better than your fellow Ma’zals. Prove to your Primary sponsor that you are worthy of command and keep your crew, and hull, intact through whatever means are necessary. Goddess protect and keep you. (OOC Note: Players should be familiar with Dominian lore and play a character with a background appropriate to a Dominian Ma'zal.)"
	mob_name_prefix = "ENS. "

	spawnpoints = list("imperial_fleet_voidsman")
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
	desc = "You are a Ma’zal who serves as an Imperial Fleet armsman, and are expected to defend the ship from boarders. Armsmen are experienced enlisted personnel of the Imperial Fleet who are often recruited from the Imperial Army. While not one of the elite Marines you are well-trained and well-equipped to defend their vessel. Armsmen are often older and more experienced than voidsmen and many have continued to serve in order to pay off the Mo’ri’zal (“Blood Debt,” the Empire’s form of taxation) of their relatives. You have been trained to obey your officer, and most Primaries, without question or hesitation. (OOC Note: Players should be familiar with Dominian lore and play a character with a background appropriate to a Dominian Ma'zal.)"
	mob_name_prefix = "ARMSN. " //Armsman

	max_count = 2

	outfit = /datum/outfit/admin/imperial_fleet_voidsman/armsman

	assigned_role = "Imperial Fleet Armsman"
	special_role = "Imperial Fleet Armsman"


/datum/outfit/admin/imperial_fleet_voidsman/armsman
	name = "Imperial Fleet Armsman"
	head = /obj/item/clothing/head/dominia/fleet/armsman
	uniform = /obj/item/clothing/under/dominia/fleet/armsman
	accessory = /obj/item/clothing/accessory/poncho/dominia_cape/mantle

/datum/ghostspawner/human/imperial_fleet_voidsman/priest
	short_name = "imperial_fleet_priest"
	name = "Imperial Fleet Priest"
	desc = "You are a Ma’zal educated and trained by the Moroz Holy Tribunal to serve as a priest or priestess of the Imperial Military. This is a great honor for most Ma’zals and an expression of immense trust in you despite your birth. While you are nominally a civilian life on the frontier is harsh and barbaric Coalitioners, such as the murderous “Rangers,” will show you little mercy. As a result you have been trained in basic military tactics and are expected to fight shoulder-to-shoulder with your fellow crew in a boarding action. Priests often have more education than their fellow Ma’zals and will often also serve as the ship’s doctor. (OOC Note: Players should be familiar with Dominian lore and play a character with a background appropriate to a Dominian Ma'zal.)"
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
	access = list(access_imperial_fleet_voidsman_ship, access_external_airlocks)
