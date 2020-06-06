/datum/design/item/mechfab/exosuit
	name = "Exosuit Frame"
	build_path = /obj/structure/heavy_vehicle_frame
	time = 50
	materials = list(DEFAULT_WALL_MATERIAL = 15000)
	category = "Exosuit (Body)"

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

/datum/design/item/mechfab/exosuit/actuator
	name = "Actuator"
	build_path = /obj/item/robot_parts/robot_component/actuator
	time = 10
	materials = list(DEFAULT_WALL_MATERIAL = 5000)

/datum/design/item/mechfab/exosuit/diagnosis_unit
	name = "Diagnosis unit"
	build_path = /obj/item/robot_parts/robot_component/diagnosis_unit
	time = 10
	materials = list(DEFAULT_WALL_MATERIAL = 5000)

/datum/design/item/mechfab/exosuit/camera
	name = "Camera"
	build_path = /obj/item/robot_parts/robot_component/camera
	time = 10
	materials = list(DEFAULT_WALL_MATERIAL = 5000)

/datum/design/item/mechfab/exosuit/radio
	name = "Radio"
	build_path = /obj/item/robot_parts/robot_component/radio
	time = 10
	materials = list(DEFAULT_WALL_MATERIAL = 5000)

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