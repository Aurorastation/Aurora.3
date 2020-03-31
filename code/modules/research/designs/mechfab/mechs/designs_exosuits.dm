/datum/design/item/mechfab/exosuit
	name = "Exosuit Frame"
	build_path = /obj/structure/heavy_vehicle_frame
	time = 50
	materials = list(DEFAULT_WALL_MATERIAL = 15000)
	category = "Exosuits"

/datum/design/item/mechfab/exosuit/basic_armour
	name = "Basic Exosuit Armor"
	build_path = /obj/item/robot_parts/robot_component/armor/mech
	time = 30
	materials = list(DEFAULT_WALL_MATERIAL = 6000)

/datum/design/item/mechfab/exosuit/radproof_armour
	name = "Radiation-proof Exosuit Armor"
	build_path = /obj/item/robot_parts/robot_component/armor/mech/radproof
	time = 50
	req_tech = list(TECH_MATERIAL = 2, TECH_ENGINEERING = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 12500)

/datum/design/item/mechfab/exosuit/em_armour
	name = "EM-shielded Exosuit Armor"
	build_path = /obj/item/robot_parts/robot_component/armor/mech/em
	time = 50
	req_tech = list(TECH_MATERIAL = 2, TECH_POWER = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 12500, MATERIAL_SILVER = 1000)

/datum/design/item/mechfab/exosuit/combat_armour
	name = "Combat Exosuit Armor"
	build_path = /obj/item/robot_parts/robot_component/armor/mech/combat
	time = 50
	req_tech = list(TECH_MATERIAL = 4, TECH_COMBAT = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 20000, MATERIAL_DIAMOND = 5000)

/datum/design/item/mechfab/exosuit/control_module
	name = "Exosuit Control Module"
	build_path = /obj/item/mech_component/control_module
	time = 15
	materials = list(DEFAULT_WALL_MATERIAL = 5000)

/datum/design/item/mechfab/exosuit/combat_head
	name = "Combat Exosuit Sensors"
	time = 30
	materials = list(DEFAULT_WALL_MATERIAL = 10000)
	build_path = /obj/item/mech_component/sensors/combat
	req_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 3)

/datum/design/item/mechfab/exosuit/combat_torso
	name = "Combat Exosuit Chassis"
	time = 60
	materials = list(DEFAULT_WALL_MATERIAL = 45000)
	build_path = /obj/item/mech_component/chassis/combat
	req_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 3)

/datum/design/item/mechfab/exosuit/combat_arms
	name = "Combat Exosuit Manipulators"
	time = 30
	materials = list(DEFAULT_WALL_MATERIAL = 15000)
	build_path = /obj/item/mech_component/manipulators/combat
	req_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 3)

/datum/design/item/mechfab/exosuit/combat_legs
	name = "Combat Exosuit Motivators"
	time = 30
	materials = list(DEFAULT_WALL_MATERIAL = 15000)
	build_path = /obj/item/mech_component/propulsion/combat
	req_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 3)

/datum/design/item/mechfab/exosuit/ripley_head
	name = "Powerloader Sensors"
	build_path = /obj/item/mech_component/sensors/ripley
	time = 15
	materials = list(DEFAULT_WALL_MATERIAL = 3500)

/datum/design/item/mechfab/exosuit/ripley_torso
	name = "Powerloader Chassis"
	build_path = /obj/item/mech_component/chassis/ripley
	time = 35
	materials = list(DEFAULT_WALL_MATERIAL = 15000)

/datum/design/item/mechfab/exosuit/ripley_arms
	name = "Powerloader Manipulators"
	build_path = /obj/item/mech_component/manipulators/ripley
	time = 25
	materials = list(DEFAULT_WALL_MATERIAL = 4500)

/datum/design/item/mechfab/exosuit/ripley_legs
	name = "Powerloader Motivators"
	build_path = /obj/item/mech_component/propulsion/ripley
	time = 25
	materials = list(DEFAULT_WALL_MATERIAL = 4500)

/datum/design/item/mechfab/exosuit/light_head
	name = "Light Exosuit Sensors"
	time = 20
	materials = list(DEFAULT_WALL_MATERIAL = 6500)
	build_path = /obj/item/mech_component/sensors/light
	req_tech = list(TECH_MATERIAL = 1)

