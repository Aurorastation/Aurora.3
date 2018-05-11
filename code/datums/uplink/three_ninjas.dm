////////////////////////
//COMBAT / TIGER NINJA//
////////////////////////
/datum/uplink_item/item/combat_ninja_modules
	category = /datum/uplink_category/combat_ninja_modules

//UNIVERSAL ITEMS
/datum/uplink_item/item/combat_ninja_modules/sink
	name = "Module - Power Sink"
	desc = "A module that sucks power out of powered items and into the users suit."
	item_cost = 4
	path = /obj/item/rig_module/power_sink

/datum/uplink_item/item/combat_ninja_modules/chem_injector
	name = "Module - Chemical Injector"
	desc = "A chemical injector that allows the user to inject themsleves with medical chemicals."
	item_cost = 3
	path = /obj/item/rig_module/chem_dispenser

/datum/uplink_item/item/combat_ninja_modules/multi_vision
	name = "Module - Multi vision"
	desc = "Contains: thermal, night, mesons, and optical vision, all in one."
	item_cost = 2
	path = /obj/item/rig_module/vision/multi

/datum/uplink_item/item/combat_ninja_modules/leg_actuators
	name = "Module - Leg Actuators"
	desc = "A set of high-powered hydraulic actuators, for improved traversal of multilevelled areas."
	item_cost = 2
	path = /obj/item/rig_module/actuators

//CLASS SPECIFIC ITEMS

/datum/uplink_item/item/combat_ninja_modules/combat_leg_actuators
	name = "Module - Combat Leg Actuators"
	desc = "A set of high-powered hydraulic actuators, for improved traversal of multilevelled areas. This variant allows you to leap on people."
	item_cost = 4
	path = /obj/item/rig_module/actuators/combat

/datum/uplink_item/item/combat_ninja_modules/combat_injector
	name = "Combat Injector"
	desc = "A chemical injector that allows the user to inject themsleves with combat chemicals."
	item_cost = 4
	path = /obj/item/rig_module/chem_dispenser/combat

/datum/uplink_item/item/combat_ninja_modules/EMP_Shield
	name = "Active EMP Shielding"
	desc = "A very complicated module for a hardsuit that protects it to some degree from EMPs."
	item_cost = 4
	path = /obj/item/rig_module/emp_shielding

/datum/uplink_item/item/combat_ninja_modules/normal_grenade_lancher
	name = "Standard Grenade Launcher"
	desc = "A shoulder mounted grenade launcher with 3 EMP, Smoke, and flashbang grenades.It can be refilled with more grenades."
	item_cost = 6
	path = /obj/item/rig_module/grenade_launcher

/datum/uplink_item/item/combat_ninja_modules/enery_blade
	name = "Energy Blade and dart launcher."
	desc = "A module that can produce a powerful energy blade in the users hand. It can also shoot stun-darts."
	item_cost = 8
	path = /obj/item/rig_module/mounted/energy_blade

/datum/uplink_item/item/combat_ninja_modules/matter_fab
	name = "Matter Fabricator"
	desc = "A hardsuit matter fabricator that can produce sharp steel ninja stars used for throwing."
	item_cost = 4
	path = /obj/item/rig_module/fabricator

///////////////////////////
//MOBILITY / SPIDER NINJA//
///////////////////////////

/datum/uplink_item/item/mobility_ninja_modules
	category = /datum/uplink_category/mobility_ninja_modules

//UNIVERSAL ITEMS
/datum/uplink_item/item/mobility_ninja_modules/sink
	name = "Module - Power Sink"
	desc = "A module that sucks power out of powered items and into the users suit."
	item_cost = 4
	path = /obj/item/rig_module/power_sink

/datum/uplink_item/item/mobility_ninja_modules/chem_injector
	name = "Module - Chemical Injector"
	desc = "A chemical injector that allows the user to inject themsleves with medical chemicals."
	item_cost = 3
	path = /obj/item/rig_module/chem_dispenser

/datum/uplink_item/item/mobility_ninja_modules/multi_vision
	name = "Module - Multi vision"
	desc = "Contains: thermal, night, mesons, and optical vision, all in one."
	item_cost = 2
	path = /obj/item/rig_module/vision/multi

/datum/uplink_item/item/mobility_ninja_modules/leg_actuators
	name = "Module - Leg Actuators"
	desc = "A set of high-powered hydraulic actuators, for improved traversal of multilevelled areas."
	item_cost = 2
	path = /obj/item/rig_module/actuators

//CLASS SPECIFIC

/datum/uplink_item/item/mobility_ninja_modules/energency_generator
	name = "Emergency Power Generator"
	desc = "An emergency use power generator that gives 1000 power to the suits battery. Has a long cooldown."
	item_cost = 4
	path = /obj/item/rig_module/emergency_powergenerator

/datum/uplink_item/item/mobility_ninja_modules/energy_net
	name = "Energy Net"
	desc = "An unlimited use net, if the user has enough power, that can be thrown at others causing them to be trapped. The net can be broken with brute force.."
	item_cost = 4
	path = /obj/item/rig_module/fabricator/energy_net

