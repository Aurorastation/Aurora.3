/datum/design/item/robot_upgrade
	build_type = MECHFAB
	time = 12
	materials = list(DEFAULT_WALL_MATERIAL = 10000)
	category = "Cyborg Upgrade Modules"

/datum/design/item/robot_upgrade/rename
	name = "Rename Module"
	desc = "Used to rename a cyborg."
	build_path = /obj/item/borg/upgrade/rename

/datum/design/item/robot_upgrade/reset
	name = "Reset Module"
	desc = "Used to reset a cyborg's module. Destroys any other upgrades applied to the robot."
	build_path = /obj/item/borg/upgrade/reset

/datum/design/item/robot_upgrade/floodlight
	name = "Floodlight Module"
	desc = "Used to boost a cyborg's integrated light intensity."
	build_path = /obj/item/borg/upgrade/floodlight

/datum/design/item/robot_upgrade/restart
	name = "Emergency Restart Module"
	desc = "Used to force a restart of a disabled-but-repaired robot, bringing it back online."
	materials = list(DEFAULT_WALL_MATERIAL = 60000, MATERIAL_GLASS = 5000)
	build_path = /obj/item/borg/upgrade/restart

/datum/design/item/robot_upgrade/vtec
	name = "VTEC Module"
	desc = "Used to kick in a robot's VTEC systems, increasing their speed."
	materials = list(DEFAULT_WALL_MATERIAL = 80000, MATERIAL_GLASS = 6000, MATERIAL_GOLD = 5000)
	build_path = /obj/item/borg/upgrade/vtec

/datum/design/item/robot_upgrade/jetpack
	name = "Jetpack Module"
	desc = "A carbon dioxide jetpack suitable for low-gravity mining operations."
	materials = list(DEFAULT_WALL_MATERIAL = 10000, MATERIAL_PHORON = 15000, MATERIAL_URANIUM = 20000)
	build_path = /obj/item/robot_parts/robot_component/jetpack

/datum/design/item/robot_upgrade/syndicate
	name = "Illegal Upgrade"
	desc = "Allows for the construction of lethal upgrades for cyborgs."
	req_tech = list(TECH_COMBAT = 4, TECH_ILLEGAL = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 10000, MATERIAL_GLASS = 15000, MATERIAL_DIAMOND = 10000)
	build_path = /obj/item/borg/upgrade/syndicate