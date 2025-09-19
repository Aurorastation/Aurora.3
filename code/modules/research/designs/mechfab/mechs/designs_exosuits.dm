/datum/design/item/mechfab/exosuit
	name = "Exosuit Frame"
	build_path = /obj/structure/heavy_vehicle_frame
	time = 50 SECONDS
	materials = list(DEFAULT_WALL_MATERIAL = 15000)
	category = "Exosuit (Body)"

/datum/design/item/mechfab/exosuit/basic_armor
	name = "Basic Exosuit Armor"
	build_path = /obj/item/robot_parts/robot_component/armor/mech
	time = 30 SECONDS
	materials = list(DEFAULT_WALL_MATERIAL = 6000)

/datum/design/item/mechfab/exosuit/radproof_armor
	name = "Radiation-proof Exosuit Armor"
	build_path = /obj/item/robot_parts/robot_component/armor/mech/radproof
	time = 50 SECONDS
	req_tech = list(TECH_MATERIAL = 2, TECH_ENGINEERING = 2)
	// Steel for equivalent armor, but lead for its radiation shielding
	materials = list(DEFAULT_WALL_MATERIAL = 6000, MATERIAL_LEAD = 7500)

/datum/design/item/mechfab/exosuit/em_armor
	name = "EM-shielded Exosuit Armor"
	build_path = /obj/item/robot_parts/robot_component/armor/mech/em
	time = 50 SECONDS
	req_tech = list(TECH_MATERIAL = 2, TECH_POWER = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 12500, MATERIAL_LEAD = 2500, MATERIAL_SILVER = 1000)

/datum/design/item/mechfab/exosuit/combat_armor
	name = "Combat Exosuit Armor"
	build_path = /obj/item/robot_parts/robot_component/armor/mech/combat
	time = 50 SECONDS
	req_tech = list(TECH_MATERIAL = 4, TECH_COMBAT = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 10000, MATERIAL_PLASTEEL = 10000, MATERIAL_DIAMOND = 5000)

/datum/design/item/mechfab/exosuit/actuator
	name = "Actuator"
	build_path = /obj/item/robot_parts/robot_component/actuator
	time = 10 SECONDS
	materials = list(DEFAULT_WALL_MATERIAL = 5000)

/datum/design/item/mechfab/exosuit/diagnosis_unit
	name = "Diagnostics Unit"
	build_path = /obj/item/robot_parts/robot_component/diagnosis_unit
	time = 10 SECONDS
	materials = list(DEFAULT_WALL_MATERIAL = 5000)

/datum/design/item/mechfab/exosuit/camera
	name = "Camera"
	build_path = /obj/item/robot_parts/robot_component/camera
	time = 10 SECONDS
	materials = list(DEFAULT_WALL_MATERIAL = 5000)

/datum/design/item/mechfab/exosuit/radio
	name = "Radio"
	build_path = /obj/item/robot_parts/robot_component/radio
	time = 10 SECONDS
	materials = list(DEFAULT_WALL_MATERIAL = 5000)

/datum/design/item/mechfab/exosuit/control_module
	name = "Exosuit Control Module"
	build_path = /obj/item/mech_component/control_module
	time = 15 SECONDS
	materials = list(DEFAULT_WALL_MATERIAL = 5000)

/datum/design/item/mechfab/exosuit/combat_head
	name = "Combat Exosuit Sensors"
	time = 90 SECONDS
	materials = list(DEFAULT_WALL_MATERIAL = 10000, MATERIAL_GOLD = 10500, MATERIAL_SILVER = 10000)
	build_path = /obj/item/mech_component/sensors/combat
	req_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 3)

/datum/design/item/mechfab/exosuit/combat_torso
	name = "Combat Exosuit Chassis"
	time = 180 SECONDS
	materials = list(DEFAULT_WALL_MATERIAL = 45000, MATERIAL_GOLD = 10500, MATERIAL_SILVER = 10000)
	build_path = /obj/item/mech_component/chassis/combat
	req_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 3)

/datum/design/item/mechfab/exosuit/combat_arms
	name = "Combat Exosuit Manipulators"
	time = 90 SECONDS
	materials = list(DEFAULT_WALL_MATERIAL = 15000, MATERIAL_GOLD = 10500, MATERIAL_SILVER = 10000)
	build_path = /obj/item/mech_component/manipulators/combat
	req_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 3)

/datum/design/item/mechfab/exosuit/combat_legs
	name = "Combat Exosuit Motivators"
	time = 90 SECONDS
	materials = list(DEFAULT_WALL_MATERIAL = 15000, MATERIAL_GOLD = 10500, MATERIAL_SILVER = 10000)
	build_path = /obj/item/mech_component/propulsion/combat
	req_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 3)

/datum/design/item/mechfab/exosuit/ripley_head
	name = "Powerloader Sensors"
	build_path = /obj/item/mech_component/sensors/ripley
	time = 45 SECONDS
	materials = list(DEFAULT_WALL_MATERIAL = 3500)

/datum/design/item/mechfab/exosuit/ripley_torso
	name = "Powerloader Chassis"
	build_path = /obj/item/mech_component/chassis/ripley
	time = 105 SECONDS
	materials = list(DEFAULT_WALL_MATERIAL = 15000)

/datum/design/item/mechfab/exosuit/ripley_arms
	name = "Powerloader Manipulators"
	build_path = /obj/item/mech_component/manipulators/ripley
	time = 75 SECONDS
	materials = list(DEFAULT_WALL_MATERIAL = 4500)