/datum/uplink_item/item/mobility_ninja_modules/emag_hand
	name = "EMAG Hand Module"
	desc = "A module that allows the user to apply an EMAG effect to the targeted item."
	item_cost = 5
	path = /obj/item/rig_module/device/emag_hand

/datum/uplink_item/item/mobility_ninja_modules/electrowarfare_suite
	name = "Electrowarfare Suite"
	desc = "A module that passively prevents AI units from tracking you, when enabled."
	item_cost = 2
	path = /obj/item/rig_module/electrowarfare_suite

/datum/uplink_item/item/mobility_ninja_modules/maneuvering_jets
	name = "Maneuvering Jets"
	desc = "A module with a built-in jetpack."
	item_cost = 3
	path = /obj/item/rig_module/maneuvering_jets

/datum/uplink_item/item/mobility_ninja_modules/flash
	name = "Mounted Flash"
	desc = "A built-in mounted flash that works like a regular flash, but never burns out."
	item_cost = 2
	path = /obj/item/rig_module/device/flash

/datum/uplink_item/item/mobility_ninja_modules/taser
	name = "Mounted Taser"
	desc = "A built-in mounted taser that works like a regular taser."
	item_cost = 2
	path = /obj/item/rig_module/mounted/taser

/datum/uplink_item/item/mobility_ninja_modules/ai_container
	name = "AI Container"
	desc = "A module that allows pAI units and AI units to be housed in the suit. Enable AI control to let the unit control the suit."
	item_cost = 2
	path = /obj/item/rig_module/ai_container

/datum/uplink_item/item/mobility_ninja_modules/datajack
	name = "Datajack"
	desc = "A built in module that allows the user to hack into encrypted networks and data disks."
	item_cost = 1
	path = /obj/item/rig_module/datajack

/datum/uplink_item/item/mobility_ninja_modules/teleporter
	name = "Module - Teleporter"
	desc = "A teleportation module that taps into bluespace that allows the user to locally teleport a short distance."
	item_cost = 8
	path = /obj/item/rig_module/teleporter

/////////////////////////
//STEALTH / SNAKE NINJA//
/////////////////////////

/datum/uplink_item/item/stealth_ninja_modules
	category = /datum/uplink_category/stealth_ninja_modules

//UNIVERSAL ITEMS
/datum/uplink_item/item/stealth_ninja_modules/sink
	name = "Module - Power Sink"
	desc = "A module that sucks power out of powered items and into the users suit."
	item_cost = 4
	path = /obj/item/rig_module/power_sink

/datum/uplink_item/item/stealth_ninja_modules/chem_injector
	name = "Module - Chemical Injector"
	desc = "A chemical injector that allows the user to inject themsleves with medical chemicals."
	item_cost = 3
	path = /obj/item/rig_module/chem_dispenser

/datum/uplink_item/item/stealth_ninja_modules/multi_vision
	name = "Module - Multi vision"
	desc = "Contains: thermal, night, mesons, and optical vision, all in one."
	item_cost = 2
	path = /obj/item/rig_module/vision/multi

/datum/uplink_item/item/stealth_ninja_modules/leg_actuators
	name = "Module - Leg Actuators"
	desc = "A set of high-powered hydraulic actuators, for improved traversal of multilevelled areas."
	item_cost = 2
	path = /obj/item/rig_module/actuators

//CLASS SPECIFIC

/datum/uplink_item/item/stealth_ninja_modules/voice
	name = "Module - Voice Changer."
	desc = "A module that allows the user to disguise their voice."
	item_cost = 4
	path = /obj/item/rig_module/voice

/datum/uplink_item/item/stealth_ninja_modules/electrowarfare_suite
	name = "Electrowarfare Suite"
	desc = "A module that passively prevents AI units from tracking you, when enabled."
	item_cost = 2
	path = /obj/item/rig_module/electrowarfare_suite

/datum/uplink_item/item/stealth_ninja_modules/ai_container
	name = "AI Container"
	desc = "A module that allows pAI units and AI units to be housed in the suit. Enable AI control to let the unit control the suit."
	item_cost = 2
	path = /obj/item/rig_module/ai_container

/datum/uplink_item/item/stealth_ninja_modules/datajack
	name = "Datajack"
	desc = "A built in module that allows the user to hack into encrypted networks and data disks."
	item_cost = 1
	path = /obj/item/rig_module/datajack

/datum/uplink_item/item/stealth_ninja_modules/stealth_field
	name = "Stealth Field"
	desc = "A module that allows the user to go invisible. Consumes power when active."
	item_cost = 6
	path = /obj/item/rig_module/stealth_field

/datum/uplink_item/item/stealth_ninja_modules/emag_hand
	name = "EMAG Hand Module"
	desc = "A module that allows the user to apply an EMAG effect to the targeted item."
	item_cost = 5
	path = /obj/item/rig_module/device/emag_hand