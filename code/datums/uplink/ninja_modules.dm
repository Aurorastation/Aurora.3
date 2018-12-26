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

/datum/uplink_item/item/ninja_modules/energy_blade
	name = "Energy Blade and Dart Launcher."
	desc = "A module that can produce a powerful energy blade in the users hand. It can also shoot stun-darts."
	item_cost = 8
	path = /obj/item/rig_module/mounted/energy_blade

/datum/uplink_item/item/ninja_modules/matter_fab
	name = "Matter Fabricator"
	desc = "A hardsuit matter fabricator that can produce sharp steel ninja stars used for throwing."
	item_cost = 4
	path = /obj/item/rig_module/fabricator

/datum/uplink_item/item/ninja_modules/emag_hand
	name = "EMAG Hand Module"
	desc = "A module that allows the user to apply an EMAG effect to the targeted item."
	item_cost = 5
	path = /obj/item/rig_module/device/emag_hand

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