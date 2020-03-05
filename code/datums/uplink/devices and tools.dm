/********************
* Devices and Tools *
********************/
/datum/uplink_item/item/tools
	category = /datum/uplink_category/tools

/datum/uplink_item/item/tools/toolbox
	name = "Fully Loaded Toolbox"
	item_cost = 2
	path = /obj/item/storage/toolbox/syndicate
	desc = "A suspiciously painted toolbox, filled with most of the odds and ends a good-for-nothing traitor would need."

/datum/uplink_item/item/tools/toolbelt
	name = "Fully Loaded Tool-belt"
	item_cost = 3
	path = /obj/item/storage/belt/utility/very_full
	desc = "A fully loaded tool-belt even Nanotrasen's top Chief Engineer would be proud to wear."

/datum/uplink_item/item/tools/money
	name = "Operations Funding"
	item_cost = 2
	path = /obj/item/storage/secure/briefcase/money
	desc = "A briefcase with 10,000 untraceable credits for funding your sneaky activities."

/datum/uplink_item/item/tools/firingpin //todo, make this a special syndicate one instead of just a normal one?
	name = "Firing Pin"
	item_cost = 2
	path = /obj/item/device/firing_pin
	desc = "A Syndicate-branded Firing pin - It should be compatible with nearly every weapon onboard."

/datum/uplink_item/item/tools/surge
	name = "IPC surge prevention module"
	item_cost = 12
	path = /obj/item/stack/nanopaste/surge
	desc = "An internal module that allow operative IPC frames to be protected from EMP pulse. The device has limited use that varies between two to five pulses"

/datum/uplink_item/item/tools/clerical
	name = "Morphic Clerical Kit"
	item_cost = 3
	path = /obj/item/storage/box/syndie_kit/clerical

/datum/uplink_item/item/tools/plastique
	name = "C-4 (Destroys walls)"
	item_cost = 3
	path = /obj/item/plastique
	desc = "A single block of C4, enough to breach any wall."

/datum/uplink_item/item/tools/heavy_vest
	name = "Heavy Armor Kit"
	item_cost = 4
	path = /obj/item/storage/box/syndie_kit/armor
	desc = "A heavy armour set consisting of a vest and a helmet. Not EVA capable."

/datum/uplink_item/item/tools/encryptionkey_radio
	name = "Encrypted Radio Channel Key"
	item_cost = 4
	path = /obj/item/device/encryptionkey/syndicate
	desc = "An encryption key for use in a headset, intercepts all frequencies and grants access to a secure syndicate frequency."

/datum/uplink_item/item/tools/encryptionkey_binary
	name = "Binary Translator Key"
	item_cost = 5
	path = /obj/item/device/encryptionkey/binary
	desc = "An encryption key for use in a headset, capable of intercepting stationbound binary communications."

/datum/uplink_item/item/tools/emag
	name = "Cryptographic Sequencer"
	item_cost = 6
	path = /obj/item/card/emag

/datum/uplink_item/item/tools/hacking_tool
	name = "Door Hacking Tool"
	item_cost = 6
	path = /obj/item/device/multitool/hacktool
	desc = "Appears and functions as a standard multitool until the mode is toggled by applying a screwdriver appropriately. \
			When in hacking mode this device will grant full access to any standard airlock within 20 to 40 seconds. \
			This device will also be able to immediately access the last 6 to 8 hacked airlocks."

/datum/uplink_item/item/tools/space_suit
	name = "Space Suit"
	item_cost = 6
	path = /obj/item/storage/box/syndie_kit/space

/datum/uplink_item/item/tools/thermal
	name = "Thermal Imaging Glasses"
	item_cost = 6
	path = /obj/item/clothing/glasses/thermal/syndi

/datum/uplink_item/item/tools/powersink
	name = "Powersink (DANGER!)"
	item_cost = 10
	path = /obj/item/device/powersink

/datum/uplink_item/item/tools/teleporter
	name = "Teleporter Circuit Board"
	item_cost = 10
	path = /obj/item/circuitboard/teleporter

/datum/uplink_item/item/tools/teleporter/New()
	..()
	antag_roles = list(MODE_MERCENARY)

/datum/uplink_item/item/tools/ai_module
	name = "Hacked AI Upload Module"
	item_cost = 14
	path = /obj/item/aiModule/syndicate

/datum/uplink_item/item/tools/supply_beacon
	name = "Hacked Supply Beacon (DANGER!)"
	item_cost = 14
	path = /obj/item/supply_beacon
	desc = "A hacked supply beacon that will call in a random supply pod when deployed and activated. Steer clear of the area afterwards."

/datum/uplink_item/item/tools/advancedpinpointer
	name = "Advanced pinpointer"
	item_cost = 15
	path = /obj/item/pinpointer/advpinpointer
	desc = "An advanced pinpointer that can find any target with DNA along with various other items."

/datum/uplink_item/item/tools/syndieborg
	name = "Syndicate Cyborg Teleporter"
	item_cost = 35
	path = /obj/item/antag_spawner/borg_tele

/datum/uplink_item/item/tools/heatpatch
	name = "HUDPatch, Thermal"
	item_cost = 6
	path = /obj/item/clothing/glasses/eyepatch/hud/thermal

/datum/uplink_item/item/tools/nightpatch
	name = "HUDPatch, Night-Vision"
	item_cost = 4
	path = /obj/item/clothing/glasses/eyepatch/hud/night

/datum/uplink_item/item/tools/aviatortherm
	name = "Aviators, Thermal"
	item_cost = 6
	path = /obj/item/clothing/glasses/thermal/aviator
	desc = "A pair of thermal-vision glasses disguised as aviator shades."

/datum/uplink_item/item/tools/aviatornight
	name = "Aviators, Night-Vision"
	item_cost = 4
	path = /obj/item/clothing/glasses/night/aviator
	desc = "A pair of night-vision glasses disguised as aviator shades."

/datum/uplink_item/item/tools/suit_cooling_unit
	name = "Portable suit cooling unit"
	item_cost = 4
	path = /obj/item/device/suit_cooling_unit
	desc = "A suit cooling unit with a high capacity power cell."

/datum/uplink_item/item/tools/keypad
	name = "Keypad Mag-Lock"
	item_cost = 4
	path = /obj/item/device/magnetic_lock/keypad
	desc = "A maglock that requires the user to enter a passcode to lock and then later unlock."

/datum/uplink_item/item/tools/personal_ai
	name = "Personal AI"
	item_cost = 2
	path = /obj/item/device/paicard
	desc = "An unmodified personal AI that can assist you in your ventures."

/datum/uplink_item/item/tools/pin_extractor
	name = "Firing Pin Extractor"
	item_cost = 2
	path = /obj/item/device/pin_extractor
	desc = "An extractor tool capable of extracting firing pins from most firearms."

/datum/uplink_item/item/tools/radio_jammer
	name = "Radio Jammer"
	item_cost = 5
	path = /obj/item/device/radiojammer
	desc = "A small jammer that can fit inside a pocket. Capable of disrupting nearby radios and hivenet transmitters."

/datum/uplink_item/item/tools/jetpack
	name = "Jetpack"
	item_cost = 5
	path = /obj/item/tank/jetpack/oxygen

/datum/uplink_item/item/tools/electropack
	name = "Electropack"
	item_cost = 6
	path = /obj/item/device/radio/electropack
	desc = "A backpack wired with electrodes. Sync up with a signaller, attach to an unwilling host and pulse the signal to shock them."