/**********
* Equipment Kits *
**********/
/datum/uplink_item/item/kits
	category = /datum/uplink_category/kits

/datum/uplink_item/item/kits/espionage
	name = "Espionage Telekit"
	item_cost = 25
	path = obj/item/antag_spawner/kitspawner/espionage
	desc = "A single-use telekit beacon that calls a variety of items intended for espionage. It will call a spy, clerical and chameleon kit, along with a voice changer, agent ID, and thermal aviators. It is highly recommended you not activate this in a public area!"

/datum/uplink_item/item/kits/stealth
	name = "Steal Telekit"
	item_cost = 25
	path = /obj/item/antag_spawner/kitspawner/stealth
	desc = "A single-use telekit beacon that calls a variety of items intended for stealth. It will call a chameleon projector, agent ID and voice changer, hacking tool, a radio jammer and encrypted radio key, along with a paralysis pen for emergencies. It is highly recommended you not activate this in a public area!"

/datum/uplink_item/item/kits/stealth
	name = "Sabotage Telekit"
	item_cost = 25
	path = /obj/item/antag_spawner/kitspawner/sabotage
	desc = "A single-use telekit beacon that calls a variety of items intended for sabotage. It will call a cryptographic sequencer, a four-pack of C4, a power sink beacon, and a firing pin extractor. It is highly recommended you not activate this in a public area!"

/datum/uplink_item/item/kits/stealth
	name = "Assassin Telekit"
	item_cost = 25
	path = /obj/item/antag_spawner/kitspawner/assassin
	desc = "A single-use telekit beacon that calls a variety of items intended for assassination. It will call a silenced 9mm pistol with extra ammo, an energy sword, a paralysis pen, and a single cyanide pill. It is highly recommended you not activate this in a public area!"


/datum/uplink_item/item/medical/stimulants
	name = "Box of Combat Stimulants"
	item_cost = 6
	path = /obj/item/storage/box/syndie_kit/stimulants

/datum/uplink_item/item/medical/firstaid
	name = "Standard First-Aid Kit"
	item_cost = 6
	path = /obj/item/storage/firstaid/regular