/datum/design/item/mechfab/exosuit/ripley_legs
	name = "Powerloader Motivators"
	build_path = /obj/item/mech_component/propulsion/ripley
	time = 75 SECONDS
	materials = list(DEFAULT_WALL_MATERIAL = 4500)

/datum/design/item/mechfab/exosuit/light_head
	name = "Light Exosuit Sensors"
	time = 60 SECONDS
	materials = list(MATERIAL_ALUMINIUM = 3500, DEFAULT_WALL_MATERIAL = 3000)
	build_path = /obj/item/mech_component/sensors/light
	req_tech = list(TECH_MATERIAL = 1)

/datum/design/item/mechfab/exosuit/light_torso
	name = "Light Exosuit Chassis"
	time = 90 SECONDS
	materials = list(MATERIAL_ALUMINIUM = 15000, DEFAULT_WALL_MATERIAL = 10000)
	build_path = /obj/item/mech_component/chassis/light
	req_tech = list(TECH_MATERIAL = 1)

/datum/design/item/mechfab/exosuit/light_arms
	name = "Light Exosuit Manipulators"
	time = 60 SECONDS
	materials = list(MATERIAL_ALUMINIUM = 6500, DEFAULT_WALL_MATERIAL = 3500)
	build_path = /obj/item/mech_component/manipulators/light
	req_tech = list(TECH_MATERIAL = 1)

/datum/design/item/mechfab/exosuit/light_legs
	name = "Light Exosuit Motivators"
	time = 75 SECONDS
	materials = list(MATERIAL_ALUMINIUM = 6500, DEFAULT_WALL_MATERIAL = 3500)
	build_path = /obj/item/mech_component/propulsion/light
	req_tech = list(TECH_MATERIAL = 1)

/datum/design/item/mechfab/exosuit/heavy_head
	name = "Heavy Exosuit Sensors"
	time = 105 SECONDS
	materials = list(DEFAULT_WALL_MATERIAL = 12000, MATERIAL_URANIUM = 7000, MATERIAL_SILVER = 7000, MATERIAL_GOLD = 7000)
	build_path = /obj/item/mech_component/sensors/heavy
	req_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 4)

/datum/design/item/mechfab/exosuit/heavy_torso
	name = "Heavy Exosuit Chassis"
	time = 225 SECONDS
	materials = list(DEFAULT_WALL_MATERIAL = 70000, MATERIAL_URANIUM = 10000, MATERIAL_SILVER = 10000, MATERIAL_GOLD = 10000)
	build_path = /obj/item/mech_component/chassis/heavy
	req_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 4)

/datum/design/item/mechfab/exosuit/heavy_arms
	name = "Heavy Exosuit Manipulators"
	time = 105 SECONDS
	materials = list(DEFAULT_WALL_MATERIAL = 20000, MATERIAL_URANIUM = 5000, MATERIAL_SILVER = 5000, MATERIAL_GOLD = 5000)
	build_path = /obj/item/mech_component/manipulators/heavy
	req_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 4)

/datum/design/item/mechfab/exosuit/heavy_legs
	name = "Heavy Exosuit Motivators"
	time = 105 SECONDS
	materials = list(DEFAULT_WALL_MATERIAL = 20000, MATERIAL_URANIUM = 5000, MATERIAL_SILVER = 5000, MATERIAL_GOLD = 5000)
	build_path = /obj/item/mech_component/propulsion/heavy
	req_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 4)

/datum/design/item/mechfab/exosuit/spider
	name = "Quadruped Motivators"
	time = 60 SECONDS
	materials = list(DEFAULT_WALL_MATERIAL = 12000)
	build_path = /obj/item/mech_component/propulsion/spider

/datum/design/item/mechfab/exosuit/spider/heavy
	name = "Industrial Quadruped Motivators"
	time = 105 SECONDS
	materials = list(DEFAULT_WALL_MATERIAL = 25000)
	build_path = /obj/item/mech_component/propulsion/spider/heavy

/datum/design/item/mechfab/exosuit/hover_legs
	name = "Heavy Hoverthrusters"
	time = 105 SECONDS
	// Significantly heavier armor than light hoverthrusters, gold, silver, and phoron are for the ion engines.
	materials = list(DEFAULT_WALL_MATERIAL = 15000, MATERIAL_ALUMINIUM = 7500, MATERIAL_GOLD = 2500, MATERIAL_SILVER = 2500, MATERIAL_PHORON = 2500)
	build_path = /obj/item/mech_component/propulsion/hover

/datum/design/item/mechfab/exosuit/hover_legs/light
	name = "Light Hoverthrusters"
	time = 75 SECONDS
	// Harder to obtain materials than other leg types, though not unobtainable by any means. You can get them roundstart by partnering up with engineering.
	// The cost is kind of intentionally set to discourage "Light hoverthruster meta", there is otherwise no actual reason to ever make anything else.
	materials = list(MATERIAL_ALUMINIUM = 15000, MATERIAL_GOLD = 4500, MATERIAL_SILVER = 4500, MATERIAL_PHORON = 4500)
	build_path = /obj/item/mech_component/propulsion/hover/light

/datum/design/item/mechfab/exosuit/track
	name = "Armored Treads"
	time = 105 SECONDS
	materials = list(DEFAULT_WALL_MATERIAL = 25000)
	build_path = /obj/item/mech_component/propulsion/tracks
