/*******************
* Hardsuit Modules *
*******************/
/datum/uplink_item/item/hardsuit_modules
	category = /datum/uplink_category/hardsuit_modules

/datum/uplink_item/item/hardsuit_modules/thermal
	name = "Thermal Scanner"
	telecrystal_cost = 2
	path = /obj/item/rig_module/vision/thermal

/datum/uplink_item/item/hardsuit_modules/energy_net
	name = "Net Projector"
	telecrystal_cost = 3
	path = /obj/item/rig_module/fabricator/energy_net

/datum/uplink_item/item/hardsuit_modules/ewar_voice
	name = "Electrowarfare Suite and Voice Synthesiser"
	telecrystal_cost = 1
	bluecrystal_cost = 1 // Voice changer and partial agent id as a module
	path = /obj/item/storage/box/syndie_kit/ewar_voice

/datum/uplink_item/item/hardsuit_modules/maneuvering_jets
	name = "Maneuvering Jets"
	telecrystal_cost = 1
	bluecrystal_cost = 1
	path = /obj/item/rig_module/maneuvering_jets

/datum/uplink_item/item/hardsuit_modules/egun
	name = "Mounted Energy Gun"
	telecrystal_cost = 6
	path = /obj/item/rig_module/mounted/egun

/datum/uplink_item/item/hardsuit_modules/power_sink
	name = "Power Sink"
	telecrystal_cost = 2
	path = /obj/item/rig_module/power_sink

/datum/uplink_item/item/hardsuit_modules/laser_canon
	name = "Mounted Laser Cannon"
	telecrystal_cost = 8
	path = /obj/item/rig_module/mounted

/datum/uplink_item/item/tools/rig_cooling_unit
	name = "mounted suit cooling unit"
	telecrystal_cost = 1
	bluecrystal_cost = 1 // Just EVA stuff for IPCs
	path = /obj/item/rig_module/cooling_unit
	desc = "A mounted suit cooling unit for use with hardsuits."

/datum/uplink_item/item/hardsuit_modules/recharger
	name = "Mounted Weapon Recharge Module"
	telecrystal_cost = 6
	path = /obj/item/rig_module/recharger
	desc = "A mounted system for recharging energy weapons."

/datum/uplink_item/item/hardsuit_modules/ai_container
	name = "Integrated Intelligence System"
	telecrystal_cost = 1
	bluecrystal_cost = 1 // Niche utility item.
	path = /obj/item/rig_module/ai_container
	desc = "A hardsuit module which allows for a support intelligence to be installed."

/datum/uplink_item/item/hardsuit_modules/combat_actuators // These come stock with pretty much all equipped suits.
	name = "Combat Actuators"
	telecrystal_cost = 3
	path = /obj/item/rig_module/actuators/combat
	desc = "Actuators that allow a hardsuit to jump long distances, and to fall safely."

/datum/uplink_item/item/hardsuit_modules/suit/scc // These are all empty suits with heavy armor stats, that essentially are overall reskins of each other. With sometimes some minor differences.
	name = "SCC Combat Hardsuit"
	telecrystal_cost = 8
	bluecrystal_cost = 8
	path = /obj/item/rig/combat
	desc = "A sleek and dangerous hardsuit for active combat. This one is a Stellar Corporate Conglomerate design in color scheme and make. Only wearable by humans and skrell."

/datum/uplink_item/item/hardsuit_modules/suit/sol
	name = "Solarian Vampire Hardsuit"
	telecrystal_cost = 8
	bluecrystal_cost = 8
	path = /obj/item/rig/military
	desc = "A Zavodskoi-manufactured hardsuit designed for the Solarian Armed Forces, the Type-9 \"Vampire\" is the suit issued to Alliance military specialists and team leaders. Only wearable by humans."

/datum/uplink_item/item/hardsuit_modules/suit/coalition
	name = "Coalition Gunslinger Hardsuit"
	telecrystal_cost = 8
	bluecrystal_cost = 8
	path = /obj/item/rig/gunslinger
	desc = "A favorite of the Frontier Rangers, the Gunslinger suit is a Xanan-designed hardsuit meant to provide the user absolute situational awareness, while remaining sturdy under fire. Only wearable by humans, tajara, skrell and non-industrial IPCs."

