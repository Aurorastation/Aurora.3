/***************
* Special Ninja Modules *
***************/
/datum/uplink_item/item/ninja_modules
	category = /datum/uplink_category/ninja_modules

/datum/uplink_item/item/ninja_modules/energency_generator
	name = "Emergency Power Generator"
	desc = "An emergency use power generator that gives 1000 power to the suits battery. Has a long cooldown."
	item_cost = 4
	path = /obj/item/rig_module/emergency_powergenerator

/datum/uplink_item/item/ninja_modules/energy_net
	name = "Energy Net"
	desc = "An unlimited use net, if the user has enough power, that can be thrown at others causing them to be trapped. The net can be broken with brute force.."
	item_cost = 4
	path = /obj/item/rig_module/fabricator/energy_net

/datum/uplink_item/item/ninja_modules/stealth_field
	name = "Stealth Field"
	desc = "A module that allows the user to go invisible. Consumes power when active."
	item_cost = 6
	path = /obj/item/rig_module/stealth_field

/datum/uplink_item/item/ninja_modules/normal_grenade_lancher
	name = "Standard Grenade Launcher"
	desc = "A shoulder mounted grenade launcher with 3 EMP, Smoke, and flashbang grenades.It can be refilled with more grenades."
	item_cost = 6
	path = /obj/item/rig_module/grenade_launcher

/datum/uplink_item/item/ninja_modules/enery_blade
	name = "Energy Blade and dart launcher."
	desc = "A module that can produce a powerful energy blade in the users hand. It can also shoot stun-darts."
	item_cost = 8
	path = /obj/item/rig_module/mounted/energy_blade

/datum/uplink_item/item/ninja_modules/matter_fab
	name = "Matter Fabricator"
	desc = "A hardsuit matter fabricator that can produce sharp steel ninja stars used for throwing."
	item_cost = 4
	path = /obj/item/rig_module/fabricator

/datum/uplink_item/item/ninja_modules/sink
	name = "Power Sink"
	desc = "A module that sucks power out of powered items and into the users suit."
	item_cost = 4
	path = /obj/item/rig_module/power_sink

/datum/uplink_item/item/ninja_modules/emag_hand
	name = "EMAG Hand Module"
	desc = "A module that allows the user to apply an EMAG effect to the targeted item."
	item_cost = 5
	path = /obj/item/rig_module/device/emag_hand

/datum/uplink_item/item/ninja_modules/chem_injector
	name = "Chemical Injector"
	desc = "A chemical injector that allows the user to inject themsleves with medical chemicals."
	item_cost = 3
	path = /obj/item/rig_module/chem_dispenser

/datum/uplink_item/item/ninja_modules/EMP_Shield
	name = "Active EMP Shielding"
	desc = "A very complicated module for a hardsuit that protects it to some degree from EMPs."
	item_cost = 4
	path = /obj/item/rig_module/emp_shielding

/datum/uplink_item/item/ninja_modules/combat_injector
	name = "Combat Injector"
	desc = "A chemical injector that allows the user to inject themsleves with combat chemicals."
	item_cost = 4
	path = /obj/item/rig_module/chem_dispenser/combat