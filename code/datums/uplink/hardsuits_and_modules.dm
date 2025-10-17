/*******************
* Hardsuit Modules *
*******************/
/datum/uplink_item/item/hardsuit_modules
	category = /datum/uplink_category/hardsuit_modules

/datum/uplink_item/item/hardsuit_modules/thermal
	name = "Thermal Scanner"
	telecrystal_cost = 2
	path = /obj/item/rig_module/vision/thermal
	desc = "A module granting the hardsuit thermal sensors, showing heat signatures through obstacles."

/datum/uplink_item/item/hardsuit_modules/energy_net
	name = "Net Projector"
	telecrystal_cost = 3
	path = /obj/item/rig_module/fabricator/energy_net
	desc = "Allows the hardsuit to synthesize and fire energy nets, immobilizing a target until the net is torn by physical force."

/datum/uplink_item/item/hardsuit_modules/ewar_voice
	name = "Electrowarfare Suite and Voice Synthesiser"
	telecrystal_cost = 1
	bluecrystal_cost = 1 // Voice changer and partial agent id as a module
	path = /obj/item/storage/box/syndie_kit/ewar_voice
	desc = "A module that blocks AI tracking. Comes with an inbuilt voice changer aswell."

/datum/uplink_item/item/hardsuit_modules/maneuvering_jets
	name = "Maneuvering Jets"
	telecrystal_cost = 1
	bluecrystal_cost = 1
	path = /obj/item/rig_module/maneuvering_jets
	desc = "A set of jets powered by a hardsuit, allowing it to move through space."

/datum/uplink_item/item/hardsuit_modules/flash
	name = "Mounted Flash" // Its just a flash but clunkier and in a hardsuit.
	telecrystal_cost = 1
	path = /obj/item/rig_module/device/flash
	desc = "A standard flash, often used by security. This one is mounted on a hardsuit."

/datum/uplink_item/item/hardsuit_modules/frag
	name = "Mounted Frag Grenade Launcher" // Uplink sells 5 of these grenades for 6 tc, this has three.
	telecrystal_cost = 5
	path = /obj/item/rig_module/grenade_launcher/frag
	desc = "A hardsuit mounted grenade launcher, containing three fragmentation grenades."

/datum/uplink_item/item/hardsuit_modules/plasma
	name = "Mounted Plasma Cannon"
	telecrystal_cost = 8
	path = /obj/item/rig_module/mounted/plasma
	desc = "A marvel of Elyran weapons technology which utilizes superheated plasma to pierce thick armor with gruesome results. This one seems fitted for RIG usage."

/datum/uplink_item/item/hardsuit_modules/egun
	name = "Mounted Energy Gun"
	telecrystal_cost = 6
	path = /obj/item/rig_module/mounted/egun
	desc = "A hardsuit mounted energy gun, with non-lethal and lethal firing modes."

/datum/uplink_item/item/hardsuit_modules/tqiqop
	name = "Mounted Tqi-Qop Carbine"
	telecrystal_cost = 6
	path = /obj/item/rig_module/mounted/skrell_gun
	desc = "A hardsuit mounted Tqi-Qop carbine, a skrellian weapon rarely seen outside of the federation."

/datum/uplink_item/item/hardsuit_modules/smg
	name = "Mounted Submachine Gun"
	telecrystal_cost = 6
	path = /obj/item/rig_module/mounted/smg
	desc = "A hardsuit mounted submachine gun, synthesizing projectiles from the suits power supply."

/datum/uplink_item/item/hardsuit_modules/power_sink
	name = "Power Sink"
	telecrystal_cost = 2
	path = /obj/item/rig_module/power_sink
	desc = "A module allowing the hardsuit to directly charge power from APC units."

/datum/uplink_item/item/hardsuit_modules/laser_canon
	name = "Mounted Laser Cannon"
	telecrystal_cost = 8
	path = /obj/item/rig_module/mounted
	desc = "A large hardsuit mounted laser cannon, designed to be powered by its battery."

/datum/uplink_item/item/hardsuit_modules/ion
	name = "Mounted Ion Rifle"
	telecrystal_cost = 8 // Can up or remove this if need be, ions are pretty strong and usually balanced by being bulky or unwieldy.
	path = /obj/item/rig_module/mounted/ion
	desc = "A hardsuit mounted ion rifle, be careful not to hit yourself with it."

/datum/uplink_item/item/hardsuit_modules/plasmacutter
	name = "Mounted Plasma Cutter"
	telecrystal_cost = 3
	path = /obj/item/rig_module/mounted/plasmacutter
	desc = "A hardsuit mounted plasma cutter, for cutting through walls and rocks."

/datum/uplink_item/item/tools/rig_cooling_unit
	name = "Mounted Suit Cooling Unit"
	telecrystal_cost = 1
	bluecrystal_cost = 1 // Just EVA stuff for IPCs
	path = /obj/item/rig_module/cooling_unit
	desc = "A mounted suit cooling unit for use with hardsuits."

/datum/uplink_item/item/hardsuit_modules/storage_unit
	name = "Mounted Storage Unit"
	telecrystal_cost = 1
	bluecrystal_cost = 1 // This thing has less space than a box does, although it can hold bulkier items like crowbars.
	path = /obj/item/rig_module/storage
	desc = "A small hardsuit mounted storage unit, capable of holding a few items."

/datum/uplink_item/item/hardsuit_modules/vitalscanner
	name = "Vitals Tracker Module"
	telecrystal_cost = 1
	bluecrystal_cost = 1
	path = /obj/item/rig_module/device/healthscanner/vitalscanner
	desc = "A module that allows a hardsuit to scan the users vitals, and give readouts of them."

/datum/uplink_item/item/hardsuit_modules/basicinjector
	name = "Emergency Chemical Injector"
	telecrystal_cost = 2
	bluecrystal_cost = 2 // This is the nerfed paramedic version, rather than the ninja version with synaptizine and hyperzine.
	path = /obj/item/rig_module/chem_dispenser/injector/paramedic
	desc = "A hardsuit mounted chemical injector containing 40u each of tricordzine, perconol, dexalin and inaprovaline."

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
	desc = "A sleek and dangerous hardsuit for active combat. This one is a Stellar Corporate Conglomerate design in color scheme and make. Wearable by humans, skrell, tajara, unathi and IPC."

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

/datum/uplink_item/item/hardsuit_modules/suit/bunker
	name = "Ceres Lance Bunker Suit"
	telecrystal_cost = 8
	bluecrystal_cost = 8
	path = /obj/item/rig/bunker/nerfed
	desc = "A powerful niche-function hardsuit utilized by Ceres' Lance to apprehend synthetics. This is a lighter version with more standard hardsuit plating. Only wearable by humans."

/datum/uplink_item/item/hardsuit_modules/suit/vaurca
	name = "Vaurca Combat Exoskeleton"
	telecrystal_cost = 10
	path = /obj/item/rig/vaurca/minimal
	desc = "An ancient piece of equipment from a bygone age, This highly advanced Vaurcan technology rarely sees use outside of a battlefield. Only wearable by vaurca."
