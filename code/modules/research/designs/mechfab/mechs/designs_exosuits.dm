/datum/design/circuit/exosuit/AssembleDesignName()
	name = "Exosuit software design ([name])"
/datum/design/circuit/exosuit/AssembleDesignDesc()
	desc = "Allows for the construction of \a [name] module."

/datum/design/circuit/exosuit/engineering
	name = "engineering system control"
	id = "mech_software_engineering"
	req_tech = list(TECH_DATA = 1)
	build_path = /obj/item/circuitboard/exosystem/engineering
	sort_string = "NAAAA"

/datum/design/circuit/exosuit/utility
	name = "utility system control"
	id = "mech_software_utility"
	req_tech = list(TECH_DATA = 1)
	build_path = /obj/item/circuitboard/exosystem/utility
	sort_string = "NAAAB"

/datum/design/circuit/exosuit/medical
	name = "medical system control"
	id = "mech_software_medical"
	req_tech = list(TECH_DATA = 3,TECH_BIO = 2)
	build_path = /obj/item/circuitboard/exosystem/medical
	sort_string = "NAABA"

/datum/design/circuit/exosuit/weapons
	name = "basic weapon control"
	id = "mech_software_weapons"
	req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/circuitboard/exosystem/weapons
	sort_string = "NAACA"

/datum/design/circuit/exosuit/advweapons
	name = "advanced weapon control"
	id = "mech_software_advweapons"
	req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/circuitboard/exosystem/advweapons
	sort_string = "NAACB"

/datum/design/item/mechfab/exosuit
	name = "exosuit frame"
	id = "mech_frame"
	build_path = /obj/structure/heavy_vehicle_frame
	time = 70
	materials = list(DEFAULT_WALL_MATERIAL = 20000)
	category = "Exosuits"

/datum/design/item/mechfab/exosuit/basic_armour
	name = "basic exosuit armour"
	id = "mech_armour_basic"
	build_path = /obj/item/robot_parts/robot_component/armor/mech
	time = 30
	materials = list(DEFAULT_WALL_MATERIAL = 7500)

/datum/design/item/mechfab/exosuit/radproof_armour
	name = "radiation-proof exosuit armour"
	id = "mech_armour_radproof"
	build_path = /obj/item/robot_parts/robot_component/armor/mech/radproof
	time = 50
	req_tech = list(TECH_MATERIAL = 2, TECH_ENGINEERING = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 12500)

/datum/design/item/mechfab/exosuit/em_armour
	name = "EM-shielded exosuit armour"
	id = "mech_armour_em"
	build_path = /obj/item/robot_parts/robot_component/armor/mech/em
	time = 50
	req_tech = list(TECH_MATERIAL = 2, TECH_POWER = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 12500, "silver" = 1000)

/datum/design/item/mechfab/exosuit/combat_armour
	name = "combat exosuit armor"
	id = "mech_armour_combat"
	build_path = /obj/item/robot_parts/robot_component/armor/mech/combat
	time = 50
	req_tech = list(TECH_MATERIAL = 4, TECH_COMBAT = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 20000, "diamond" = 5000)

/datum/design/item/mechfab/exosuit/control_module
	name = "exosuit control module"
	id = "mech_control_module"
	build_path = /obj/item/mech_component/control_module
	time = 15
	materials = list(DEFAULT_WALL_MATERIAL = 5000)

/datum/design/item/mechfab/exosuit/combat_head
	name = "combat exosuit sensors"
	id = "combat_head"
	time = 30
	materials = list(DEFAULT_WALL_MATERIAL = 10000)
	build_path = /obj/item/mech_component/sensors/combat
	req_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 3)

/datum/design/item/mechfab/exosuit/combat_torso
	name = "combat exosuit chassis"
	id = "combat_body"
	time = 60
	materials = list(DEFAULT_WALL_MATERIAL = 45000)
	build_path = /obj/item/mech_component/chassis/combat
	req_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 3)

/datum/design/item/mechfab/exosuit/combat_arms
	name = "combat exosuit manipulators"
	id = "combat_arms"
	time = 30
	materials = list(DEFAULT_WALL_MATERIAL = 15000)
	build_path = /obj/item/mech_component/manipulators/combat
	req_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 3)

/datum/design/item/mechfab/exosuit/combat_legs
	name = "combat exosuit motivators"
	id = "combat_legs"
	time = 30
	materials = list(DEFAULT_WALL_MATERIAL = 15000)
	build_path = /obj/item/mech_component/propulsion/combat
	req_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 3)

/datum/design/item/mechfab/exosuit/ripley_head
	name = "power loader sensors"
	id = "ripley_head"
	build_path = /obj/item/mech_component/sensors/ripley
	time = 15
	materials = list(DEFAULT_WALL_MATERIAL = 5000)