/datum/design/item/mechfab/exosuit/light_torso
	name = "Light Exosuit Chassis"
	time = 30
	materials = list(DEFAULT_WALL_MATERIAL = 25000)
	build_path = /obj/item/mech_component/chassis/light
	req_tech = list(TECH_MATERIAL = 1)

/datum/design/item/mechfab/exosuit/light_arms
	name = "Light Exosuit Manipulators"
	time = 20
	materials = list(DEFAULT_WALL_MATERIAL = 10000)
	build_path = /obj/item/mech_component/manipulators/light
	req_tech = list(TECH_MATERIAL = 1)

/datum/design/item/mechfab/exosuit/light_legs
	name = "Light Exosuit Motivators"
	time = 25
	materials = list(DEFAULT_WALL_MATERIAL = 10000)
	build_path = /obj/item/mech_component/propulsion/light
	req_tech = list(TECH_MATERIAL = 1)

/datum/design/item/mechfab/exosuit/heavy_head
	name = "Heavy Exosuit Sensors"
	time = 35
	materials = list(DEFAULT_WALL_MATERIAL = 12000)
	build_path = /obj/item/mech_component/sensors/heavy
	req_tech = list(TECH_COMBAT = 2)

/datum/design/item/mechfab/exosuit/heavy_torso
	name = "Heavy Exosuit Chassis"
	time = 75
	materials = list(DEFAULT_WALL_MATERIAL = 70000, MATERIAL_URANIUM = 10000)
	build_path = /obj/item/mech_component/chassis/heavy

/datum/design/item/mechfab/exosuit/heavy_arms
	name = "Heavy Exosuit Manipulators"
	time = 35
	materials = list(DEFAULT_WALL_MATERIAL = 20000)
	build_path = /obj/item/mech_component/manipulators/heavy

/datum/design/item/mechfab/exosuit/heavy_legs
	name = "Heavy Exosuit Motivators"
	time = 35
	materials = list(DEFAULT_WALL_MATERIAL = 20000)
	build_path = /obj/item/mech_component/propulsion/heavy

/datum/design/item/mechfab/exosuit/spider
	name = "Quadruped Motivators"
	time = 20
	materials = list(DEFAULT_WALL_MATERIAL = 12000)
	build_path = /obj/item/mech_component/propulsion/spider
	req_tech = list(TECH_ENGINEERING = 2)

/datum/design/item/mechfab/exosuit/hover_torso
	name = "Hoverpod Torso"
	time = 40
	materials = list(DEFAULT_WALL_MATERIAL = 22000)
	build_path = /obj/item/mech_component/chassis/pod

/datum/design/item/mechfab/exosuit/hover_legs
	name = "Hoverthrusters"
	time = 35
	materials = list(DEFAULT_WALL_MATERIAL = 14000)
	build_path = /obj/item/mech_component/propulsion/hover

/datum/design/item/mechfab/exosuit/track
	name = "Armored Treads"
	time = 35
	materials = list(DEFAULT_WALL_MATERIAL = 25000)
	build_path = /obj/item/mech_component/propulsion/tracks
	req_tech = list(TECH_MATERIAL = 4)

/datum/design/item/mechfab/exosuit/hydraulic_clamp
	name = "Hydraulic Clamp"
	materials = list(DEFAULT_WALL_MATERIAL = 10000)
	build_path = /obj/item/mecha_equipment/clamp

/datum/design/item/mechfab/exosuit/gravity_catapult
	name = "Gravity Catapult"
	build_path = /obj/item/mecha_equipment/catapult

/datum/design/item/mechfab/exosuit/drill
	name = "Drill"
	materials = list(DEFAULT_WALL_MATERIAL = 10000)
	build_path = /obj/item/mecha_equipment/drill

/datum/design/item/mechfab/exosuit/taser
	name = "Mounted Taser"
	materials = list(DEFAULT_WALL_MATERIAL = 10000)
	req_tech = list(TECH_COMBAT = 1)
	build_path = /obj/item/mecha_equipment/mounted_system/taser

/datum/design/item/mechfab/exosuit/uac
	name = "Mounted Automatic Weapon"
	req_tech = list(TECH_COMBAT = 4)
	build_path = /obj/item/mecha_equipment/mounted_system/taser/smg

/datum/design/item/mechfab/exosuit/plasma
	name = "Mounted Plasma Cutter"
	materials = list(DEFAULT_WALL_MATERIAL = 2000, MATERIAL_GLASS = 1000, MATERIAL_GOLD = 1000, MATERIAL_PHORON = 1000)
	req_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 4, TECH_ENGINEERING = 3)
	build_path = /obj/item/mecha_equipment/mounted_system/plasmacutter

