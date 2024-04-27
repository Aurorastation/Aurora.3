/*******************
* Hardsuit Modules *
*******************/
/datum/uplink_item/item/hardsuit_modules
	category = /datum/uplink_category/hardsuit_modules

/datum/uplink_item/item/hardsuit_modules/thermal
	name = "Thermal Scanner"
	telecrystal_cost = 1
	path = /obj/item/rig_module/vision/thermal

/datum/uplink_item/item/hardsuit_modules/energy_net
	name = "Net Projector"
	telecrystal_cost = 3
	path = /obj/item/rig_module/fabricator/energy_net

/datum/uplink_item/item/hardsuit_modules/ewar_voice
	name = "Electrowarfare Suite and Voice Synthesiser"
	telecrystal_cost = 1
	path = /obj/item/storage/box/syndie_kit/ewar_voice

/datum/uplink_item/item/hardsuit_modules/maneuvering_jets
	name = "Maneuvering Jets"
	telecrystal_cost = 1
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
	path = /obj/item/rig_module/ai_container
	desc = "A hardsuit module which allows for a support intelligence to be installed."