/datum/design/item/mechfab/exosuit/ripley_torso
	name = "power loader chassis"
	id = "ripley_body"
	build_path = /obj/item/mech_component/chassis/ripley
	time = 50
	materials = list(DEFAULT_WALL_MATERIAL = 20000)

/datum/design/item/mechfab/exosuit/ripley_arms
	name = "power loader manipulators"
	id = "ripley_arms"
	build_path = /obj/item/mech_component/manipulators/ripley
	time = 30
	materials = list(DEFAULT_WALL_MATERIAL = 6000)

/datum/design/item/mechfab/exosuit/ripley_legs
	name = "power loader motivators"
	id = "ripley_legs"
	build_path = /obj/item/mech_component/propulsion/ripley
	time = 30
	materials = list(DEFAULT_WALL_MATERIAL = 6000)

/datum/design/item/mechfab/exosuit/light_head
	name = "light exosuit sensors"
	id = "light_head"
	time = 20
	materials = list(DEFAULT_WALL_MATERIAL = 8000)
	build_path = /obj/item/mech_component/sensors/light
	req_tech = list(TECH_MATERIAL = 1)

/datum/design/item/mechfab/exosuit/light_torso
	name = "light exosuit chassis"
	id = "light_body"
	time = 40
	materials = list(DEFAULT_WALL_MATERIAL = 30000)
	build_path = /obj/item/mech_component/chassis/light
	req_tech = list(TECH_MATERIAL = 1)

/datum/design/item/mechfab/exosuit/light_arms
	name = "light exosuit manipulators"
	id = "light_arms"
	time = 20
	materials = list(DEFAULT_WALL_MATERIAL = 10000)
	build_path = /obj/item/mech_component/manipulators/light
	req_tech = list(TECH_MATERIAL = 1)

/datum/design/item/mechfab/exosuit/light_legs
	name = "light exosuit motivators"
	id = "light_legs"
	time = 25
	materials = list(DEFAULT_WALL_MATERIAL = 10000)
	build_path = /obj/item/mech_component/propulsion/light
	req_tech = list(TECH_MATERIAL = 1)

/datum/design/item/mechfab/exosuit/heavy_head
	name = "heavy exosuit sensors"
	id = "heavy_head"
	time = 35
	materials = list(DEFAULT_WALL_MATERIAL = 16000)
	build_path = /obj/item/mech_component/sensors/heavy
	req_tech = list(TECH_COMBAT = 2)

/datum/design/item/mechfab/exosuit/heavy_torso
	name = "heavy exosuit chassis"
	id = "heavy_body"
	time = 75
	materials = list(DEFAULT_WALL_MATERIAL = 70000, "uranium" = 10000)
	build_path = /obj/item/mech_component/chassis/heavy

/datum/design/item/mechfab/exosuit/heavy_arms
	name = "heavy exosuit manipulators"
	id = "heavy_arms"
	time = 35
	materials = list(DEFAULT_WALL_MATERIAL = 20000)
	build_path = /obj/item/mech_component/manipulators/heavy

/datum/design/item/mechfab/exosuit/heavy_legs
	name = "heavy exosuit motivators"
	id = "heavy_legs"
	time = 35
	materials = list(DEFAULT_WALL_MATERIAL = 20000)
	build_path = /obj/item/mech_component/propulsion/heavy

/datum/design/item/mechfab/exosuit/spider
	name = "quadruped motivators"
	id = "quad_legs"
	time = 20
	materials = list(DEFAULT_WALL_MATERIAL = 12000)
	build_path = /obj/item/mech_component/propulsion/spider
	req_tech = list(TECH_ENGINEERING = 2)

/datum/design/item/mechfab/exosuit/track
	name = "armored treads"
	id = "treads"
	time = 35
	materials = list(DEFAULT_WALL_MATERIAL = 25000)
	build_path = /obj/item/mech_component/propulsion/tracks
	req_tech = list(TECH_MATERIAL = 4)

/datum/design/item/mechfab/exosuit/sphere_body
	name = "spherical chassis"
	id = "sphere_body"
	build_path = /obj/item/mech_component/chassis/pod
	time = 50
	materials = list(DEFAULT_WALL_MATERIAL = 18000)

/datum/design/item/mechfab/exosuit/hydraulic_clamp
	name = "hydraulic clamp"
	id = "hydraulic_clamp"
	materials = list(DEFAULT_WALL_MATERIAL = 10000)
	build_path = /obj/item/mecha_equipment/clamp

/datum/design/item/mechfab/exosuit/gravity_catapult
	name = "gravity catapult"
	id = "gravity_catapult"
	build_path = /obj/item/mecha_equipment/catapult

/datum/design/item/mechfab/exosuit/drill
	name = "drill"
	id = "mech_drill"
	materials = list(DEFAULT_WALL_MATERIAL = 10000)
	build_path = /obj/item/mecha_equipment/drill

