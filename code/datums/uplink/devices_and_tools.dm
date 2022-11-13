/********************
* Devices and Tools *
********************/
/datum/uplink_item/item/tools
	category = /datum/uplink_category/tools

/datum/uplink_item/item/tools/toolbox
	name = "Fully Loaded Toolbox"
	item_cost = 1
	path = /obj/item/storage/toolbox/syndicate
	desc = "A suspiciously painted toolbox, filled with most of the odds and ends a good-for-nothing traitor would need."

/datum/uplink_item/item/tools/toolbelt
	name = "Fully Loaded Tool-belt"
	item_cost = 1
	path = /obj/item/storage/belt/utility/very_full
	desc = "A fully loaded tool-belt even NanoTrasen's top Chief Engineer would be proud to wear."

/datum/uplink_item/item/tools/money
	name = "Operations Funding"
	item_cost = 1
	path = /obj/item/storage/secure/briefcase/money
	desc = "A briefcase with 10,000 untraceable credits for funding your sneaky activities."

/datum/uplink_item/item/tools/firingpin //todo, make this a special syndicate one instead of just a normal one?
	name = "Firing Pin"
	item_cost = 1
	path = /obj/item/device/firing_pin
	desc = "A Syndicate-branded Firing pin - It should be compatible with nearly every weapon onboard."

/datum/uplink_item/item/tools/surge
	name = "IPC surge prevention module"
	item_cost = 3
	path = /obj/item/stack/nanopaste/surge
	desc = "An internal module that allow operative IPC frames to be protected from EMP pulse. The device has limited use that varies between two to five pulses"

/datum/uplink_item/item/tools/clerical
	name = "Morphic Clerical Kit"
	item_cost = 1
	path = /obj/item/storage/box/syndie_kit/clerical

/datum/uplink_item/item/tools/plastique
	name = "C-4 (Destroys walls)"
	item_cost = 1
	path = /obj/item/plastique
	desc = "A single block of C4, enough to breach any wall."

/datum/uplink_item/item/tools/heavy_vest
	name = "Heavy Armor Kit"
	item_cost = 2
	path = /obj/item/storage/box/syndie_kit/armor
	desc = "A heavy armor set consisting of a full kit. Not EVA capable."

/datum/uplink_item/item/tools/encryptionkey_radio
	name = "Encrypted Radio Channel Key"
	item_cost = 1
	path = /obj/item/device/encryptionkey/syndicate
	desc = "An encryption key for use in a headset, intercepts all frequencies and grants access to a secure syndicate frequency."

/datum/uplink_item/item/tools/encryptionkey_binary
	name = "Binary Translator Key"
	item_cost = 1
	path = /obj/item/device/encryptionkey/binary
	desc = "An encryption key for use in a headset, capable of intercepting stationbound binary communications."

/datum/uplink_item/item/tools/emag
	name = "Cryptographic Sequencer"
	item_cost = 1
	path = /obj/item/card/emag

/datum/uplink_item/item/tools/personal_shield
	name = "Personal Shield"
	desc = "A personal shield that, when kept in your hand and activated, will protect its user from five projectile shots. \
	        This can only be bought once."
	item_cost = 1
	item_limit = 1
	path = /obj/item/device/personal_shield

/datum/uplink_item/item/tools/hacking_tool
	name = "Door Hacking Tool"
	item_cost = 1
	path = /obj/item/device/multitool/hacktool
	desc = "Appears and functions as a standard multitool until the mode is toggled by applying a screwdriver appropriately. \
			When in hacking mode this device will grant full access to any standard airlock within 7 to 13 seconds. \
			This device will also be able to immediately access the last 6 to 8 hacked airlocks."

/datum/uplink_item/item/tools/space_suit
	name = "Space Suit"
	item_cost = 2
	path = /obj/item/storage/box/syndie_kit/space

/datum/uplink_item/item/tools/thermal
	name = "Thermal Imaging Glasses"
	item_cost = 2
	path = /obj/item/clothing/glasses/thermal/syndi

/datum/uplink_item/item/tools/powersink
	name = "Powersink (DANGER!)"
	item_cost = 6
	path = /obj/item/device/powersink

/datum/uplink_item/item/tools/ai_module
	name = "Hacked AI Upload Module"
	item_cost = 2
	path = /obj/item/aiModule/syndicate
	desc = "A hacked AI law module able to subvert a shipbound intelligence when appropriately configured. It must be installed through a special upload console \
			-- a circuitboard for which can be found in the secure technical storage areas of most SCC facilities."

