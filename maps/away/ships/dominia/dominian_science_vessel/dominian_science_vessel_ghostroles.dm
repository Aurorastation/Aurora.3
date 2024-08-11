/datum/ghostspawner/human/house_volvalaad_voidsman
	short_name = "house_volvalaad_voidsman"
	name = "House Volvalaad Voidsman"
	desc = "You are an enlisted Ma’zal voidsman of the Imperial Fleet, seconded to House Volvalaad for a scientific mission. Pilot and maintain the ship to support its mission. (OOC Note: Players should be familiar with Dominian lore and play a character with a background appropriate to a Dominian Ma'zal.)"
	welcome_message = "You are an enlisted Ma’zal voidsman of the Imperial Fleet, seconded to House Volvalaad for a scientific mission. Voidsmen are generally recruited from the Imperial Frontier and are eager to pay off their Mo’ri’zal (“Blood Debt,” the Empire’s form of taxation) via military service. You have been trained to obey your superior, and most Primaries, without question or delay. Your mission is to pilot and maintain the vessel, ensuring it is able to fulfill its mission of scientific discovery."
	tags = list("External")
	mob_name_prefix = "VDSMN. " //Voidsman
	culture_restriction = list(/singleton/origin_item/culture/dominia)

	spawnpoints = list("house_volvalaad_voidsman")
	max_count = 2

	outfit = /obj/outfit/admin/house_volvalaad_voidsman
	possible_species = list(SPECIES_HUMAN)
	allow_appearance_change = APPEARANCE_PLASTICSURGERY

	assigned_role = "House Volvalaad Voidsman"
	special_role = "House Volvalaad Voidsman"
	respawn_flag = null


/obj/outfit/admin/house_volvalaad_voidsman
	name = "House Volvalaad Voidsman"

	uniform = /obj/item/clothing/under/dominia/fleet
	head = /obj/item/clothing/head/dominia/fleet
	shoes = /obj/item/clothing/shoes/jackboots
	back = /obj/item/storage/backpack/satchel

	id = /obj/item/card/id/house_volvalaad

	l_ear = /obj/item/device/radio/headset/ship

	backpack_contents = list(/obj/item/storage/box/survival = 1)

/obj/outfit/admin/house_volvalaad_voidsman/get_id_access()
	return list(ACCESS_HOUSE_VOLVALAAD_SHIP, ACCESS_EXTERNAL_AIRLOCKS)

/datum/ghostspawner/human/house_volvalaad_officer
	short_name = "house_volvalaad_officer"
	name = "House Volvalaad Captain"
	desc = "You are a Secondary affiliated with House Volvalaad assigned to captain a science ship. With a background in science, you are expected to serve House Volvalaad by searching for artifacts, surveying planetary bodies, and making scientific discoveries. (OOC Note: Players should be familiar with Dominian lore and play a character with a background appropriate to a Dominian Secondary.)"
	welcome_message = "You are a Secondary affiliated with House Volvalaad assigned to captain a science ship of the House's scientific wing. You are the ultimate authority on the vessel and must ensure that your Primary sponsor is pleased with your work, otherwise you may find your affiliation in jeoprady. Survey the stars for the House and Empire, and ensure the ship remains out of danger. Goddess protect and keep you."
	culture_restriction = list(/singleton/origin_item/culture/dominia)

	spawnpoints = list("house_volvalaad_officer")
	max_count = 1

	outfit = /obj/outfit/admin/house_volvalaad_officer

	assigned_role = "House Volvalaad Captain"
	special_role = "House Volvalaad Captain"
	respawn_flag = null


/obj/outfit/admin/house_volvalaad_officer
	name = "House Volvalaad Captain"
	uniform = /obj/item/clothing/under/dominia/imperial_suit/volvalaad
	shoes = /obj/item/clothing/shoes/laceup
	back = /obj/item/storage/backpack/satchel
	id = /obj/item/card/id/house_volvalaad

	l_ear = /obj/item/device/radio/headset/ship

	backpack_contents = list(/obj/item/storage/box/survival = 1)

/obj/outfit/admin/house_volvalaad_officer/get_id_access()
	return list(ACCESS_HOUSE_VOLVALAAD_SHIP, ACCESS_EXTERNAL_AIRLOCKS)