/datum/design/item/mechfab/exosuit/taser
	name = "mounted electrolaser"
	id = "mech_taser"
	materials = list(DEFAULT_WALL_MATERIAL = 10000)
	req_tech = list(TECH_COMBAT = 1)
	build_path = /obj/item/mecha_equipment/mounted_system/taser

/datum/design/item/mechfab/exosuit/uac
	name = "mounted automatic weapon"
	id = "mech_uac"
	req_tech = list(TECH_COMBAT = 4)
	build_path = /obj/item/mecha_equipment/mounted_system/taser/smg

/datum/design/item/mechfab/exosuit/plasma
	name = "mounted plasma cutter"
	id = "mech_plasma"
	materials = list(DEFAULT_WALL_MATERIAL = 2000, "glass" = 1000, "gold" = 1000, "phoron" = 1000)
	req_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 4, TECH_ENGINEERING = 3)
	build_path = /obj/item/mecha_equipment/mounted_system/plasmacutter

/datum/design/item/mechfab/exosuit/ion
	name = "mounted ion rifle"
	id = "mech_ion"
	materials = list(DEFAULT_WALL_MATERIAL = 10000)
	req_tech = list(TECH_COMBAT = 4, TECH_MAGNET = 4)
	build_path = /obj/item/mecha_equipment/mounted_system/taser/ion

/datum/design/item/mechfab/exosuit/laser
	name = "mounted laser gun"
	id = "mech_laser"
	materials = list(DEFAULT_WALL_MATERIAL = 10000)
	req_tech = list(TECH_COMBAT = 4, TECH_MAGNET = 4)
	build_path = /obj/item/mecha_equipment/mounted_system/taser/laser

/datum/design/item/mechfab/exosuit/rcd
	name = "RFD-C"
	id = "mech_rcd"
	time = 90
	materials = list(DEFAULT_WALL_MATERIAL = 30000, "phoron" = 25000, "steel" = 15000, "gold" = 15000)
	req_tech = list(TECH_MATERIAL = 4, TECH_BLUESPACE = 3, TECH_MAGNET = 4, TECH_POWER = 4, TECH_ENGINEERING = 4)
	build_path = /obj/item/mecha_equipment/mounted_system/rfd

/datum/design/item/mechfab/exosuit/floodlight
	name = "floodlight"
	id = "mech_floodlight"
	materials = list(DEFAULT_WALL_MATERIAL = 5000, "glass" = 5000)
	req_tech = list(TECH_ENGINEERING = 1)
	build_path = /obj/item/mecha_equipment/light

/datum/design/item/mechfab/exosuit/sleeper
	name = "mounted sleeper"
	id   = "mech_sleeper"
	materials = list(DEFAULT_WALL_MATERIAL = 5000, "glass" = 10000)
	build_path = /obj/item/mecha_equipment/sleeper

/datum/design/item/mechfab/exosuit/extinguisher
	name = "mounted extinguisher"
	id   = "mecha_extinguisher"
	materials = list(DEFAULT_WALL_MATERIAL = 10000)
	build_path = /obj/item/mecha_equipment/mounted_system/extinguisher

/datum/design/item/mechfab/exosuit/xray
	name = "xray gun"
	id = "xray_gun"
	req_tech = list(TECH_COMBAT = 4, TECH_MAGNET = 4, TECH_MATERIAL = 5, TECH_ILLEGAL = 3)
	build_path = /obj/item/mecha_equipment/mounted_system/xray
	materials = list(DEFAULT_WALL_MATERIAL = 20000, "gold" = 6000, "phoron" = 6000)

/datum/design/item/mechfab/exosuit/flashbang
	name = "flashbang launcher"
	id = "flashbang_launcher"
	req_tech = list(TECH_COMBAT = 3)
	build_path = /obj/item/mecha_equipment/mounted_system/grenadeflash
	materials = list(DEFAULT_WALL_MATERIAL = 20000, "gold" = 6000, "phoron" = 6000)

/datum/design/item/mechfab/exosuit/crisisdrone
	name = "crisis drone"
	id = "crisis_drone"
	build_path = /obj/item/mecha_equipment/crisis_drone
	req_tech = list(TECH_MAGNET = 3, TECH_DATA = 3, TECH_BIO = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 10000, "gold" = 1000, "silver" = 2000, "glass" = 5000)

/datum/design/item/mechfab/exosuit/analyzer
	name = "mounted health analyzer"
	id   = "mech_analyzer"
	req_tech = list(TECH_MAGNET = 2, TECH_BIO = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 5000, "glass" = 5000)
	build_path = /obj/item/mecha_equipment/mounted_system/medanalyzer

/datum/design/item/mechfab/exosuit/flaregun
	name = "mounted flare launcher"
	id   = "mech_flare"
	materials = list(DEFAULT_WALL_MATERIAL = 10000)
	build_path = /obj/item/mecha_equipment/mounted_system/flarelauncher
