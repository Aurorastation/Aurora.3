//td this whole thing

/datum/ghostspawner/human/house_volvalaad
	short_name = "house_volvalaad"
	name = "House Volvalaad Voidsman"
	desc = "You are an enlisted Ma’zal voidsman of the Imperial Fleet, seconded to House Volvalaad. Voidsmen are generally recruited from the Imperial Frontier and are eager to pay off their Mo’ri’zal (“Blood Debt,” the Empire’s form of taxation) via military service. Few serve more than a few tours of duty due to the lonely and hazardous nature of interstellar military service. You have been trained to obey your superior, and most Primaries, without question or delay. If the Ensign wills it, get it done. (OOC Note: Players should be familiar with Dominian lore and play a character with a background appropriate to a Dominian Ma'zal.)"
	tags = list("External")
	mob_name_prefix = "VDSMN. " //Voidsman

	spawnpoints = list("house_volvalaad")
	max_count = 2

	outfit = /datum/outfit/admin/house_volvalaad
	possible_species = list(SPECIES_HUMAN)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "House Volvalaad Voidsman"
	special_role = "House Volvalaad Voidsman"
	respawn_flag = null


/datum/outfit/admin/house_volvalaad
	name = "House Volvalaad Voidsman"

	uniform = /obj/item/clothing/under/dominia/fleet
	head = /obj/item/clothing/head/dominia/fleet
	shoes = /obj/item/clothing/shoes/jackboots
	back = /obj/item/storage/backpack/satchel

	id = /obj/item/card/id/imperial_fleet

	l_ear = /obj/item/device/radio/headset/ship

	backpack_contents = list(/obj/item/storage/box/survival = 1)

/datum/outfit/admin/house_volvalaad/get_id_access()
	return list(ACCESS_HOUSE_VOLVALAAD_SHIP, ACCESS_EXTERNAL_AIRLOCKS)

//change
/datum/ghostspawner/human/house_volvalaad/officer
	short_name = "house_volvalaad_officer"
	name = "House Volvalaad Captain"
	desc = "You are a Secondary affiliated with House Volvalaad assigned to captain a science ship. Serve House Volvalaad by searching for artifacts, surveying planetary bodies, and making scientific discoveries. Goddess protect and keep you. (OOC Note: Players should be familiar with Dominian lore and play a character with a background appropriate to a Dominian Secondary.)"
	mob_name_prefix = "ENS. "

	spawnpoints = list("house_volvalaad")
	max_count = 1

	outfit = /datum/outfit/admin/house_volvalaad/officer

	assigned_role = "House Volvalaad Captain"
	special_role = "House Volvalaad Captain"


/datum/outfit/admin/house_volvalaad/officer
	name = "House Volvalaad Captain"
	head = /obj/item/clothing/head/dominia/fleet/officer
	uniform = /obj/item/clothing/under/dominia/fleet/officer
	suit = /obj/item/clothing/suit/storage/dominia/fleet


/datum/ghostspawner/human/house_volvalaad/armsman
	short_name = "house_volvalaad_armsman"
	name = "House Volvalaad Armsman"
	desc = "You are a Ma’zal who serves as an Imperial Fleet armsman aboard a House Volvalaad science vessel, and are expected to defend the ship from boarders. Armsmen are experienced enlisted personnel of the Imperial Fleet who are often recruited from the Imperial Army. While not one of the elite Marines you are well-trained and well-equipped to defend their vessel. Armsmen are often older and more experienced than voidsmen and many have continued to serve in order to pay off the Mo’ri’zal (“Blood Debt,” the Empire’s form of taxation) of their relatives. You have been trained to obey your officer, and most Primaries, without question or hesitation. (OOC Note: Players should be familiar with Dominian lore and play a character with a background appropriate to a Dominian Ma'zal.)"
	mob_name_prefix = "ARMSN. " //Armsman

	max_count = 2

	outfit = /datum/outfit/admin/house_volvalaad/armsman

	assigned_role = "House Volvalaad Armsman"
	special_role = "House Volvalaad Armsman"


/datum/outfit/admin/house_volvalaad/armsman
	name = "House Volvalaad Armsman"
	head = /obj/item/clothing/head/dominia/fleet/armsman
	uniform = /obj/item/clothing/under/dominia/fleet/armsman
	accessory = /obj/item/clothing/accessory/poncho/dominia_cape/mantle

/datum/ghostspawner/human/house_volvalaad/scientist
	short_name = "house_volvalaad_scientist"
	name = "House Volvalaad Scientist"
	/* change */ desc = "You are a  (OOC Note: Players should be familiar with Dominian lore and play a character with a background appropriate to a Dominian Ma'zal.)"
	mob_name_prefix = null

	max_count = 1

	outfit = /datum/outfit/admin/house_volvalaad/scientist

	assigned_role = "House Volvalaad Scientist"
	special_role = "House Volvalaad Scientist"


/datum/outfit/admin/house_volvalaad/scientist
	name = "House Volvalaad Scientist"
	head = /obj/item/clothing/head/beret/dominia/priest //change v
	uniform = /obj/item/clothing/under/dominia/priest
	accessory = /obj/item/clothing/accessory/poncho/dominia/red/surcoat

//items

/obj/item/card/id/house_volvalaad
	name = "house volvalaad id"
	access = list(ACCESS_HOUSE_VOLVALAAD_SHIP, ACCESS_EXTERNAL_AIRLOCKS)