/datum/uplink_item/item/hardsuit_modules/suit/eridani
	name = "Eridani Strike Hardsuit"
	telecrystal_cost = 8
	bluecrystal_cost = 8
	path = /obj/item/rig/strike
	desc = "An expensive hardsuit utilized by Eridani security contractors to field heavy weapons and coordinate non-lethal takedowns directly. Usually seen spearheading police raids. Only wearable by humans."

/datum/uplink_item/item/hardsuit_modules/suit/elyra
	name = "Elyran Battlesuit"
	telecrystal_cost = 8
	bluecrystal_cost = 8
	path = /obj/item/rig/elyran
	desc = "An advanced Elyran hardsuit specialized in scorched earth tactics. Only wearable by humans."

/datum/uplink_item/item/hardsuit_modules/suit/dominia
	name = "Dominian Jinxiang Hardsuit"
	telecrystal_cost = 8
	bluecrystal_cost = 8
	path = /obj/item/rig/jinxiang
	desc = "An off-shoot of the core Bunker Suit design, utilized by the Imperial Dominian military and painted accordingly. This is a powerful suit specializing in melee confrontations. Only wearable by humans and unathi."

/datum/uplink_item/item/hardsuit_modules/suit/tcaf
	name = "TCAF Legionnaire Hardsuit"
	telecrystal_cost = 8
	bluecrystal_cost = 8
	path = /obj/item/rig/combat/legionnaire
	desc = "An armored combat hardsuit in the blue colors of the Tau Ceti Armed Forces. The red shoulder pad dignifying the individual as a member of rank. \
	Its golden visor reflecting the shining liberty the TCAF stands for. Only wearable by humans, Zeng-hu IPCs and Bishop IPCs."

/datum/uplink_item/item/hardsuit_modules/suit/xanu
	name = "Xanan dNAXS-52 Hardsuit"
	telecrystal_cost = 8
	bluecrystal_cost = 8
	path = /obj/item/rig/xanu
	desc = "The dNAXS-52 combat hardsuit is designed for the All-Xanu Spacefleet's interstellar infantry. It is specially designed for boarding operations, close quarters combat, and demolitions. Only wearable by humans and non-industrial IPCs."

/datum/uplink_item/item/hardsuit_modules/suit/crimson
	name = "Crimson Hardsuit"
	telecrystal_cost = 8
	bluecrystal_cost = 8
	path = /obj/item/rig/merc/trulyempty
	desc = "A blood-red hardsuit featuring some fairly illegal technology. Made by Hammertail, and popular on the black market. Only wearable by humans, unathi, skrell, tajara and non-industrial IPCs."

/datum/uplink_item/item/hardsuit_modules/suit/einstein
	name = "Einstein Engines Paragon Hardsuit"
	telecrystal_cost = 8
	bluecrystal_cost = 8
	path = /obj/item/rig/merc/einstein/empty
	desc = "A back mounted control mechanism of an Einstein Engines hardsuit. This model is issued to the leaders of security teams within the corporation. Wearable only by humans, industrial, zeng-hu and bishop IPCs."

/datum/uplink_item/item/hardsuit_modules/suit/qukala
	name = "Qukala Assault Hardsuit"
	telecrystal_cost = 8
	bluecrystal_cost = 8
	path = /obj/item/rig/skrell
	desc = "A Nralakk-manufactured combat hardsuit, designed for use by elite operatives of the Qukala. Due to their expense and classified design, these suits are rarely seen outside of Qukala hands. Only wearable by skrell."

/datum/uplink_item/item/hardsuit_modules/suit/vaurca
	name = "Vaurca Combat Exoskeleton"
	telecrystal_cost = 10
	path = /obj/item/rig/vaurca/minimal
	desc = "An ancient piece of equipment from a bygone age, This highly advanced Vaurcan technology rarely sees use outside of a battlefield. Only wearable by vaurca."