/datum/uplink_item/item/tools/supply_beacon
	name = "Hacked Supply Beacon (DANGER!)"
	item_cost = 4
	path = /obj/item/supply_beacon
	desc = "A hacked supply beacon that will call in a random supply pod when deployed and activated. Steer clear of the area afterwards."

/datum/uplink_item/item/tools/advancedpinpointer
	name = "Advanced pinpointer"
	item_cost = 5
	path = /obj/item/pinpointer/advpinpointer
	desc = "An advanced pinpointer that can find any target with DNA along with various other items."

/datum/uplink_item/item/tools/combat_robot
	name = "Combat Robot Teleporter"
	item_cost = 20
	path = /obj/item/antag_spawner/combat_robot

/datum/uplink_item/item/tools/thermal_drill
	name = "Thermal Safe Drill"
	item_cost = 3
	path = /obj/item/thermal_drill

/datum/uplink_item/item/tools/heatpatch
	name = "HUDPatch, Thermal"
	item_cost = 2
	path = /obj/item/clothing/glasses/eyepatch/hud/thermal

/datum/uplink_item/item/tools/nightpatch
	name = "HUDPatch, Night-Vision"
	item_cost = 1
	path = /obj/item/clothing/glasses/eyepatch/hud/night

/datum/uplink_item/item/tools/aviatortherm
	name = "Aviators, Thermal"
	item_cost = 2
	path = /obj/item/clothing/glasses/thermal/aviator
	desc = "A pair of thermal-vision glasses disguised as aviator shades."

/datum/uplink_item/item/tools/aviatornight
	name = "Aviators, Night-Vision"
	item_cost = 1
	path = /obj/item/clothing/glasses/night/aviator
	desc = "A pair of night-vision glasses disguised as aviator shades."

/datum/uplink_item/item/tools/suit_cooling_unit
	name = "Portable suit cooling unit"
	item_cost = 1
	path = /obj/item/device/suit_cooling_unit
	desc = "A suit cooling unit with a high capacity power cell."

/datum/uplink_item/item/tools/keypad
	name = "Keypad Mag-Lock"
	item_cost = 1
	path = /obj/item/device/magnetic_lock/keypad
	desc = "A maglock that requires the user to enter a passcode to lock and then later unlock."

/datum/uplink_item/item/tools/personal_ai
	name = "Personal AI"
	item_cost = 1
	path = /obj/item/device/paicard
	desc = "An unmodified personal AI that can assist you in your ventures."

/datum/uplink_item/item/tools/pin_extractor
	name = "Firing Pin Extractor"
	item_cost = 1
	path = /obj/item/device/pin_extractor
	desc = "An extractor tool capable of extracting firing pins from most firearms."

/datum/uplink_item/item/tools/radio_jammer
	name = "Radio Jammer"
	item_cost = 2
	path = /obj/item/device/radiojammer
	desc = "A small jammer that can fit inside a pocket. Capable of disrupting nearby radios and hivenet transmitters."

/datum/uplink_item/item/tools/jetpack
	name = "Jetpack"
	item_cost = 1
	path = /obj/item/tank/jetpack/oxygen

/datum/uplink_item/item/tools/electropack
	name = "Electropack"
	item_cost = 1
	path = /obj/item/device/radio/electropack
	desc = "A backpack wired with electrodes. Sync up with a signaller, attach to an unwilling host and pulse the signal to shock them."

/datum/uplink_item/item/tools/ammo_display
	name = "Holographic Ammo Display"
	item_cost = 1
	path = /obj/item/ammo_display

/datum/uplink_item/item/tools/mesons_glasses
	name = "Mesons Scanners"
	desc = "These glasses make use of meson-scanning technology to allow the wearer to see through solid walls and floors."
	item_cost = 1
	path = /obj/item/clothing/glasses/meson

/datum/uplink_item/item/tools/materials_glasses
	name = "Optical Material Scanner"
	desc = "These glasses make use of scanning technology to allow the wearer to see objects through solid walls and floors."
	item_cost = 1
	path = /obj/item/clothing/glasses/material

/datum/uplink_item/item/tools/earmuff_headset
	name = "Earmuff Headset"
	desc = "This set of earmuffs has a secret compartment housing radio gear, allowing it to function as a standard headset."
	item_cost = 1
	path = /obj/item/device/radio/headset/earmuff

/datum/uplink_item/item/tools/liquidbags
	name = "25 Liquid-Bags"
	desc = "Use these bags to set up some barricades. Does not come with barbed wire included."
	item_cost = 2
	path = /obj/item/stack/liquidbags
