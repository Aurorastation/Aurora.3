/datum/uplink_item/item/exosuit_equipment
	category = /datum/uplink_category/exosuit_equipment

// COMBAT //

/datum/uplink_item/item/exosuit_equipment/mounted_gun
	name = "Mounted Electrolaser Carbine"
	desc = "A dual fire mode electrolaser system connected to the exosuit's targetting system."
	item_cost = 8
	path = /obj/item/mecha_equipment/mounted_system/taser

/datum/uplink_item/item/exosuit_equipment/mounted_gun/ion
	name = "Mounted Ion Rifle"
	desc = "An exosuit-mounted ion rifle. Handle with care."
	item_cost = 12
	path = /obj/item/mecha_equipment/mounted_system/taser/ion

/datum/uplink_item/item/exosuit_equipment/mounted_gun/laser
	name = "Mounted Laser Rifle"
	desc = "An exosuit-mounted laser rifle. Handle with care."
	item_cost = 10
	path = /obj/item/mecha_equipment/mounted_system/taser/laser

/datum/uplink_item/item/exosuit_equipment/mounted_gun/smg
	name = "Mounted Machine Gun"
	desc = "An exosuit-mounted automatic weapon. Handle with care."
	item_cost = 10
	path = /obj/item/mecha_equipment/mounted_system/taser/smg

/datum/uplink_item/item/exosuit_equipment/mounted_launcher
	name = "Mounted Missile Rack"
	desc = "An SRM-8 missile rack loaded with explosive missiles."
	item_cost = 20
	path = /obj/item/mecha_equipment/mounted_system/missile

// UTILITY //

/datum/uplink_item/item/exosuit_equipment/mounted_tool
	name = "Mounted RFD-C"
	desc = "A RFD, modified to construct walls and floors. This one can be mounted on an exosuit."
	item_cost = 12
	path = /obj/item/mecha_equipment/mounted_system/rfd

/datum/uplink_item/item/exosuit_equipment/mounted_tool/clamp
	name = "Mounted Clamp"
	desc = "A large, heavy industrial cargo loading clamp."
	item_cost = 4
	path = /obj/item/mecha_equipment/clamp

/datum/uplink_item/item/exosuit_equipment/mounted_tool/catapult
	name = "Mounted Gravitational Catapult"
	desc = "An exosuit-mounted gravitational catapult."
	item_cost = 10
	path = /obj/item/mecha_equipment/catapult

/datum/uplink_item/item/exosuit_equipment/mounted_tool/drill
	name = "Mounted Drill"
	desc = "An exosuit-mounted drill."
	item_cost = 6
	path = /obj/item/mecha_equipment/drill

/datum/uplink_item/item/exosuit_equipment/mounted_tool/passenger
	name = "Mounted Passenger Compartment"
	desc = "An exosuit-mounted passenger compartment."
	item_cost = 4
	path = /obj/item/mecha_equipment/sleeper/passenger_compartment

// MEDICAL //

/datum/uplink_item/item/exosuit_equipment/mounted_medical
	name = "Mounted Sleeper"
	desc = "An exosuit-mounted sleeper designed to maintain patients stabilized on their way to medical facilities."
	item_cost = 8
	path = /obj/item/mecha_equipment/sleeper

/datum/uplink_item/item/exosuit_equipment/mounted_medical/drone
	name = "Mounted Crisis Dronebay"
	desc = "A small shoulder-mounted dronebay containing a rapid response drone capable of moderately stabilizing a patient near the exosuit."
	item_cost = 8
	path = /obj/item/mecha_equipment/crisis_drone