/datum/ghostspawner/human/house_volvalaad_armsman
	short_name = "house_volvalaad_armsman"
	name = "House Volvalaad Armsman"
	desc = "You are a Ma’zal who serves as an Imperial Fleet armsman aboard a House Volvalaad science vessel, and are expected to defend the ship from boarders. (OOC Note: Players should be familiar with Dominian lore and play a character with a background appropriate to a Dominian Ma'zal.)"
	welcome_message = "You are a Ma'zal who serves as an Imperial Fleet armsman aboard a House Volvalaad science vessel. Armsmen are experienced enlisted personnel of the Imperial Fleet who are often recruited from the Imperial Army. Armsmen are often older and more experienced than voidsmen and many have continued to serve in order to pay off the Mo’ri’zal (“Blood Debt,” the Empire’s form of taxation) of their relatives. You have been trained to obey your officer, and most Primaries, without question or hesitation. Ensure the ship remains safe and support your voidsman with the ship and your scientists in their endeavors."
	mob_name_prefix = "ARMSN. " //Armsman
	culture_restriction = list(/singleton/origin_item/culture/dominia)

	spawnpoints = list("house_volvalaad_armsman")
	max_count = 1

	outfit = /obj/outfit/admin/house_volvalaad_armsman

	assigned_role = "House Volvalaad Armsman"
	special_role = "House Volvalaad Armsman"
	respawn_flag = null

/obj/outfit/admin/house_volvalaad_armsman
	name = "House Volvalaad Armsman"
	head = /obj/item/clothing/head/dominia/fleet/armsman
	uniform = /obj/item/clothing/under/dominia/fleet/armsman
	accessory = /obj/item/clothing/accessory/poncho/dominia_cape/mantle
	shoes = /obj/item/clothing/shoes/jackboots
	back = /obj/item/storage/backpack/satchel
	id = /obj/item/card/id/house_volvalaad

	l_ear = /obj/item/device/radio/headset/ship

	backpack_contents = list(/obj/item/storage/box/survival = 1)

/obj/outfit/admin/house_volvalaad_armsman/get_id_access()
	return list(ACCESS_HOUSE_VOLVALAAD_SHIP, ACCESS_EXTERNAL_AIRLOCKS)

/datum/ghostspawner/human/house_volvalaad_scientist
	short_name = "house_volvalaad_scientist"
	name = "House Volvalaad Scientist"
	desc = "You are a Secondary or Ma'zal affiliated with House Volvalaad who serves as a scientist aboard a House Volvalaad science vessel. Visit planetary bodies, make new discoveries, and bring honor to the Goddess and House. (OOC Note: Players should be familiar with Dominian lore and play a character with a background appropriate to a Dominian Ma'zal or Secondary.)"
	welcome_message = "You are a Secondary or Ma'zal affiliated with House Volvalaad, serving as a scientist aboard a House Volvalaad science vessel. You are experienced in your field and have been highly educated and entrusted with supporting the mission of this ship. Make discoveries, retrieve artifacts, and survey planetary bodies. Be sure to follow the direction of your captain."
	mob_name_prefix = null
	culture_restriction = list(/singleton/origin_item/culture/dominia)

	spawnpoints = list("house_volvalaad_scientist")
	max_count = 2

	outfit = /obj/outfit/admin/house_volvalaad_scientist

	assigned_role = "House Volvalaad Scientist"
	special_role = "House Volvalaad Scientist"
	respawn_flag = null

/obj/outfit/admin/house_volvalaad_scientist
	name = "House Volvalaad Scientist"
	uniform = /obj/item/clothing/under/dominia/imperial_suit/volvalaad
	suit = /obj/item/clothing/suit/storage/toggle/labcoat
	shoes = /obj/item/clothing/shoes/laceup
	back = /obj/item/storage/backpack/satchel
	id = /obj/item/card/id/house_volvalaad

	l_ear = /obj/item/device/radio/headset/ship

	backpack_contents = list(/obj/item/storage/box/survival = 1)

/obj/outfit/admin/house_volvalaad_scientist/get_id_access()
	return list(ACCESS_HOUSE_VOLVALAAD_SHIP, ACCESS_EXTERNAL_AIRLOCKS)

//items

/obj/item/card/id/house_volvalaad
	name = "house volvalaad id"
	access = list(ACCESS_HOUSE_VOLVALAAD_SHIP, ACCESS_EXTERNAL_AIRLOCKS)
