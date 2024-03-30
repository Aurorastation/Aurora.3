//elyran naval infantry

/datum/ghostspawner/human/imperial_fleet_voidsman
	short_name = "imperial_fleet_voidsman"
	name = "Imperial Fleet Voidsman"
	desc = "You are an enlisted Ma'zal (a Dominian citizen not from Moroz) voidsman of the Imperial Fleet. Recruited from the Frontier Worlds such as Novi Jadran and Sun Reach, you are eager to pay off your Mo’ri’zal (“Blood Debt,” the Empire’s form of taxation) via military service. You have been trained to obey your commanding Ensign and Imperial nobility without question or delay. (OOC Note: Players should be familiar with Dominian lore and play a character with a background appropriate to a Dominian Ma'zal.)"
	tags = list("External")
	mob_name_prefix = "VDSMN. " //Voidsman

	spawnpoints = list("imperial_fleet_voidsman")
	max_count = 3

	outfit = /obj/outfit/admin/imperial_fleet_voidsman
	possible_species = list(SPECIES_HUMAN)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "Imperial Fleet Voidsman"
	special_role = "Imperial Fleet Voidsman"
	respawn_flag = null


/obj/outfit/admin/imperial_fleet_voidsman
	name = "Imperial Fleet Voidsman"

	uniform = /obj/item/clothing/under/dominia/fleet
	head = /obj/item/clothing/head/dominia/fleet
	shoes = /obj/item/clothing/shoes/jackboots
	back = /obj/item/storage/backpack/satchel

	id = /obj/item/card/id/imperial_fleet

	l_ear = /obj/item/device/radio/headset/ship

	backpack_contents = list(/obj/item/storage/box/survival = 1)

/obj/outfit/admin/imperial_fleet_voidsman/get_id_access()
	return list(ACCESS_IMPERIAL_FLEET_VOIDSMAN_SHIP, ACCESS_EXTERNAL_AIRLOCKS)

/datum/ghostspawner/human/imperial_fleet_voidsman/officer
	short_name = "imperial_fleet_voidsman_officer"
	name = "Imperial Fleet Officer"
	desc = "You are a Ma’zal (a Dominian citizen not from Moroz) Ensign of the Imperial Fleet assigned to captain a corvette. You are not a noble, but you are better than your fellow Ma’zals. Prove to your sponsor that you are worthy of command and keep your crew, and hull, intact. Goddess protect and keep you. (OOC Note: Players should be familiar with Dominian lore and play a character with a background appropriate to a Dominian Ma'zal.)"
	mob_name_prefix = "ENS. "

	spawnpoints = list("imperial_fleet_voidsman", "imperial_fleet_voidsman/officer")
	max_count = 1

	outfit = /obj/outfit/admin/imperial_fleet_voidsman/officer

	assigned_role = "Imperial Fleet Officer"
	special_role = "Imperial Fleet Officer"


/obj/outfit/admin/imperial_fleet_voidsman/officer
	name = "Imperial Fleet Officer"
	head = /obj/item/clothing/head/dominia/fleet/officer
	uniform = /obj/item/clothing/under/dominia/fleet/officer
	suit = /obj/item/clothing/suit/storage/dominia/fleet

/datum/ghostspawner/human/imperial_fleet_voidsman/armsman
	short_name = "imperial_fleet_armsman"
	name = "Imperial Fleet Armsman"
	desc = "You are a Ma’zal (a Dominian citizen not from Moroz) who serves as an Imperial Fleet armsman, and are expected to defend the ship from boarders. While not one of the elite Marines, you are older, more experienced, and are well-trained and well-equipped to defend your vessel. You have been trained to obey your commanding officer, and most nobles, without question or delay. (OOC Note: Players should be familiar with Dominian lore and play a character with a background appropriate to a Dominian Ma'zal.)"
	mob_name_prefix = "ARMSN. " //Armsman

	max_count = 2

	outfit = /obj/outfit/admin/imperial_fleet_voidsman/armsman

	assigned_role = "Imperial Fleet Armsman"
	special_role = "Imperial Fleet Armsman"


/obj/outfit/admin/imperial_fleet_voidsman/armsman
	name = "Imperial Fleet Armsman"
	head = /obj/item/clothing/head/dominia/fleet/armsman
	uniform = /obj/item/clothing/under/dominia/fleet/armsman
	accessory = /obj/item/clothing/accessory/poncho/dominia_cape/mantle

/datum/ghostspawner/human/imperial_fleet_voidsman/priest
	short_name = "imperial_fleet_priest"
	name = "Imperial Fleet Priest"
	desc = "You are a Ma’zal (a Dominian citizen not from Moroz) educated and trained by the Moroz Holy Tribunal to serve as a priest or priestess of the Imperial Military, a great honour. While you are nominally a civilian, life on the frontier is harsh and barbaric Coalitioners will show you little mercy. You have been trained in basic military tactics and are expected to fight shoulder-to-shoulder with your fellow crew in a boarding action. You have more education than your fellow crewmembers and also serve as the ship’s doctor. (OOC Note: Players should be familiar with Dominian lore and play a character with a background appropriate to a Dominian Ma'zal.)"
	mob_name_prefix = null

	max_count = 1

	outfit = /obj/outfit/admin/imperial_fleet_voidsman/priest

	assigned_role = "Imperial Fleet Priest"
	special_role = "Imperial Fleet Priest"


/obj/outfit/admin/imperial_fleet_voidsman/priest
	name = "Imperial Fleet Priest"
	head = /obj/item/clothing/head/beret/dominia/priest
	uniform = /obj/item/clothing/under/dominia/priest
	accessory = /obj/item/clothing/accessory/poncho/dominia/red/surcoat

//items

/obj/item/card/id/imperial_fleet
	name = "imperial fleet id"
	access = list(ACCESS_IMPERIAL_FLEET_VOIDSMAN_SHIP, ACCESS_EXTERNAL_AIRLOCKS)