/datum/design/item/mechfab/exosuit/ion
	name = "Mounted Ion Rifle"
	materials = list(DEFAULT_WALL_MATERIAL = 10000)
	req_tech = list(TECH_COMBAT = 4, TECH_MAGNET = 4)
	build_path = /obj/item/mecha_equipment/mounted_system/taser/ion

/datum/design/item/mechfab/exosuit/laser
	name = "Mounted Laser Gun"
	materials = list(DEFAULT_WALL_MATERIAL = 10000)
	req_tech = list(TECH_COMBAT = 4, TECH_MAGNET = 4)
	build_path = /obj/item/mecha_equipment/mounted_system/taser/laser

/datum/design/item/mechfab/exosuit/rcd
	name = "Mounted RFD-C"
	time = 90
	materials = list(DEFAULT_WALL_MATERIAL = 30000, MATERIAL_PHORON = 25000, DEFAULT_WALL_MATERIAL = 15000, MATERIAL_GOLD = 15000)
	req_tech = list(TECH_MATERIAL = 4, TECH_BLUESPACE = 3, TECH_MAGNET = 4, TECH_POWER = 4, TECH_ENGINEERING = 4)
	build_path = /obj/item/mecha_equipment/mounted_system/rfd

/datum/design/item/mechfab/exosuit/floodlight
	name = "Mounted Floodlight"
	materials = list(DEFAULT_WALL_MATERIAL = 5000, MATERIAL_GLASS = 5000)
	req_tech = list(TECH_ENGINEERING = 1)
	build_path = /obj/item/mecha_equipment/light

/datum/design/item/mechfab/exosuit/sleeper
	name = "Mounted Sleeper"
	materials = list(DEFAULT_WALL_MATERIAL = 5000, MATERIAL_GLASS = 10000)
	build_path = /obj/item/mecha_equipment/sleeper

/datum/design/item/mechfab/exosuit/extinguisher
	name = "Mounted Extinguisher"
	materials = list(DEFAULT_WALL_MATERIAL = 10000)
	build_path = /obj/item/mecha_equipment/mounted_system/extinguisher

/datum/design/item/mechfab/exosuit/xray
	name = "Mounted X-Ray Gun"
	req_tech = list(TECH_COMBAT = 4, TECH_MAGNET = 4, TECH_MATERIAL = 5, TECH_ILLEGAL = 3)
	build_path = /obj/item/mecha_equipment/mounted_system/xray
	materials = list(DEFAULT_WALL_MATERIAL = 20000, MATERIAL_GOLD = 6000, MATERIAL_PHORON = 6000)

/datum/design/item/mechfab/exosuit/flashbang
	name = "Mounted Flashbang Launcher"
	req_tech = list(TECH_COMBAT = 3)
	build_path = /obj/item/mecha_equipment/mounted_system/grenadeflash
	materials = list(DEFAULT_WALL_MATERIAL = 20000, MATERIAL_GOLD = 6000, MATERIAL_PHORON = 6000)

/datum/design/item/mechfab/exosuit/crisisdrone
	name = "Mounted Crisis Drone"
	build_path = /obj/item/mecha_equipment/crisis_drone
	req_tech = list(TECH_MAGNET = 3, TECH_DATA = 3, TECH_BIO = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 10000, MATERIAL_GOLD = 1000, MATERIAL_SILVER = 2000, MATERIAL_GLASS = 5000)

/datum/design/item/mechfab/exosuit/analyzer
	name = "Mounted Health Analyzer"
	req_tech = list(TECH_MAGNET = 2, TECH_BIO = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 5000, MATERIAL_GLASS = 5000)
	build_path = /obj/item/mecha_equipment/mounted_system/medanalyzer

/datum/design/item/mechfab/exosuit/flaregun
	name = "Mounted Flare Launcher"
	materials = list(DEFAULT_WALL_MATERIAL = 10000)
	build_path = /obj/item/mecha_equipment/mounted_system/flarelauncher

/datum/design/item/mechfab/exosuit/passenger_compartment
	name = "Mounted Passenger Compartment"
	materials = list(DEFAULT_WALL_MATERIAL = 10000)
	build_path = /obj/item/mecha_equipment/sleeper/passenger_compartment